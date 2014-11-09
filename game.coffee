class Player
    constructor:(@number, @isHuman) ->

    getPlanetColor:() ->
        return "red"

    getShipColor:() ->
        return "white"

BASE_NEUTRAL_PLANETS = 5
# States of the game:
# 0: Initializing.
# 1: Planning phase.
# 2: Interactive phase

class GameCls
    constructor:() ->
        @canvas = $("canvas")
        @ctx = @canvas[0].getContext("2d")
        @canvasWidth = window.innerWidth
        @canvasHeight = window.innerHeight
        @bg = new Image()
        @bg.src = "bg.jpg"

        @currentState = 0

        # List of all event handlers.
        # Other objects looking to add hooks to DOM events need
        # to use @addHandler
        @eventHandlers = {"click":[]}

        @addEvents()
        # Set the canvas width/height
        @handleResize()

    startRenderLoop:() ->
        @player = new Player(1, true)

        @generateDefaultPlanetSet()
        @selectedPlanet = null
        @missiles = []
        @fleets = []


        window.requestAnimationFrame(@renderLoop.bind(@));

    generateDefaultPlanetSet: () ->
        # Generate a home planet for the user
        homePlanet = new Planet(0, 0, 4)
        homePlanet.setOwner(@player)
        homePlanet.setLocation(homePlanet.chooseRandomCoords(false)...)
        @planets = [homePlanet]

        # Now generate the neutral planets
        numPlanets = utilities.randInt(BASE_NEUTRAL_PLANETS, BASE_NEUTRAL_PLANETS+6)
        i = 0
        while i < numPlanets
            planet = new Planet(0, 0, utilities.randInt(1, 3))
            planet.setLocation(planet.chooseRandomCoords()...)
            @planets.push(planet)
            i++
    getContext:() ->
        return @ctx

    addEvents:() ->
        $(window).resize(@handleResize.bind(this))
        $(document).click(@handleClick.bind(this))
        # $(document).mousedown(@handleMouseDown.bind(this))
        # $(document).mouseup(@handleMouseUp.bind(this))
        # $(document).mousemove(@handleMouseMove.bind(this))

    # shootContinuously: () ->
    #     if (@shooting)
    #         wiggle_room = [-5,-4,-3,-2,-1,0,1,2,3,4,5]
    #         [cx, cy] = utilities.getCenter()
    #         cx += wiggle_room[Math.round(Math.random()*10)]
    #         cy += wiggle_room[Math.round(Math.random()*10)]
    #         angle = utilities.getAngle(@cursorPosition..., cx, cy)
    #         @missiles.push(new Missile(cx, cy, -angle, 5))
    #         setTimeout((() =>
    #             @shootContinuously()
    #         ), 100)

    # handleMouseMove: (e) ->
    #     @cursorPosition = [e.clientX, e.clientY]

    # handleMouseDown: (e) ->
    #     @shooting = true
    #     setTimeout((() =>
    #         @shootContinuously(e)
    #     ), 100)

    # handleMouseUp:(e) ->
    #     @shooting = false


    handleClick:(e) ->
        selectedPlanet = null
        for planet in @planets
            if utilities.euclideanDistance(planet.x, planet.y, e.clientX, e.clientY) < planet.radius
                selectedPlanet = planet
                break
        if @selectedPlanet
            @selectedPlanet.setSelected(false)
            
        if selectedPlanet != null
            selectedPlanet.setSelected(true)
            @selectedPlanet = selectedPlanet

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