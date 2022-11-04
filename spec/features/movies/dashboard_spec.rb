require 'rails_helper'

RSpec.describe 'Movie Dashboard', type: :feature do
  describe 'As a User' do
    describe 'Discover Movies Page' do
      before :each do
        @user_1 = create(:user)

        visit login_path
        fill_in 'Email', with: "#{@user_1.email}"
        fill_in 'Password', with: "#{@user_1.password}"
        click_button "Submit"

      end

      it 'When I go to a user dashboard, and click "Discover Movies" button, I am redirected to a discover page' do
        visit dashboard_path

        click_button 'Discover Movies'

        expect(current_path).to eq(discover_path)
      end
    end
  end
end
