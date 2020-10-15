note
	description: "Summary description for {OPERATION_MOVE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OPERATION_MOVE

inherit
	OPERATION

create
	make

feature {NONE} -- Initialization
	make (row_val: INTEGER_32 ; column_val: INTEGER_32)
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
		end

feature {NONE} -- Attributes
	state : GRID_DATA
	row, column : INTEGER_32

feature -- Deferred

	undo
		do
			grid.update_state (state.deep_twin)
		end

	redo
		do
			execute
		end

	execute
		do
			grid.move (row, column)
		end

end
