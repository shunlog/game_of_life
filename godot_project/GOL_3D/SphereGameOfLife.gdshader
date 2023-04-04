shader_type spatial;
uniform sampler2D tex;
varying vec2 tex_position;


void convert_xyz_to_cube_uv(float x, float y, float z, out int index, out float u, out float v)
{
  float absX = abs(x);
  float absY = abs(y);
  float absZ = abs(z);
  
  bool isXPositive = x > 0. ? true : false;
  bool isYPositive = y > 0. ? true : false;
  bool isZPositive = z > 0. ? true : false;
  
  float maxAxis, uc, vc;
  
  // POSITIVE X
  if (isXPositive && absX >= absY && absX >= absZ) {
    // u (0 to 1) goes from +z to -z
    // v (0 to 1) goes from -y to +y
    maxAxis = absX;
    uc = -z;
    vc = y;
    index = 0;
  }
  // NEGATIVE X
  if (!isXPositive && absX >= absY && absX >= absZ) {
    // u (0 to 1) goes from -z to +z
    // v (0 to 1) goes from -y to +y
    maxAxis = absX;
    uc = z;
    vc = y;
    index = 1;
  }
  // POSITIVE Y
  if (isYPositive && absY >= absX && absY >= absZ) {
    // u (0 to 1) goes from -x to +x
    // v (0 to 1) goes from +z to -z
    maxAxis = absY;
    uc = x;
    vc = -z;
    index = 2;
  }
  // NEGATIVE Y
  if (!isYPositive && absY >= absX && absY >= absZ) {
    // u (0 to 1) goes from -x to +x
    // v (0 to 1) goes from -z to +z
    maxAxis = absY;
    uc = x;
    vc = z;
    index = 3;
  }
  // POSITIVE Z
  if (isZPositive && absZ >= absX && absZ >= absY) {
    // u (0 to 1) goes from -x to +x
    // v (0 to 1) goes from -y to +y
    maxAxis = absZ;
    uc = x;
    vc = y;
    index = 4;
  }
  // NEGATIVE Z
  if (!isZPositive && absZ >= absX && absZ >= absY) {
    // u (0 to 1) goes from +x to -x
    // v (0 to 1) goes from -y to +y
    maxAxis = absZ;
    uc = -x;
    vc = y;
    index = 5;
  }

  // Convert range from -1 to 1 to 0 to 1
  u = 0.5f * (uc / maxAxis + 1.0f);
  v = 0.5f * (vc / maxAxis + 1.0f);
}


void index_uv_to_texture_uv(int index, float u, float v, out float tx, out float ty){
//	CUBE FACES:
//
//--------------------             -------
//|     |     |      |             |     |      
//|  4  |  5  |  6   |             |  5  |       
//--------------------  =>   --------------------------
//|     |     |      |       |     |     |      |     |
//|  1  |  2  |  3   |       |  1  |  2  |  3   |  6  |
//--------------------       --------------------------
//								 |     |
//								 |  4  |
//								 -------

	float x, y;
	switch(index){
		case 0:
		case 3:
			x = 0.;
			break;
		case 1:
		case 4:
			x = 1./3.;
			break;
		case 2:
		case 5:
			x = 2./3.;
			break;
	}
	switch(index){
		case 0:
		case 1:
		case 2:
			y = .5;
			break;
		case 3:
		case 4:
		case 5:
			y = .0;
			break;
	}
	tx = x + u / 3.;
	ty = y + v / 2.;
}


void vertex() {
	float x = VERTEX.x;
	float y = VERTEX.y;
	float z = VERTEX.z;
	
	int index;
	float u, v;
	convert_xyz_to_cube_uv(x, y, z, index, u, v);
	float tx, ty;
	index_uv_to_texture_uv(index, u, v, tx, ty);
	
	tex_position = vec2(tx, ty);

	
	VERTEX = normalize(VERTEX);
}


void fragment() {
	ALBEDO = texture(tex, tex_position).xyz;
}
