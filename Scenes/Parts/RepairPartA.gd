extends Label


func _init_repair_partA(_word:String)->void:
	text="        "+_word.right(-1)
	pivot_offset=size*Vector2(0.5,0.5)
