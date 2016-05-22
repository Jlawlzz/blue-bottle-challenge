require 'bluebottle'

describe BlueBottle::Models::Customer do
  let(:sally) { BlueBottle::Models::Customer.new(1, 'Sally', 'Fields', 'sally@fields.com') }

  context '#full_name' do

    it 'should return their full name' do
      expect(sally.full_name).to eql('Sally Fields')
    end

  end
end
