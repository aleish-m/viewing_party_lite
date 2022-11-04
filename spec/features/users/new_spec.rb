require 'rails_helper'

RSpec.describe 'User Registration Page' do
  describe 'As a user' do
    describe "When a user visits the '/register' path" do
      it 'They should see a form to register. The form should include: Name, Email, Password, Password Confirmation and Register Button, once the user registers they should be taken to a dashboard page /users/:id' do
        visit '/register'

        fill_in 'Name', with: 'Melissa'
        fill_in 'Email', with: 'melissa.j@aol.com'
        fill_in 'Password:', with: 'password'
        fill_in 'Confirm Password', with: 'password'

        click_button 'Register'

        expect(current_path).to eq(user_path(User.find_by(name: 'Melissa')))
      end

      it 'The email must be unique' do
        visit '/register'

        User.create!(name: 'Janny', email: 'Jane.doe@aol.com', password: 'password')

        fill_in 'Name', with: 'Jane'
        fill_in 'Email', with: 'Jane.doe@aol.com'
        fill_in 'Password:', with: 'password'
        fill_in 'Confirm Password', with: 'password'

        click_button 'Register'

        expect(current_path).to eq('/register')
        expect(page).to have_content('Email has already been taken')
      end


      it 'The password and password confirmation must match' do
        visit '/register'

        fill_in 'Name', with: 'Jane'
        fill_in 'Email', with: 'Jane.doe@aol.com'
        fill_in 'Password:', with: 'password'
        fill_in 'Confirm Password', with: 'password2'

        click_button 'Register'

        expect(current_path).to eq('/register')
        expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it 'The password and password confirmation must match' do
        visit '/register'

        fill_in 'Name', with: 'Jane'
        fill_in 'Email', with: 'Jane.doe@aol.com'

        click_button 'Register'

        expect(current_path).to eq('/register')
        expect(page).to have_content("Password can't be blank")
      end
    end
  end
end
