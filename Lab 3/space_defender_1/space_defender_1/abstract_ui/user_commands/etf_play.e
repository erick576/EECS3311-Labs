note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
create
	make
feature -- command
	play(row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		require else
			play_precond(row, column, player_mov, project_mov)
		local
			operation_play : OPERATION_PLAY
    	do
			-- perform some update on the model state
			create {OPERATION_PLAY} operation_play.make (row , column , player_mov , project_mov)
			operation_play.execute
			if not model.grid.did_error_occur then
				model.grid.history.put (operation_play)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
