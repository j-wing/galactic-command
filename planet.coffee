DEFAULT_PLANET_COLOR = "white"

class Planet
    # Base class for planets
    constructor:(@x, @y, @radius) ->
        # alert("odded" + this.x + " " + this.y)
        @owner = null
        @ctx = Game.getContext()

    render:() ->
        utilities.drawCircle(@x, @y, @radius, @getColor())

    getColor:() ->
        if @owner != null
            return @owner.getPlanetColor()
        else
            return DEFAULT_PLANET_COLOR

window.Planet = Planet