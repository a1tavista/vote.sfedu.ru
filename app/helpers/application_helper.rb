module ApplicationHelper
  def user_root_path
    send("#{current_user.kind_type}_root_path".downcase)
  end
end
