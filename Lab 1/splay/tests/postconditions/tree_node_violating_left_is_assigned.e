note
	description: "Summary description for {TREE_NODE_VIOLATING_LEFT_IS_ASSIGNED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_LEFT_IS_ASSIGNED[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			insert_left
		end

create
	make_internal, make_external

feature --Redfine Command

	insert_left (p_node: like Current)
		do
			-- This is a wrong implementation
			Current.set_left (p_node)

			if
				attached left as a_left
			then
				a_left.parent := Current
			end
			left := Current
		end

end
