extends Control
@onready var Center:Control=$Center


###### PaseParts
func _init_segment(_segment_info_words:Array)->void:
	_words_count=_segment_info_words.size()
	
	#init images
	for word in _segment_info_words:
		var _img_name:String="res://Assets/Images/Objects/"+Data.Words[word][0]+".png"
		var _isnt:TextureRect=TextureRect.new()
		Center.add_child(_isnt)
		_isnt.mouse_filter=2
		_isnt.modulate=Color(0.2,0.2,0.2,0.10)
		_isnt.texture=load(_img_name)
		_isnt.scale=Vector2(0,0)
		_images.append(_isnt)
	

var _images:Array=[]
var _words_count:int
func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	
	var _y_summ:int=0 #summ of all Y fot centrilizing
	for i in _images:
		_y_summ+=i.size.y
	
	var _offset:int=16 #base offset
	var _base_y:int=-60-0.5*( _y_summ+_offset*(_words_count-1) )
	
	
	for n in _words_count:
		var i:TextureRect=_images[n]
		
		i.position.y=_base_y
		_base_y+=i.size.y+_offset
		i.position.x=-250-0.5*i.size.x
		i.pivot_offset=i.size*Vector2(0.5,0.5)
		
		var _delay:float=n*0.15
		_tween.tween_property(i,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_callback(PlayerData.emit_signal.bind("SFX","B")).set_delay(_delay)
	
	_tween.tween_callback(message.bind("Нужно собрать слоги,\nчтобы они превратились\nв слово","Fear",Vector2(0.5,0)) )\
				.set_delay(1)


func message(_text:String,img:String,from_scale:=Vector2(1.05,0.95))->void:
	PlayerData.emit_signal("ShowMessage",_text,img,from_scale)

func disappear_anim()->void:
	queue_free()
