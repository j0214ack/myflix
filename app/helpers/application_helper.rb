module ApplicationHelper
  def bootstrap_form_for(record, options = {}, &block)
    options.merge!(builder: MyBootstrapFormBuilder)
    form_for(record, options, &block)
  end

  def rating_chioces(value = nil)
    option_pairs = Review::RATING_RANGE.map{ |n| [pluralize(n,"Star"), n] }
    options_for_select(option_pairs, value)
  end

  def bootstrap_class_for_flash(name)
    case name
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      flash_type.to_s
    end
  end
end
