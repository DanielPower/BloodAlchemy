local class = require('libraries/middleclass')

local Card = require('class/card')


local Fireball = class('Fireball', Card)
Fireball.image = love.graphics.newImage('resources/cards/fireball.png')

return Fireball
