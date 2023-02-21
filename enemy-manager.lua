local Object = require "libraries/classic"
local Enemy = require "enemy"

local EnemyManager = Object:extend()

function EnemyManager:new(game)
    
    self.game = game
    local enemySprite = love.graphics.newImage("assets/images/enemySprite.png")
    local enemy
    local enetable = {}
    self.game.enemyLayer.enemies = {}
	for k, object in pairs(self.game.map.objects) do
		if object.name == "Enemy" then
			enemy = object
			table.insert(enetable, enemy)
		end
	end
    local sprite = love.graphics.newImage("assets/images/enemySprite.png")
    for i = 1, #enetable do
        local enemyv = {
            sprite = sprite,
            x      = enetable[i].x,
            y      = enetable[i].y,
            width = 48,
            height = 96,
            speed = 100,
            isEnemy = true
        }
        table.insert(self.game.enemyLayer.enemies, enemyv)
    end

    self.game.enemyLayer.draw = function(self)
       
        for i = 1, #self.enemies do
            love.graphics.draw(
                self.enemies[i].sprite,
                math.floor(self.enemies[i].x),
                math.floor(self.enemies[i].y),
                0,
                1,
                1,
                self.enemies[i].ox,
                self.enemies[i].oy
            )
            love.graphics.setPointSize(5)
		    love.graphics.points(
                math.floor(self.enemies[i].x), math.floor(self.enemies[i].y)
            )
        end
	end
    self.game.map:removeLayer("enemies")

    for i = 1, #self.game.enemyLayer.enemies do
        self.game.world:add(
            self.game.enemyLayer.enemies[i],
            self.game.enemyLayer.enemies[i].x,
            self.game.enemyLayer.enemies[i].y,
            self.game.enemyLayer.enemies[i].width,
            self.game.enemyLayer.enemies[i].height
        )
    end 
    
    self.game.enemyLayer.update = function(self, dt)
        
        
        for i = 1, #self.enemies do
            local goalX = self.enemies[i].x 
            local goalY = self.enemies[i].y

            goalX, goalY = goalX + self.enemies[i].speed * dt, goalY

            local enemyFilter = function(item, other)
                if other.isEnemy  then 
                    return nil
                elseif other.isWall then
                    return "touch"
                end
            end

            local actualX, actualY, cols, len = game.world:move(self.enemies[i], goalX, goalY, enemyFilter)
     

            self.enemies[i].x = actualX
            self.enemies[i].y = actualY
            local items, len = game.world:queryPoint(self.enemies[i].x + self.enemies[i].width/2, self.enemies[i].y + self.enemies[i].height + 1)
            if #items == 0 then
                self.enemies[i].speed = self.enemies[i].speed * - 1
            end
    
        end
    
    end
end

function EnemyManager:update()
end

function EnemyManager:draw()
end

function EnemyManager:spawnEnemy()
end

return EnemyManager

-- enemylayer = {
--     x = 0,
--     y = 0,
--     enemies= {
--         {
--             sprite = sprite,
--             x      = enetable[i].x,
--             y      = enetable[i].y
--         },
--         {
--             sprite = sprite,
--             x      = enetable[i].x,
--             y      = enetable[i].y
--         },
--         {
--             sprite = sprite,
--             x      = enetable[i].x,
--             y      = enetable[i].y
--         }
--     }
-- }