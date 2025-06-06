extends Control
@onready var Placeholder:TextureRect=$PlaceHolder
var _part_mat:Material=preload("res://Assets/Shaders/TransitionPuzzle.tres")

var _parts_places:={ } # n:placement
var _proportion:Vector2
var LavelCounter:int
func _init_segment(_segment_info:Array)->void:
	var _texture=load(_segment_info[0])
	Placeholder.texture=_texture
	Placeholder.self_modulate.a=0.0
	_proportion=_segment_info[1]
	#everything in appear anim since need to wait for texture applying


func appear_anim()->void:
	var _size:Vector2=Placeholder.size
	var _part_size:Vector2=_size/_proportion
	
	var _count:int=_proportion.x*_proportion.y
	LavelCounter=_count
	var _part_axis:=Vector2(0,0)
	for i in _count:
		var _inst:TextureRect=TextureRect.new()
		Placeholder.add_child(_inst)
		_inst.texture=Placeholder.texture
		_inst.expand_mode=1
		_inst.size=_part_size
		_inst.pivot_offset=_part_size*Vector2(0.5,0.5)
		_inst.mouse_filter=0
		_inst.scale=Vector2(0,0)
		_inst.material=_part_mat.duplicate()
		_inst.mouse_entered.connect(Globals._hover_image.bind(_inst))
		_inst.mouse_exited.connect(Globals._hover_image_exit)
		_inst.gui_input.connect(object_input.bind(_inst))
		_inst.material.set("shader_parameter/proportions",_proportion)
		_inst.material.set("shader_parameter/axis",_part_axis)
		_inst.name=str(i)
		_parts_places[_inst.name]=_part_axis*_part_size
		
		#prep for next
		_part_axis.x+=1
		if _part_axis.x==_proportion.x:
			_part_axis.x=0
			_part_axis.y+=1

	#start placement
	var _nodes:Array=Placeholder.get_children()
	_nodes.shuffle()
	
	var _viewport_size:Vector2=get_viewport_rect().size
	var _side_count:int=_count/2
	#x placement calculation
	var _middle_in_empty_space:float=(_viewport_size.x-Placeholder.size.x)/4.0
	var left_middle_x=-_middle_in_empty_space-_part_size.x/2.0
	var right_middle_x=Placeholder.size.x+_middle_in_empty_space-_part_size.x/2.0
	#y placement calculation
	var _y_offset:int=20
	var _overall_height:float=_side_count*_part_size.y+_y_offset*(_side_count-1)
	var _start_y:float=Placeholder.size.y/2.0 #image middle
	_start_y-=_overall_height/2.0
	
	for i in _count:
		var _node:TextureRect=_nodes[i]
		var _n_in_row:int
		if i <_side_count: #left side
			_node.position.x=left_middle_x +randi()%50-25
			_n_in_row=i
		else: #right side
			_n_in_row=i-_side_count
			_node.position.x=right_middle_x +randi()%50-25
		
		_node.position.y=_start_y + _n_in_row*_part_size.y + _y_offset*clamp(_n_in_row,0,999)


	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(Placeholder,"self_modulate:a",0.08,2)
	
	var _delay:=0.2
	for _img in Placeholder.get_children():
		_delay+=0.05
		_tween.tween_property(_img,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.4,0.4))
		_tween.tween_property(_img,"modulate:a",1.0,0.3).set_delay(_delay)
		
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)


func object_input(event:InputEvent,object)->void:
	if event.is_pressed():
		object.mouse_filter=2
		var _tween:Tween=create_tween().set_parallel(true)
		Globals.emit_signal("SFX","B")
		
		var _diff:Vector2=(_parts_places[object.name]-object.position).limit_length(100)
		var _anim_start_pos:Vector2=_parts_places[object.name]-_diff
		
		_tween.tween_property(object,"position",_parts_places[object.name],0.85)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(_anim_start_pos)
		
		_tween.tween_property(object,"scale",Vector2(1.0,1.0),1.3)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.85,0.85))
		LavelCounter-=1
		if LavelCounter==0:
			_tween.tween_callback(finish_level).set_delay(0.8)

func finish_level()->void:
	Placeholder.pivot_offset=Placeholder.size*Vector2(0.5,0.5)
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(Placeholder,"scale",Vector2(1.1,1.1),2.5)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(Placeholder,"modulate",Color(1.2,1.2,1.2,1),1.5)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	Globals.emit_signal("SFX","A")
	
	_tween.tween_property(self,"modulate:a",0,1.0).set_delay(2.0)
	_tween.tween_callback(Globals.emit_signal.bind("NextSegment")).set_delay(3.0)

	#main scene will call disappear anim after that
	

func disappear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(self,"scale",Vector2(0.0,0.0),0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.tween_property(self,"modulate:a",0,0.3)
	_tween.tween_callback(queue_free).set_delay(0.3)
