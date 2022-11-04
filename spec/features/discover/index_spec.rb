require 'rails_helper'

RSpec.describe 'Discover Movies page', type: :feature do
  before :each do
    @user_1 = create(:user)

    visit login_path
    fill_in 'Email', with: "#{@user_1.email}"
    fill_in 'Password', with: "#{@user_1.password}"
    click_button "Submit"

    visit discover_path
  end

  it 'user sees Discover Movies title' do
    expect(page).to have_content('Discover Movies')
    expect(current_path).to eq(discover_path)
  end

  it 'has button to discover top rated movies' do
    expect(page).to have_button('Find Top Rated Movies')
  end

  it 'has a search field with text to Search by movie title' do
    expect(page).to have_field('Search by Movie Title')
  end

  it 'has button to search for a movie by name' do
    expect(page).to have_button('Find Movies')
  end

  it 'has movie title links that lead to the correct path', :vcr do
    click_button('Find Top Rated Movies')

    click_link('The Godfather')

    expect(page).to have_current_path(movie_path(238))
  end

  it 'has the correct page title', :vcr do
    click_button('Find Top Rated Movies')

    expect(page).to have_content('Top Rated Movies')
  end

  it 'has a functioning button to return to the discover page', :vcr do
    click_button('Find Top Rated Movies')

    click_button('Discover Movies')
    expect(page).to have_current_path(discover_path)
  end

  it 'returns matches and partial matches based off keyword', :vcr do
    fill_in(:q, with: 'miss cong')
    click_button('Find Movies')

    expect(page).to have_content('Miss Congeniality')
    expect(page).to have_content('Miss Congeniality 2: Armed and Fabulous')
    expect(page).to have_content('Miss Congo')
    expect(page).to_not have_content('Fight Club')
  end

  it 'button to return to discover page', :vcr do
    fill_in(:q, with: 'miss cong')
    click_button('Find Movies')
    click_button('Discover Movies')

    expect(current_path).to eq(discover_path)
  end
end
