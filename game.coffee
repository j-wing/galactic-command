class Player
    constructor:(@number, @isHuman) ->

class Game

    constructor:() ->
        @canvas = $("canvas")
        @ctx = @canvas[0].getContext("2d")
        @canvasWidth = window.innerWidth
        @canvasHeight = window.innerHeight

        @addEvents()
        # Set the canvas width/height
        @handleResize()

        window.requestAnimationFrame(@renderLoop.bind(@));

    getContext:() ->
        return @ctx

    addEvents:() ->
        $(window).resize(@handleResize.bind(@))

    handleResize:() ->
        @canvasWidth = window.innerWidth
        @canvasHeight = window.innerHeight
        @canvas.attr("width", @canvasWidth).attr("height", @canvasHeight)

    renderLoop:() ->
        @ctx.clearRect(0, 0, @canvasWidth, @canvasHeight)

        window.requestAnimationFrame(@renderLoop.bind(this))