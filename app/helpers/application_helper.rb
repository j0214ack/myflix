module ApplicationHelper
  def bootstrap_form_for(record, options = {}, &block)
    options.merge!(builder: MyBootstrapFormBuilder)
    form_for(record, options, &block)
  end

  def rating_chioces(value = nil)
    option_pairs = Review::RATING_RANGE.map{ |n| [pluralize(n,"Star"), n] }
    options_for_select(option_pairs, value)
  end
end
