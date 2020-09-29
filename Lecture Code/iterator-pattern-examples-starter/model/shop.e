note
	description: "Summary description for {SHOP}."
	author: "Jackie Wang and You"
	date: "$Date$"
	revision: "$Revision$"

class
	SHOP

create
	make

feature -- Commands
	make
			-- creates an empty shop
		do
			create cart.make
		ensure
			empty_shop: cart.orders.is_empty
		end

	add_order (o: ORDER)
		do
			cart.orders.force (o, cart.orders.count + 1)
		ensure
			-- To Do: Complete Postcondition
		end

feature -- Attributes
	cart: CART

feature -- Queries
	checkout: INTEGER
		local
			i: INTEGER
		do
			from
				i := cart.orders.lower
			until
				i > cart.orders.upper
			loop
				Result := Result + cart.orders[i].price * cart.orders[i].quantity
				i := i + 1
			end
		ensure
			nothing_changed:
				-- To Do: Complete this postcondition and run the test.
		end
end
