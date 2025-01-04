extends "res://class_trash/ChessPiece.gd"
class_name Defender

# Свойства
var defense_power: int = 30
var can_counterattack: bool = true

# Метод для контратаки атакующего
func counterattack(attacker: ChessPiece):
	if can_counterattack:
		print("Defender at", position, "counterattacking attacker at", attacker.position)
		attacker.take_damage(defense_power)
		if not attacker.is_alive():
			print("Attacker defeated by counterattack.")
