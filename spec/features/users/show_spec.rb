require 'rails_helper'

RSpec.describe 'User Dashboard', type: :feature do
  describe 'As a visitor' do
    before :each do
      @user_1 = create(:user)
      @user_2 = create(:user)
    end

    it "When I try to visit '/dashboard' I remain on the landing page And I see a message telling me that I must be logged in or registered to access my dashboard" do
      visit dashboard_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content("Please log in to access the requested page")
    end
  end

  describe 'As a User' do
    before :each do
      @user_1 = create(:user)
      @user_2 = create(:user)

      visit login_path
      fill_in 'Email', with: "#{@user_1.email}"
      fill_in 'Password', with: "#{@user_1.password}"
      click_button "Submit"
    end

    it 'shows users names dashboard at top of page' do
      visit dashboard_path

      expect(page).to have_content(@user_1.name)
      expect(page).to have_content("#{@user_1.name}'s Dashboard")
      expect(page).to_not have_content("#{@user_2.name}'s Dashboard")
    end

    it 'has a button to discover movies' do
      visit dashboard_path
      expect(page).to have_button('Discover Movies')
    end

    it 'has a section that lists viewing parties' do
      visit dashboard_path
      expect(page).to have_content('Viewing Parties')
    end

    describe 'Veiwing parties' do
      describe 'I should see the viewing parties that the user has been invited to with the following details:' do
        before :each do
          @user_1 = create(:user)
          @user_2 = create(:user)
          @user_3 = create(:user)
          @user_4 = create(:user)

          @party_1 = create(:party, movie_id: 8, host_id: @user_1.id)
          @party_2 = create(:party, movie_id: 2, host_id: @user_3.id)
          @party_3 = create(:party, movie_id: 3, host_id: @user_2.id)

          @party_1.users << @user_1
          @party_1.users << @user_2
          @party_1.users << @user_3

          @party_2.users << @user_1
          @party_2.users << @user_2
          @party_2.users << @user_3
          @party_2.users << @user_4

          @party_3.users << @user_1
          @party_3.users << @user_2

          visit login_path
          fill_in 'Email', with: "#{@user_1.email}"
          fill_in 'Password', with: "#{@user_1.password}"
          click_button "Submit"
        end

        it 'Each viewing party has a Movie Image', vcr: { record: :new_episodes } do
          visit dashboard_path

          within("#view-parties-#{@user_1.id}") do
            expect(page).to have_css("img[src='#{MovieFacade.movie_data(@party_1.movie_id).image}']")
            expect(page).to have_css("img[src='#{MovieFacade.movie_data(@party_2.movie_id).image}']")
            expect(page).to have_css("img[src='#{MovieFacade.movie_data(@party_3.movie_id).image}']")
          end

          visit login_path
          fill_in 'Email', with: "#{@user_4.email}"
          fill_in 'Password', with: "#{@user_4.password}"
          click_button "Submit"

          within("#view-parties-#{@user_4.id}") do
            expect(page).to have_css("img[src='#{MovieFacade.movie_data(@party_2.movie_id).image}']")

            expect(page).to_not have_css("img[src='#{MovieFacade.movie_data(@party_1.movie_id).image}']")
            expect(page).to_not have_css("img[src='#{MovieFacade.movie_data(@party_3.movie_id).image}']")
          end
        end

        it 'Each viewing party has a Movie Title, which links to the movie show page', vcr: { record: :new_episodes } do
          visit dashboard_path

          within("#view-parties-#{@user_1.id}") do
            expect(page).to have_link("#{MovieFacade.movie_data(@party_1.movie_id).title}")
            expect(page).to have_link("#{MovieFacade.movie_data(@party_2.movie_id).title}")
            expect(page).to have_link("#{MovieFacade.movie_data(@party_3.movie_id).title}")
          end

          visit login_path
          fill_in 'Email', with: "#{@user_4.email}"
          fill_in 'Password', with: "#{@user_4.password}"
          click_button "Submit"

          within("#view-parties-#{@user_4.id}") do
            expect(page).to have_link("#{MovieFacade.movie_data(@party_2.movie_id).title}")

            expect(page).to_not have_link("#{MovieFacade.movie_data(@party_1.movie_id).title}")
            expect(page).to_not have_link("#{MovieFacade.movie_data(@party_3.movie_id).title}")
          end
        end

        it 'Each viewing party has a Date and Time of the Event', vcr: { record: :new_episodes } do
          visit dashboard_path

          within("#view-parties-#{@user_1.id}") do
            expect(page).to have_content(@party_1.start_date)
            expect(page).to have_content(@party_2.start_date)
            expect(page).to have_content(@party_3.start_date)

            expect(page).to have_content(@party_1.time)
            expect(page).to have_content(@party_2.time)
            expect(page).to have_content(@party_3.time)
          end

          visit login_path
          fill_in 'Email', with: "#{@user_4.email}"
          fill_in 'Password', with: "#{@user_4.password}"
          click_button "Submit"

          within("#view-parties-#{@user_4.id}") do
            expect(page).to have_content(@party_2.start_date)
            expect(page).to have_content(@party_2.time)

            expect(page).to_not have_content(@party_1.start_date)
            expect(page).to_not have_content(@party_3.start_date)

            expect(page).to_not have_content(@party_1.time)
            expect(page).to_not have_content(@party_3.time)
          end
        end

        it 'Each viewing party has a who is hosting, list of users invited', vcr: { record: :new_episodes } do
          visit dashboard_path

          within("#view-parties-#{@user_1.id}") do
            expect(page).to have_content('Hosting')
            expect(page).to have_content('Invited')
          end

          visit login_path
          fill_in 'Email', with: "#{@user_4.email}"
          fill_in 'Password', with: "#{@user_4.password}"
          click_button "Submit"

          within("#view-parties-#{@user_4.id}") do
            expect(page).to have_content('Invited')

            expect(page).to_not have_content('Hosting')
          end
        end

        it 'list of users invited', vcr: { record: :new_episodes } do
          visit dashboard_path

          within("#view-parties-#{@user_1.id}") do
            within("#party-#{@party_1.id}") do
              expect(page).to have_content(@user_1.name)
              expect(page).to have_content(@user_2.name)
              expect(page).to have_content(@user_3.name)
              expect(page).to_not have_content(@user_4.name)
            end

            within("#party-#{@party_2.id}") do
              expect(page).to have_content(@user_1.name)
              expect(page).to have_content(@user_2.name)
              expect(page).to have_content(@user_3.name)
              expect(page).to have_content(@user_4.name)
            end

            within("#party-#{@party_3.id}") do
              expect(page).to have_content(@user_1.name)
              expect(page).to have_content(@user_2.name)
              expect(page).to_not have_content(@user_3.name)
              expect(page).to_not have_content(@user_4.name)
            end
          end

          visit login_path
          fill_in 'Email', with: "#{@user_4.email}"
          fill_in 'Password', with: "#{@user_4.password}"
          click_button "Submit"

          within("#view-parties-#{@user_4.id}") do
            within("#party-#{@party_2.id}") do
              expect(page).to have_content(@user_1.name)
              expect(page).to have_content(@user_2.name)
              expect(page).to have_content(@user_3.name)
              expect(page).to have_content(@user_4.name)
            end
          end
        end
      end
    end
  end
end
