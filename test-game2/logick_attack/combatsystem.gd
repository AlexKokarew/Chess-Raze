# CombatSystem.gd
extends Node
class_name CombatSystem

enum PieceType { KING, QUEEN, BISHOP, ROOK, KNIGHT, PAWN }
enum Direction { UP, DOWN, LEFT, RIGHT, UP_RIGHT, UP_LEFT, DOWN_RIGHT, DOWN_LEFT, 
				KNIGHT_RIGHT2_DOWN1, KNIGHT_RIGHT1_DOWN2, KNIGHT_LEFT1_DOWN2, 
				KNIGHT_LEFT2_DOWN1, KNIGHT_LEFT2_UP1, KNIGHT_LEFT1_UP2, 
				KNIGHT_RIGHT1_UP2, KNIGHT_RIGHT2_UP1, ZERO }

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
signal action_processed
signal conflict_resolved

var _action_queue = []
var _conflicts = {}

func process_combat_event(all_pieces: Array, involved_pieces: Array, board_size: Vector2i):
	if not _validate_pieces(involved_pieces):
		return

	_process_attacks(all_pieces, involved_pieces, board_size)
	_resolve_conflicts()
	_cleanup_pieces(all_pieces)

func calculate_movement(piece_type: PieceType, direction: Direction, steps: int) -> Vector2i:
	return MOVEMENTS[piece_type].get(direction, Vector2i.ZERO) * steps

func is_valid_position(position: Vector2i, board_size: Vector2i) -> bool:
	return position.x >= 0 and position.y >= 0 and \
		   position.x < board_size.x and position.y < board_size.y

# Приватные методы
func _process_attacks(all_pieces: Array, involved_pieces: Array, board_size: Vector2i):
	var attackers = involved_pieces.filter(func(p): return p.is_attacker)
	var defenders = involved_pieces.filter(func(p): return p.is_defender)
	
	for attacker in attackers:
		_process_attack(attacker, defenders, board_size)

func _process_attack(attacker, defenders, board_size):
	var attack_vector = calculate_movement(attacker.type, attacker.attack_direction, 1)
	var target_pos = attacker.position + attack_vector
	
	if is_valid_position(target_pos, board_size):
		var target = _find_piece_at(target_pos, defenders)
		if target:
			_resolve_combat(attacker, target)

func _resolve_combat(attacker, defender):
	var original_positions = { attacker: attacker.position, defender: defender.position }
	
	if defender.can_reflect_attack(attacker):
		print("Attack reflected")
		_restore_positions(original_positions)
		return
	
	attacker.take_damage(defender.attack_power)
	if attacker.is_alive():
		defender.take_damage(attacker.attack_power)

func _resolve_conflicts():
	for position in _conflicts:
		var queue = _conflicts[position]
		queue.sort_attackers()
		queue.process_conflict()
	_conflicts.clear()

func _cleanup_pieces(pieces):
	for piece in pieces:
		if piece.health <= 0:
			piece.queue_free()

func _find_piece_at(position, pieces):
	return pieces.filter(func(p): return p.position == position]).front()

func _validate_pieces(pieces) -> bool:
	return pieces.all(func(p): return p.has_method("is_alive"))

func _restore_positions(positions):
	for piece in positions:
		piece.position = positions[piece]
