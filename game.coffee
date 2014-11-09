class Player
    constructor:(@number, @isHuman) ->

class GameCls
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

    startRenderLoop:() ->

        @planets = [new Planet(utilities.getCenter()..., 50)]
        @missiles = []
        @fleets = []


        window.requestAnimationFrame(@renderLoop.bind(@));

    getContext:() ->
        return @ctx

    addEvents:() ->
        $(window).resize(@handleResize.bind(this))
        $(document).click(@handleClick.bind(this))
        $(document).mousedown(@handleMouseDown.bind(this))
        $(document).mouseup(@handleMouseUp.bind(this))
        $(document).mousemove(@handleMouseMove.bind(this))

    shootContinuously: () ->
        if (@shooting)
            wiggle_room = [-5,-4,-3,-2,-1,0,1,2,3,4,5]
            [cx, cy] = utilities.getCenter()
            cx += wiggle_room[Math.round(Math.random()*10)]
            cy += wiggle_room[Math.round(Math.random()*10)]
            angle = utilities.getAngle(@cursorPosition..., cx, cy)
            @missiles.push(new Ship(cx, cy, -angle, 5, 0, null))
            setTimeout((() =>
                @shootContinuously()
            ), 100)

    handleMouseMove: (e) ->
        @cursorPosition = [e.clientX, e.clientY]

    handleMouseDown: (e) ->
        @shooting = true
        # setTimeout((() =>
        #     @shootContinuously(e)
        # ), 100)

    handleMouseUp:(e) ->
        @shooting = false


    handleClick:(e) ->
        @planets.push(new Planet( e.clientX, e.clientY, 10))
        [cx, cy] = utilities.getCenter()
        angle = utilities.getAngle(e.clientX, e.clientY, cx, cy)
        @fleets.push(new Fleet(@planets[0], @planets[@planets.length - 1], 50))

        console.log(@fleets[0])

        for handler in @eventHandlers["click"]
            handler(e)

    addHandler:(eventName, func) ->
        @eventHandlers[eventName].push(func)

    handleResize:() ->
        @canvasWidth = window.innerWidth
        @canvasHeight = window.innerHeight
        @canvas.attr("width", @canvasWidth).attr("height", @canvasHeight)

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
                # Collision detection for missiles and planets
                if utilities.euclideanDistance(missile.x, missile.y, planet.x, planet.y) < planet.radius and planet != @planets[0]
                    @planets.splice(pi, 1)
                    collided = true
                    break
                pi++
            if collided
                @missiles.splice(mi, 1)
            else
                missile.render()
            mi++

        fi = 0
        while fi < @fleets.length
            fleet = @fleets[fi]
            if !fleet.hasCollided()
                fleet.render()
            else
                @fleets.splice(fi, 1)
            fi++

        window.requestAnimationFrame(@renderLoop.bind(this))

$(document).ready(() ->
    window.Game = new GameCls()
    Game.startRenderLoop()
)