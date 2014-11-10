class Player
    constructor:(@number, @isHuman) ->

    getPlanetColor:() ->
        return "#3CB400"

    getShipColor:() ->
        if @isHuman
            return "#00FF04"

class AI extends Player
    constructor:(@number, @isHuman=false) ->
        @numShips = 100

    getPlanetColor:() ->
        return "red"

    getShipColor:() ->
        return "red"

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
        @ai_players = []
        @ai_players.push(new AI(2))
        @ai_planets = []

        @generateDefaultPlanetSet()
        @selectedSource = null
        @selectedDestination = null
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

            # FOR DEBUGGING
            if Math.round(Math.random()) == 0
                planet.setOwner(@player)

            @planets.push(planet)
            i++

    getContext:() ->
        return @ctx

    addEvents:() ->
        $(window).resize(@handleResize.bind(this))
        $(document).click(@handleClick.bind(this))
        $(document).mousemove(@handleMouseMove.bind(this))
        # $(document).mousedown(@handleMouseDown.bind(this))
        # $(document).mouseup(@handleMouseUp.bind(this))

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

    handleMouseMove: (e) ->
        hoverPlanet = @mouseOnPlanet(e)
        if hoverPlanet
            InfoBox.draw(hoverPlanet)
        else
            InfoBox.hide()

    # handleMouseUp:(e) ->
    #     @shooting = false

    setSource:(planet) ->
        if @selectedSource
            @selectedSource.setSelected(false)
        if planet
            planet.setSelected(true)
        @selectedSource = planet

    setDestination:(planet) ->
        if @selectedDestination
            @selectedDestination.setSelected(false)
        if planet
            planet.setSelected(true)
        @selectedDestination = planet


    mouseOnPlanet:(e) ->
        for planet in @planets
            if utilities.euclideanDistance(planet.x, planet.y, e.clientX, e.clientY) < planet.radius
                return planet
        return null
#
    handleClick:(e) ->
        selectedPlanet = @mouseOnPlanet(e)

        if selectedPlanet == null
            @setSource(null)
            @setDestination(null)

        else
            if @selectedSource
                @setDestination(selectedPlanet)
                console.log(@selectedSource.x, @selectedSource.y, @selectedDestination.x, @selectedDestination.y)
                utilities.drawLine("white", @selectedSource.x, @selectedSource.y,
                    @selectedDestination.x, @selectedDestination.y)
                @deployFleet()
            else if !@selectedSource && !@selectedDestination
                if selectedPlanet.owner == @player
                    @setSource(selectedPlanet)

        for handler in @eventHandlers["click"]
            handler(e)

    deployFleet:() ->
        if @selectedSource.numShips > 0
            shipsToSend = Math.floor(@selectedSource.numShips)
            @fleets.push(new Fleet(@selectedSource, @selectedDestination, shipsToSend, 5))
            @selectedSource.sendShips(shipsToSend)
        @setSource(null)
        @setDestination(null)

    deployFleetAI:() ->
        neutralPlanets = @getNeutralPlanets()
        if @ai_player.numShips >= 0
            index = utilities.randInt(0, neutralPlanets.length - 1)
            @fleets.push(new Fleet(@ai_starting_planet))

    getNeutralPlanets:() ->
        neutralPlanets = []
        for planet in @planets
            if !planet.owner
                neutralPlanets.push(planet)
        return neutralPlanets

    getLeastShipsPlanet:() ->
        min_planet = undefined
        min_ships = 999
        for planet in @planets
            if planet.owner && planet.owner.isHuman && planet.numShips < min_ships
                min_planet = planet
        return min_planet

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
                fleet.planetTo.handleFleetCollision(fleet)
            fi++

        #### HANDLE AI ####


        window.requestAnimationFrame(@renderLoop.bind(this))

$(document).ready(() ->
    window.Game = new GameCls()
    Game.startRenderLoop()
)