note
	description: "Summary description for {TREE_NODE_VIOLATING_CORRECT_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_CORRECT_RESULT[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			count
		end

create
	make_internal, make_external

feature --Redfine Command

	count: INTEGER
		do
			-- This is a wrong implementation
			if
				is_external
			then
				Result := 0
			end

			if
				not is_external
			then
				Result := 1
			end

			if
				attached right as a_right
			then
				Result := Result + a_right.count
			end

			if
				attached left as a_left
			then
				Result:= Result + a_left.count
			end

			Result := Result + 3
		end

end
