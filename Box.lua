Box = Class{}

function Box:init(follow, xOffset, yOffset, class)
    self.follow = follow
    self.w = self.follow.w
    self.h = self.follow.h
    self.xOffset = xOffset
    self.yOffset = yOffset
    self.box = world:newRectangleCollider(self.follow.x + self.xOffset, self.follow.y + self.yOffset, self.w, self.h)
    self.box:setCollisionClass(class)
    self.box:setObject(self)
end
function Box:update(dt)
   --[[self.box:destroy()
   self.box = world:newRectangleCollider(math.floor(self.follow.x + self.xOffset), math.floor(self.follow.y + self.yOffset), self.w, self.h)--]]
   self.box:setPosition(math.floor(self.follow.x + self.xOffset), math.floor(self.follow.y + self.yOffset))
end
