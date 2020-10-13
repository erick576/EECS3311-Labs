note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

create
	make

feature {NONE} -- Initialization

	make
			-- create new grid for the model
		do
			row_size := 0
			col_size := 0

--			create starfighter.make
--			create projectiles.make

			valid_command_count := 0
			error_count := 0

			grid_char_rows := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create grid_elements.make_empty

			currently_playing := false
			still_alive := true

			operation_message := "Welcome to Space Defender Version 1."
			create error_message.make_empty
		end

	reset
		do

		end

feature {NONE} -- Attributes

	row_size : INTEGER
	col_size : INTEGER

--	starfighter : STARFIGHTER
--	projectiles : ARRAYED_LIST[PROJECTILE]

	valid_command_count : INTEGER
	error_count : INTEGER

	grid_char_rows : ARRAY[CHARACTER]
	grid_elements : ARRAY[CHARACTER]

	currently_playing : BOOLEAN
	still_alive : BOOLEAN

	operation_message : STRING
	error_message : STRING


feature {NONE} -- queries

feature {NONE} -- Helpers

feature -- Output Displays

--	display_error : STRING
--		do

--		end

--	display_state : STRING
--		do

--		end

--	display_operation_messages : STRING
--		do

--		end

--	display_grid : STRING
--		do

--		end

	display_output(state : INTEGER) : STRING
		do
			create Result.make_empty

			-- Default Greeting into the game
			if state ~ 0 then
				Result.append("  " + operation_message)
			end
		end

feature {ETF_COMMAND} -- commands to implement

--	turn_first_part
--		do

--		end

--	abort
--		do

--		end

--	fire
--		do

--		end

--	move
--		do

--		end

--	pass
--		do

--		end

--	play
--		do

--		end
end
