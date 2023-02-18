local Object = require "libraries/classic"
local Player = Object:extend()

function Player:new(Game)
    self.game = Game
    gravity = 0
    jumpVelocity = 0
    yVelocity = 0
    local player
	for k, object in pairs(self.game.map.objects) do
		if object.name == "Player" then
			player = object
			break
		end
	end

    local sprite = love.graphics.newImage("assets/images/sprite.png")
	self.game.layer.player = {
		sprite = sprite,
		x      = player.x,
		y      = player.y
	}
    local playerHitBox = {name="playerHitBox"}
    self.game.world:add(playerHitBox, self.game.layer.player.x, self.game.layer.player.y, 48, 96)

    self.game.layer.update = function(self, dt)
        speed = 200  * dt
		-- 96 pixels per second
        yVelocity = yVelocity + gravity * dt 
        self.player.y = self.player.y + yVelocity
        local actualX, actualY, cols, len = Game.world:move(playerHitBox, self.player.x, self.player.y)
        if len > 0 then
            self.player.x = actualX
            self.player.y = actualY
            yVelocity = 0
        end

		if love.keyboard.isDown("up") then
            -- yVelocity = -jumpVelocity
			self.player.y = self.player.y - speed
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

		-- Temporarily draw a point at our location so we know
		-- that our sprite is offset properly
		love.graphics.setPointSize(5)
		love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
	end

	-- Remove unneeded object layer
	self.game.map:removeLayer("Spawn Point")

    for i = 1, #self.game.map:getLayerProperties(layer) do
        print(self.game.map:getLayerProperties(layer)[1])
    end

end

function Player:update(dt)

end

function Player:draw()

end

return Player