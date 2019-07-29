--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPickupPotState = Class{__includes = BaseState}

function PlayerPickupPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    self.objects = {}
    -- we don't need a hitbox, b/c we can't use sword in this state

    -- edit this to be pot pickup based on self.player.direction
    self.player:changeAnimation('pickup-' .. self.player.direction)

    local new_pot = GameObject(
        GAME_OBJECT_DEFS['pot'],
        self.player.x, self.player.y
    )
    table.insert(self.objects, new_pot)
    -- make the pot move up from the ground
    Timer.tween(1, {[new_pot] = {y = self.player.y - 8} } )
end

function PlayerPickupPotState:update(dt)
    for k, object in pairs(self.objects) do
        object:update(dt)
    end

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player.pickedPot = true
        self.player:changeState('idle')
    end
end

function PlayerPickupPotState:render(adjacentOffsetX, adjacentOffsetY)
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    for k, object in pairs(self.objects) do
        object:render(0, 0)
    end
end
