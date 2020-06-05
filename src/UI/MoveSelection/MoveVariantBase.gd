extends Node2D
class_name MoveVariantBase

enum VariantType {
	Left,
	Right,
	JumpUp,
	JumpDiagonal
}

export(VariantType) var variant_type = VariantType.Left
export var steps_count = 1
