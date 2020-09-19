note
	description: "Summary description for {TREE_NODE_VIOLATING_RESULT_IS_MAXIMUM_IN_THIS_SUBTREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_RESULT_IS_MAXIMUM_IN_THIS_SUBTREE[K -> COMPARABLE, V -> ANY]

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
		end
end
