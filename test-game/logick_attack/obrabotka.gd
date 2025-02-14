extends Node

# Импортируйте класс ConflictQueue
var ConflictQueue = preload("res://class_trash/ConflictQueue.gd")

var index: int = 0              # Индекс на поле
var participants: Array = []    # Участники, попавшие в очередь

# Добавление участника в очередь
func add_participant(piece):
	if piece.is_defender() and not has_defender():
		participants.insert(0, piece)  # Защитник всегда в начале
		print("Defender added to index", index)
	elif piece.is_attacker():
		participants.append(piece)       # Атакующие добавляются в конец
		print("Attacker added to index", index)
	else:
		print("Unknown piece type:", piece)

# Проверка наличия защитника в очереди
func has_defender() -> bool:
	if participants.size() > 0 and participants[0].is_defender():
		return true
	return false

# Сортировка атакующих (оставляем защитника на первом месте, если он есть)
func sort_attackers():
	if has_defender():
		var attackers = participants.slice(1)
		attackers.sort_custom(Callable(self, "_compare_attackers"))
		participants = [participants[0]] + attackers
	else:
		participants.sort_custom(Callable(self, "_compare_attackers"))

# Пользовательская функция сравнения атакующих по силе атаки (по убыванию)
func _compare_attackers(a, b) -> int:
	return b.attack_power - a.attack_power

# Обработка конфликта между участниками
func process_conflict():
	if participants.size() == 0:
		print("No participants to process at index:", index)
		return
	print("Processing conflict at index:", index)
	for piece in participants:
		if piece.is_defender():
			print("Defender processing:", piece)
			# Здесь можно добавить логику обработки защитника
		elif piece.is_attacker():
			print("Attacker processing:", piece)
			# Здесь можно добавить логику обработки атакующего

func restore_positions(positions: Dictionary):
	for piece in positions.keys():
		if piece.has_method("move_to"):
			piece.move_to(positions[piece])

func calculate_index(row: int, column: int, M: int) -> int:
	return row * M + column

func check_trap_or_obstacle(position: Vector2, all_pieces: Array) -> bool:
	for piece in all_pieces:
		if piece.index == position and piece.has_method("is_trap") and piece.is_trap():
			print("Trap activated at position:", position)
			return true
	return false

##############################
# Функции боевой логики      #
##############################
# Атака на клетке
func _process_attack_on_cell(attacker: Player, defender: Player, all_pieces: Array):
	var original_positions = save_positions([attacker, defender])
	
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

# Вторичная защита (например, повторная атака, если на клетке есть другой защитник)
func _process_secondary_defense(attacker: Player, all_pieces: Array):
	for piece in all_pieces:
		if piece.is_defender() and piece.index == attacker.index and not piece.has_attacked:
			print("Secondary defender found at position:", piece.index)
			_process_attack_on_cell(attacker, piece, all_pieces)
			return

# Взаимодействие на соседних клетках
func _process_adjacent_interaction(attacker: Player, defender: Player):
	if not defender.has_attacked:
		defender.has_attacked = true
		attacker.take_damage(defender.attack_power)
		print("Defender attacked attacker. Attacker took damage:", defender.attack_power)

# Столкновение атакующих
func _process_attacker_vs_attacker(attacker1: Player, attacker2: Player):
	attacker1.take_damage(attacker2.attack_power)
	attacker2.take_damage(attacker1.attack_power)
	print("Both attackers took damage.")
	if not attacker1.is_alive():
		print("Attacker1 defeated.")
	if not attacker2.is_alive():
		print("Attacker2 defeated.")

# Столкновение защитников
func _process_defender_vs_defender(defender1: Player, defender2: Player):
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

##############################
# Линия атаки и дополнительные#
##############################
# Атака по линии с первым препятствием
func _process_line_attack(attacker: Player, all_pieces: Array, M: int):
	var start_index = attacker.index
	var direction = attacker.attack_direction  # Убедитесь, что этот параметр корректно определён
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

##############################
# Основная функция события   #
##############################
func process_event(all_pieces: Array, involved_pieces: Array, M: int):
	if not validate_pieces(involved_pieces):
		return

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
			elif abs(attacker.index - defender.index) == 1:
				_process_adjacent_interaction(attacker, defender)
	
	_process_collisions(attackers, _process_attacker_vs_attacker)
	_process_collisions(defenders, _process_defender_vs_defender)
	
	# Дополнительная обработка конфликтов по позициям с использованием ConflictQueue
	var conflict_map = {}
	for piece in involved_pieces:
		var idx = piece.index
		var queue
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

func _reset_defender_states(defenders: Array):
	for defender in defenders:
		if defender.has_method("reset_attack_state"):
			defender.reset_attack_state()

func save_positions(pieces: Array) -> Dictionary:
	var positions = {}
	for piece in pieces:
		if piece.has_method("index"):
			positions[piece] = piece.index
	return positions

func validate_pieces(pieces: Array) -> bool:
	for piece in pieces:
		if not piece.has_method("index"):
			print("Invalid piece detected:", piece)
			return false
	return true
