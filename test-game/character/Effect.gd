# Effect.gd
extends Node

class_name Effect

var effect_type: String
var value: int

func apply_effect(target: BaseCharacter):
	if effect_type == "damage_boost":
		target.attack_power += value
	elif effect_type == "defense_boost":
		target.defense_power += value
