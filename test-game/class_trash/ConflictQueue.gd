extends Node
class ConflictQueue:
	var index: int                     # Индекс на поле
	var participants: Array = []       # Участники, попавшие в очередь

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
		for i in range(participants.size()):
			var piece = participants[i]
			if piece.is_defender():
				print("Defender processing:", piece)
				# Здесь можно добавить логику обработки защитника
			elif piece.is_attacker():
				print("Attacker processing:", piece)
				# Здесь можно добавить логику обработки атакующего
