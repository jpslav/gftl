# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def trash_icon
    image_tag("trash.gif", {:border => 0, :alt => "Delete", :title => "Delete"})
  end
  
  def edit_icon(dom_id="edit_img")
    image_tag("edit.gif", {:id => dom_id, :border => 0, :alt => "Edit", :title => "Edit"})
  end
  
  def show_icon
    image_tag("show.gif", {:border => 0, :alt => "Show Details", :title => "Show Details"})
  end
  
  def subject_prefix
    "[GFTL]"
  end
  
  def tf_to_yn(bool)
    bool ? "Yes" : "No"
  end
  
  def please_wait_js
    '$(this).blur().hide().parent().append("Please wait");'
  end
  
  
end
