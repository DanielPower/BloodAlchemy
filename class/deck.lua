local class = require('libraries/middleclass')
local Deck = class('Deck')

function Deck:initialize(...)
    args = {...}
    self.cards = {}

    for i=1, #args do
        self:insert(args[i])
    end
end

function Deck:insert(card, position)
    local position = (#self.cards+1) - (position or 0)
    table.insert(self.cards, position, card)
end

function Deck:shuffle()
    math.randomseed(os.time())
    local random = math.random
    local originalCards = self.cards
    local shuffledCards = {}

    for i=#self.cards, 1, -1 do
        number = random(i)
        table.insert(shuffledCards, originalCards[number])
        table.remove(originalCards, number)
    end

    self.cards = shuffledCards
end

function Deck:pull(position)
    local position = (#self.cards) - (position or 0)
    local card = self.cards[position]
    table.remove(self.cards, position)

    return(card)
end

function Deck:print()
    print(unpack(self.cards))
end

return(Deck)
