DEFAULT_PLANET_COLOR = "white"

class Planet
    # Base class for planets
    constructor:(@game, @x, @y, @radius) ->
        # alert("odded" + this.x + " " + this.y)
        @owner = null
        @ctx = @game.getContext()

    render:() ->
        @game.drawCircle(@x, @y, @radius, @getColor())

    getColor:() ->
        if @owner != null
            return @owner.getPlanetColor()
        else
            return DEFAULT_PLANET_COLOR

window.Planet = Planet