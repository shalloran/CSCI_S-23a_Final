--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,

        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,

        width = 16,
        height = 22,

        -- one heart == 2 health
        health = 6,

        -- rendering and collision offset for spaced sprites
        offsetY = 5
    }

    self.dungeon = Dungeon(self.player)
    self.currentRoom = Room(self.player)

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['swing-sword'] = function() return PlayerSwingSwordState(self.player, self.dungeon) end,
        ['pickup-pot'] = function() return PlayerPickupPotState(self.player, self.dungeon) end,
        ['walk-with-pot'] = function() return PlayerWalkWithPotState(self.player, self.dungeon) end
    }
    self.player:changeState('idle')
end

function PlayState:enter(params)
    self.player = params.player or Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,

        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,

        width = 16,
        height = 22,

        -- one heart == 2 health
        health = 6,

        -- rendering and collision offset for spaced sprites
        offsetY = 5
    }
    self.dungeon = params.dungeon or Dungeon(self.player)
    self.currentRoom = params.currentRoom or Room(self.player)
    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['swing-sword'] = function() return PlayerSwingSwordState(self.player, self.dungeon) end,
        ['pickup-pot'] = function() return PlayerPickupPotState(self.player, self.dungeon) end,
        ['walk-with-pot'] = function() return PlayerWalkWithPotState(self.player, self.dungeon) end
    }
    self.player:changeState('idle')
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('p') then
        -- change to the pause state, passing self.player, self.currentRoom, self.dungeon
        gStateMachine:change('pause', {
            player = self.player,
            dungeon = self.dungeon,
            currentRoom = self.currentRoom
        })
    end

    self.dungeon:update(dt)
end

function PlayState:render()
    -- render dungeon and all entities separate from hearts GUI
    love.graphics.push()
    self.dungeon:render()
    love.graphics.pop()

    -- draw player hearts, top of screen
    local healthLeft = self.player.health
    local heartFrame = 1

    for i = 1, 3 do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
            (i - 1) * (TILE_SIZE + 1), 2)

        healthLeft = healthLeft - 2
    end

    -- render the player's score at the top middle of the screen
    love.graphics.setFont(gFonts['zelda-teeny'])
    love.graphics.printf('Score ' .. self.player.score, 0, 0, VIRTUAL_WIDTH, 'right')

    -- render the keys heads up display
    local keysInHand = self.player.keysCollected
    local keyFrame = 7
    -- self.player.keys = {}
    love.graphics.printf('Keys ', -15, 0, VIRTUAL_WIDTH, 'center')
    -- love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
    -- some type of logic here for the empty keys HUD
    for i = 1, 3 do

        if i == 1 and self.player.goldKey == true then
            keyFrame = 1
        elseif i == 1 and self.player.goldKey == false then
            keyFrame = 7
        elseif i == 2 and self.player.silverKey == true then
            keyFrame = 2
        elseif i == 2 and self.player.silverKey == false then
            keyFrame = 7
        elseif i == 3 and self.player.bronzeKey == true then
            keyFrame = 3
        elseif i == 3 and self.player.bronzeKey == false then
            keyFrame = 7
        end

        love.graphics.draw(gTextures['keys-coins'], gFrames['keys-coins'][keyFrame],
            (VIRTUAL_WIDTH/2) + (10 + (i - 1) * (TILE_SIZE + 1)), 1)
        -- handle the first and second keys
        keysInHand = keysInHand - 1
    end
end
