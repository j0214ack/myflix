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

  bootstrap_field :text_field, :email_field, :password_field

  def group(attr_sym, &block)
    classes = %w(form-group)
    classes << "has-error" if object.errors[attr_sym].any?
    @template.content_tag :div, class: classes do
      block.call
    end
  end

  def label(method, text = nil, options = {}, &block)
    col_sm_num = options.delete(:col_sm)
    options.merge!(class: ["col-sm-#{col_sm_num}", "control-label"])
    super(method, text, objectify_options(options), &block)
  end

  # def email_field(method, options = {})
  #   col_sm_num = options.delete(:col_sm)
  #   the_email_field = super(method, bootstrap_options(method, options))
  #   @template.content_tag :div, class: ["col-sm-#{col_sm_num}"] do
  #     the_email_field + field_errors(method)
  #   end
  # end
  #
  # def password_field(method, options = {})
  #   col_sm_num = options.delete(:col_sm)
  #   the_password_field = super(method, bootstrap_options(method, options))
  #   @template.content_tag :div, class: ["col-sm-#{col_sm_num}"] do
  #     the_password_field + field_errors(method)
  #   end
  # end

  # def text_field(method, options = {})
  #   col_sm_num = options.delete(:col_sm)
  #   the_text_field = super(method, bootstrap_options(method, options))
  #   @template.content_tag :div, class: ["col-sm-#{col_sm_num}"] do
  #     the_text_field + field_errors(method)
  #   end
  # end

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
