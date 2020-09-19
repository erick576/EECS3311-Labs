note
	description: "Summary description for {TREE_NODE_VIOLATING_KEEP_LEFT_PARENT_REFERENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_KEEP_LEFT_PARENT_REFERENCE[K -> COMPARABLE, V -> ANY]

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
				a_left.parent := void
			end
		end

end
