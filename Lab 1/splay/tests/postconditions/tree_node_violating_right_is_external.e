note
	description: "Summary description for {TREE_NODE_VIOLATING_RIGHT_IS_EXTERNAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_RIGHT_IS_EXTERNAL[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			make_internal
		end

create
	make_internal, make_external

feature --Redfine Command

	make_internal (p_key: K; p_value: V)
		do
			-- This is a wrong implementation
			key := p_key
			value := p_value

			create left.make_external

			if
				attached left as a_left
			then
				a_left.parent := Current
			end

			create right.make_external

			if
				attached right as a_right
			then
				a_right.parent := Current
			end
			right := Current
		end

end

