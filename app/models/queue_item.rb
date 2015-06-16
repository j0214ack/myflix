class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  before_validation :set_position, unless: :has_position?

  delegate :category, to: :video

  def rating
    review = video.reviews.find_by(user_id: user.id)
    review.rating if review
  end

  def destroy_by_user(the_user)
    if user == the_user
      destroy
      QueueItem.normalize(user)
      true
    else
      false
    end
  end

  private

  def set_position
    self.position = QueueItem.where(user_id: self.user_id).count + 1
  end

  def has_position?
    !!self.position
  end
end

class << QueueItem
  def batch_update_by_user(user, queue_items_params)
    if ( ParamsValidator.new(user, queue_items_params).valid? &&
         update_queue_items(queue_items_params) )
      true
    else
      false
    end
  end

  def normalize(user)
    user.queue_items.each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end

  private

  def update_queue_items(queue_items_params)
    begin
      transaction do
        queue_items_params
          .sort_by { |item_data| item_data[:position] }
          .each_with_index do |item_data, index|
            item = find(item_data[:id])
            item.update_attributes!(position: index + 1)
          end
      end
      true
    rescue
      false
    end
  end

  class ParamsValidator
    attr_reader :requester, :params

    def initialize(requester, params)
      @requester = requester
      @params = params
    end

    def valid?
      valid_ids? && !duplicate_positions?
    end

    private

    def is_not_int?(input)
      if input.is_a?(String)
        !input.match(/^\d+$/)
      else
        !input.is_a?(Integer)
      end
    end

    def duplicate_positions?
      !!params.map{ |item_data| item_data[:position] }.uniq!
    end

    def valid_ids?
      !contain_other_user_item &&
      !contain_non_integer
    end

    def contain_other_user_item
      item_ids = params.map{ |item_data| item_data[:id] }
      result = false
      item_ids.each do |id|
        unless requester.queue_item_ids.include? id.to_i
          result = true
          break
        end
      end

      result
    end

    def contain_non_integer
      !!params
        .map{ |data| data[:position]}
        .index{ |position| is_not_int?(position) }
    end
  end # class ParamsValidator
end # class << QueueItem
