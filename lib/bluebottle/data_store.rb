module BlueBottle

  class DataStore
    def initialize
      @store = {
        customers: [],
        coffees: [],
        subscriptions: []
      }
    end

    def customers
       @store[:customers]
    end

    def subscriptions
      @store[:subscriptions]
    end

    def add_coffee(coffee)
      @store[:coffees] << coffee
    end

    def add_customer(customer)
      @store[:customers] << customer
    end

    def add_subscription(subscription)
      @store[:subscriptions] << subscription
    end

    def find_subscriptions_by_customer(customer, status = 'any')
      if status == 'active'
        find_active_subscriptions_by_customer(customer)
      elsif status == 'paused'
        find_paused_subscriptions_by_customer(customer)
      else
        find_all_subscriptions_by_customer(customer)
      end
    end

    def find_all_subscriptions_by_customer(customer)
      @store[:subscriptions].select do |subscription|
        (subscription.customer_name == customer.full_name)
      end
    end

    def find_active_subscriptions_by_customer(customer)
      @store[:subscriptions].select do |subscription|
        (subscription.customer_name == customer.full_name) && (subscription.active?)
      end
    end

    def find_paused_subscriptions_by_customer(customer)
      @store[:subscriptions].select do |subscription|
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
      @store[:subscriptions].select do |subscription|
        subscription.coffee_name == coffee.name
      end
    end

    def find_active_subscriptions_by_coffee(coffee)
      @store[:subscriptions].select do |subscription|
        subscription.coffee_name == coffee.name && subscription.active?
      end
    end

  end
end
