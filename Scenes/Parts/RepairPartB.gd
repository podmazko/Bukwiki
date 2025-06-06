extends TextureRect

var full_word:String
func _init_repair_partB(_word:String)->void:
	full_word=_word
	$Label.text=_word.left(1)

	
func _become_right()->void:
	$Label.visible=false
