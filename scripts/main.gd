extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var reserves_container: PanelContainer = $CanvasLayer/ReservesContainer
@onready var money_container: PanelContainer = $CanvasLayer/MoneyContainer
@onready var show_reserves_button: Button = $CanvasLayer/ShowReservesButton
@onready var pause_button: Button = $CanvasLayer/PauseButton

var pause_button_press_count = 0
var show_reserves_button_press_count = 0

# --- Mineral Variables --- #
var dirt_ore_amount = 0

var gravel_ore_amount = 0

var stone_ore_amount = 0

var copper_ore_amount = 0
var copper_metal_amount = 0

var silver_ore_amount = 0
var silver_metal_amount = 0

var gold_ore_amount = 0
var gold_metal_amount = 0

var diamond_ore_amount = 0
var diamond_metal_amount = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reserves_container.visible = false
	var block = player.block_mined.connect(_on_block_mined)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_block_mined(type: String) -> void:
	if type == "dirt":
		dirt_ore_amount += 1
	elif type == "gravel":
		gravel_ore_amount += 1	
	elif type == "stone":
		stone_ore_amount +=	1
	elif type == "copper":
		copper_ore_amount += 1
	elif type == "silver":
		silver_ore_amount += 1
	elif type == "gold":
		gold_ore_amount += 1
	elif type == "diamond":
		diamond_ore_amount += 1


func _on_pause_button_pressed() -> void:
	pause_button.text = ">"
	get_tree().paused = not get_tree().paused


func _on_show_reserves_button_pressed() -> void:
	show_reserves_button_press_count += 1
	
	if show_reserves_button_press_count % 2 == 1:
		reserves_container.visible = true
		show_reserves_button.text = "Hide Reserves ^"
	else:
		reserves_container.visible = false
		show_reserves_button.text = "Show Reserves V"
