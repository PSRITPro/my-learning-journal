x= {}
y=[1,2]
z=[3,4]
print("x,x:", x.fromkeys(x,x))
print("x,y:", x.fromkeys(x,y))
print("x,z:", x.fromkeys(x,z))
print("y,y:", x.fromkeys(y,y))
print("y,x:",x.fromkeys(y,x))
print("y,z:",x.fromkeys(y,z))
print("z.x:",x.fromkeys(z,x))
print("z,y:", x.fromkeys(z,y))
print("z,z:", x.fromkeys(z,z))