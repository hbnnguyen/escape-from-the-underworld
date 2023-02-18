local Object = require "libraries/classic"
local bump = require "libraries/bump"
local sti = require "libraries/sti"
local classic = require "libraries/classic"
local Player = require "player"
local Game = Object:extend()

function Game:new()
    
    self.world = bump.newWorld()
	self.map = sti("assets/maps/map1.lua", {"bump"})
    self.layer = self.map:addCustomLayer("Sprites", 7)



    self.player = Player(self)
    self.map:bump_init(self.world)
    

end

function Game:update(dt)
    self.map:update(dt)
end

function Game:draw()

    --self.map:draw()
    self.map:bump_draw()
	-- Translate world so that player is always centred
	local player = self.map.layers["Sprites"].player
	local tx = math.floor(player.x - love.graphics.getWidth()  / 2)
	local ty = math.floor(player.y - love.graphics.getHeight() / 2)

	-- Draw world with translation
	self.map:draw(-tx, -ty)
end

return Game