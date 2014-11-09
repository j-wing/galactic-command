class InfoBox
	draw:(@planet) ->
		@centerX = utilities.getCenter()[0]

		# if (@planet.x <= @centerX)
		topLeft = [@planet.x + @planet.radius + 10,
				   @planet.y - @planet.radius]

		# utilities.drawLine("white", @planet.x, @planet.y, topLeft[0], topLeft[1])
		# else
		# 	topLeft = [@planet.x - @planet.radius - $("#info-box").innerWidth(),
		# 			   @planet.y - @planet.radius]
		$("#info-box").css({
			"top":"" + (topLeft[1]) + "px",
			"left":"" + (topLeft[0]) + "px",
			"display":"block"
		});

		# Set owner text
		ownerText = ""
		if !@planet.owner
			ownerText = "Neutral"
		else if @planet.owner.isHuman
			ownerText = "You"
		else
			ownerText = "AI-" + @planet.owner.number
		$("#owner").html(ownerText)

		# Set num ships
		$("#num-ships").html(@planet.numShips)

		# Set kill rate
		$("#power").html(@planet.killRate.toFixed(2))

	hide:() ->
		$("#info-box").css("display","none")

window.InfoBox = new InfoBox()