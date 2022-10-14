require 'rails_helper'

RSpec.describe 'New Viewing Party Page' do
  describe 'As a user' do
    describe "When I visit the new viewing party page", :vcr => {:record => :new_episodes } do
      before :each do
        @user_1 = User.create!(name: 'Jane', email: 'jane@mail.com')
        @user_2 = User.create!(name: 'John', email: 'john@mail.com')
        @user_3 = User.create!(name: 'Megan', email: 'megan@mail.com')
        @user_4 = User.create!(name: 'Mike', email: 'mike@mail.com')

        @movie_1 = MovieFacade.movie_data(271110)
        @movie_2 = MovieFacade.movie_data(3)

        visit new_user_movie_viewing_party_path(@user_1, @movie_1.id)
      end

      it 'I should see the name of the movie title rendered above a form' do
        expect(page).to have_content(@movie_1.title)
      end

      it "Form has the following fields: duration of Party, date, start Time, checkboxes next to each existing user" do
        save_and_open_page
        expect(page).to have_field("Duration of Party", with: "#{@movie_1.runtime}")
        expect(page).to have_field("Date")
        expect(page).to have_field("Start Time")
        expect(page).to have_no_checked_field("Invite Users")
      end

      it 'When I fill in the form and click "Create Party" I am redirected back to my dashboad' do
        fill_in "Duration of Party",	with: "#{@movie_1.runtime + 30}" 
        fill_in "Date",	with: "2022/11/14" 
        fill_in "Start Time",	with: "16:30" 
        check "#{@user_2.name}"
        check "#{@user_4.name}"
        click_button "Create Party"
        
        expect(current_path).to eq(user_path(@user_1))
      end

      it 'When I am Re-directed back to my dashboard I see the the new event is shown on my dashboard' do
        fill_in "Duration of Party",	with: "#{@movie_1.runtime + 30}" 
        fill_in "Date",	with: "2022/11/14" 
        fill_in "Start Time",	with: "16:30" 
        check "#{@user_2.name}"
        check "#{@user_4.name}"
        click_button "Create Party"

        within("#view-parties-#{@user_1.id}") do
          expect(page).to have_link(@movie_1.title)
          expect(page).to have_content("November 14, 2022")
          expect(page).to have_content("04:30 PM")
          expect(page).to have_content(@user_2.name)
          expect(page).to have_content(@user_4.name)
        end
      end

      it 'After I submit the form the event is also added to the other selected users dashboard' do
        fill_in "Duration of Party",	with: "#{@movie_1.runtime + 30}" 
        fill_in "Date",	with: "2022/11/14" 
        fill_in "Start Time",	with: "16:30" 
        check "#{@user_2.name}"
        check "#{@user_4.name}"
        click_button "Create Party"

        visit user_path(@user_2)
        within("#view-parties-#{@user_2.id}") do
          expect(page).to have_link(@movie_1.title)
          expect(page).to have_content("November 14, 2022")
          expect(page).to have_content("04:30 PM")
          expect(page).to have_content(@user_2.name)
          expect(page).to have_content(@user_4.name)
        end

        visit user_path(@user_3)
        within("#view-parties-#{@user_3.id}") do
          expect(page).to_not have_link(@movie_1.title)
          expect(page).to_not have_content("November 14, 2022")
          expect(page).to_not have_content("04:30 PM")
          expect(page).to_not have_content(@user_2.name)
          expect(page).to_not have_content(@user_4.name)
        end

        visit user_path(@user_4)
        within("#view-parties-#{@user_4.id}") do
          expect(page).to have_link(@movie_1.title)
          expect(page).to have_content("November 14, 2022")
          expect(page).to have_content("04:30 PM")
          expect(page).to have_content(@user_2.name)
          expect(page).to have_content(@user_4.name)
        end

      end

      it 'If I try to create a party with a duration that is shorter then the length of the movie then I am redirected back to the form and see a error message' do
        fill_in "Duration of Party",	with: "#{@movie_1.runtime - 30}" 
        fill_in "Date",	with: "2022/11/14" 
        fill_in "Start Time",	with: "16:30" 
        check "#{@user_2.name}"
        check "#{@user_4.name}"
        click_button "Create Party"
        
        expect(current_path).to eq(new_user_movie_viewing_party_path(@user_1, @movie_1.id))
        expect(page).to have_content("Duration cannot be less then movie length #{@movie_1.runtime}")
      end
    end
  end
end