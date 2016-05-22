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
      sally_active_subcriptions = subscription_service.find_subscriptions_by_customer(sally, 'active')
      expect(sally_active_subcriptions.count).to eql(1)
      expect(sally_active_subcriptions[0].coffee_name).to eql('Bella Donovan')
      expect(sally_active_subcriptions[0].coffee_type).to eql('blend')
    end

    it 'Bella Donovan should have one customer subscribed to it' do
      bella_donovan_subscribers = subscription_service.find_subscriptions_by_coffee(bella_donovan)
      expect(bella_donovan_subscribers.count).to eql(1)
      expect(bella_donovan_subscribers[0].customer_name).to eql('Sally Fields')
    end
  end

  context 'Liv and Elijah subscribe to Hayes Valley Espresso' do
    before do
      subscription_service.new_subscription(2, liv, hayes_valley_espresso)
      subscription_service.new_subscription(3, elijah, hayes_valley_espresso)
    end

    it 'Liv should have one active subscription' do
      liv_active_subscriptions = subscription_service.find_subscriptions_by_customer(liv, 'active')
      expect(liv_active_subscriptions.count).to eql(1)
      expect(liv_active_subscriptions[0].coffee_name).to eql('Hayes Valley Espresso')
      expect(liv_active_subscriptions[0].coffee_type).to eql('blend')
    end

    it 'Elijah should have one active subscription' do
      elijah_active_subscriptions = subscription_service.find_subscriptions_by_customer(elijah, 'active')
      expect(elijah_active_subscriptions.count).to eql(1)
      expect(elijah_active_subscriptions[0].coffee_name).to eql('Hayes Valley Espresso')
      expect(elijah_active_subscriptions[0].coffee_type).to eql('blend')
    end

    it 'Hayes Valley Espresso should have two customers subscribed to it' do
      hayes_valley_subscribers = subscription_service.find_subscriptions_by_coffee(hayes_valley_espresso)
      expect(hayes_valley_subscribers.count).to eql(2)
      expect(hayes_valley_subscribers[0].customer_name).to eql('Liv Tyler')
      expect(hayes_valley_subscribers[1].customer_name).to eql('Elijah Wood')
    end
  end

  context 'Pausing:' do
    context 'when Liv pauses her subscription to Bella Donovan,' do
      before do
        subscription_service.new_subscription(2, liv, bella_donovan)
        subscription_service.pause_subscription(liv, bella_donovan)
      end

      it 'Liv should have zero active subscriptions' do
        expect(subscription_service.find_subscriptions_by_customer(liv, 'active').count).to eql(0)
      end

      it 'Liv should have a paused subscription' do
        expect(subscription_service.find_subscriptions_by_customer(liv, 'paused').count).to eql(1)
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
        expect(subscription_service.find_subscriptions_by_customer(jack, 'active').count).to eql(0)
      end

      it 'Bella Donovan should have zero active customers subscribed to it' do
        expect(subscription_service.find_subscriptions_by_coffee(bella_donovan, 'active').count).to eql(0)
      end

      context 'when Jack resubscribes to Bella Donovan' do
        before do
          subscription_service.new_subscription(2, jack, bella_donovan)
        end

        it 'Bella Donovan has two subscriptions, one active, one cancelled' do
          bella_donovan_subscribers = subscription_service.find_subscriptions_by_coffee(bella_donovan)
          expect(bella_donovan_subscribers.count).to eql(2)
          expect(bella_donovan_subscribers[0].status).to eql('cancelled')
          expect(bella_donovan_subscribers[1].status).to eql('active')
        end

      end
    end
  end

  context 'Cancelling while Paused:' do
    context 'when Jack tries to cancel his paused subscription to Bella Donovan,' do
      before do
        subscription_service.new_subscription(1, jack, bella_donovan)
        subscription_service.pause_subscription(jack, bella_donovan)
      end

      it 'Jack raises an exception preventing him from cancelling a paused subscription' do
        expect(subscription_service.cancel_subscription(jack, bella_donovan)).to eql('Sorry, you cannot cancel a paused subscription.')
      end
    end
  end

end
