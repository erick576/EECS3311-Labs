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

			player_move := 0
			project_move := 0

			create starfighter.make (0, 0)
			create projectiles.make (0)

			valid_command_count := 0
			error_count := 0

			grid_char_rows := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create grid_elements.make_empty

			currently_playing := false
			still_alive := true
			is_error := false

			operation_message := "Welcome to Space Defender Version 1."
			game_over_message := "The game is over. Better luck next time!"
			create error_message.make_empty
		end

	reset (row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		local
			start_pos : DOUBLE
		do
			-- Set the row and column size
			row_size := row
			col_size := column

			-- Set the player_mov and projectile_mov
			player_move := player_mov
			project_move := project_move

			-- Set up the ceiling of the row / 2 for the default position in the grid
			start_pos := row_size / 2

			-- Use the set up value to set the position of the starfighter and default porjectiles (0)
			create starfighter.make (start_pos.ceiling, 1)
			create projectiles.make (0)

			-- Set up the row values and grid values in character form
			grid_char_rows := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create grid_elements.make_filled ('_', 0, row_size * col_size)
			grid_elements.force ('S', ((starfighter.x - 1) * col_size) + starfighter.y)

			-- Set up boolean expression for game playing
			currently_playing := true
			still_alive := true
			is_error := false

			-- Defauly messages to be updated when operations are invoked
			create operation_message.make_empty
			create error_message.make_empty
		end

feature {NONE} -- Attributes

	row_size : INTEGER_32
	col_size : INTEGER_32

	player_move : INTEGER_32
	project_move : INTEGER_32

	starfighter : STARFIGHTER
	projectiles : ARRAYED_LIST[PROJECTILE]

	valid_command_count : INTEGER
	error_count : INTEGER

	grid_char_rows : ARRAY[CHARACTER]
	grid_elements : ARRAY[CHARACTER]

	currently_playing : BOOLEAN
	is_error : BOOLEAN
	still_alive : BOOLEAN

	operation_message : STRING
	error_message : STRING
	game_over_message : STRING


feature {NONE} -- queries

feature {NONE} -- Helpers

feature -- Output Displays

	display_state : STRING
		do
			create Result.make_empty
			Result.append("  state:" + valid_command_count.out + "." + error_count.out + ", ")

			if is_error = true then
				Result.append("error")
			else
				Result.append("ok")
			end
			Result.append ("%N")
		end

	display_grid : STRING
		local
			i, j, count : INTEGER
		do
			create Result.make_empty
			Result.append("    ")
			from
				i := 1
			until
				i > col_size
			loop
				if i = col_size then
					Result.append (i.out)
				else
					Result.append (i.out)

					if i >= 9 then
						Result.append (" ")
					else
						Result.append ("  ")
					end
				end

				i := i + 1
			end

			Result.append ("%N")

			count := 1

			from
				i := 1
			until
				i > row_size
			loop
				Result.append ("    " + grid_char_rows.at (i).out + " ")

				from
					j := 1
				until
					j > col_size
				loop
					if j = col_size then
						Result.append (grid_elements.at (count).out)
					else
						Result.append (grid_elements.at (count).out + "  ")
					end
					j := j  + 1
					count := count + 1
				end

				if i < row_size then
					Result.append ("%N")
				end

				i := i + 1
			end
		end

	display_output(state : INTEGER) : STRING
		do
			create Result.make_empty

			-- Default Greeting into the game
			if state ~ 0 then
				Result.append("  " + operation_message)

			else
				-- Display the state
				Result.append(display_state)

				-- Display Operations or errors
				if is_error = true then
					Result.append("  " + error_message)
				else
					Result.append("  " + operation_message)
				end

				-- Display The grid is playing
				if currently_playing = true and is_error = false then
					Result.append(display_grid)
				end

				if still_alive = false then
					Result.append("  " + game_over_message)
				end

				-- Display aftermath of turn
			end
		end

feature {ETF_COMMAND} -- commands to implement

	play (row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		do
			if currently_playing = true then
				is_error := true
				still_alive := true
				error_count := error_count + 1
				error_message := "Please end the current game before starting a new one."

			elseif player_mov > (row - 1 + column - 1) then
				is_error := true
				still_alive := true
				error_count := error_count + 1
				error_message := "Starfighter movement should not exceed row - 1 + column - 1 size of the board."
			else
				reset (row, column, player_mov, project_mov)
				valid_command_count := valid_command_count + 1
				error_count := 0
			end
		end

	abort
		do
			if currently_playing = false then
				is_error := true
				still_alive := true
				error_count := error_count + 1
				error_message := "Not in game."
			else
				currently_playing := false
				is_error := false
				still_alive := true
				error_count := 0
				valid_command_count := valid_command_count + 1
				operation_message := "Game has been exited."
			end
		end

	move (row: INTEGER_32 ; column: INTEGER_32)
--		local
--			i : INTEGER
--			moves, column_diff, row_diff : INTEGER
--			old_collided_x, old_collided_y, new_collided_x, new_collided_y : INTEGER
		do
--			moves := player_move

--			if (starfighter.y - column) >= 0 then
--				column_diff := starfighter.y - column
--			else
--				column_diff := column - starfighter.y
--			end

--			if (starfighter.x - row) >= 0 then
--				row_diff := starfighter.x - row
--			else
--				row_diff := row - starfighter.x
--			end

--			if currently_playing = false then
--				is_error := true
--				error_count := error_count + 1
--				error_message := "Not in game."

--			elseif row > row_size or row < 1 or column > col_size or column < 1 then
--				is_error := true
--				error_count := error_count + 1
--				error_message := "The location to move to is outside of the board."

--			elseif (moves - (row_diff + column_diff)) < 0 then
--				is_error := true
--				error_count := error_count + 1
--				error_message := "The location to move to is out of the Starfighter's movement range."

--			elseif row = starfighter.x and column = starfighter.y then
--				is_error := true
--				error_count := error_count + 1
--				error_message := "The Starfighter is already at that location."

--			else
--				-- Part 1
--				turn_first_part

--				is_error := false
--				valid_command_count := valid_command_count + 1

--				-- Part 2
--				if still_alive = true then

--					old_collided_x := starfighter.x
--					old_collided_y := starfighter.y

--					if row = starfighter.x and column /= starfighter.y then

--						-- Move Right
--						if column > starfighter.y then

--							from
--								i := starfighter.y
--							until
--								i > column
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_y (starfighter.y + 1)

--									if starfighter.y <= col_size then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i + 1
--							end

--						-- Move Left
--						-- column < starfighter.y
--						else

--							from
--								i := starfighter.y
--							until
--								i < column
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_y (starfighter.y - 1)

--									if starfighter.y > 1 then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i - 1
--							end

--						end

--					elseif row /= starfighter.x and column = starfighter.y then

--						-- Move Up
--						if row > starfighter.x then

--							from
--								i := starfighter.x
--							until
--								i > row
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_x (starfighter.x + 1)

--									if starfighter.x <= row_size then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i + 1
--							end

--						-- Move Down
--						-- row < starfighter.x
--						else

--							from
--									i := starfighter.x
--								until
--									i < row
--								loop
--									grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--										starfighter.set_x (starfighter.x - 1)

--										if starfighter.x > 1 then

--											if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--												-- Game Over
--												grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--												new_collided_x := starfighter.x
--												new_collided_y := starfighter.y
--												still_alive := false
--												currently_playing := false

--											else
--												grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--											end
--										end
--									i := i - 1
--								end

--						end

--					else

--						if row > starfighter.x and column > starfighter.y then

--							-- Move Up then Right

--							from
--								i := starfighter.x
--							until
--								i > row
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_x (starfighter.x + 1)

--									if starfighter.x <= row_size then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i + 1
--							end

--							from
--								i := starfighter.y
--							until
--								i > column
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_y (starfighter.y + 1)

--									if starfighter.y <= col_size then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i + 1
--							end

--						elseif row < starfighter.x and column > starfighter.y then

--							-- Move Down then Right

--							from
--								i := starfighter.x
--							until
--								i < row
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_x (starfighter.x - 1)

--									if starfighter.x > 1 then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i - 1
--							end

--							from
--								i := starfighter.y
--							until
--								i > column
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_y (starfighter.y + 1)

--									if starfighter.y <= col_size then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i + 1
--							end

--						elseif row > starfighter.x and column < starfighter.y then

--							-- Move Up then Left

--							from
--								i := starfighter.x
--							until
--								i > row
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_x (starfighter.x + 1)

--									if starfighter.x <= row_size then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i + 1
--							end

--							from
--								i := starfighter.y
--							until
--								i < column
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_y (starfighter.y - 1)

--									if starfighter.y > 1 then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i - 1
--							end

--						-- row < starfighter.x and column < starfighter.y
--						else

--							-- Move Down then Left

--							from
--								i := starfighter.x
--							until
--								i < row
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_x (starfighter.x - 1)

--									if starfighter.x > 1 then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i - 1
--							end

--							from
--								i := starfighter.y
--							until
--								i < column
--							loop
--								grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := '_'

--									starfighter.set_y (starfighter.y - 1)

--									if starfighter.y > 1 then

--										if grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) = '*' then
--											-- Game Over
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'X'
--											new_collided_x := starfighter.x
--											new_collided_y := starfighter.y
--											still_alive := false
--											currently_playing := false

--										else
--											grid_elements.at (((starfighter.x - 1) * col_size) + starfighter.y) := 'S'
--										end
--									end
--								i := i - 1
--							end
--						end
--					end

--					if still_alive = true then
--						operation_message := "The Starfighter moves: [" + old_collided_x.out + "," + old_collided_y.out + "] -> [" + row.out + "," + column.out + "]"
--					else
--						operation_message := "The Starfighter moves and collides with a projectile: [" + old_collided_x.out + "," + old_collided_y.out + "] -> [" + new_collided_x.out + "," + new_collided_y.out + "]"
--					end
--				end
--			end
		end

	fire
		do
			if currently_playing = false then
				is_error := true
				error_count := error_count + 1
				error_message := "Not in game."
			else
				-- Part 1
				turn_first_part

				is_error := false
				valid_command_count := valid_command_count + 1

				-- Part 2
				if still_alive = true then
					projectiles.force (create {PROJECTILE}.make (starfighter.x, starfighter.y + 1))
					if projectiles.at (projectiles.count).y <= col_size then
						grid_elements.at (((projectiles.at (projectiles.count).x - 1) * col_size) + projectiles.at (projectiles.count).y) := '*'
					end
					operation_message.append ("The Starfighter fires a projectile at: [" + projectiles.at (projectiles.count).x.out + "," + projectiles.at (projectiles.count).y.out + "]")
				end
			end
		end

	pass
		do
			if currently_playing = false then
				is_error := true
				error_count := error_count + 1
				error_message := "Not in game."
			else
				-- Part 1
				turn_first_part

				is_error := false
				valid_command_count := valid_command_count + 1

				-- Part 2
				if still_alive = true then
					operation_message.append ("The Starfighter stays at: [" + starfighter.x.out + "," + starfighter.y.out + "]")
				end
			end
		end

	turn_first_part
		local
			i, j : INTEGER
			old_y, old_collided_x, old_collided_y, new_collided_x, new_collided_y : INTEGER
		do
			operation_message := ""

			from
				i := 1
			until
				i > projectiles.count
			loop
					old_y := projectiles.at (i).y

					if still_alive = true then
						old_collided_x := projectiles.at (i).x
						old_collided_y := projectiles.at (i).y
					end

					from
						j := 1
					until
						j > project_move
					loop
						grid_elements.at (((projectiles.at (i).x - 1) * col_size) + projectiles.at (i).y) := '_'

						projectiles.at (i).set_y (projectiles.at (i).y + 1)

						if projectiles.at (i).y <= col_size then

							if grid_elements.at (((projectiles.at (i).x - 1) * col_size) + projectiles.at (i).y) = 'S' then
								-- Game Over
								grid_elements.at (((projectiles.at (i).x - 1) * col_size) + projectiles.at (i).y) := 'X'
								new_collided_x := projectiles.at (i).x
								new_collided_y := projectiles.at (i).y
								still_alive := false
								currently_playing := false
							else
								grid_elements.at (((projectiles.at (i).x - 1) * col_size) + projectiles.at (i).y) := '*'
							end
						end
					end
					operation_message.append ("A projectile moves: [" + grid_char_rows.at (projectiles.at (i).x).out + "," + old_y.out + "] -> [" + grid_char_rows.at (projectiles.at (i).x).out + "," + projectiles.at (i).y.out + "]%N")
			end

			if still_alive = false then
				operation_message.append ("A projectile moves and collides with the Starfighter: [" + old_collided_x.out + "," + old_collided_y.out + "] -> [" + new_collided_x.out + "," + new_collided_y.out + "]")
			end
		end

end
