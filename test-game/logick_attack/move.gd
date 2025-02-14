extends Node
# Текущие координаты игрока


func move_player(direction: Vector2, C: int, M: int, current_row: int, current_column: int):
	# Вычисляем новый индекс
	var new_row = current_row + direction.y
	var new_column = current_column + direction.x
	var index = 0
	# Проверяем границы
	if new_row >= 0 and new_row < C and new_column >= 0 and new_column < M:
		index = new_row * M + new_column
		return index
	else:
		print("Перемещение вне границ!")

func _king_input_event(event: String, dlinahoda: int, C: int, M: int, position_x: int, position_y: int):
	var ver := event
	var dlina := dlinahoda
	var upper = Vector2(0, -1) * dlina
	if ver == "up":
		var new_index = move_player(upper, C, M, position_x, position_y)
		return new_index
	var downer = Vector2(0, 1) * dlina
	if ver == "down":
		var new_index = move_player(downer, C, M, position_x, position_y)
		return new_index
	var lefter = Vector2(-1, 0) * dlina
	if ver == "left":
		var new_index = move_player(lefter, C, M, position_x, position_y)
		return new_index
	var righter = Vector2(1, 0) * dlina
	if ver == "right":
		var new_index = move_player(righter, C, M, position_x, position_y)
		return new_index
	var up_righter = Vector2(1, -1) * dlina
	if ver == "up_right":
		var new_index = move_player(up_righter, C, M, position_x, position_y)
		return new_index
	var up_lefter = Vector2(-1, -1) * dlina
	if ver == "up_left":
		var new_index = move_player(up_lefter, C, M, position_x, position_y)
		return new_index
	var down_righter = Vector2(1, 1) * dlina
	if ver == "down_right":
		var new_index = move_player(down_righter, C, M, position_x, position_y)
		return new_index
	var down_lefter = Vector2(-1, 1) * dlina
	if ver == "down_left":
		var new_index = move_player(down_lefter, C, M, position_x, position_y)
		return new_index
	var zeroer = Vector2(0, 0)
	if ver == "zero":
		var new_index = move_player(zeroer, C, M, position_x, position_y)
		return new_index

func _Qween_input_event(event: String, dlinahoda: int, C: int, M: int, position_x: int, position_y: int):
	var ver := event
	var dlina := dlinahoda
	var upper = Vector2(0, -1) * dlina
	if ver == "up":
		var new_index = move_player(upper, C, M, position_x, position_y)
		return new_index
	var downer = Vector2(0, 1) * dlina
	if ver == "down":
		var new_index = move_player(downer, C, M, position_x, position_y)
		return new_index
	var lefter = Vector2(-1, 0) * dlina
	if ver == "left":
		var new_index = move_player(lefter, C, M, position_x, position_y)
		return new_index
	var righter = Vector2(1, 0) * dlina
	if ver == "right":
		var new_index = move_player(righter, C, M, position_x, position_y)
		return new_index
	var up_righter = Vector2(1, -1) * dlina
	if ver == "up_right":
		var new_index = move_player(up_righter, C, M, position_x, position_y)
		return new_index
	var up_lefter = Vector2(-1, -1) * dlina
	if ver == "up_left":
		var new_index = move_player(up_lefter, C, M, position_x, position_y)
		return new_index
	var down_righter = Vector2(1, 1) * dlina
	if ver == "down_right":
		var new_index = move_player(down_righter, C, M, position_x, position_y)
		return new_index
	var down_lefter = Vector2(-1, 1) * dlina
	if ver == "down_left":
		var new_index = move_player(down_lefter, C, M, position_x, position_y)
		return new_index
	var zeroer = Vector2(0, 0)
	if ver == "zero":
		var new_index = move_player(zeroer, C, M, position_x, position_y)
		return new_index

func _bishop_input_event(event: String, dlinahoda: int, C: int, M: int, position_x: int, position_y: int):
	var ver := event
	var dlina := dlinahoda

	var up_righter = Vector2(1, -1) * dlina
	if ver == "up_right":
		var new_index = move_player(up_righter, C, M, position_x, position_y)
		return new_index
	var up_lefter = Vector2(-1, -1) * dlina
	if ver == "up_left":
		var new_index = move_player(up_lefter, C, M, position_x, position_y)
		return new_index
	var down_righter = Vector2(1, 1) * dlina
	if ver == "down_right":
		var new_index = move_player(down_righter, C, M, position_x, position_y)
		return new_index
	var down_lefter = Vector2(-1, 1) * dlina
	if ver == "down_left":
		var new_index = move_player(down_lefter, C, M, position_x, position_y)
		return new_index
	var zeroer = Vector2(0, 0)
	if ver == "zero":
		var new_index = move_player(zeroer, C, M, position_x, position_y)
		return new_index

func _rock_input_event(event: String, dlinahoda: int, C: int, M: int, position_x: int, position_y: int):
	var ver := event
	var dlina := dlinahoda
	var upper = Vector2(0, -1) * dlina
	if ver == "up":
		var new_index = move_player(upper, C, M, position_x, position_y)
		return new_index
	var downer = Vector2(0, 1) * dlina
	if ver == "down":
		var new_index = move_player(downer, C, M, position_x, position_y)
		return new_index
	var lefter = Vector2(-1, 0) * dlina
	if ver == "left":
		var new_index = move_player(lefter, C, M, position_x, position_y)
		return new_index
	var righter = Vector2(1, 0) * dlina
	if ver == "right":
		var new_index = move_player(righter, C, M, position_x, position_y)
		return new_index
	var zeroer = Vector2(0, 0)
	if ver == "zero":
		var new_index = move_player(zeroer, C, M, position_x, position_y)
		return new_index

func _knight_input_event(event: String,dlinahoda: int, C: int, M: int, position_x: int, position_y: int):
	var ver := event
	var dlina := dlinahoda
	var right2down1 = Vector2(2, 1) * dlina
	if ver == "right2down1":
		var new_index = move_player(right2down1, C, M, position_x, position_y)
		return new_index
	var right1down2 = Vector2(1, 2) * dlina
	if ver == "right1down2":
		var new_index = move_player(right1down2, C, M, position_x, position_y)
		return new_index
	var left1down2 = Vector2(-1, 2) * dlina
	if ver == "left1down2":
		var new_index = move_player(left1down2, C, M, position_x, position_y)
		return new_index
	var left2down1 = Vector2(-2, 1) * dlina
	if ver == "left2down1":
		var new_index = move_player(left2down1, C, M, position_x, position_y)
		return new_index
	var left2up1 = Vector2(-2, -1) * dlina
	if ver == "left2up1":
		var new_index = move_player(left2up1, C, M, position_x, position_y)
		return new_index
	var left1up2 = Vector2(-1, -2) * dlina
	if ver == "left1up2":
		var new_index = move_player(left1up2, C, M, position_x, position_y)
		return new_index
	var right1up2 = Vector2(1, -2) * dlina
	if ver == "right1up2":
		var new_index = move_player(right1up2, C, M, position_x, position_y)
		return new_index
	var right2up1 = Vector2(2, -1) * dlina
	if ver == "right2up1":
		var new_index = move_player(right2up1, C, M, position_x, position_y)
		return new_index
	var zeroer = Vector2(0, 0)
	if ver == "zero":
		var new_index = move_player(zeroer, C, M, position_x, position_y)
		return new_index

func _pawn_input_event(event: String, dlinahoda: int, C: int, M: int, position_x: int, position_y: int):
	var ver := event
	var dlina := dlinahoda
	var upper = Vector2(0, -1) * dlina
	if ver == "up":
		var new_index = move_player(upper, C, M, position_x, position_y)
		return new_index
	var downer = Vector2(0, 1) * dlina
	if ver == "down":
		var new_index = move_player(downer, C, M, position_x, position_y)
		return new_index
	var lefter = Vector2(-1, 0) * dlina
	if ver == "left":
		var new_index = move_player(lefter, C, M, position_x, position_y)
		return new_index
	var righter = Vector2(1, 0) * dlina
	if ver == "right":
		var new_index = move_player(righter, C, M, position_x, position_y)
		return new_index
	var zeroer = Vector2(0, 0)
	if ver == "zero":
		var new_index = move_player(zeroer, C, M, position_x, position_y)
		return new_index
