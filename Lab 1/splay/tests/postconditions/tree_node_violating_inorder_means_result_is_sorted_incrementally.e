note
	description: "Summary description for {TREE_NODE_VIOLATING_INORDER_MEANS_RESULT_IS_SORTED_INCREMENTALLY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_INORDER_MEANS_RESULT_IS_SORTED_INCREMENTALLY[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			nodes
		end

create
	make_internal, make_external

feature --Redfine Command

	nodes: LIST[TREE_NODE[K, V]]
		local
			a_max : TREE_NODE[K,V]
		do
			-- This is a wrong implementation
			Result := create {LINKED_LIST[TREE_NODE[K, V]]}.make

			if attached Current.left as a_current then
				Result.append(a_current.nodes)
			end

			if is_internal then
				a_max := Current.max_node
				Result.force(a_max)
			end

			if attached Current.right as a_current then
				Result.append(a_current.nodes)
			end

			Result.compare_objects
		end
end
