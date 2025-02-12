class conflict_qe:
	var index: int                     # Индекс на поле
	var participants: Array = []       # Участники, попавшие в очередь

	# Добавление участника в очередь
	func add_participant(unit: Unit):
		if unit is Defender and not has_defender():
			participants.insert(0, unit)  # Защитник всегда в начале
			print("Защитник добавлен в индекс", index)
		elif unit is Attacker:
			participants.append(unit)     # Атакующие добавляются в конец
			print("Атакующий добавлен в индекс", index)
		else:
			print("Неизвестный тип юнита:", unit)

	# Проверка наличия защитника в очереди
	func has_defender() -> bool:
		return participants.size() > 0 and participants[0] is Defender

	# Сортировка атакующих (оставляем защитника на первом месте, если он есть)
	func sort_attackers():
		if has_defender():
			var attackers = participants.slice(1)
			attackers.sort_custom(self, "_compare_attackers")
			participants = [participants[0]] + attackers
		else:
			participants.sort_custom(self, "_compare_attackers")

	# Пользовательская функция сравнения атакующих по силе атаки (по убыванию)
	func _compare_attackers(a: Attacker, b: Attacker) -> int:
		return b.attack_power - a.attack_power

	# Обработка конфликта между участниками
	func process_conflict():
		if participants.size() == 0:
			print("Нет участников для обработки на индексе:", index)
			return
		print("Обработка конфликта на индексе:", index)
		for i in range(participants.size()):
			if i == 0 and has_defender():
				var defender = participants[i]
				print("Защитник обрабатывается:", defender)
				# Здесь можно добавить логику обработки защитника
			else:
				var attacker = participants[i]
				print("Атакующий обрабатывается:", attacker)
				# Здесь можно добавить логику обработки атакующего
