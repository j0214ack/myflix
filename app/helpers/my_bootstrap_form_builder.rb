class MyBootstrapFormBuilder < ActionView::Helpers::FormBuilder

  def self.bootstrap_field(*method_names)
    method_names.each do |method_name|
      method_name = method_name.to_s
      self.class_eval %Q{
        def #{method_name}(method, options = \{\})
          col_sm_num = options.delete(:col_sm)
          content = super(method, bootstrap_options(options))
          content += field_errors(method) if object.errors[method].any?
          @template.content_tag :div, class: ["col-sm-\#\{col_sm_num\}"] do
            content
          end
        end
      }
    end
  end

  bootstrap_field :text_field, :email_field, :password_field, :text_area

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    col_sm_num = html_options.delete(:col_sm)
    content = super(method, choices, options, bootstrap_options(html_options), &block)
    content += field_errors(method) if object.errors[method].any?
    @template.content_tag :div, class: "col-sm-#{col_sm_num}" do
      content
    end
  end

  def group(attr_sym, &block)
    classes = %w(form-group)
    classes << "has-error" if object.errors[attr_sym].any?
    @template.content_tag :div, class: classes do
      block.call
    end
  end

  def label(method, text = nil, options = {}, &block)
    col_sm_num = options.delete(:col_sm)
    col_sm_num && options.merge!(class: ["col-sm-#{col_sm_num}", "control-label"])
    super(method, text, objectify_options(options), &block)
  end

  private

  def bootstrap_options(options = {})
    options.merge!(class: "form-control")
    objectify_options(options)
  end

  def field_errors(method)
    object.errors[method].map do |err_msg|
      @template.content_tag(:span, class: "help-block") do
         err_msg
      end
    end.join.html_safe
  end
end
