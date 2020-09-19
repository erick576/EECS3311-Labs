note
	description: "Summary description for {TREE_NODE_VIOLATING_NO_PARENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_NO_PARENT[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			make_external
		end

create
	make_internal, make_external

feature --Redfine Command

	make_external
		do
			-- This is a wrong implementation
			parent := Current
		end
end
