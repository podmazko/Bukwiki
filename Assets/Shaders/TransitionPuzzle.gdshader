shader_type canvas_item;

uniform vec2 proportions = vec2(4,4);
uniform vec2 axis = vec2(0,0);

void vertex() {
	float _x=1.0/proportions.x;
	float _y=1.0/proportions.y;
	UV=UV*vec2(_x,_y)+vec2(_x,_y)*axis;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
