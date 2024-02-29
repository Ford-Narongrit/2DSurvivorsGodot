extends PanelContainer

signal  selected

@onready var name_label: Label = $%NameLabel
@onready var description_lable: Label = $%DescriptionLabel


func _ready():
	gui_input.connect(on_gui_input)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	print("yo")
	print(upgrade.id)
	name_label.text = upgrade.name
	description_lable.text = upgrade.description


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_cilick"):
		selected.emit()
