class Player
    constructor:(@number, @isHuman) ->

window.getCenter = () ->
    return [window.innerWidth/2, window.innerHeight/2]
window.euclidean_distance = (x1, y1, x2, y2) ->
    return Math.sqrt(Math.pow(x2-x1, 2)+Math.pow(y2-y1, 2))
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
        [cx, cy] = getCenter()
        xdiff = e.clientX - cx
        ydiff = e.clientY - cy
        angle = Math.atan(ydiff/xdiff)
        if xdiff < 0
            angle += Math.PI
        @missiles.push(new Missile(@, cx, cy, -angle, 5))

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

        mi = 0
        while mi < @missiles.length
            missile = @missiles[mi]
            pi = 0
            collided = false
            while pi < @planets.length
                planet = @planets[pi]
                if euclidean_distance(missile.x, missile.y, planet.x, planet.y) < planet.radius and planet != @planets[0]
                    @planets.splice(pi, 1)
                    collided = true
                    break
                pi++
            if collided
                @missiles.splice(mi, 1)
            else
                missile.render()
            mi++

        window.requestAnimationFrame(@renderLoop.bind(this))

$(document).ready(() ->
    window.Game = new Game()
)