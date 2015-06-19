require 'spec_helper'

feature 'user signs in' do
  background do
    user = Fabricate(:user, email: 'a@example.com')
  end

  scenario 'with valid e-mail and password' do
    visit root_path
    click_link 'sign in'
  end

  scenario 'with invalid e-mail or password' do

  end
end
