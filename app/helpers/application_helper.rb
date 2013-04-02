module ApplicationHelper
  
  def bootstrap_icon(class_identifier)
    "<i class='#{class_identifier}'></i>".html_safe
  end
  
end
