class Player
    constructor:(@number, @isHuman) ->

window.getCenter = () ->
    return [window.innerWidth/2, window.innerHeight/2]

class Game
    constructor:() ->
        @canvas = $("canvas")
        @ctx = @canvas[0].getContext("2d")
        @canvasWidth = window.innerWidth
        @canvasHeight = window.innerHeight

        # List of all event handlers.
        # Other objects looking to add hooks to DOM events need
        # to use @addHandler
        @eventHandlers = {"click":[]}

        @addEvents()
        # Set the canvas width/height
        @handleResize()

        @planets = [new Planet(@, getCenter()..., 50)]
        @missiles = []


        window.requestAnimationFrame(@renderLoop.bind(@));

    getContext:() ->
        return @ctx

    addEvents:() ->
        $(window).resize(@handleResize.bind(this))
        $(document).click(@handleClick.bind(this))

    handleClick:(e) ->
        @planets.push(new Planet(@, e.clientX, e.clientY, 10))

        for handler in @eventHandlers["click"]
            handler(e)

    addHandler:(eventName, func) ->
        @eventHandlers[eventName].push(func)

    handleResize:() ->
        @canvasWidth = window.innerWidth
        @canvasHeight = window.innerHeight
        @canvas.attr("width", @canvasWidth).attr("height", @canvasHeight)


    # Draws a circle to the canvas
    # @params:
    #   cx = center x
    #   cy = center y
    #   radius
    #   color = valid css color (hex, word, etc)
    drawCircle:(cx, cy, radius, color) ->
        @ctx.fillStyle = color;
        @ctx.beginPath();
        @ctx.arc(cx, cy, radius, 0, 2*Math.PI, false);
        @ctx.fill();

    renderLoop:() ->
        @ctx.clearRect(0, 0, @canvasWidth, @canvasHeight)

        # Fill default background
        @ctx.fillStyle = "black"
        @ctx.fillRect(0, 0, @canvasWidth, @canvasHeight)

        for planet in @planets
            planet.render()
            if planet != @planets[0]
                @ctx.beginPath()
                @ctx.moveTo(@planets[0].x, @planets[0].y)
                @ctx.lineTo(planet.x, planet.y)
                @ctx.strokeStyle = "white"
                @ctx.stroke();

        window.requestAnimationFrame(@renderLoop.bind(this))

$(document).ready(() ->
    window.Game = new Game()
)