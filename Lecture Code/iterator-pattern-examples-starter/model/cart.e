note
	description: "Summary description for {CART}."
	author: "Jackie Wang and You"
	date: "$Date$"
	revision: "$Revision$"

class
	CART 

create
	make

feature -- Commands
	make
			-- creates an empty cart
		do
			create orders.make_empty
		ensure
			empty_cart: orders.is_empty
		end

feature -- Attributes
	orders: ARRAY[ORDER]

end
