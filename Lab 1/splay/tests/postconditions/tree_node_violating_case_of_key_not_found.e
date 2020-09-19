note
	description: "Summary description for {TREE_NODE_VIOLATING_CASE_OF_KEY_NOT_FOUND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_CASE_OF_KEY_NOT_FOUND[K -> COMPARABLE, V -> ANY]

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
			if is_external then Result := Current end
			if is_internal then
				if Current.key ~ p_key then
					Result := Current
				end

				if
					attached key as a_key
				then
					if p_key < a_key then
						if attached Current.left as a_current then
							Result := a_current.tree_search (p_key)
						end
					end

					if p_key > a_key then
						if attached Current.right as a_current then
							Result := a_current.tree_search (p_key)
						end
					end
				end
			end

			Result := create {TREE_NODE[K,V]}.make_external
		end
end
