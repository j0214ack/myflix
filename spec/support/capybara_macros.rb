def login_user_in_capybara(user)
  visit root_path
  click_link 'Sign In'
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password || 'password'
  click_button 'Sign in'
end

def find_link_with_href(href)
  find(:xpath, "//a[@href='#{href}']")
end
