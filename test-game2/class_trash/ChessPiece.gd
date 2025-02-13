extends Object
class_name ChessPiece

# Основные свойства юнита
var health: int = 100           # Текущее здоровье
var max_health: int = 100       # Максимальное здоровье
var index: int = -1             # Позиция юнита на поле (например, индекс клетки)
var team: int = 0               # Команда (0 - нейтральный, 1 - атакующий, 2 - защитник)
var attack_power: int = 10      # Сила атаки
var defense_power: int = 5      # Защита от урона
var alive: bool = true          # Флаг, жив ли юнит
var piece_role: String = "Defender"  # Роль юнита: "Defender" или "Attacker"
var has_attacked: bool = false  # Флаг, показывающий, совершал ли юнит атакующий ход за текущий ход
var reflect_chance: float = 0.3  # Шанс отражения атаки (30%)
var crit_chance: float = 0.2     # Шанс критического удара (20%)
var block_chance: float = 0.3    # Шанс блокировки урона (30%)

# Направление атаки (например, +1 – движение по индексам вперед, -1 – назад)
var attack_direction: int = 1

#####################################
# Методы для обработки урона и состояния
#####################################

# Получение урона с учетом защиты
func take_damage(amount: int):
	if randf() < block_chance:
		print(self, "заблокировал атаку!")
		return
	
	var damage = calculate_damage(amount)
	health -= damage
	print(self, "получил урон:", damage, "Осталось здоровья:", health)
	
	if health <= 0:
		die()

# Расчет урона: с учетом критического удара
func calculate_damage(amount: int) -> int:
	var final_damage = max(amount - defense_power, 0)
	if randf() < crit_chance:
		final_damage *= 1.5
		print(self, "нанес критический удар!")
	return final_damage

# Метод смерти
func die():
	if alive:
		alive = false
		print(self, "на позиции", index, "умер.")
		_on_death()

# Событие при смерти
func _on_death():
	print("Стандартное поведение при смерти для", self)

# Проверка, что юнит жив
func is_alive() -> bool:
	return health > 0

# Восстановление здоровья
func heal(amount: int):
	if not alive:
		print(self, "не может быть вылечен, так как мертв.")
		return
	
	health = min(health + amount, max_health)
	print(self, "восстановил", amount, "здоровья. Текущее здоровье:", health)

# Передвижение юнита
func move_to(new_index: int):
	if not alive:
		print(self, "не может двигаться, так как мертв.")
		return
	
	index = new_index
	print(self, "переместился на позицию:", new_index)

#####################################
# Методы для атаки и отражения
#####################################

# Метод атаки
func attack(target: ChessPiece):
	if not alive:
		print(self, "не может атаковать, так как мертв.")
		return
	
	if not target.is_alive():
		print("Цель на позиции", target.index, "уже мертва.")
		return
	
	if has_attacked:
		print(self, "уже атаковал в этом ходу.")
		return
	
	if piece_role == "Defender" and can_reflect_attack(target):
		print(self, "отразил атаку от цели на позиции", target.index)
		has_attacked = true
		return
	
	target.take_damage(attack_power)
	print(self, "атаковал цель на позиции", target.index, "с уроном", attack_power)
	has_attacked = true

	if target.is_alive():
		_take_counter_damage(target)
	else:
		print(self, "цель на позиции", target.index, "побеждена.")

# Ответный урон
func _take_counter_damage(target: ChessPiece):
	take_damage(target.attack_power)
	print(self, "получил ответный урон:", target.attack_power)
	if not alive:
		die()

# Логика отражения атаки
func can_reflect_attack(attacker: ChessPiece) -> bool:
	if attacker.is_alive():
		return randf_range(0, 1) > 0.8
	return false

# Специальная атака
func special_attack_logic(targets: Array):
	for target in targets:
		if target is ChessPiece:
			attack(target)
	print(self, "выполнил специальную атаку.")

#####################################
# Методы для переключения роли и окончания хода
#####################################

# Переключение роли
func switch_role_based_on_action():
	if piece_role == "Attacker" and not has_attacked:
		piece_role = "Defender"
		print(self, "переключил роль на Защитника.")
	elif piece_role == "Defender" and has_attacked:
		piece_role = "Attacker"
		print(self, "переключил роль на Атакующего.")
	has_attacked = false

# Завершение хода
func end_turn():
	switch_role_based_on_action()
	print(self, "завершил ход. Текущая роль:", piece_role)

#####################################
# Методы для определения роли
#####################################

# Проверка роли
func is_attacker() -> bool:
	return piece_role == "Attacker"

func is_defender() -> bool:
	return piece_role == "Defender"
