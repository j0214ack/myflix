def login_user(user = nil)
  user ||= Fabricate(:user)
  session[:user_id] = user.id
end

def clear_current_user
  session[:user_id] = nil
end