WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

Class = require 'class'
push = require 'push'

require 'Util'
require 'Map'
require 'Box'
wf = require 'windfield'
local socket = require 'socket'

function love.load()
    world = wf.newWorld(0, 0, true)
    love.graphics.setDefaultFilter("nearest","nearest")
    world:addCollisionClass('Border')
    world:addCollisionClass('Obstacle')
    world:addCollisionClass('Gem')
    world:addCollisionClass('Player')
    map = Map()
    start = false
    love.window.setTitle('Hacker Marathon - TESTING')
    smallFont = love.graphics.newFont('Blockt.TTF', 16)
    largeFont = love.graphics.newFont('Blockt.TTF', 24)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function sleep(sec)
    socket.select(nil, nil, sec)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    world:update(dt)
    map:update(dt)
    if love.keyboard.wasPressed('space') then
        start = true 
    end
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:apply('start')
    love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))
    love.graphics.clear(212 / 255, 152 / 255, 74 / 255, 1)
    if start then
        map:render(true)
        if map.player.lives > 0 then
            for i=1, 4 do 
                map.obs['o' .. i].a = 'yes'
            end
        end
        --world:draw() -- The world can be drawn for debugging purposes
    else
        map:render(false)
        love.graphics.setFont(largeFont)
        love.graphics.printf("Welcome to Hacker Marathon", math.floor(VIRTUAL_WIDTH / 12), 0, map.tileW * 45, 'center')
        love.graphics.printf("Press SPACE to Start", math.floor(VIRTUAL_WIDTH / 12), 32, map.tileW * 45, 'center')
    end
    if map.player.lives <= 0 then
        if love.keyboard.isDown('r') then
            start = false
            map:reset()
        else
            love.graphics.printf("Press R to Restart", math.floor(VIRTUAL_WIDTH / 12), 32, map.tileW * 45, 'center')
        end
    end
    push:apply('end')
end
