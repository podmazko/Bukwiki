extends Button


func set_status(_status:int=0)->void: #0-done, 1-open 2-closed
	$Star.visible= (_status==0)
	disabled= (_status==2)
			
			
func level_unlocked()->void: #call when this level should be unlocked
	disabled=false
	print("level unlocked anim!")
	
func level_completed()->void: #call when this level completed
	$Star.visible=true
	print("level completed anim!")
