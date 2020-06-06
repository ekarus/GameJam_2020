extends Node2D
class_name MoveVariantBase

enum VariantType {
	Left,
	Right,
	JumpUp,
	JumpLeft,
	JumpRight
}

export(VariantType) var variant_type = VariantType.Left
export var steps_count = 1
