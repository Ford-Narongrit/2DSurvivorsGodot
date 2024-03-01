extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_lable: Label = $%DescriptionLabel


func _ready():
	gui_input.connect(on_gui_input)


func select_card():
	$MainAnimationPlayer.play("selected")


func set_meta_upgrade(upgrade: MetaUpgrade):
	name_label.text = upgrade.name
	description_lable.text = upgrade.description


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_cilick"):
		select_card()
