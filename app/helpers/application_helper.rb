module ApplicationHelper
  def bootstrap_form_for(record, options = {}, &block)
    options.merge!(builder: MyBootstrapFormBuilder)
    form_for(record, options, &block)
  end
end
