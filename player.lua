local Object = require "libraries/classic"
local Player = Object:extend()

function Player:new(Game)
    self.game = Game
    gravity = 200
    jumpVelocity = 10
    yVelocity = 0
    local player
	for k, object in pairs(self.game.map.objects) do
		if object.name == "Player" then
			player = object
			break
		end
	end

    local sprite = love.graphics.newImage("assets/images/sprite.png")
    local vine = love.graphics.newImage("assets/images/vine.png")
	self.game.layer.player = {
		sprite = sprite,
		x      = player.x,
		y      = player.y,
        width = 48,
        height = 96,
        health = 5,
        touchedEne = false,
        touchTimer = 1000
	}

    self.game.layer.vine = {
        sprite = vine,
        x = self.game.layer.player.x,
        y = self.game.layer.player.y + self.game.layer.player.height/2,
        width = 96,
        height = 16
    }    


    self.game.world:add(
        self.game.layer.player,
        self.game.layer.player.x,
        self.game.layer.player.y,
        self.game.layer.player.width,
        self.game.layer.player.height
    )
   
    self.game.layer.update = function(self, dt)
        speed = 200  * dt

        yVelocity = yVelocity + gravity * dt 

        self.player.y = self.player.y + yVelocity
        self.goalX = self.player.x
        self.goalY = self.player.y
		-- 96 pixels per second
     

        self.player.touchTimer = self.player.touchTimer - 1
        if self.player.touchTimer <= 0 then 
            self.player.touchedEne = false
            self.player.touchTimer = 1000
        end

        local actualX, actualY, cols, len = Game.world:move(self.player, self.goalX, self.goalY, enemyFilter)

        for i=1,len do
            local other = cols[i].other
            if other.isEnemy and self.player.touchedEne == false then
                self.player.health = self.player.health - 1
                self.player.x = self.player.x + 50
                self.player.touchedEne = true
            end
        end
        self.player.x = actualX
        self.player.y = actualY
        yVelocity = 0
       
		if love.keyboard.isDown("up") then
            yVelocity = -jumpVelocity 
			-- self.player.y = self.player.y - speed
		end
		-- Move player down
		if love.keyboard.isDown("down") then
			self.player.y = self.player.y + speed
		end

		-- Move player left
		if love.keyboard.isDown("left") then
			self.player.x = self.player.x - speed
		end

		-- Move player right
		if love.keyboard.isDown("right") then
			self.player.x = self.player.x + speed
		end

        self.vine.x = actualX - self.player.width * 2
        self.vine.y = actualY + self.player.height/2

 
    

	end

    if love.keyboard.isDown("v") then
        self.game.world:add(
            self.game.layer.vine,
            self.game.layer.vine.x,
            self.game.layer.vine.y,
            self.game.layer.vine.width,
            self.game.layer.vine.height
        )
    end

	-- Draw player
	self.game.layer.draw = function(self)
		love.graphics.draw(
			self.player.sprite,
			math.floor(self.player.x),
			math.floor(self.player.y),
			0,
			1,
			1,
			self.player.ox,
			self.player.oy
		)

        if love.keyboard.isDown("v") then
            love.graphics.draw(
			self.vine.sprite,
			math.floor(self.vine.x),
			math.floor(self.vine.y),
			0,
			1,
			1,
			self.vine.ox,
			self.vine.oy
		    )
        end
		-- Temporarily draw a point at our location so we know
		-- that our sprite is offset properly
		love.graphics.setPointSize(5)
		love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
        
	end

	-- Remove unneeded object layer
	self.game.map:removeLayer("Spawn Point")
end

function Player:update(dt)
    if love.keyboard.isDown("v") then
        local items, len = self.game.world:queryRect(
            self.game.layer.vine.x,
            self.game.layer.vine.y,
            self.game.layer.vine.width,
            self.game.layer.vine.height,
            vineFilter
        )
  
        for i=1,#items do
            if items[i].isEnemy then
                print("oo")
            end
        end
    end  

end

function Player:draw()
    love.graphics.printf(self.game.layer.player.health,0,0,1000,center)
end

local enemyFilter = function(item, other)
    if other.isEnemy then 
        return "bounce"
    end
end

local vineFilter = function(item, other)
    if other.isEnemy then
        return "slide"
    end
end


return Player