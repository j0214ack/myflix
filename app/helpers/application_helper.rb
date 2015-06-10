module ApplicationHelper
  def bootstrap_form_for(record, options = {}, &block)
    options.merge!(builder: MyBootstrapFormBuilder)
    form_for(record, options, &block)
  end

  def rating_chioces
    Review::RATING_RANGE.map { |n| [pluralize(n,"Star"), n]  }
  end
end
