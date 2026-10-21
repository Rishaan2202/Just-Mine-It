extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var reserves_container: PanelContainer = $CanvasLayer/ReservesContainer
@onready var money_container: PanelContainer = $CanvasLayer/MoneyContainer
@onready var show_reserves_button: Button = $CanvasLayer/ShowReservesButton
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var pause_container: PanelContainer = $CanvasLayer/PauseContainer
@onready var continue_button: Button = $CanvasLayer/ContinueButton
@onready var restart_button: Button = $CanvasLayer/RestartButton
@onready var crusher_container: PanelContainer = $CanvasLayer/CrusherContainer
@onready var sell_button: Button = $CanvasLayer/SellButton
@onready var back_button: Button = $CanvasLayer/BackButton
@onready var money_bar: Label = $CanvasLayer/MoneyContainer/MoneyBar

# ---- Reserves Display Elements ---- 

@onready var dirt: Label = $CanvasLayer/ReservesContainer/Dirt
@onready var gravel: Label = $CanvasLayer/ReservesContainer/Gravel
@onready var stone: Label = $CanvasLayer/ReservesContainer/Stone

@onready var copper_ore: Label = $"CanvasLayer/ReservesContainer/Copper Ore"
@onready var silver_ore: Label = $"CanvasLayer/ReservesContainer/Silver Ore"
@onready var gold_ore: Label = $"CanvasLayer/ReservesContainer/Gold Ore"
@onready var diamond_ore: Label = $"CanvasLayer/ReservesContainer/Diamond Ore"

@onready var copper: Label = $CanvasLayer/ReservesContainer/Copper
@onready var silver: Label = $CanvasLayer/ReservesContainer/Silver
@onready var gold: Label = $CanvasLayer/ReservesContainer/Gold
@onready var diamond: Label = $CanvasLayer/ReservesContainer/Diamond


var pause_button_press_count = 0
var show_reserves_button_press_count = 0

# --- Money Variables --- #

var balance: int = 0
var disguised_balance: int = 0

# --- Mineral Variables --- #

var dirt_amount = 0
var gravel_amount = 0
var stone_amount = 0

var copper_ore_amount = 0
var silver_ore_amount = 0
var gold_ore_amount = 0
var diamond_ore_amount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reserves_container.visible = false
	pause_container.visible = false
	continue_button.visible = false
	restart_button.visible = false
	crusher_container.visible = false
	sell_button.visible = false
	back_button.visible = false
	var block = player.block_mined.connect(_on_block_mined)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_block_mined(type: String) -> void:
	if type == "dirt":
		dirt_amount += 1
		dirt.text = "Dirt x %s" % dirt_amount
	elif type == "gravel":
		gravel_amount += 1
		gravel.text = "Gravel x %s" % gravel_amount	
	elif type == "stone":
		stone_amount +=	1
		stone.text = "Stone x %s" % stone_amount
	elif type == "copper":
		copper_ore_amount += 1
		copper_ore.text = "Copper x %s" % copper_ore_amount
	elif type == "silver":
		silver_ore_amount += 1
		silver_ore.text = "Silver x %s" % silver_ore_amount
	elif type == "gold":
		gold_ore_amount += 1
		gold_ore.text = "Gold x %s" % gold_ore_amount
	elif type == "diamond":
		diamond_ore_amount += 1
		diamond_ore.text = "Diamond x %s" % diamond_ore_amount
	disguised_balance = (5 * dirt_amount) + (10 * gravel_amount) + (30 * stone_amount) + (75 * copper_ore_amount) + (150 * silver_ore_amount) + (750 * gold_ore_amount) + (1500 * diamond_ore_amount)
	sell_button.text = "Sell for $%s" % disguised_balance	

func _on_pause_button_pressed() -> void:
	pause_button.text = ">"
	get_tree().paused = not get_tree().paused
	pause_container.visible = true
	continue_button.visible = true
	restart_button.visible = true

func _on_show_reserves_button_pressed() -> void:
	show_reserves_button_press_count += 1
	
	if show_reserves_button_press_count % 2 == 1:
		reserves_container.visible = true
		show_reserves_button.text = "Hide Reserves ^"
	else:
		reserves_container.visible = false
		show_reserves_button.text = "Show Reserves V"


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	pause_container.visible = false
	continue_button.visible = false
	restart_button.visible = false


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_crusher_entered(body: Node2D) -> void:
	crusher_container.visible = true
	sell_button.visible = true
	back_button.visible = true


func _on_back_button_pressed() -> void:
	crusher_container.visible = false
	sell_button.visible = false
	back_button.visible = false


func _on_sell_button_pressed() -> void:
	balance += disguised_balance
	
	dirt_amount = 0
	gravel_amount = 0
	stone_amount = 0
	copper_ore_amount = 0
	silver_ore_amount = 0
	gold_ore_amount = 0
	diamond_ore_amount = 0
	
	disguised_balance = 0
	
	sell_button.text = "Sell for $0"
	money_bar.text = "$%s" % balance
