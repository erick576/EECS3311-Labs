note
	description: "Summary description for {TREE_NODE_VIOLATING_KEEP_RIGHT_PARENT_REFERENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_KEEP_RIGHT_PARENT_REFERENCE[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			insert_right
		end

create
	make_internal, make_external

feature --Redfine Command

	insert_right (p_node: like Current)
		do
			-- This is a wrong implementation
			Current.set_right (p_node)

			if
				attached right as a_right
			then
				a_right.parent := void
			end
		end

end
