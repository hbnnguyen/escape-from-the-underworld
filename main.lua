local bump = require "libraries/bump"
local sti = require "libraries/sti"
local classic = require "libraries/classic"

local Game = require "game"

function love.load()
    game = Game()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end