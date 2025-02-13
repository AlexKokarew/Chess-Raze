# BaseCharacter.gd
extends Node

class_name BaseCharacter

var attack_power: int
var defense_power: int
var health: int

func _init(attack: int, defense: int):
	attack_power = attack
	defense_power = defense
