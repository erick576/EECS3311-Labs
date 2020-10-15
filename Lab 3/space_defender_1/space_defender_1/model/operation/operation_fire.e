note
	description: "Summary description for {OPERATION_FIRE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OPERATION_FIRE

inherit
	OPERATION

create
	make

feature {NONE} -- Initialization
	make
		do
			create state.make
			state.set_counters (0, grid.grid_data.get_valid_command_count)
			state.set_error_message (create {STRING}.make_empty)
			state.set_grid (grid.grid_data.get_grid_elements)
			state.set_operation_message (grid.grid_data.get_operation_message)
			state.set_player_status (grid.grid_data.get_currently_playing, grid.grid_data.get_is_error, grid.grid_data.get_still_alive)
			state.set_projectiles (grid.grid_data.get_projectiles)
			state.set_starfighter (grid.grid_data.get_starfighter)
		end

feature {NONE} -- Attributes
	state : GRID_DATA

feature -- Setters

feature -- Deferred

	undo
		do
			grid.update_state (state)
		end

	redo
		do
			execute
		end

	execute
		do
			grid.fire
		end


end
