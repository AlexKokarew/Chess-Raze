extends Node
class_name ChessPieceController

enum PieceType { KING, QUEEN, BISHOP, ROOK, KNIGHT, PAWN }
enum Direction {
	UP, DOWN, LEFT, RIGHT, 
	UP_RIGHT, UP_LEFT, DOWN_RIGHT, DOWN_LEFT,
	KNIGHT_RIGHT2_DOWN1, KNIGHT_RIGHT1_DOWN2, KNIGHT_LEFT1_DOWN2, KNIGHT_LEFT2_DOWN1,
	KNIGHT_LEFT2_UP1, KNIGHT_LEFT1_UP2, KNIGHT_RIGHT1_UP2, KNIGHT_RIGHT2_UP1,
	ZERO
}

var _piece_movements = {
	PieceType.KING: {
		Direction.UP: Vector2i(0, -1),
		Direction.DOWN: Vector2i(0, 1),
		Direction.LEFT: Vector2i(-1, 0),
		Direction.RIGHT: Vector2i(1, 0),
		Direction.UP_RIGHT: Vector2i(1, -1),
		Direction.UP_LEFT: Vector2i(-1, -1),
		Direction.DOWN_RIGHT: Vector2i(1, 1),
		Direction.DOWN_LEFT: Vector2i(-1, 1),
		Direction.ZERO: Vector2i(0, 0)
	},
	PieceType.QUEEN: {
		Direction.UP: Vector2i(0, -1),
		Direction.DOWN: Vector2i(0, 1),
		Direction.LEFT: Vector2i(-1, 0),
		Direction.RIGHT: Vector2i(1, 0),
		Direction.UP_RIGHT: Vector2i(1, -1),
		Direction.UP_LEFT: Vector2i(-1, -1),
		Direction.DOWN_RIGHT: Vector2i(1, 1),
		Direction.DOWN_LEFT: Vector2i(-1, 1),
		Direction.ZERO: Vector2i(0, 0)
	},
	PieceType.BISHOP: {
		Direction.UP_RIGHT: Vector2i(1, -1),
		Direction.UP_LEFT: Vector2i(-1, -1),
		Direction.DOWN_RIGHT: Vector2i(1, 1),
		Direction.DOWN_LEFT: Vector2i(-1, 1),
		Direction.ZERO: Vector2i(0, 0)
	},
	PieceType.ROOK: {
		Direction.UP: Vector2i(0, -1),
		Direction.DOWN: Vector2i(0, 1),
		Direction.LEFT: Vector2i(-1, 0),
		Direction.RIGHT: Vector2i(1, 0),
		Direction.ZERO: Vector2i(0, 0)
	},
	PieceType.KNIGHT: {
		Direction.KNIGHT_RIGHT2_DOWN1: Vector2i(2, 1),
		Direction.KNIGHT_RIGHT1_DOWN2: Vector2i(1, 2),
		Direction.KNIGHT_LEFT1_DOWN2: Vector2i(-1, 2),
		Direction.KNIGHT_LEFT2_DOWN1: Vector2i(-2, 1),
		Direction.KNIGHT_LEFT2_UP1: Vector2i(-2, -1),
		Direction.KNIGHT_LEFT1_UP2: Vector2i(-1, -2),
		Direction.KNIGHT_RIGHT1_UP2: Vector2i(1, -2),
		Direction.KNIGHT_RIGHT2_UP1: Vector2i(2, -1),
		Direction.ZERO: Vector2i(0, 0)
	},
	PieceType.PAWN: {
		Direction.UP: Vector2i(0, -1),
		Direction.DOWN: Vector2i(0, 1),
		Direction.LEFT: Vector2i(-1, 0),
		Direction.RIGHT: Vector2i(1, 0),
		Direction.ZERO: Vector2i(0, 0)
	}
}

var current_index: int = 0

func calculate_move(
	piece_type: PieceType,
	direction: Direction,
	steps: int,
	rows: int,
	columns: int,
	current_position: Vector2i
) -> int:
	var movement = _piece_movements[piece_type].get(direction, Vector2i.ZERO)
	if movement == Vector2i.ZERO && direction != Direction.ZERO:
		push_error("Invalid direction for this piece type")
		return current_index

	var new_position = current_position + movement * steps
	return _clamp_position(new_position, rows, columns)

func _clamp_position(position: Vector2i, rows: int, columns: int) -> int:
	var clamped_x = clamp(position.x, 0, columns - 1)
	var clamped_y = clamp(position.y, 0, rows - 1)
	
	if clamped_x != position.x || clamped_y != position.y:
		push_error("Move out of bounds!")
		return current_index
	
	return clamped_y * columns + clamped_x

# Пример использования
func handle_input(
	piece_type: PieceType,
	direction: Direction,
	steps: int,
	rows: int,
	columns: int,
	current_position: Vector2i
) -> int:
	var new_index = calculate_move(piece_type, direction, steps, rows, columns, current_position)
	if new_index != current_index:
		current_index = new_index
		print("Moved to index:", current_index)
	return current_index
