extends Control
@onready var Center:Control=$Center
@onready var PuzzleNode:PackedScene=preload("res://Scenes/Parts/PuzzlePart.tscn")

var base_y_offset:int=-60 #to offset objects center
###### PaseParts

func _init_segment(_segment_info_words:Array)->void:
	_words_count=_segment_info_words.size()
	var _between_offset:int=30
	var PuzzlePart_height:int=150
	var _place_y:int=base_y_offset-0.5*(_words_count*PuzzlePart_height+_between_offset*(_words_count-1))
	
	#init images
	var puzzle_img_n:int=1
	for word in _segment_info_words:
		var _word_info:Array=Data.Words[word]
		
		var _img_name:String="res://Assets/Images/Objects/"+_word_info[0]+".png"
		var _isnt:TextureRect=TextureRect.new()
		Center.add_child(_isnt)
		_isnt.mouse_filter=2
		_isnt.modulate=Color(0.2,0.2,0.2,0.10)
		_isnt.texture=load(_img_name)
		_isnt.scale=Vector2(0,0)
		_images.append(_isnt)
		
		#init both sides
		var _l_part_size:int=_word_info[1].size()/2
		var _l_part_n:int
		for i in _l_part_size:
			_l_part_n+=_word_info[1][i]
			
		var parts:Array=[word.left(_l_part_n),word.right(-_l_part_n)] #["СУН", "ДУК"]
		##init puzzles
		var _pzL:NinePatchRect=PuzzleNode.instantiate()
		Center.add_child(_pzL)
		L_parts.append(_pzL)
		_pzL._init_PuzzlePart(true,parts[0],"res://Assets/Images/Puzzle/L"+str(puzzle_img_n)+".png")
		_pzL.name=str(puzzle_img_n)+"L"
		
		var _pzR:NinePatchRect=PuzzleNode.instantiate()
		Center.add_child(_pzR)
		R_parts.append(_pzR)
		_pzR._init_PuzzlePart(false,parts[1],"res://Assets/Images/Puzzle/R"+str(puzzle_img_n)+".png")
		_pzR.name=str(puzzle_img_n)+"R"
		
		puzzle_img_n+=1#set next images
		
	L_parts.shuffle()
	R_parts.shuffle()
	for i in _words_count:
		var _pzL:NinePatchRect=L_parts[i]
		var _pzR:NinePatchRect=R_parts[i]
		
		_pzL.position=Vector2(-870,_place_y)
		_pzR.position=Vector2(-50,_place_y)
		_pzL.scale=Vector2(0,0)
		_pzR.scale=Vector2(0,0)
		
		_place_y+=PuzzlePart_height+_between_offset
		
		
var L_parts:Array
var R_parts:Array
var _images:Array=[]
var _words_count:int
func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	
	var _y_summ:int=0 #summ of all Y fot centrilizing
	for i in _images:
		_y_summ+=i.size.y
	
	var _offset:int=16 #base offset
	var _base_y:int=base_y_offset-0.5*( _y_summ+_offset*(_words_count-1) )
	
	

	for n in _words_count:
		var _I:TextureRect=_images[n]
		var _L:NinePatchRect=L_parts[n]
		var _R:NinePatchRect=R_parts[n]
		
		_I.position.y=_base_y
		_base_y+=_I.size.y+_offset
		_I.position.x=-250-0.5*_I.size.x
		_I.pivot_offset=_I.size*Vector2(0.5,0.5)
		

		var _delay:float=n*0.15
		_tween.tween_property(_L,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_property(_L,"position:x",_L.position.x,0.6).set_delay(_delay)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).from(_L.position.x-400)
		_tween.tween_property(_R,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_property(_R,"position:x",_R.position.x,0.6).set_delay(_delay)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).from(_R.position.x+400)
		_tween.tween_property(_I,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_callback(PlayerData.emit_signal.bind("SFX","A")).set_delay(_delay)

	
	_tween.tween_callback(message.bind("Как же собрать слоги\nобратно в слова?","Fear",Vector2(0.5,0)) )\
				.set_delay(1)


func message(_text:String,img:String,from_scale:=Vector2(1.05,0.95))->void:
	PlayerData.emit_signal("ShowMessage",_text,img,from_scale)

func disappear_anim()->void:
	queue_free()
