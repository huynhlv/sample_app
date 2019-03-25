module ApplicationHelper
  def full_title page_title
    if page_title.blank?
      t(".base_title")
    else
      page_title + " | " + t(".base_title")
    end
  end
end
