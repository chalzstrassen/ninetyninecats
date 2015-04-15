module ApplicationHelper
  def csrf_token
    <<-HTML.html_safe
      <input type = "hidden"
        name="authenticity_token"
        value="#{form_authenticity_token}">
    HTML
  end

  def owned_cat?(cat)
    # return true if user owns the cat
    return false if current_user.nil?
    current_user.id == cat.user_id
  end
end
