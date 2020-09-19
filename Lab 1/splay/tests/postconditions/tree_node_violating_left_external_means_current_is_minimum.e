note
	description: "Summary description for {TREE_NODE_VIOLATING_LEFT_EXTERNAL_MEANS_CURRENT_IS_MINIMUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_LEFT_EXTERNAL_MEANS_CURRENT_IS_MINIMUM[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			min_node
		end

create
	make_internal, make_external

feature --Redfine Command

	min_node: TREE_NODE[K, V]
		do
			-- This is a wrong implementation
			Result := Current
			if
				attached left as a_left
			then
				if
					attached a_left.left as a_left_left
				then
					Result:= a_left.min_node
				end
			end
			right := Current
		end
end
