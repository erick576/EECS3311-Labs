note
	description: "Summary description for {OPERATION_PLAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OPERATION_PLAY

inherit
	OPERATION

create
	make

feature {NONE} -- Initialization
	make (row_val: INTEGER_32 ; column_val: INTEGER_32 ; player_mov_val: INTEGER_32 ; project_mov_val: INTEGER_32)
		do
			create state.make
			state.set_counters (0, grid.grid_data.get_valid_command_count)
			state.set_error_message (create {STRING}.make_empty)
			state.set_grid (grid.grid_data.get_grid_elements.deep_twin)
			state.set_operation_message (grid.grid_data.get_operation_message.deep_twin)
			state.set_player_status (grid.grid_data.get_currently_playing, grid.grid_data.get_is_error, grid.grid_data.get_still_alive)
			state.set_projectiles (grid.grid_data.get_projectiles.deep_twin)
			state.set_starfighter (grid.grid_data.get_starfighter.deep_twin)

			row := row_val
			column := column_val
			player_mov := player_mov_val
			project_mov := project_mov_val
		end

feature {NONE} -- Attributes
	state : GRID_DATA
	row, column, player_mov, project_mov: INTEGER_32

feature -- Deferred

	undo
		do
			grid.update_state (state.deep_twin)
		end

	redo
		do
			-- Do Nothing
		end

	execute
		do
			grid.play (row , column , player_mov , project_mov)
		end
		
end
