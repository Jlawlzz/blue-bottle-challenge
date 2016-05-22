require 'bluebottle'
require 'bluebottle/coding_question'

describe BlueBottle::CodingQuestion do
  let(:sally) { BlueBottle::Models::Customer.new(1, 'Sally', 'Fields', 'sally@movies.com') }
  let(:jack) { BlueBottle::Models::Customer.new(2, 'Jack', 'Nickleson', 'jack@movies.com') }
  let(:liv) { BlueBottle::Models::Customer.new(3, 'Liv', 'Tyler', 'liv@movies.com') }
  let(:elijah) { BlueBottle::Models::Customer.new(4, 'Elijah', 'Wood', 'elijah@movies.com') }

  let(:bella_donovan) { BlueBottle::Models::Coffee.new(1, 'Bella Donovan', 'blend') }
  let(:giant_steps) { BlueBottle::Models::Coffee.new(2, 'Giant Steps', 'blend') }
  let(:hayes_valley_espresso) { BlueBottle::Models::Coffee.new(3, 'Hayes Valley Espresso', 'blend') }

  let(:store) { BlueBottle::DataStore.new }
  let(:subscription_service) { BlueBottle::Services::SubscriptionService.new(store) }

  before do
    store.add_customer(sally)
    store.add_customer(jack)
    store.add_customer(liv)
    store.add_customer(elijah)

    store.add_coffee(bella_donovan)
    store.add_coffee(giant_steps)
    store.add_coffee(hayes_valley_espresso)
  end

  context 'Sally subscribes to Bella Donovan' do
    before do
      subscription_service.new_subscription(1, sally, bella_donovan)
    end

    it 'Sally should have one active subscription' do
      expect(subscription_service.find_active_subscriptions_by_customer(sally).count).to eql(1)
      expect(subscription_service.find_active_subscriptions_by_customer(sally)[0].coffee_name).to eql('Bella Donovan')
      expect(subscription_service.find_active_subscriptions_by_customer(sally)[0].coffee_type).to eql('blend')
    end

    it 'Bella Donovan should have one customer subscribed to it' do
      expect(subscription_service.find_subscriptions_by_coffee(bella_donovan).count).to eql(1)
      expect(subscription_service.find_subscriptions_by_coffee(bella_donovan)[0].customer_name).to eql('Sally Fields')
    end
  end

  context 'Liv and Elijah subscribe to Hayes Valley Espresso' do
    before do
      subscription_service.new_subscription(2, liv, hayes_valley_espresso)
      subscription_service.new_subscription(3, elijah, hayes_valley_espresso)
    end

    it 'Liv should have one active subscription' do
      expect(subscription_service.find_active_subscriptions_by_customer(liv).count).to eql(1)
      expect(subscription_service.find_active_subscriptions_by_customer(liv)[0].coffee_name).to eql('Hayes Valley Espresso')
      expect(subscription_service.find_active_subscriptions_by_customer(liv)[0].coffee_type).to eql('blend')
    end

    it 'Elijah should have one active subscription' do
      expect(subscription_service.find_active_subscriptions_by_customer(elijah).count).to eql(1)
      expect(subscription_service.find_active_subscriptions_by_customer(elijah)[0].coffee_name).to eql('Hayes Valley Espresso')
      expect(subscription_service.find_active_subscriptions_by_customer(elijah)[0].coffee_type).to eql('blend')
    end

    it 'Hayes Valley Espresso should have two customers subscribed to it' do
      expect(subscription_service.find_subscriptions_by_coffee(hayes_valley_espresso).count).to eql(2)
      expect(subscription_service.find_subscriptions_by_coffee(hayes_valley_espresso)[0].customer_name).to eql('Liv Tyler')
      expect(subscription_service.find_subscriptions_by_coffee(hayes_valley_espresso)[1].customer_name).to eql('Elijah Wood')
    end
  end

  context 'Pausing:' do
    context 'when Liv pauses her subscription to Bella Donovan,' do
      before do
        subscription_service.new_subscription(2, liv, bella_donovan)
        subscription_service.pause_subscription(liv, bella_donovan)
      end

      it 'Liv should have zero active subscriptions' do
        expect(subscription_service.find_active_subscriptions_by_customer(liv).count).to eql(0)
      end

      it 'Liv should have a paused subscription' do
        expect(subscription_service.find_paused_subscriptions_by_customer(liv).count).to eql(1)
      end

      it 'Bella Donovan should have one customers subscribed to it' do
        expect(subscription_service.find_subscriptions_by_coffee(bella_donovan).count).to eql(1)
      end
    end
  end

  context 'Cancelling:' do
    context 'when Jack cancels his subscription to Bella Donovan,' do
      before do
        subscription_service.new_subscription(1, jack, bella_donovan)
        subscription_service.cancel_subscription(jack, bella_donovan)
      end

      it 'Jack should have zero active subscriptions' do
        expect(subscription_service.find_active_subscriptions_by_customer(jack).count).to eql(0)
      end

      it 'Bella Donovan should have zero active customers subscribed to it' do
        expect(subscription_service.find_subscriptions_by_coffee(bella_donovan, 'active').count).to eql(0)
      end

      context 'when Jack resubscribes to Bella Donovan' do
        before do
          # Establish subscription here
        end

        xit 'Bella Donovan has two subscriptions, one active, one cancelled' do
        end

      end
    end
  end

  context 'Cancelling while Paused:' do
    context 'when Jack tries to cancel his paused subscription to Bella Donovan,' do
      before do
        # Establish paused subscription here
      end

      xit 'Jack raises an exception preventing him from cancelling a paused subscription' do
      end
    end
  end



end
