module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then "notification is-info"
    when 'success' then "notification is-success"
    when 'error' then "notification is-danger"
    when 'alert' then "notification is-warning"
    end
  end

  def profile_image
    current_user.image_path || current_user.gravatar_url(default: 'mm')
  end

  def avatar_image
    @user.image_path || @user.gravatar_url(default: 'mm')
  end

  def current_class?(path)
    (request.path == path) ? 'is-active' : ''
  end
end
