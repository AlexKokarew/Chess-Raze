extends "res://class_trash/ChessPiece.gd"

class_name logick_attack

var conflict = preload("res://class_trash/ConflictQueue.gd")

# Основная функция обработки события боя и конфликтов
func process_event(all_pieces: Array, involved_pieces: Array, M: int):
	if not validate_pieces(involved_pieces):
		return

	# Разделяем фигуры на атакующих и защитников
	var attackers = []
	var defenders = []
	for piece in involved_pieces:
		if piece.is_attacker():
			attackers.append(piece)
		elif piece.is_defender():
			defenders.append(piece)
	_reset_defender_states(defenders)
	
	# Основная логика боя: атака по линии, атака на клетке и взаимодействия
	for attacker in attackers:
		_process_line_attack(attacker, all_pieces, M)
		for defender in defenders:
			if attacker.index == defender.index:
				_process_attack_on_cell(attacker, defender, all_pieces)
			elif attacker.index.distance_to(defender.index) == 1:
				_process_adjacent_interaction(attacker, defender)
	
	_process_collisions(attackers, _process_attacker_vs_attacker)
	_process_collisions(defenders, _process_defender_vs_defender)
	
	# Дополнительно: обработка конфликтов по позициям с использованием ConflictQueue
	var conflict_map = {}
	for piece in involved_pieces:
		var idx = piece.index
		var queue: ConflictQueue
		if conflict_map.has(idx):
			queue = conflict_map[idx]
		else:
			queue = ConflictQueue.new()
			queue.index = idx
			conflict_map[idx] = queue
		queue.add_participant(piece)
	
	for idx in conflict_map.keys():
		var queue = conflict_map[idx]
		queue.sort_attackers()
		queue.process_conflict()


# Сброс состояния защитников
func _reset_defender_states(defenders: Array):
	for defender in defenders:
		if defender.has_method("reset_attack_state"):
			defender.reset_attack_state()


# Обработка атаки на клетке
func _process_attack_on_cell(attacker: ChessPiece, defender: ChessPiece, all_pieces: Array):
	var original_positions = save_positions([attacker, defender])
	
	# Если защитник может отразить атаку, возвращаем фигуры на исходные позиции
	if defender.can_reflect_attack(attacker):
		print("Attack reflected. Returning to original positions.")
		restore_positions(original_positions)
		return

	# Сначала урон получает нападающий
	attacker.take_damage(defender.attack_power)
	print("Attacker took damage:", defender.attack_power)
	
	if not attacker.is_alive():
		print("Attacker defeated before dealing damage.")
		return

	# Если нападающий выжил – наносим урон защитнику
	defender.take_damage(attacker.attack_power)
	print("Defender took damage:", attacker.attack_power)
	
	if not defender.is_alive():
		attacker.index = defender.index
		print("Defender defeated. Attacker moved to defender's position.")
		_process_secondary_defense(attacker, all_pieces)
	else:
		print("Defender survived. Returning to original positions.")
		restore_positions(original_positions)


# Обработка вторичной защиты (например, повторная атака, если на клетке есть другой защитник)
func _process_secondary_defense(attacker: ChessPiece, all_pieces: Array):
	for piece in all_pieces:
		if piece.is_defender() and piece.index == attacker.index and not piece.has_attacked:
			print("Secondary defender found at position:", piece.index)
			_process_attack_on_cell(attacker, piece, all_pieces)
			return


# Обработка взаимодействия на соседних клетках
func _process_adjacent_interaction(attacker: ChessPiece, defender: ChessPiece):
	if not defender.has_attacked:
		defender.has_attacked = true
		attacker.take_damage(defender.attack_power)
		print("Defender attacked attacker. Attacker took damage:", defender.attack_power)


# Обработка столкновения атакующих
func _process_attacker_vs_attacker(attacker1: ChessPiece, attacker2: ChessPiece):
	attacker1.take_damage(attacker2.attack_power)
	attacker2.take_damage(attacker1.attack_power)
	print("Both attackers took damage.")
	if not attacker1.is_alive():
		print("Attacker1 defeated.")
	if not attacker2.is_alive():
		print("Attacker2 defeated.")


# Обработка столкновения защитников
func _process_defender_vs_defender(defender1: ChessPiece, defender2: ChessPiece):
	if defender1.attack_power > defender2.attack_power:
		defender2.take_damage(defender1.attack_power - defender2.attack_power)
		print("Defender2 took damage from Defender1.")
	elif defender2.attack_power > defender1.attack_power:
		defender1.take_damage(defender2.attack_power - defender1.attack_power)
		print("Defender1 took damage from Defender2.")
	else:
		print("No damage. Both defenders have equal attack power.")


# Обработка столкновений для списка фигур
func _process_collisions(pieces: Array, collision_handler: Callable):
	for i in range(pieces.size()):
		for j in range(i + 1, pieces.size()):
			collision_handler.call(pieces[i], pieces[j])


# Проверка корректности фигур
func validate_pieces(pieces: Array) -> bool:
	for piece in pieces:
		if not piece.has_method("index"):
			print("Invalid piece detected:", piece)
			return false
	return true


# Сохранение оригинальных позиций фигур
func save_positions(pieces: Array) -> Dictionary:
	var positions = {}
	for piece in pieces:
		if piece.has_method("index"):
			positions[piece] = piece.index
	return positions


# Восстановление позиций фигур
func restore_positions(positions: Dictionary):
	for piece in positions.keys():
		if piece.has_method("move_to"):
			piece.move_to(positions[piece])


# Атака по линии с первым препятствием
func _process_line_attack(attacker: ChessPiece, all_pieces: Array, M: int):
	var start_index = attacker.index
	var direction = attacker.attack_direction
	while true:
		start_index += direction
		if start_index < 0 or start_index >= M * M:
			print("Attack went out of bounds.")
			return
		for piece in all_pieces:
			if piece.index == start_index:
				if piece.is_defender():
					print("Attacker at index", attacker.index, "attacking defender at index", piece.index)
					_process_attack_on_cell(attacker, piece, all_pieces)
					return
				else:
					print("Attack stopped by obstacle at index", piece.index)
					return
		print("No targets found in attack range.")


# Расчет индекса на основе строки и столбца
func calculate_index(row: int, column: int, M: int) -> int:
	return row * M + column


# Ловушки и преграды
func check_trap_or_obstacle(position: Vector2, all_pieces: Array) -> bool:
	for piece in all_pieces:
		if piece.index == position and piece.has_method("is_trap") and piece.is_trap():
			print("Trap activated at position:", position)
			return true
	return false
