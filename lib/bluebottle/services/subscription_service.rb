module BlueBottle
  module Services
    class SubscriptionService

      def initialize(data_store)
        @data_store = data_store
      end

      def new_subscription(id, customer, coffee)
        subscription = BlueBottle::Models::Subscription.new(id, customer, coffee)
        @data_store.add_subscription(subscription)
      end

      def pause_subscription(customer, coffee)
        subscription = @data_store.find_subscriptions_by_customer(customer, 'active').find do |subscription|
          subscription.coffee_name == coffee.name
        end
        subscription.pause
      end

      def cancel_subscription(customer, coffee)
        subscription = @data_store.find_subscriptions_by_customer(customer).find do |subscription|
          subscription.coffee_name == coffee.name
        end
        cancel_switch(subscription)
      end

      def cancel_switch(subscription)
        begin
          subscription.active? ? subscription.cancel : raise_cancel_exception
        rescue Exception
          'Sorry, you cannot cancel a paused subscription.'
        end
      end

      def raise_cancel_exception
        raise Exception.new('subscription paused')
      end

      def find_subscriptions_by_customer(customer, status = 'any')
        @data_store.find_subscriptions_by_customer(customer, status)
      end

      def find_subscriptions_by_coffee(coffee, status = 'any')
        @data_store.find_subscriptions_by_coffee(coffee, status)
      end
    end
  end
end
