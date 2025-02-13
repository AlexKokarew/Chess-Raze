extends Node

class_name ActionQueues

var timer_queue: Array = []  # Очередь по времени
var damage_queue: Array = []  # Очередь нанесения урона

# Добавление действия в очередь таймера
func add_timer_action(object, time, action_type, data = {}):
	var action = {
		"object": object,
		"time": time,
		"action_type": action_type,
		"data": data
	}
	timer_queue.append(action)
	timer_queue.sort_custom(Callable(self, "_compare_time"))  # Сортируем по времени

# Добавление действия в очередь урона (обрабатывается отдельно)
func add_damage_action(attacker, target, damage):
	var action = {
		"attacker": attacker,
		"target": target,
		"damage": damage
	}
	damage_queue.append(action)

# Сортировка по времени
func _compare_time(a, b) -> int:
	return a["time"] - b["time"]

# Выполнение действий из очереди таймера
func process_timer_actions():
	while timer_queue.size() > 0:
		var action = timer_queue.pop_front()
		if action == null:
			continue

		var obj = action["object"]
		var action_type = action["action_type"]
		var data = action["data"]

		match action_type:
			"move":
				process_move(obj, data)
			"attack":
				process_attack(obj, data)  # Добавляем атаку в очередь урона
			"destroy":
				process_destroy(obj, data)
			_:
				print("Unknown action:", action_type)

# Выполнение действий из очереди нанесения урона
func process_damage_actions():
	while damage_queue.size() > 0:
		var action = damage_queue.pop_front()
		if action == null:
			continue

		var attacker = action["attacker"]
		var target = action["target"]
		var damage = action["damage"]

		if target.health > 0:
			target.health -= damage
			print(attacker.name, "наносит", damage, "урона", target.name)
			if target.health <= 0:
				print(target.name, "погибает!")
				target.queue_free()

# Пример обработки движения
func process_move(obj, data):
	print(obj.name, "движется в", data["position"])
	obj.move_to(data["position"])

# Пример обработки атаки
func process_attack(attacker, data):
	var target = data["target"]
	var damage = attacker.attack_power
	add_damage_action(attacker, target, damage)  # Добавляем атаку в очередь урона

# Пример обработки разрушения объекта
func process_destroy(obj, _data):
	print(obj.name, "разрушается")
	obj.queue_free()
