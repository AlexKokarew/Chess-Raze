extends Object
# Базовый класс для игровых фигур
class_name ChessPiece

# Свойства
var health: int = 100
var position: Vector2 = Vector2(0, 0)

# Метод для проверки, жива ли фигура
func is_alive() -> bool:
	return health > 0

# Метод для получения урона
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

# Метод для удаления фигуры с поля
func die():
	print("Chess piece at", position, "has been defeated.")

# Метод для перемещения фигуры
func move_to(new_position: Vector2):
	position = new_position
