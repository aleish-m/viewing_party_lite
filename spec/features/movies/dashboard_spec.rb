require 'rails_helper'

RSpec.describe 'Movie Dashboard', type: :feature do
  describe 'As a User' do
    describe 'Discover Movies Page' do
      before :each do
        @user_1 = create(:user)
      end

      it 'When I go to a user dashboard, and click "Discover Movies" button, I am redirected to a discover page' do
        visit user_path(@user_1)

        click_button 'Discover Movies'

        expect(current_path).to eq(user_discover_path(@user_1))
      end
    end
  end
end
