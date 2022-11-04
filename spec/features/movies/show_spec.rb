require 'rails_helper'

RSpec.describe 'Movie Detail Page', type: :feature do
  describe 'As a User' do
    before :each do
      @user_1 = create(:user)

      @movie_1 = MovieFacade.movie_data(271_110)
      @movie_2 = MovieFacade.movie_data(3)
    end

    describe 'When I visit a movies detail page' do
      it 'I see a button to create a viewing party', vcr: { record: :new_episodes } do
        visit user_movie_path(@user_1, @movie_1.id)

        within('#action_options') do
          click_button "Create Viewing Party for #{@movie_1.title}"
        end
        expect(current_path).to eq(new_user_movie_viewing_party_path(@user_1, @movie_1.id))

        visit user_movie_path(@user_1, @movie_2.id)

        within('#action_options') do
          click_button "Create Viewing Party for #{@movie_2.title}"
        end
        expect(current_path).to eq(new_user_movie_viewing_party_path(@user_1, @movie_2.id))
      end

      it 'I see a Button to return to the Discover Page', :vcr do
        visit user_movie_path(@user_1, @movie_1.id)

        within('#action_options') do
          click_button 'Discover Page'
        end
        expect(current_path).to eq(user_discover_path(@user_1))

        visit user_movie_path(@user_1, @movie_2.id)

        within('#action_options') do
          click_button 'Discover Page'
        end
        expect(current_path).to eq(user_discover_path(@user_1))
      end

      describe 'I should see the following information:' do
        it 'Movie Title', :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-details") do
            expect(page).to have_content(@movie_1.title)
          end
          expect(page).to_not have_content(@movie_2.title)

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-details") do
            expect(page).to have_content(@movie_2.title)
          end
          expect(page).to_not have_content(@movie_1.title)
        end

        it 'Vote Average of the movie', :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-details") do
            expect(page).to have_content("Vote Average: #{@movie_1.rating}")
          end
          expect(page).to_not have_content("Vote Average: #{@movie_2.rating}")

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-details") do
            expect(page).to have_content("Vote Average: #{@movie_2.rating}")
          end
          expect(page).to_not have_content("Vote Average: #{@movie_1.rating}")
        end

        it 'Runtime in hours & minutes', :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-details") do
            expect(page).to have_content("Run Time: #{@movie_1.runtime_in_hours}")
          end
          expect(page).to_not have_content("Run Time: #{@movie_2.runtime_in_hours}")

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-details") do
            expect(page).to have_content("Run Time: #{@movie_2.runtime_in_hours}")
          end
          expect(page).to_not have_content("Run Time: #{@movie_1.runtime_in_hours}")
        end

        it 'Genre(s) associated to movie', :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-details") do
            expect(page).to have_content("Genre(s): #{@movie_1.genre_list}")
          end
          expect(page).to_not have_content("Genre(s): #{@movie_2.genre_list}")

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-details") do
            expect(page).to have_content("Genre(s): #{@movie_2.genre_list}")
          end
          expect(page).to_not have_content("Genre(s): #{@movie_1.genre_list}")
        end

        it 'Summary description', :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-description") do
            expect(page).to have_content(@movie_1.summary)
          end
          expect(page).to_not have_content(@movie_2.summary)

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-description") do
            expect(page).to have_content(@movie_2.summary)
          end
          expect(page).to_not have_content(@movie_1.summary)
        end

        it 'List the first 10 cast members (characters&actress/actors)', :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-description") do
            MovieFacade.cast_data(@movie_1.id).each do |cast|
              expect(page).to have_content("#{cast.name} as #{cast.character}")
            end
          end

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-description") do
            MovieFacade.cast_data(@movie_2.id).each do |cast|
              expect(page).to have_content("#{cast.name} as #{cast.character}")
            end
          end
        end

        it 'Count of total reviews', :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-reviews") do
            expect(page).to have_content("#{MovieFacade.review_data(@movie_1.id).count} Reviews")
          end
          expect(page).to_not have_content("#{MovieFacade.review_data(@movie_2.id).count} Reviews")

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-reviews") do
            expect(page).to have_content("#{MovieFacade.review_data(@movie_2.id).count} Reviews")
          end
          expect(page).to_not have_content("#{MovieFacade.review_data(@movie_1.id).count} Reviews")
        end

        it "Each review's author and information", :vcr do
          visit user_movie_path(@user_1, @movie_1.id)

          within("#movie-#{@movie_1.id}-reviews") do
            MovieFacade.review_data(@movie_1.id).each_with_index do |review, index|
              within("#review-#{index}") do
                expect(page).to have_content(review.author)
                expect(page).to have_content(review.content[0..10])
              end
            end
          end

          unwanted_movie_reviews = MovieFacade.review_data(@movie_2.id)
          expect(page).to_not have_content(unwanted_movie_reviews[0].content[0..10])

          visit user_movie_path(@user_1, @movie_2.id)

          within("#movie-#{@movie_2.id}-reviews") do
            MovieFacade.review_data(@movie_2.id).each_with_index do |review, index|
              within("#review-#{index}") do
                expect(page).to have_content(review.author)
                expect(page).to have_content(review.content[0..10])
              end
            end

            unwanted_movie_reviews = MovieFacade.review_data(@movie_1.id)
            expect(page).to_not have_content(unwanted_movie_reviews[0].content[0..10])
          end
        end
      end
    end
  end
end
