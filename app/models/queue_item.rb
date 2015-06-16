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

  def self.batch_update_by_user(user, queue_items_params)
    if params_are_valid?(user, queue_items_params)
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
    else
      false
    end
  end

  def self.params_are_valid?(user, queue_items_params)
    item_ids = queue_items_params.map{|item_data| item_data[:id]}
    valid_item_ids = true
    item_ids.each do |id|
      valid_item_ids = false unless user.queue_item_ids.include? id.to_i
    end

    positions = queue_items_params.map{|item_data| item_data[:position]}
    duplication = !!positions.uniq!

    containing_non_integer = !!positions.index{|position| is_not_int?(position)}

    (!(duplication || containing_non_integer) && valid_item_ids)
  end

  def self.normalize(user)
    user.queue_items.each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end

  def self.is_not_int?(input)
    if input.is_a?(String)
      !input.match(/^\d+$/)
    else
      !input.is_a?(Integer)
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
