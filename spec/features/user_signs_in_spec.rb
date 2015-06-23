require 'spec_helper'

feature 'user signs in' do
  scenario 'with valid e-mail and password' do
    user = Fabricate(:user)
    login_user_in_capybara(user)

    expect(page).to have_content('Welcome')
  end

  scenario 'with invalid e-mail or password' do
    visit root_path
    click_link 'Sign In'
    fill_in 'Email Address', with: 'ghost@example.com'
    fill_in 'Password', with: 'passwordsss'
    click_button 'Sign in'

    expect(page).to have_content('Invalid password or E-mail!')
  end
end
