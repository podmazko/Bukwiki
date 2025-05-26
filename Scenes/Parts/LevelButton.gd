extends Button


func set_status(_status:int=0)->void: #0-done, 1-open 2-c;osed
	if _status!=0:
		$Star.visible=false
		if _status==2:#closed
			disabled=true
			
			
func level_unlocked()->void: #call when this level should be unlocked
	disabled=false
	print("level unlocked anim!")
	
func level_completed()->void: #call when this level completed
	$Star.visible=true
	print("level completed anim!")
