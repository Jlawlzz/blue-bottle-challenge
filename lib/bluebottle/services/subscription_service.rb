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

      def find_active_subscriptions_by_customer(customer)
        @data_store.subscriptions.select do |subscription|
          subscription.customer_name == customer.full_name
        end
      end

      def find_subscriptions_by_coffee(coffee)
        @data_store.subscriptions.select do |subscription|
          subscription.coffee_name == coffee.name
        end
      end

    end
  end
end
