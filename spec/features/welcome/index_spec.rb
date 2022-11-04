require 'rails_helper'

RSpec.describe 'welcome page', type: :feature do
  describe 'index page' do
    it 'has the title of the application' do
      visit '/'
      expect(page).to have_content('Viewing Party Lite')
    end

    it 'has a button to create a new user' do
      visit '/'
      expect(page).to have_button('Create a New User')
      click_button('Create a New User')
      expect(page).to have_current_path('/register')
    end

    it 'has a link to return to landing page' do
      user_1 = create(:user)
      user_2 = create(:user)

      visit '/'
      expect(page).to have_content('Existing Users')

      within '#user-0' do
        expect(page).to have_content("#{user_1.name}")
        expect(page).to_not have_content("#{user_2.name}")
      end

      within '#user-1' do
        expect(page).to have_content("#{user_2.name}")
        expect(page).to_not have_content("#{user_1.name}")
      end
    end

    it 'each existing user links to user dashboard' do
      user_1 = create(:user)
      user_2 = create(:user)

      visit '/'
      
      click_link("#{user_1.name}'s Dashboard")
      expect(current_path).to eq("/users/#{user_1.id}")
      expect(current_path).to_not eq("/users/#{user_2.id}")
    end
  end
end
