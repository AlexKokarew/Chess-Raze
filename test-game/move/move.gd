extends Node

var M = 10 # Ширина псевдо-массива
var C = 10 # столбец
var max_index = 99  # Максимальный индекс (10 * 10 - 1)
var min_index = 0  # Минимальный индекс

# Текущие координаты игрока
var current_row = 0
var current_column = 0
var current_position_move = Vector2(1, 1)
var index

func move_player(direction: Vector2):
	# Вычисляем новый индекс
	var new_row = current_row + direction.y
	var new_column = current_column + direction.x

	# Проверяем границы
	if new_row >= 0 and new_row < C and new_column >= 0 and new_column < M:
		current_row = new_row
		current_column = new_column
		index = current_row * M + current_column
		print("Игрок перемещен на индекс: ", index)
	else:
		print("Перемещение вне границ!")

func _on_input_event(event: String):
	var ver := event

	var upper = Vector2(0, -1)
	if ver == "up":
		move_player(upper)

	var downer =  Vector2(0, 1)
	if ver == "down":
		move_player(downer)

	var lefter = Vector2(-1, 0)
	if ver == "left":
		move_player(lefter)

	var righter = Vector2(1, 0)
	if ver == "right":
		move_player(righter)

	var up_righter = Vector2(1, -1)
	if ver == "up_right":
		move_player(up_righter)

	var up_lefter = Vector2(-1, -1)
	if ver == "up_left":
		move_player(up_lefter)

	var down_righter = Vector2(1, 1)
	if ver == "down_right":
		move_player(down_righter)

	var down_lefter = Vector2(-1, 1)
	if ver =="down_left":
		move_player(down_lefter)

	var zeroer = Vector2(0, 0)
	if ver =="zero":
		move_player(zeroer)
	
	
	
