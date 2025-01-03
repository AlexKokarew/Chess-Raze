extends "res://class_trash/ChessPiece.gd"
class_name Defender

# Свойства защитников
var defense_power: int  # Сила защиты
var has_attacked: bool = false  # Совершил ли атаку

# Метод для отражения атаки
func can_reflect_attack(attacker: Attacker) -> bool:
	return defense_power > attacker.attack_power

# Сброс состояния после атаки
func reset_attack_state():
	has_attacked = false
	print("Defender attack state reset.")
