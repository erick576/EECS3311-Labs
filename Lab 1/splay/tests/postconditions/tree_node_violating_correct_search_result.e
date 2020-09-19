note
	description: "Summary description for {TREE_NODE_VIOLATING_CORRECT_SEARCH_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_VIOLATING_CORRECT_SEARCH_RESULT[K -> COMPARABLE, V -> ANY]

inherit
	TREE_NODE[K , V]
		redefine
			has
		end

create
	make_internal, make_external

feature --Redfine Command

	has (p_key: K): BOOLEAN
		do
			-- This is a wrong implementation
			Result := False
			if is_external then Result := False end
			if is_internal then
				if Current.key ~ p_key then
					Result := True
				end

				if
					attached key as a_key
				then
					if p_key < a_key then
						if attached Current.left as a_current then
							Result := a_current.has (p_key)
						end
					end

					if p_key > a_key then
						if attached Current.right as a_current then
							Result := a_current.has (p_key)
						end
					end
				end
			end

			if Result = True then
				Result := False

			else
				Result := True
			end
		end
end
