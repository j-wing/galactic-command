class Projectile
	# @params
	#	game = main game object with ctx
	#	x,y = current x, y position
	#	angle = direction of motion, in radians
	#	speed = distance object moves in one frame
	constructor:(@x, @y, @angle, @speed) ->

	getNextCoords:() ->
		x = @x + Math.cos(@angle)*@speed
		y = @y + Math.sin(@angle)*@speed
		return [x, y]

class Missile extends Projectile
	constructor:(@x, @y, @angle, @speed) ->
		super(@x, @y, -@angle, @speed)
		@height = 8
		@width = 2
		@color = "white"

	render:() ->
		[@x, @y] = @getNextCoords()
		halfWidth = @width / 2
		angle1 = (Math.PI / 2) + @angle
		pt1 = [@x + Math.cos(angle1)*halfWidth,
			   @y + Math.sin(angle1)*halfWidth]
		angle2 = Math.PI + @angle
		pt2 = [pt1[0] + Math.cos(angle2)*@height,
			   pt1[1] + Math.sin(angle2)*@height]
		angle4 = (-Math.PI / 2) + @angle
		pt4 = [@x + Math.cos(angle4)*halfWidth,
			   @y + Math.sin(angle4)*halfWidth]
		angle3 = Math.PI + @angle
		pt3 = [pt4[0] + Math.cos(angle3)*@height,
			   pt4[1] + Math.sin(angle3)*@height]

		utilities.drawPolygon(@color, pt1, pt2, pt3, pt4)

class Ship extends Projectile
	constructor:(@x, @y, @angle, @speed, @planetFrom, @owner) ->
		super(@x, @y, -@angle, @speed)
		@size = 12
		@power = 5
		@color = "white"

	render:() ->
		[@x, @y] = @getNextCoords()
		halfSize = @size / 3
		angle1 = Math.PI + @angle
		pt0 = [@x, @y]
		pt1 = [@x + Math.cos(angle1)*@size,
			   @y + Math.sin(angle1)*@size]
		angle2 = (Math.PI / 2) + @angle
		pt2 = [pt1[0] + Math.cos(angle2)*halfSize,
			   pt1[1] + Math.sin(angle2)*halfSize]
		angle3 = (-Math.PI / 2) + @angle
		pt3 = [pt1[0] + Math.cos(angle3)*halfSize,
			   pt1[1] + Math.sin(angle3)*halfSize]

		utilities.drawPolygon(@color, pt0, pt2, pt3)

class Fleet
	constructor:(@planetFrom, @planetTo, @numShips, @speed) ->
		console.log("created new fleet")
		@ships = []
		radius = @numShips / 2
		i = 0
		angle = utilities.getAngle(@planetTo.x, @planetTo.y, @planetFrom.x, @planetFrom.y)
		@ships.push(new Ship(@planetFrom.x, @planetFrom.y, -angle, 5, @planetFrom, @planetFrom.owner))
		console.log(@planetFrom.x, @planetFrom.y)
		while i < @numShips
			spawnRadius = utilities.randInt(0, radius)
			spawnAngle = utilities.randDouble(0, Math.PI*2)
			cx = @planetFrom.x + Math.cos(spawnAngle)*spawnRadius
			cy = @planetFrom.y + Math.sin(spawnAngle)*spawnRadius

			tx = @planetTo.x + Math.cos(spawnAngle)*spawnRadius
			ty = @planetTo.y + Math.sin(spawnAngle)*spawnRadius

			angle = utilities.getAngle(tx, ty, cx, cy)
			@ships.push(new Ship(cx, cy, -angle, 5, @planetFrom, @planetFrom.owner))
			i++

	hasCollided:() ->
		distToPlanet = utilities.euclideanDistance(@ships[0].x, @ships[0].y, @planetTo.x, @planetTo.y)
		if distToPlanet < @planetTo.radius
			# console.log("true")
			return true
		else
			# console.log("false")
			return false

	render:() ->
		for ship in @ships
			# console.log("In fleet renderer")
			ship.render()

window.Projectile = Projectile
window.Missile = Missile
window.Ship = Ship
window.Fleet = Fleet


