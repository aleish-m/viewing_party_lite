require 'rails_helper'

RSpec.describe 'welcome page', type: :feature do
  describe 'index page' do
    describe 'before user is logged in' do
      before :each do 
        @user_1 = create(:user)
        @user_2 = create(:user)
      end

      it 'has the title of the application' do
        visit root_path
        expect(page).to have_content('Viewing Party Lite')
      end

      it 'has a button to create a new user' do
        visit root_path
        expect(page).to have_button('Create an Account')
        click_button('Create an Account')
        expect(page).to have_current_path(new_register_path)
      end

      it 'does not have a section for existing users' do
        visit root_path

        expect(page).to_not have_content('Existing Users')

        expect(page).to_not have_content("#{@user_1.name}")
        expect(page).to_not have_content("#{@user_2.name}")
        
      end
    end

    describe 'after user has logged in' do
      before :each do 
        @user_1 = create(:user)
        @user_2 = create(:user)

        visit login_path
        fill_in 'Email', with: "#{@user_1.email}"
        fill_in 'Password', with: "#{@user_1.password}"
        click_button "Submit"

        visit root_path
      end

      it 'has the title of the application' do
        expect(page).to have_content('Viewing Party Lite')
      end

      it 'has a button to Log Out' do
        expect(page).to have_button('Log Out')
      end

      it 'has a section for existing users where each users name and email is listed' do
        expect(page).to have_content('Existing Users')

        within '#user-0' do
          expect(page).to have_content("#{@user_1.name}")
          expect(page).to have_content("#{@user_1.email}")
          expect(page).to_not have_content("#{@user_2.name}")
        end

        within '#user-1' do
          expect(page).to have_content("#{@user_2.name}")
          expect(page).to have_content("#{@user_2.email}")
          expect(page).to_not have_content("#{@user_1.name}")
        end
      end

      ### Outdated functionality ###
      # it 'each existing user links to user dashboard' do
      #   visit root_path
        
      #   click_link("#{@user_1.name}'s Dashboard")
      #   expect(current_path).to eq(dashboard_path)
      # end
    end
  end
end
