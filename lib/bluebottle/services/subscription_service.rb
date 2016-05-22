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
        subscription = find_active_subscriptions_by_customer(customer).find do |subscription|
          subscription.coffee_name == coffee.name
        end
        subscription.pause
      end

      def cancel_subscription(customer, coffee)
        subscription = find_any_subscriptions_by_customer(customer).find do |subscription|
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
        if status == 'active'
          find_active_subscriptions_by_customer(customer)
        elsif status == 'paused'
          find_paused_subscriptions_by_customer(customer)
        else
          find_any_subscriptions_by_customer(customer)
        end
      end

      def find_any_subscriptions_by_customer(customer)
        @data_store.subscriptions.select do |subscription|
          (subscription.customer_name == customer.full_name)
        end
      end

      def find_active_subscriptions_by_customer(customer)
        @data_store.subscriptions.select do |subscription|
          (subscription.customer_name == customer.full_name) && (subscription.active?)
        end
      end

      def find_paused_subscriptions_by_customer(customer)
        @data_store.subscriptions.select do |subscription|
          (subscription.customer_name == customer.full_name) && (subscription.paused?)
        end
      end

      def find_subscriptions_by_coffee(coffee, status = 'any')
        if status == 'active'
          find_active_subscriptions_by_coffee(coffee)
        else
          find_all_subscriptions_by_coffee(coffee)
        end
      end

      def find_all_subscriptions_by_coffee(coffee)
        @data_store.subscriptions.select do |subscription|
          subscription.coffee_name == coffee.name
        end
      end

      def find_active_subscriptions_by_coffee(coffee)
        @data_store.subscriptions.select do |subscription|
          subscription.coffee_name == coffee.name && subscription.active?
        end
      end
    end
  end
end
