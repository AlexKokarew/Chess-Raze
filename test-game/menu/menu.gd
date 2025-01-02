extends Node2D

@onready var label = $CanvasLayer/Panel/Label2
@onready var timer = $Timer

@onready var anode = preload("res://node/node.gd")
@onready var bnode = anode.new()

@onready var move = preload("res://move/move.gd")
@onready var moveer = move.new()

@onready var massive_cell = preload("res://Massive_cell/Massive_cell.gd")
@onready var massive = massive_cell.new()
@onready var massivea = massive._ready()

@onready var sravn_cell = preload("res://sravn_cell/sravn_cell.gd")
@onready var sravnener_cell = sravn_cell.new()

func _on_start_button_pressed() -> void:
	var mainscenetraningroom = load("res://level traning room/scene.tscn")
	get_tree().change_scene_to_packed(mainscenetraningroom)

func _on_button_test_pressed() -> void:
	
	print(bnode)
	
	bnode.move("up")
	print("После перемещения вверх:", bnode.massive_position)
	bnode.move("down")
	print("После перемещения вниз:", bnode.massive_position)
	bnode.move("left")
	print("После перемещения влево:", bnode.massive_position)
	bnode.move("right")
	print("После перемещения вправо:", bnode.massive_position)
	bnode.move("up_right")
	print("После перемещения вверз вправо:", bnode.massive_position)
	bnode.move("up_left")
	print("После перемещения вверх влево:", bnode.massive_position)
	bnode.move("down_right")
	print("После перемещения вниз вправо:", bnode.massive_position)
	bnode.move("down_left")
	print("После перемещения вниз влево:", bnode.massive_position)
	bnode.move("zero")
	print("После перемещения остаться по центру:", bnode.massive_position)
	

func _on_test() -> void:
	start_timer()
	moveer._on_input_event("down")
	print(moveer.current_column)
	print(moveer.current_row)
	print(moveer.current_position_move)
	print(moveer.index)
	print(moveer)
	moveer._on_input_event("up")
	print(moveer.current_column)
	print(moveer.current_row)
	print(moveer.current_position_move)
	print(moveer.index)
	print(moveer)


func _button_massive_test() -> void:
	
	var stringmassive = str(massive.is_cell_filled(0)) + str(massive.is_cell_filled(1)) + str(massive.is_cell_filled(2))
	moveer._on_input_event("right")
	
	
	label.text = stringmassive
	
	
	
	
	
	
	
func start_timer():
	timer.start()


func _on_timer_timeout() -> void:
	massive._on_timer_timeout()
	moveer._on_input_event("zero")
	
	bnode.move("zero")
	print(str(bnode.current_position))
	print(str(bnode.massive_position))
