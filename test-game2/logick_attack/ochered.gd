extends Node

class_name ActionQueue

var queue: Array = []  # Очередь действий

# Добавление действия в очередь
func add_action(player, time, action_type):
	var action = {"player": player, "time": time, "action_type": action_type}
	queue.append(action)
	# Сортировка очереди по времени с использованием Callable для вызова функции сравнения
	queue.sort_custom(Callable(self, "_compare_time"))

# Функция для сортировки по времени
func _compare_time(a, b) -> int:
	# Если один или оба элемента равны null, обрабатываем их корректно
	if a == null and b == null:
		return 0
	elif a == null:
		return -1
	elif b == null:
		return 1
	return a["time"] - b["time"]

# Получение следующего действия из очереди
func get_next_action():
	if queue.size() > 0:
		return queue.pop_front()  # Извлекаем первое действие из очереди
	return null  # Если очередь пуста, возвращаем null

# Обработка всех действий в очереди
func process_actions():
	while queue.size() > 0:
		var action = get_next_action()
		if action == null:  # Проверка на null
			print("No action found, skipping.")
			continue  # Пропустить итерацию, если action равен null

		# Проверка, что action содержит необходимые ключи
		if not action.has("player") or not action.has("action_type"):
			print("Action is missing required keys, skipping.")
			continue

		var player = action["player"]  # Извлекаем игрока из действия
		var action_type = action["action_type"]  # Извлекаем тип действия
		print(player.name, "делает", action_type)  # Выводим информацию о действии
		if action_type == "attack":
			process_attack(player)  # Обработка атаки
		elif action_type == "defend":
			process_defend(player)  # Обработка защиты

# Обработка атаки: ищем защитника и выполняем атаку
func process_attack(player):
	var defender = get_defender_for_attack(player)
	if defender:
		print(player.name, "attacks", defender.name)
		if player.attack_successful():
			print(defender.name, "takes damage from", player.name)
			defender.health -= player.attack_power
		# Если защитник жив и может контратаковать, выполняем ответную атаку
		if defender.health > 0 and defender.defender_can_counter():
			defender.counter_attack(player)
	else:
		print(player.name, "attacks but no defender found")

# Поиск защитника для атаки: перебор действий в очереди и поиск первого, у кого тип "defend"
func get_defender_for_attack(attacker):
	for action in queue:
		if action != null and action["player"] != attacker and action["action_type"] == "defend":
			return action["player"]
	return null

# Обработка защиты: вызываем метод защиты у игрока
func process_defend(player):
	print(player.name, "defends!")
	player.defend()
