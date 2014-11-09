class Utilities

	# Draws a circle to the canvas
	# @params:
	#   cx = center x
	#   cy = center y
	#   radius
	#   color = valid css color (hex, word, etc)
	fillCircle:(cx, cy, radius, color) ->
		@drawCircle(cx, cy, radius, color, false)

	strokeCircle:(cx, cy, radius, color) ->
		@drawCircle(cx, cy, radius, color, true)

	drawCircle:(cx, cy, radius, color, stroke) ->
		@ctx = Game.getContext()
		@ctx.beginPath();
		@ctx.arc(cx, cy, radius, 0, 2*Math.PI, false);
		if stroke
			@ctx.strokeStyle = color
			@ctx.stroke()
		else
			@ctx.fillStyle = color;
			@ctx.fill();


	getCenter:() ->
		return [window.innerWidth/2, window.innerHeight/2]

	euclideanDistance: (x1, y1, x2, y2) ->
		return Math.sqrt(Math.pow(x2-x1, 2)+Math.pow(y2-y1, 2))

	getAngle: (toX, toY, fromX, fromY) ->
		xdiff = toX - fromX
		ydiff = toY - fromY
		angle = Math.atan(ydiff/xdiff)
		if xdiff < 0
			angle += Math.PI
		return angle

	drawPolygon:(color, pts...) ->
		@ctx.fillStyle = color
		@ctx.beginPath()
		for pt in pts
			@ctx.lineTo(pt...)
		@ctx.fill();

	randInt:(low, high) ->
		if !high?
			high = low
			low = 0
		return low + Math.round(Math.random() * (high - low))

window.utilities = new Utilities()