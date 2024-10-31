extends Panel

@onready var itemView: Sprite2D = $ItemView

func update(varitem: item):
	if !varitem:
		itemView.visible = false
	else:
		itemView.visible = true
		itemView.texture = varitem.texture
		
