extends BaseCharacter

var is_critical: bool = false
var is_reflecting: bool = false
var experience: int = 0
var level: int = 1
var character_name: String  # Имя персонажа
var max_health: int = 100  # Максимальное здоровье
var has_attacked: bool = false
var index: int = 0  # Позиция на поле  # Направление атаки

# Определение ролей
func is_attacker() -> bool:
    return self.attack_power >= self.defense

func is_defender() -> bool:
    return self.defense > self.attack_power

# Проверка успешности атаки
func attack_successful() -> bool:
    return randf_range(0, 1) > (self.defense / 100.0)

# Проверка возможности контратаки
func defender_can_counter() -> bool:
    return randf_range(0, 1) > 0.5

# Контратака
func counter_attack(attacker: BaseCharacter):
    if attacker.is_alive():
        print(self.character_name, "контратакует", attacker.character_name)
        attacker.take_damage(self.attack_power)  # Используем метод take_damage
    else:
        print(attacker.character_name, "уже побежден и не может контратаковать.")

# Защита
func defend():
    print(self.character_name, "защищается!")
    self.health = min(self.health + 10, max_health)  # Теперь max_health объявлено
    self.defense += 5

# Получение урона
func take_damage(amount: int):
    self.health -= amount
    print(self.character_name, "получил урон:", amount, "Осталось здоровья:", self.health)

# Проверка жив ли персонаж
func is_alive() -> bool:
    return self.health > 0

# Сброс состояния атаки
func reset_attack_state():
    has_attacked = false

# Проверка возможности отражения атаки
func can_reflect_attack(_attacker: BaseCharacter) -> bool:
    return randf_range(0, 1) > 0.8

# Перемещение персонажа
func move_to(new_index: int):
    print(self.character_name, "переместился на позицию", new_index)
    index = new_index

# Уровень персонажа
func level_up():
    level += 1
    attack_power += 5  # Увеличиваем атаку
    defense_power += 3  # Увеличиваем защиту
    print("Уровень повышен! Теперь уровень ", level)