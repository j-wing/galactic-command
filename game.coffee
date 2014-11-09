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


    # Draws a circle to the canvas
    # @params:
    #   cx = center x
    #   cy = center y
    #   radius
    #   color = valid css color (hex, word, etc)
    drawCircle:(cx, cy, radius, color) ->
        @ctx.fillStyle = color;
        @ctx.beginPath();
        @ctx.arc(cx, cy, radius, 0, 2*pi, false);
        @ctx.fill();