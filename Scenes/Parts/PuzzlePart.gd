extends NinePatchRect

@onready var Word:Label=$Label

var PuzzleSize:String

func _init_PuzzlePart(_left:bool,_text:String,img_path:String)->void:
	pivot_offset=size*Vector2(0.5,0.5)
	if _left:
		Word.text=_text+"  "
	else:
		Word.text=" "+_text
	
	size.x=Word.size.x+130
	texture=load(img_path)
