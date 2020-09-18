note
	description: "Summary description for {BAD_BIRTHDAY_VIOLATING_DAY_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BAD_BIRTHDAY_VIOLATING_DAY_SET


inherit
	BIRTHDAY
		redefine
			make
		end

create
	make

feature --Redfine Command

	make (m:INTEGER; d:INTEGER)
		do
			-- This is a wrong implementation
			month := m
			day := m -- This line should trigger a postcondition violation with tag "day_set"
			-- Do not write any postcondition here
			-- all the postcondition from birthday will be inherited
		end
end
