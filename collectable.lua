local Object = require "libraries/classic"
local Collectables = Object:extend()

function Collectables:new(game)
    self.game = game
    self.game.collectLayer.treats = {}
    local treatSprite = love.graphics.newImage("assets/images/treat.png")
    local treat
    local treatTable = {}
    for k, object in pairs(self.game.map.objects) do
		if object.name == "treat" then
			treat = object
            table.insert(treatTable, treat)
		end
	end

    for i = 1, #treatTable do
        local treatObj = {
            sprite = treatSprite,
            x = treatTable[i].x,
            y = treatTable[i].y,
            width = 16,
            height = 16,
            isTreat = true
        }
        table.insert(self.game.collectLayer.treats, treatObj)
    end

    self.game.collectLayer.hearts = {}
    local heartSprite = love.graphics.newImage("assets/images/heart.png")
    local heart
    local heartTable = {}
    for k, object in pairs(self.game.map.objects) do
		if object.name == "heart" then
			heart = object
            table.insert(heartTable, heart)
		end
	end

    for i = 1, #heartTable do
        local heartObj = {
            sprite = heartSprite,
            x = heartTable[i].x,
            y = heartTable[i].y,
            width = 16,
            height = 16,
            isHeart = true
        }
        table.insert(self.game.collectLayer.hearts, heartObj)
    end
   
    self.game.map:removeLayer("collectables")

    for i = 1, #self.game.collectLayer.treats do
        self.game.world:add(
            self.game.collectLayer.treats[i],
            self.game.collectLayer.treats[i].x,
            self.game.collectLayer.treats[i].y,
            self.game.collectLayer.treats[i].width,
            self.game.collectLayer.treats[i].height
        )
    end 

    for i = 1, #self.game.collectLayer.hearts do
        self.game.world:add(
            self.game.collectLayer.hearts[i],
            self.game.collectLayer.hearts[i].x,
            self.game.collectLayer.hearts[i].y,
            self.game.collectLayer.hearts[i].width,
            self.game.collectLayer.hearts[i].height
        )
    end 
    
    self.game.collectLayer.draw = function(self)
        for i = 1, #self.treats do
            love.graphics.draw(
                self.treats[i].sprite,
                math.floor(self.treats[i].x),
                math.floor(self.treats[i].y),
                0,
                1,
                1,
                self.treats[i].ox,
                self.treats[i].oy
            )
            love.graphics.setPointSize(5)
            love.graphics.points(
                math.floor(self.treats[i].x), math.floor(self.treats[i].y)
            )
        end

        for i = 1, #self.hearts do
            love.graphics.draw(
                self.hearts[i].sprite,
                math.floor(self.hearts[i].x),
                math.floor(self.hearts[i].y),
                0,
                1,
                1,
                self.hearts[i].ox,
                self.hearts[i].oy
            )
            love.graphics.setPointSize(5)
            love.graphics.points(
                math.floor(self.hearts[i].x), math.floor(self.hearts[i].y)
            )
        end
        
    end
end

function Collectables:update(dt)

end

function Collectables:draw()

end



return Collectables