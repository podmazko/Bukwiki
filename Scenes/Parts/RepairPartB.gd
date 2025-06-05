extends TextureRect


func _init_repair_partB(_word:String)->void:
	$Label.text=_word.left(1)
	pivot_offset=size*Vector2(0.5,0.5)
