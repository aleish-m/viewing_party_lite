require 'rails_helper'

RSpec.describe Party, type: :model do
  describe 'relationships' do
    it { should have_many(:user_parties) }
    it { should have_many(:users).through(:user_parties) }
  end

  describe 'validations' do
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:host_id) }
    it { should validate_presence_of(:movie_runtime) }

    it { should validate_numericality_of(:duration) }
    it { should validate_numericality_of(:movie_id) }
    it { should validate_numericality_of(:host_id) }
    it { should validate_numericality_of(:movie_runtime) }
  end

  describe 'model methods' do
    before :each do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)
      @user_4 = create(:user)

      @party_1 = Party.create!(movie_id: 8, duration: 80, date: '2023/8/10', start_time: '21:00', host_id: @user_1.id,
                               movie_runtime: 80)
      @party_2 = Party.create!(movie_id: 2, duration: 73, date: '10/12/2022', start_time: '18:00', host_id: @user_3.id,
                               movie_runtime: 73)
      @party_3 = Party.create!(movie_id: 3, duration: 74, date: '12/11/2022', start_time: '16:30', host_id: @user_2.id,
                               movie_runtime: 70)
    end

    it 'has start_date and time' do
      expect(@party_1.start_date).to eq('August 10, 2023')
      expect(@party_1.time).to eq('09:00 PM')
      expect(@party_2.start_date).to eq('December 10, 2022')
      expect(@party_2.time).to eq('06:00 PM')
      expect(@party_2.start_date).to_not eq('August 10, 2023')
      expect(@party_2.time).to_not eq('09:00 PM')
    end

    it 'find_host' do
      expect(@party_1.find_host).to eq("#{@user_1.name}")
      expect(@party_2.find_host).to eq("#{@user_3.name}")
      expect(@party_2.find_host).to_not eq("#{@user_2.name}")
    end

    it 'find_title', :vcr do
      expect(@party_1.find_title).to eq('Life in Loops (A Megacities RMX)')
      expect(@party_2.find_title).to eq('Ariel')
      expect(@party_2.find_title).to_not eq('Life in Loops (A Megacities RMX)')
    end

    it 'find_image_url', :vcr do
      expect(@party_1.find_image_url).to eq('https://image.tmdb.org/t/p/w500/x7Sz339F2oC8mBf0DHCQpKizXaL.jpg')
      expect(@party_2.find_image_url).to eq('https://image.tmdb.org/t/p/w500/ojDg0PGvs6R9xYFodRct2kdI6wC.jpg')
      expect(@party_2.find_image_url).to_not eq('https://image.tmdb.org/t/p/w500/x7Sz339F2oC8mBf0DHCQpKizXaL.jpg')
    end
  end
end
