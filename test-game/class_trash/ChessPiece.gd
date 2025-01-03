extends "res://class_trash/Cell_object.gd"

class_name ChessPiece

# Свойства фигур
var index: int  # Индекс клетки
var health: int = 100  # Здоровье фигуры

# Метод для получения урона
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

# Метод для проверки, жива ли фигура
func is_alive() -> bool:
	return health > 0

# Метод для удаления фигуры с поля
func die():
	release()
	print("Piece at index", index, "is defeated.")
