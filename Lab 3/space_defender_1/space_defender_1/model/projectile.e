note
	description: "Summary description for {PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTILE

create
	make

feature {NONE} -- Initialization

	make (x_value : INTEGER_32 ; y_value : INTEGER_32)
		do
			x := x_value
			y := y_value
		end

feature -- Attributes

	x : INTEGER_32
	y : INTEGER_32

end
