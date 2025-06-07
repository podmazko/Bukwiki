extends Control

var _CardNode:PackedScene=preload("res://Scenes/Parts/MemoryCard.tscn")
@onready var Center:Control=$Center
@onready var Mage:Sprite2D=$Mage

var LevelCounter:int
func _init_segment(_segment_info_words:Array)->void: #[(2, 2), 0.3]
	Mage.modulate.a=0
	
	var _grid:Vector2=Vector2(_segment_info_words[0],_segment_info_words[0])
	var _difficult:float=_segment_info_words[1]
	
	var _all_words:Array=Data.Words.keys()
	var _words_count:int=_grid.x*_grid.y/2
	LevelCounter=_words_count
	
	#generate words
	var _all_words_count:int=_all_words.size()
	
	var _median:int=_all_words_count*_difficult
	var _rand_power:int=_words_count*3
	
	var _n_min:int=clamp(_median-_rand_power,0,_all_words_count-1)
	var _n_max:int=clamp(_median+_rand_power,0,_all_words_count-1)
	
	var _words_ns:=[]
	while _n_min!=_n_max:
		_words_ns.append(_n_min)
		_n_min+=1
		
	_words_ns.shuffle()
	_words_ns.resize(_words_count)
	
	#generate cards
	
	for i in _words_ns:
		var _word:String=_all_words[i]
		for _copy in 2:
			var _inst:Control=_CardNode.instantiate()
			Center.add_child(_inst)

			_inst._init_memory_card(_word)
			
			_inst.mouse_entered.connect(Globals._hover_image.bind(_inst))
			_inst.mouse_exited.connect(Globals._hover_image_exit)
			_inst.gui_input.connect(object_input.bind(_inst))
			_inst.modulate.a=0
			
	var _all_cards:Array=Center.get_children()
	_all_cards.shuffle()
	#1200x1000 field
	var _card_size:Vector2=_all_cards[0].size
	var _offset:Vector2=Vector2(25,30)
	var _axis:Vector2=Vector2(0,0)  #_grid
	var _start_point:Vector2
	_start_point.x=-0.5*(_grid.x*_card_size.x+_offset.x*(_grid.x-1))
	_start_point.y=-0.5*(_grid.y*_card_size.y+_offset.y*(_grid.y-1))
	
	for _card in _all_cards:
		_card.position=_start_point+_axis*(_card_size+_offset)
		
		_axis.x+=1
		if _axis.x==_grid.x:
			_axis.x=0
			_axis.y+=1
	
	if _start_point.x<-600:
		var _f:float=-600/_start_point.x
		Center.scale=Vector2(_f,_f)



func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)

	var _delay:=0.0
	for _word in Center.get_children():
		_tween.tween_property(_word,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.7,0.7))
		_tween.tween_property(_word,"modulate:a",1.0,0.3).set_delay(_delay)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		_delay+=0.05
	

	_tween.tween_property(Mage,"modulate:a",1.0,1.0)
	_tween.tween_property(Mage,"position:x",Mage.position.x,2.3).from(Mage.position.x+300)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(Mage,"rotation_degrees",0,2.8).from(13)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(Mage,"scale",Vector2(1,1),2.55).from(Vector2(1.15,0.85))\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func object_input(event:InputEvent,object)->void:
	if event.is_pressed():
		object.swap()
		Globals.emit_signal("SFX","D")


func disappear_anim()->void:
	queue_free()
