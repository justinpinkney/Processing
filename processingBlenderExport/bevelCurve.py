import bpy
 
def createBevelObject():
	# Create Bevel curve and object
	bpy.ops.mesh.primitive_circle_add(radius=0.1)
	bpy.ops.object.convert(target='CURVE')
	ob = bpy.context.active_object
	return ob
 
def createCurveObject(bevob, beziers):
    # Create curve and object
    cu = bpy.data.curves.new('MyCurve', 'CURVE')
    ob = bpy.data.objects.new('MyCurveObject', cu)
    bpy.context.scene.objects.link(ob)
 
    # Set some attributes
    cu.bevel_object = bevob
    cu.dimensions = '3D'
    ob.show_name = True
	
    # Create nurbs curve
    spline = cu.splines.new('NURBS')
    nPointsU = len(beziers)
    spline.points.add(nPointsU)
	
    for num in range(len(beziers)):  
        x, y, z = beziers[num]
        spline.points[num].co = (x, y, z, 1)
        print(x,y,z)
    return ob
 
def run(origin, beziers, bevob):
    curveob = createCurveObject(bevob, beziers)
    curveob.location = origin
    bevob.select = False
    curveob.select = True
    return
 
if __name__ == "__main__":
	# create the object to bevel with
	bevob = createBevelObject()
	bevob.location = (0,0,0)
	
	# open the file and read in co-ordinates line by line
	f = open('C:/Users/Justin/Desktop/temp.txt', 'r')
	f.seek(0)
	for line in f:
		temp = line.split(',')
		print('new line')
		beziers = list()
		for x in temp:
			a,b,c = [float(num) for num in x.split()]
			beziers.append((a,b,c))
		
		# create the curve and bevel
		run((0,0,0),beziers, bevob)
	f.close();