# CellObject.gd
extends Object

# Базовый класс для объектов на игровом поле
class_name CellObject

# Свойства клетки
var position: Vector2  # Позиция клетки на поле
var is_occupied: bool = false  # Занята ли клетка

# Метод для проверки, является ли клетка ловушкой
func is_trap() -> bool:
	return false  # По умолчанию клетка не является ловушкой

# Метод для проверки препятствий
func has_obstacle() -> bool:
	return false  # По умолчанию на клетке нет препятствия

# Метод для установки объекта в клетку
func occupy():
	is_occupied = true

# Метод для освобождения клетки
func release():
	is_occupied = false
