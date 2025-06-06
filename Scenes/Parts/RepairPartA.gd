extends Label

var full_word:String
func _init_repair_partA(_word:String)->void:
	full_word=_word
	text="        "+_word.right(-1)
	pivot_offset=size*Vector2(0.5,0.5)+Vector2(30,0)
	
	
func _become_right()->void:
	custom_minimum_size=size
	text="   "+full_word
	$RozetkaB.visible=false
