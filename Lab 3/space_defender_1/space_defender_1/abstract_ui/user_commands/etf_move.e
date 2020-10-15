note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make
feature -- command
	move(row: INTEGER_32 ; column: INTEGER_32)
		require else
			move_precond(row, column)
		local
			operation_move : OPERATION_MOVE
    	do
			-- perform some update on the model state
			create {OPERATION_MOVE} operation_move.make (model.grid.decode(row), column)
			operation_move.execute
			if not model.grid.did_error_occur then
				model.grid.history.put (operation_move)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
