note
	description: "Summary description for {STARFIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER

create
	make

feature {NONE} -- Initialization

	make (x_value : INTEGER_32 ; y_value : INTEGER_32)
		do
			x := x_value
			y := y_value
		end

feature -- Setters
	set_x (new_x_value : INTEGER_32)
		do
			x := new_x_value
		end

	set_y (new_y_value : INTEGER_32)
		do
			y := new_y_value
		end

feature -- Attributes

	x : INTEGER_32
	y : INTEGER_32

end
