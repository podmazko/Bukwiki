shader_type canvas_item;

uniform float offset=0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.a*=0.05*(sin( (TIME+offset)*6.0)+sin( (TIME+offset)*15.3)+14.9);

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
