shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float _gr=(COLOR.r+COLOR.g+COLOR.b)/3.0;
	COLOR.rgb=vec3(_gr,_gr,_gr)*vec3(1.4,1.0,1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
