require 'active_support/all'

module BlueBottle
  module Models
    class Subscription
      attr_accessor :id,
                    :customer,
                    :coffee,
                    :status

      def initialize(id, customer, coffee)
        @id = id
        @customer = customer
        @coffee = coffee
        @status = 'active'
      end

      def customer_name
        customer.full_name
      end

      def coffee_name
        coffee.name
      end

      def coffee_type
        coffee.type
      end
    end
  end
end
