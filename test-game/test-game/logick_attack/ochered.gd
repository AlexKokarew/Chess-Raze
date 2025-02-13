class ActionQueue:
	var queue: Array = []  # Очередь действий

	# Добавление действия в очередь
	func add_action(player, time, action_type):
		var action = {"player": player, "time": time, "action_type": action_type}
		queue.append(action)
		queue.sort_custom(Callable(self, "_compare_time"))  # Исправлено

	# Сортировка по времени
	func _compare_time(a, b) -> int:
		return a["time"] - b["time"]

	# Получение следующего действия из очереди
	func get_next_action():
		if queue.size() > 0:
			return queue.pop_front()
		return null

	# Обработка всех действий в очереди
	func process_actions():
		while queue.size() > 0:
			var action = get_next_action()
			var player = action["player"]
			var action_type = action["action_type"]
			print(player.name, "does", action_type)
			if action_type == "attack":
				process_attack(player)
			elif action_type == "defend":
				process_defend(player)

	# Обработка атаки
	func process_attack(player):
		var defender = get_defender_for_attack(player)
		if defender:
			print(player.name, "attacks", defender.name)
			if player.attack_successful():
				print(defender.name, "takes damage from", player.name)
				defender.health -= player.attack_power
			if defender.health > 0 and defender.defender_can_counter():
				defender.counter_attack(player)
		else:
			print(player.name, "attacks but no defender found")

	# Получение защитника для атаки
	func get_defender_for_attack(attacker):
		for action in queue:
			if action["player"] != attacker and action["action_type"] == "defend":
				return action["player"]
		return null

	# Обработка защиты
	func process_defend(player):
		print(player.name, "defends!")
		player.defend()
