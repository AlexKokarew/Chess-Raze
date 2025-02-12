# Character.gd
extends BaseCharacter

var is_critical: bool = false
var is_reflecting: bool = false
var experience: int = 0
var level: int = 1

func attack(target: BaseCharacter):
	var damage = calculate_damage(target)
	target.take_damage(damage)
	print("Dealt ", damage, " damage to the target.")

func calculate_damage(target: BaseCharacter) -> int:
	var base_damage = attack_power
	var damage = base_damage - target.defense_power
	damage = max(damage, 0)

	if is_critical:
		damage *= 2  # Удваиваем урон при критическом ударе
		print("Critical hit!")
		
	if target.is_reflecting:
		damage = 0  # Отражение урона противником
		print("The damage was reflected back!")
		
	return damage

func gain_experience(amount: int):
	experience += amount
	if experience >= level * 100:  # Пример условия для повышения уровня
		level_up()

func level_up():
	level += 1
	attack_power += 5  # Увеличиваем атаку
	defense_power += 3  # Увеличиваем защиту
	print("Level up! Now at level ", level)
