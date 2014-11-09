DEFAULT_PLANET_COLOR = "#EEE"
SELECTED_COLOR = "#00FFFF"
PLANET_SIZES = 
    1: 15
    2: 25
    3: 35
    4: 45

class Planet
    # Base class for planets
    constructor:(@x, @y, @size) ->
        @radius = @chooseRadius()
        @owner = null
        @ctx = Game.getContext()
        @numShips = @chooseDefaultShips()
        @killRate = @chooseDefaultKillRate()
        @selected = false


    render:() ->
        @ctx.shadowBlur = 100
        @ctx.shadowColor = @getColor()
        utilities.fillCircle(@x, @y, @radius, @getColor())
        if @selected
            # @ctx.stroke
            @ctx.shadowBlur = 100
            @ctx.shadowColor = SELECTED_COLOR
            @ctx.lineWidth = 4
            utilities.strokeCircle(@x, @y, @radius+4, SELECTED_COLOR)


    getColor:() ->
        if @owner != null
            return @owner.getPlanetColor()
        else
            return DEFAULT_PLANET_COLOR

    chooseRadius:() ->
        return PLANET_SIZES[@size] + Math.round(Math.random()*3)

    chooseDefaultShips:() ->
        # Returns a number of ships suitable as a default, as a random number from 1-15
        return 1 + Math.round(Math.random()*14)

    chooseDefaultKillRate:() ->
        # Chooses a default kill rate as random number between .3 and .8
        return (3 + Math.random()*5)/10

    setOwner:(player) ->
        @owner = player

    setLocation:(x, y) ->
        @x = x
        @y = y

    setSelected:(selected) ->
        @selected = selected

    chooseRandomCoords:(checkCollisions) ->
        # Returns random x, y for this planet such that the whole planet is at least 20 units from an edge and any other planet
        while true
            x = @radius+20 + Math.round(Math.random() * (Game.canvasWidth-(2*@radius+40)))
            y = @radius+20 + Math.round(Math.random() * (Game.canvasHeight-(2*@radius+40)))
            
            if !checkCollisions && checkCollisions?
                break
            
            collided = false
            for planet in Game.planets
                if utilities.euclideanDistance(x, y, planet.x, planet.y) < (planet.radius+20)
                    collided = true
                    break
            if !collided
                break
        return [x, y]

    handleFleetCollision:(fleet) ->
        if fleet.owner == @owner
            # Reinforcements
            @numShips += fleet.numShips
        else
            attackerRand = utilities.randDouble(.8, 1.2)
            defenderRand = utilities.randDouble(.8, 1.2)
            remainingShips = Math.round(fleet.numShips * fleet.planetFrom.killRate * attackerRand - @numShips*@killRate*defenderRand)
            if remainingShips > 0
                @owner = fleet.owner
                @numShips = Math.round(remainingShips / fleet.planetFrom.killRate)
            else
                @numShips = Math.round(Math.abs(remainingShips) /@killRate)

    sendShips:(num) ->
        @numShips -= num


window.Planet = Planet