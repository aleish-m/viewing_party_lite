require 'rails_helper'

RSpec.describe 'User Login Page' do
  describe 'As a registered user' do
    describe "When I visit the landing page, before logging in " do
      
      it "I see a link see a link to 'Log In' or 'Create an Account', but I do not see a link for 'Log Out'" do
        visit root_path

        expect(page).to have_button("Create an Account")
        expect(page).to have_button("Log In")

        expect(page).to_not have_button("Log Out")
      end
    end

    describe "When I visit the landing page, after loggin in " do
      before :each do
        @user_1 = create(:user)

        visit login_path
        fill_in 'Email', with: "#{@user_1.email}"
        fill_in 'Password', with: "#{@user_1.password}"
        click_button "Submit"
      end
      
      it "I no longer see a link to Log In or Create an Account, But I see a link to Log Out." do
        visit root_path

        expect(page).to_not have_button("Create an Account")
        expect(page).to_not have_button("Log In")

        expect(page).to have_button("Log Out")
      end

      it "When I click the link to Log Out I'm taken to the landing pagend I can see that the Log Out link has changed back to a Log In link" do
        visit root_path

        click_button("Log Out")

        expect(current_path).to eq root_path

        expect(page).to have_button("Create an Account")
        expect(page).to have_button("Log In")

        expect(page).to_not have_button("Log Out")

        expect(page).to have_content("You have successfully logged out.")
      end
    end
  end
end
