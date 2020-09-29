note
	description: "[
		Tests of the Iterator Design Patterns.
		]"
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision 19.05$"

class
	TEST_ITERATORS

inherit

	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do
			add_boolean_case (agent test_cart_value)
		end

feature -- tests

	test_cart_value: BOOLEAN
		local
			shop: SHOP
			coffee, bagel: ORDER
		do
			comment ("t0: Test calculation of cart value")
			create shop.make
			Result := shop.checkout = 0
			check Result end
			create coffee.make (2, 3)
			create bagel.make (3, 4)
			shop.add_order (coffee)
			shop.add_order (bagel)
			Result := shop.checkout = 2 * 3 + 3 * 4
		end

end
