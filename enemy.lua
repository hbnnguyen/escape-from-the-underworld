local Object = require "libraries/classic"
local Enemy = Object:extend()

function Enemy:new()
    local enemySprite = love.graphics.newImage("assets/images/enemySprite.png")
end

function Enemy:update()
end

function Enemy:draw()
end

return Enemy