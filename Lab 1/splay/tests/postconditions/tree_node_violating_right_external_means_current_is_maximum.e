note
	description: "Summary description for {TREE_NODE_VIOLATING_RIGHT_EXTERNAL_MEANS_CURRENT_IS_MAXIMUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_RIGHT_EXTERNAL_MEANS_CURRENT_IS_MAXIMUM[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			max_node
		end

create
	make_internal, make_external

feature --Redfine Command

	max_node: TREE_NODE[K, V]
		do
			-- This is a wrong implementation
			Result := Current
			if
				attached right as a_right
			then
				if
					attached a_right.right as a_right_right
				then
					Result:= a_right.max_node
				end
			end
			left := Current
		end
end
