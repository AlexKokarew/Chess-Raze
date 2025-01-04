extends "res://class_trash/ChessPiece.gd"
class_name Attacker


# Свойства
var attack_power: int = 50

# Метод для атаки защитника
func attack(defender: ChessPiece):
	print("Attacker at", position, "attacking defender at", defender.position)
	defender.take_damage(attack_power)
	if defender.is_alive():
		print("Defender survived the attack.")
	else:
		print("Defender defeated.")
