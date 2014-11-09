class Projectile
	# @params
	#	game = main game object with ctx
	#	x,y = current x, y position
	#	angle = direction of motion, in radians
	#	speed = distance object moves in one frame
	constructor:(@game, @x, @y, @angle, @speed) ->
		@ctx = @game.getContext()

	getNextCoords:() ->
		x = @x + Math.cos(@angle)*@speed
		y = @y + Math.sin(@angle)*@speed
		return [x, y]

class Missile extends Projectile
	constructor:(@game, @x, @y, @angle, @speed) ->
		super(@game, @x, @y, -@angle, @speed)
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

		@ctx.fillStyle = @color;
		@ctx.beginPath();
		@ctx.lineTo(pt1...);
		@ctx.lineTo(pt2...);
		@ctx.lineTo(pt3...);
		@ctx.lineTo(pt4...);
		@ctx.fill();

window.Projectile = Projectile
window.Missile = Missile

