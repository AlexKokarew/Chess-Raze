extends Node2D

@onready var label = $CanvasLayer/Panel/Label2
@onready var timer = $Timer
@onready var timer_frezze = $Timer_frezze
@onready var anode = preload("res://node/node.gd")
@onready var bnode = anode.new()

@onready var move = preload("res://move/move.gd")
@onready var moveer = move.new()

@onready var massive_cell = preload("res://Massive_cell/Massive_cell.gd")
@onready var massive = massive_cell.new()

@onready var sravn_cell = preload("res://sravn_cell/sravn_cell.gd")
@onready var sravnener_cell = sravn_cell.new()

var score = 0

func _ready():
	start_timer()
	
	

func _on_start_button_pressed() -> void:
	var mainscenetraningroom = load("res://level traning room/scene.tscn")
	get_tree().change_scene_to_packed(mainscenetraningroom)

func _on_button_test_pressed() -> void:
	
	
	reset_timer()
	var stringmassive = str(massive.is_cell_filled(0)) + str(massive.is_cell_filled(1)) + str(massive.is_cell_filled(2))
	
	var left = "left"
	var ffd = moveer._king_input_event(left)
	print(ffd)
	
	bnode.move(left)
	var vector_cuda_tolkatb = bnode.current_position
	
	label.text = stringmassive
	print("ход произошел")

func _on_test() -> void:
	var stringmassive = str(massive.is_cell_filled(0)) + str(massive.is_cell_filled(1)) + str(massive.is_cell_filled(2))
	label.text = stringmassive
	var on_boll_timer_freze
	
	start_timer_frezze()
	massive.initialize(64, false) 
	


func _button_massive_test() -> void:
	reset_timer()
	
	
	var right = "right"
	var ffd = moveer._king_input_event(right)
	print(ffd)
	
	bnode.move(right)
	var vector_cuda_tolkatb = bnode.current_position
	
	
	
	print("ход произошел")
	

func start_timer_frezze():
	timer_frezze.start()
	stop_timer()

func start_timer():
	timer.start()
	print("начало игры")

func stop_timer():
	timer.stop()
	print("пауза")

func reset_timer():
	timer.stop()
	
	timer.start()
	

func _on_timer_timeout() -> void:
	massive._on_timer_timeout()
	moveer._king_input_event("zero")
	print("ход произошел")
	score = score + 1
	print(score)
	
	bnode.move("zero")
	print(str(bnode.current_position))
	print(str(bnode.massive_position))


func _on_timer_frezze_timeout() -> void:
	massive._on_timer_timeout()
	moveer._king_input_event("zero")
	
	
