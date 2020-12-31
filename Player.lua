Player = Class{}

require 'Animation'

local MOVE_SPEED = 80
local JUMP_VELOCITY = 400
local GRAVITY = 25

function Player:init(map)
    self.w = 16
    self.h = 20

    self.map = map
    
    self.x = map.tileW * 10
    self.y = map.tileH * (map.mapH / 2 - 1) - self.h

    self.dx = 0
    self.dy = 0

    self.fillerx = 0
    self.fillery = 0

    self.xOffset = 8
    self.yOffset = 10

    self.texture = love.graphics.newImage('Sprites/Peoplesprites.png')
    self.frames = generateQuads(self.texture, 16, 20)
    self.state = 'idle'
    self.direction = 'right'
    self.power = 'D'

    self.lives = 3
    self.lost = 1
    self.score = 0
    self.transformed = false

    self.m = 1

    self.sounds = {
        ['gem'] = love.audio.newSource('Sounds/Gem.wav', 'static'),
        ['hit'] = love.audio.newSource('Sounds/Hurt.wav', 'static'),
        ['jump'] = love.audio.newSource('Sounds/Jump.wav', 'static'),
        ['transform'] = love.audio.newSource('Sounds/Powerup.wav', 'static')
    }

    self.pbox = Box(self, self.w / 2, self.h / 2, 'Player')
    self.pbox.box:setPreSolve(function(collider_1, collider_2, contact)
        if collider_1.collision_class == 'Player' and collider_2.collision_class == 'Border' then
            contact:setEnabled(false)
            if collider_1:enter(collider_2.collision_class) and self.state ~= 'jumping' then
                self.lives =  0
                self.sounds['hit']:play()
                --[[self.fillerx, self.fillery = collider_2:getPosition()
                x2, y2 = self.fillerx, self.fillery
                if self.x >= 210 then--right
                    self.x = math.min(self.x, x2)
                    self.y = math.min(self.y, y2)
                elseif self.x < 240  then --left
                    self.x = math.max(self.x, x2)
                    self.y = math.max(self.y, y2)
                end--]]
                --[[if self.y > 11 0 then--right
                    self.y = math.min(self.y, y2)
                end
                if self.y < 110 then --left
                    self.y = math.max(self.y, y2)
                end--]]
            end
        end
        if collider_1.collision_class == 'Player' and collider_2.collision_class == 'Obstacle' then
            contact:setEnabled(false)
            if collider_1:enter(collider_2.collision_class) and self.state ~= 'jumping' then
                self.sounds['hit']:play()
                if self.lost == 1 then
                    self.lives = self.lives - 1
                    self.m = 1
                    self.power = 'D'
                    self.x = map.tileW * 10
                    self.y = map.tileH * (map.mapH / 2 - 1) - self.h
                    for i = 1, 4 do
                        self.map.obs['o' .. i]:reset()
                        self.map.obs['o' .. i].y = -100
                        self.map.obs['o' .. i].d = 'down'
                        self.map.obs['o' .. i].rounds = 0
                    end
                else
                    self.lost = self.lost - 1
                    self.power = 'D'
                end
            end
        end
        if collider_1.collision_class == 'Player' and collider_2.collision_class == 'Gem' then
            contact:setEnabled(false)
            if collider_1:enter(collider_2.collision_class) and self.state ~= 'jumping' then
                self.sounds['gem']:play()
                if self.map.obs['o4'].currentFrame == RED then
                    self.power = 'C'
                    self.m = self.m + 0.25
                    self.lost = 2
                elseif self.map.obs['o4'].currentFrame == YELLOW then
                    self.power = 'E'
                    self.m = self.m + 0.25
                    self.lost = 2
                elseif self.map.obs['o4'].currentFrame == GREEN then
                    self.power = 'T'
                    self.m = self.m + 0.25
                    self.lost = 2
                elseif self.map.obs['o4'].currentFrame == BLUE then
                    self.power = 'B'
                    self.m = self.m + 0.25
                end
                self.state = 'transform'
            end
        end
    end)

    --[[self.border = false
    self.obstacle = false]]--

    self.animations = {

        ['idleD'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[10]
            },
            interval = 1
        }, 
        ['idleC'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1]
            },
            interval = 1
        }, 
        ['idleT'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[14]
            },
            interval = 1
        }, 
        ['idleB'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[22]
            },
            interval = 1
        }, 
        ['idleE'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[28]
            },
            interval = 1
        }, 
        ['walkingD'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[11]
            },
            interval = 1
        }, 
        ['walkingC'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[7]
            },
            interval = 1
        }, 
        ['walkingT'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[19]
            },
            interval = 1
        }, 
        ['walkingB'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[25]
            },
            interval = 1
        }, 
        ['walkingE'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[31]
            },
            interval = 1
        }, 
        ['backD'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[34]
            },
            interval = 1
        }, 
        ['backC'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[33]
            },
            interval = 1
        }, 
        ['backT'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[35]
            },
            interval = 1
        },
        ['backB'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[36]
            },
            interval = 1
        },  
        ['backE'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[37]
            },
            interval = 1
        }, 
        ['transformC'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1], self.frames[2], self.frames[3], self.frames[4], self.frames[5], self.frames[6]
            },
            interval = 0.15
        }, 
        ['transformT'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[14], self.frames[15], self.frames[16], self.frames[17], self.frames[18]
            },
            interval = 0.15
        }, 
        ['transformB'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[22], self.frames[23], self.frames[24]
            },
            interval = 0.15
        }, 
        ['transformE'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[28], self.frames[29], self.frames[29], self.frames[28]  
            },
            interval = 0.15
        } 
    }

    self.animation = self.animations['idleD']

    self.behaviors = {
        ['idle'] = function(dt)
            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['idle' .. self.power]
                self.sounds['jump']:play()
            elseif love.keyboard.isDown('down') then
                self.y = self.y + MOVE_SPEED * dt
                self.x = self.x - MOVE_SPEED * dt
                self.direction = 'right'
                self.animation = self.animations['idle' .. self.power]
                 
            elseif love.keyboard.isDown('left') then
                self.x = self.x - MOVE_SPEED * dt
                self.direction = 'left'
                self.animation = self.animations['walking' .. self.power]
                 
            elseif love.keyboard.isDown('right') then
                self.x = self.x + MOVE_SPEED * dt
                self.direction = 'right'
                self.animation = self.animations['walking' .. self.power]
                 
            elseif love.keyboard.isDown('up') then
                self.y = self.y - MOVE_SPEED * dt
                self.x = self.x + MOVE_SPEED * dt
                self.direction = 'right'
                self.animation = self.animations['back' .. self.power]
                 
            else
                self.animation = self.animations['back' .. self.power]
            end
        end,

        ['walking'] = function(dt)
            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.sounds['jump']:play()
            elseif love.keyboard.isDown('down') then
                self.y = self.y + MOVE_SPEED * dt
                self.x = self.x - MOVE_SPEED * dt
                self.direction = 'right'
                self.animation = self.animations['idle' .. self.power]
                 
            elseif love.keyboard.isDown('left') then
                self.x = self.x - MOVE_SPEED * dt
                self.direction = 'left'
                self.animation = self.animations['walking' .. self.power]
                 
            elseif love.keyboard.isDown('right') then
                self.x = self.x + MOVE_SPEED * dt
                self.direction = 'right'
                self.animation = self.animations['walking' .. self.power]
                 
            elseif love.keyboard.isDown('up') then
                self.y = self.y - MOVE_SPEED * dt
                self.x = self.x + MOVE_SPEED * dt
                self.direction = 'right'
                self.animation = self.animations['back' .. self.power]
                 
            elseif love.keyboard.isDown(self.power:lower()) then
                self.state = 'transform'
            else
                self.animation = self.animations['back' .. self.power]
            end
        end,
        
        ['jumping'] = function(dt)
            -- break if we go below the surface
            if self.y > 300 then
                return
            end

            -- apply map's gravity before y velocity
            self.dy = self.dy + GRAVITY

            -- check if there's a tile directly beneath us
            if self.dy >= JUMP_VELOCITY then
                --self.y = map.tileH * (map.mapH / 2 - 1) - self.h
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations['idle' .. self.power]
                self.y = (self.map:tileAt(self.x, self.y + self.h).y - 1) * self.map.tileH - self.h
            end
        end,

        ['transform'] = function(dt)
            for i = 1, 4 do
                self.map.obs['o' .. i].a = 'no'
            end
            self.state = 'transform'
            self.animation = self.animations['transform' .. self.power]
            if not self.transformed then
                self.sounds['transform']:play()
                self.score = self.score + 100
                self.transformed = true
            end
            if love.keyboard.wasPressed('space') or love.keyboard.isDown('down') or love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') then
                self.state = 'idle'
                self.animation = self.animations['idle' .. self.power]
                self.transformed = false
                for i = 1, 4 do
                    self.map.obs['o' .. i].a = 'yes'
                end
            end
        end,

        ['end'] = function(dt)
            characters = {
                'D', 'C', 'E', 'T', 'B'
            }
            for i = 1, 5 do
                if love.keyboard.isDown(characters[i]:lower()) then
                    self.animation = self.animations['idle'.. characters[i]]
                end
            end
            self.x = math.floor(VIRTUAL_WIDTH / 2) 
            self.y = math.floor(VIRTUAL_HEIGHT / 2) 
        end
    }
    
end

function Player:update(dt)
    self.behaviors[self.state] (dt)
    self.animation:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    if self.x <= 0 then self.x = 0 elseif self.x >= 420 then self.x = 420 end
    if self.y <= 0 then self.y = 0 elseif self.y >= 220 then self.y = 220 end
    if self.lives > 0 and self.state ~= 'transform' then 
        self.score = self.score + math.random(0.2, 0.25) * self.m 
    end
    self.pbox:update(dt)
end

function Player:reset()
    self.lives = 3
    self.score = 0
    self.m = 1
    self.power = 'D'
    self.state = 'idle'
    self.animation = self.animations['idleD']
end
function Player:render()
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end
    love.graphics.setFont(largeFont)
    if self.lives <= 0 then
        scaleX = scaleX * 3
        scaleY = 3
        if love.keyboard.isDown('down') then scaleY = scaleY * -1 end
        self.map.music:setVolume(1)
        for i = 1, 4 do
            self.map.obs['o' .. i].a = 'no'
        end
        self.behaviors['end'] (dt)
        self.state = 'end'
        love.graphics.printf("Score: " .. tostring(math.floor(self.score)), self.map.mapWP / 4, 0, math.floor(VIRTUAL_WIDTH / 2), 'center')
    else
        scaleY = 1
        love.graphics.printf("Lives: " .. tostring(self.lives), 0, 0, self.map.tileW * 30, 'left')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Score: " .. tostring(math.floor(self.score)), 0, 32, self.map.tileW * 30, 'left')
        love.graphics.printf("Multiplier: " .. tostring(math.floor(self.m)), 0, 52, self.map.tileW * 30, 'left')
        if self.score >= 3000 then love.graphics.printf("HACKERS STOPPED", 0, 72, self.map.tileW * 30, 'left') end
        --[[love.graphics.printf("X-Collide: " .. tostring(math.floor(self.fillerx)), 0, 72, self.map.tileW * 30, 'left')
        love.graphics.printf("Y-Collide: " .. tostring(math.floor(self.fillery)), 0, 92, self.map.tileW * 30, 'left')]]--
    end
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, scaleY, self.xOffset, self.yOffset)
end
