extends Node2D



@onready var label = $CanvasLayer/Panel/Label2
@onready var timer = $Timer
@onready var timer_frezze = $Timer_frezze

@onready var BaseArrayManager = preload("res://BaseArrayManager.gd").new()

@onready var move = preload("res://logick_attack/move.gd").new()

@onready var node = preload("res://node/node.gd").new()


@onready var Massive_cell = preload("res://Massive_cell/Massive_cell.gd").new()


@onready var sravn_cell = preload("res://sravn_cell/sravn_cell.gd").new()

var score = 0

func _ready():
	

	 # Инициализируем массив
	var x = 10
	var y = 10
	BaseArrayManager.initialize_grid(x, y)
	var xposition = 5
	var yposition = 5
	var hero = BaseArrayManager.to_index(xposition, yposition)
	BaseArrayManager.update_cell(hero, 1)
	start_timer()
	
	var Cudashodil = move._king_input_event("down",1,x,y,xposition,yposition)
	var hod = BaseArrayManager.from_index(Cudashodil)
	var rowe = hod[0]
	var columne = hod[1]
	var cudashod = BaseArrayManager.to_index(rowe, columne)
	BaseArrayManager.update_cell(hero, 0)
	BaseArrayManager.update_cell(cudashod, 1)
	
	
	
	
	
	
func _on_start_button_pressed() -> void:
	var mainscenetraningroom = load("res://level traning room/scene.tscn")
	get_tree().change_scene_to_packed(mainscenetraningroom)

func _on_button_test_pressed() -> void:
	reset_timer()
	var left = "left"
	print("ход произошел")

func _on_test() -> void:
	var on_boll_timer_freze
	start_timer_frezze()

func _button_massive_test() -> void:
	reset_timer()
	var right = "right"
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
	score = 1 + score
	print(score)
func _on_timer_frezze_timeout() -> void:
	score = 1 + score
	print(score)
	
