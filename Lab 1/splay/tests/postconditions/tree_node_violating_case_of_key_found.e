note
	description: "Summary description for {TREE_NODE_VIOLATING_CASE_OF_KEY_FOUND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_CASE_OF_KEY_FOUND[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			tree_search
		end

create
	make_internal, make_external

feature --Redfine Command

	tree_search (p_key: K): TREE_NODE[K, V]
		do
			-- This is a wrong implementation
			Result := Current
		end
end
