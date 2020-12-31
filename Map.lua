Map = Class{}

TILE_EMPTY = 15

ONE = 5
ZERO = 6
FIVE = 7
ZERO2 = 8

TILE_TOP = 9
TILE_MIDDLE = 10
TILE_BOTTOM = 11

TILE_RTOP = 12
TILE_RMIDDLE = 13
TILE_RBOTTOM = 14

RED = 1
YELLOW = 2
GREEN = 3
BLUE = 4

local SCROLL_SPEED = 62

require 'Player'

require 'Obstacle'


function Map:init()
    self.spritesheet = love.graphics.newImage('Sprites/Objects.png')
    self.tileW = 8
    self.tileH = 8
    self.mapW = 60
    self.mapH = 56 
    self.tiles = {}

    self.player = Player(self)

    self.obs = {
        ['o1'] = Obstacle({
        map = self,
        texture = self.spritesheet,
        f = {
            ONE, ZERO, FIVE, ZERO2
        },
        name = 'obstacle'
        }),
        ['o2'] = Obstacle({
            map = self,
            texture = self.spritesheet,
            f = {
                ONE, ZERO, FIVE, ZERO2
            },
            name = 'obstacle'
        }),
        ['o3'] = Obstacle({
            map = self,
            texture = self.spritesheet,
            f = {
                ONE, ZERO, FIVE, ZERO2
            },
            name = 'obstacle'
        }),
        ['o4'] = Obstacle({
            map = self,
            texture = self.spritesheet,
            f = {
                RED, YELLOW, GREEN, BLUE
            },
            name = 'gem'
        })
    }

    self.camX = 0
    self.camY = 0

    self.music = love.audio.newSource('Sounds/Background.mp3', 'static')
    self.music:setVolume(0.6)

    self.tileSprites = generateQuads(self.spritesheet, self.tileW, self.tileH)
    
    self.mapWP = self.mapW * self.tileW
    self.mapHP = self.mapH * self.tileH

    self.pyramidColliders = {}

    for y = 1, self.mapH do
        for x = 1, self.mapW do
            self:setTile(x, y, TILE_EMPTY)
        end
    end
    --Rainbow Pyramid Base to the right
    for y = 1, self.mapH do
        for x = 1, self.mapW do
            if x == self.mapH - y then
                self:setTile(x, y, TILE_TOP)
                sample = world:newRectangleCollider(x * 8 - 8, y * 8 - 8, 8, 8)
                sample:setType('static')
                sample:setCollisionClass('Border')
                table.insert(self.pyramidColliders, sample)
            elseif x == self.mapH - y + 1 then
                self:setTile(x, y, TILE_MIDDLE)
                sample = world:newRectangleCollider(x * 8 - 8, y * 8 - 8, 8, 8)
                sample:setType('static')
                sample:setCollisionClass('Border')
            end
        end
    end

    for y = 1, self.mapH do
        for x = self.mapH - y + 2, self.mapW do
            self:setTile(x, y, TILE_BOTTOM)
        end
    end
    --Rainbow Pyramid Base to the left
    for y = 1, self.mapH do
        for x = 1, self.mapW do
            if x == self.mapH - y - 25 then
                self:setTile(x, y, TILE_RTOP)
                sample = world:newRectangleCollider(x * 8 - 8, y * 8 - 8, 8, 8)
                sample:setType('static')
                sample:setCollisionClass('Border')
                table.insert(self.pyramidColliders, sample)
            elseif x == self.mapH - y - 26 then
                self:setTile(x, y, TILE_RMIDDLE)
            end
        end
    end

    for y = 1, self.mapH do
        for x = 1, self.mapW / 2 - y - 1 do
            self:setTile(x, y, TILE_RBOTTOM)
        end
    end

    self.music:setLooping(true)
    self.music:play()
end

function Map:collides(tile)
    local collidables = {
        TILE_TOP, TILE_MIDDLE, TILE_BOTTOM, TILE_RTOP, TILE_RMIDDLE, TILE_RBOTTOM 
    }
    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return false
        end
    end
    return true
end

function Map:update(dt)
    if start then
        self.player:update(dt)
        for i = 1, 4 do
            self.obs['o' .. i]:update(dt)
        end
    end
    if love.keyboard.isDown('m') then 
        self.music:stop()
        self.music:play()
    end
end

function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileW) + 1,
        y = math.floor(y / self.tileH) + 1,
        id = self:getTile(math.floor(x / self.tileW) + 1, math.floor(y / self.tileH) + 1)
    }
end

function Map:setTile(x, y, tile)
    self.tiles[(y-1) * self.mapW + x] = tile
end

function Map:getTile(x, y)
    return self.tiles[(y-1) * self.mapW + x] 
end

function Map:reset()
    self.music:stop()
    self.music:play()
    self.player:reset()
    for i=1, 4 do 
        self.obs['o' .. i].x = math.random(self.tileW * 40, self.tileW * 60)
        self.obs['o' .. i].y = -100
    end
end
function Map:render(start)
    for y = 1, self.mapH do
        for x = 1, self.mapW do
            love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileW, (y-1) * self.tileH)
        end
    end
    if start then
        for i = 1, 4 do
            self.obs['o' .. i]:render()
        end
        self.player:render()
    end
end
