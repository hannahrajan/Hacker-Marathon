Obstacle = Class{}

SPEED = math.random(1.4, 1.5)

function Obstacle:init(params)
    self.map = params.map
    self.name = params.name
    if self.name == 'obstacle' then self.x = math.random(self.map.tileW * 30, self.map.tileW * 45) else self.x = math.random(self.map.tileW * 30, self.map.tileW * 48) end
    if self.name == 'obstacle' then self.y = -50 else self.y = -20 end
    self.rounds = 0
    self.d = 'down'
    self.a = 'yes'
    self.texture = params.texture
    self.frames = generateQuads(self.texture, 8, 8)
    self.f = params.f
    self.currentFrame = math.random(#params.f)
    self.obj = self.frames[params.f[self.currentFrame]] --frames for gem or obstacle
    if self.name == 'gem' then 
        self.w = 16
        self.h = 16
        self.collider = Box(self, self.w / 2, self.h / 2, 'Gem')
    else
        self.w = 22
        self.h = 32
        self.collider = Box(self, self.w / 2 + 9, self.h / 2 + 4, 'Obstacle')
    end
    self.collider.box:setPreSolve(function(collider_1, collider_2, contact)
        if collider_1.collision_class == 'Obstacle' and collider_2.collision_class == 'Border' then
            contact:setEnabled(false)
        end
        if collider_1.collision_class == 'Obstacle' and collider_2.collision_class == 'Obstacle' then
            contact:setEnabled(false)
        end
        if collider_1.collision_class == 'Gem' and collider_2.collision_class == 'Obstacle' then
            contact:setEnabled(false)
        end
    end)
    
end

function Obstacle:update(dt)
    if self.y <= -100 then self.d = 'down' elseif self.y >= 400 then self.d = 'up' end 
    if self.y <= -100 or self.y >= 400 then
        if self.rounds < 8 then self.rounds = self.rounds + 0.5 end
        self:reset() 
    end
    local speed = math.random(1.4, 2.5) + self.rounds
    local num = 0
    if self.d == 'up' and self.a == 'yes' then 
        self.x = (self.x + speed) 
        self.y = (self.y - speed)
    elseif self.d == 'down' and self.a == 'yes' then
        self.x = (self.x - speed)
        self.y = (self.y + speed)
    end
    self.collider:update(dt)
end

function Obstacle:reset()
    if self.d == 'up' then self.x = math.random(self.map.tileW - 190, self.map.tileW - 45) else self.x = math.random(self.map.tileW * 40, self.map.tileW * 60) end 
    self.currentFrame = math.random(#self.f)
    self.obj = self.frames[self.f[self.currentFrame]] --frames for gem or obstacle
end

function Obstacle:render()
    if self.name == 'obstacle' then
        scale = 5
    else
        scale = 2
    end
    if self.a == 'yes' then
        love.graphics.draw(self.texture, self.obj, math.floor(self.x), math.floor(self.y), 0, scale, scale)
    end
end