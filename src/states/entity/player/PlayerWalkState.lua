--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkState:update(dt)
    if self.entity.pickedPot == false then
        if love.keyboard.isDown('left') then
            self.entity.direction = 'left'
            self.entity:changeAnimation('walk-left')
        elseif love.keyboard.isDown('right') then
            self.entity.direction = 'right'
            self.entity:changeAnimation('walk-right')
        elseif love.keyboard.isDown('up') then
            self.entity.direction = 'up'
            self.entity:changeAnimation('walk-up')
        elseif love.keyboard.isDown('down') then
            self.entity.direction = 'down'
            self.entity:changeAnimation('walk-down')
        else
            self.entity:changeState('idle')
        end

        if love.keyboard.wasPressed('space') then
            self.entity:changeState('swing-sword')
        end
    elseif self.entity.pickedPot == true then
        -- he is now carrying the pot
        self.entity.carryPot = true
        -- add the pot object above his head???
        if love.keyboard.isDown('left') then
            self.entity.direction = 'left'
            self.entity:changeAnimation('walk-pot-left')
        elseif love.keyboard.isDown('right') then
            self.entity.direction = 'right'
            self.entity:changeAnimation('walk-pot-right')
        elseif love.keyboard.isDown('up') then
            self.entity.direction = 'up'
            self.entity:changeAnimation('walk-pot-up')
        elseif love.keyboard.isDown('down') then
            self.entity.direction = 'down'
            self.entity:changeAnimation('walk-pot-down')
        else
            self.entity:changeState('idle')
        end
        -- if the player presses space or enter (or return)
        if love.keyboard.wasPressed('space') or (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter')) then
            -- code for implementing use of projectile pot
            -- throw those flags back to false
            self.entity.carryPot = false
            self.entity.pickedPot = false
            -- tween the pot from player x 4 tiles up, down, left, or right
            local new_pot = GameObject(
                GAME_OBJECT_DEFS['pot'],
                self.entity.x, self.entity.y
            )

            table.insert(self.entity.objects, new_pot)

            -- make the pot move up from the ground
            if self.entity.direction == 'up' then
                Timer.tween(0.5, {[new_pot] = {y = self.entity.y - 48} } )
                self.entity.potJustThrown = true
            elseif self.entity.direction == 'down' then
                Timer.tween(0.5, {[new_pot] = {y = self.entity.y + 48} } )
                self.entity.potJustThrown = true
            elseif self.entity.direction == 'left' then
                Timer.tween(0.5, {[new_pot] = {x = self.entity.x - 48} } )
                self.entity.potJustThrown = true
            elseif self.entity.direction == 'right' then
                Timer.tween(0.5, {[new_pot] = {x = self.entity.x + 48} } )
                self.entity.potJustThrown = true
            end
            -- go back to idle
            self.entity:changeState('idle')
        end
    end
    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then

            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt

            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then

            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt

            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end

            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then

            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt

            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else

            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt

            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end
end
