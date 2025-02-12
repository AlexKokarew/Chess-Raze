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
		print(self, "blocked the attack!")
		return
	
	var damage = calculate_damage(amount)
	health -= damage
	print(self, "took damage:", damage, "Remaining health:", health)
	
	if health <= 0:
		die()

# Расчет урона: с учетом критического удара
func calculate_damage(amount: int) -> int:
	var final_damage = max(amount - defense_power, 0)
	if randf() < crit_chance:
		final_damage *= 1.5
		print(self, "landed a critical hit!")
	return final_damage

# Метод смерти
func die():
	if alive:
		alive = false
		print(self, "at index", index, "has died.")
		_on_death()

# Событие при смерти
func _on_death():
	print("Default death behavior for", self)

# Проверка, что юнит жив
func is_alive() -> bool:
	return health > 0

# Восстановление здоровья
func heal(amount: int):
	if not alive:
		print(self, "cannot be healed because it's dead.")
		return
	
	health = min(health + amount, max_health)
	print(self, "healed by", amount, "Current health:", health)

# Передвижение юнита
func move_to(new_index: int):
	if not alive:
		print(self, "cannot move because it's dead.")
		return
	
	index = new_index
	print(self, "moved to index:", new_index)

#####################################
# Методы для атаки и отражения
#####################################

# Метод атаки
func attack(target: ChessPiece):
	if not alive:
		print(self, "cannot attack because it's dead.")
		return
	
	if not target.is_alive():
		print("Target at index", target.index, "is already dead.")
		return
	
	if has_attacked:
		print(self, "has already attacked this turn.")
		return
	
	if piece_role == "Defender" and can_reflect_attack(target):
		print(self, "reflected attack from target at index", target.index)
		has_attacked = true
		return
	
	target.take_damage(attack_power)
	print(self, "attacked target at index", target.index, "with", attack_power, "damage.")
	has_attacked = true

	if target.is_alive():
		_take_counter_damage(target)
	else:
		print(self, "target at index", target.index, "defeated.")

# Ответный урон
func _take_counter_damage(target: ChessPiece):
	take_damage(target.attack_power)
	print(self, "took counter damage:", target.attack_power)
	if not alive:
		die()

# Логика отражения атаки
func can_reflect_attack(attacker: ChessPiece) -> bool:
	if piece_role == "Defender" and randf() < reflect_chance:
		print(self, "attack reflected by defender.")
		return true
	return false

# Специальная атака
func special_attack_logic(targets: Array):
	for target in targets:
		if target is ChessPiece:
			attack(target)
	print(self, "special attack executed.")

#####################################
# Методы для переключения роли и окончания хода
#####################################

# Переключение роли
func switch_role_based_on_action():
	if piece_role == "Attacker" and not has_attacked:
		piece_role = "Defender"
		print(self, "switched role to Defender.")
	elif piece_role == "Defender" and has_attacked:
		piece_role = "Attacker"
		print(self, "switched role to Attacker.")
	has_attacked = false

# Завершение хода
func end_turn():
	switch_role_based_on_action()
	print(self, "turn ended. Current role:", piece_role)

#####################################
# Методы для определения роли
#####################################

# Проверка роли
func is_attacker() -> bool:
	return piece_role == "Attacker"

func is_defender() -> bool:
	return piece_role == "Defender"
