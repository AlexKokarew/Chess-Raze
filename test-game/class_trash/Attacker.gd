extends "res://class_trash/ChessPiece.gd"
class_name Attacker

# Свойства нападающих
var attack_power: int  # Сила атаки
var attack_direction: Vector2  # Направление атаки

# Атака цели
func attack(target: ChessPiece):
	if not target.is_alive():
		print("Target is already defeated.")
		return
	target.take_damage(attack_power)
	print("Attacker dealt", attack_power, "damage to target.")
