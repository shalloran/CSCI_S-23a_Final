--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Room = Class{}

function Room:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()

    -- entities in the room
    self.entities = {}
    self:generateEntities()

    -- game objects in the room
    self.objects = {}
    self:generateObjects()

    -- doorways that lead to other dungeon rooms
    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))
    table.insert(self.doorways, Doorway('bottom', false, self))
    table.insert(self.doorways, Doorway('left', false, self))
    table.insert(self.doorways, Doorway('right', false, self))

    -- reference to player for collisions, etc.
    self.player = player

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, 10 do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),

            width = 16,
            height = 16,

            health = 1
        })
    end
    -- 1 in every 3 rooms will contain a coin
    if math.random(3) == 1 then
        table.insert(self.entities, Entity {
          animations = ENTITY_DEFS['coins'].animations,
          walkSpeed = ENTITY_DEFS['coins'].walkSpeed or 20,
          -- ensure X and Y are within bounds of the map
          x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
              VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
          y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
              VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
          width = 16,
          height = 16,
          health = ENTITY_DEFS['coins'].health or 10
        })
    end

    for i = 1, #self.entities do
        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    local switch = GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    )

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'

            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end

            gSounds['door']:play()
        end
    end
    -- add to list of objects in scene (only one switch for now)
    table.insert(self.objects, switch)

    -- instantiate a pot randomly in the level
    local pot = GameObject(
        GAME_OBJECT_DEFS['pot'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    )
    -- add the onCollide fn here!!
    pot.onCollide = function(target)

        -- assume we didn't hit a wall
        self.bumped = false

        -- code stolen from boundary checking for walls
        -- allowing us to avoid collision detection on pots
        if self.player.direction == 'left' then
            self.player.x = self.player.x - self.player.walkSpeed

            if self.player.x <= target.x then
                self.player.x = target.x + TILE_SIZE
                self.bumped = true
            end
        elseif self.player.direction == 'right' then
            self.player.x = self.player.x + self.player.walkSpeed

            if self.player.x + self.player.width >= target.x - TILE_SIZE then
                self.player.x = target.x - self.player.width
                self.bumped = true
            end
        elseif self.player.direction == 'up' then
            self.player.y = self.player.y - self.player.walkSpeed

            if self.player.y <= target.y + TILE_SIZE then
                self.player.y = target.y
                self.bumped = true
            end
        elseif self.player.direction == 'down' then
            self.player.y = self.player.y + self.player.walkSpeed

            if self.player.y + self.player.height >= target.y - TILE_SIZE then
                self.player.y = target.y - self.player.height
                self.bumped = true
            end
        end
        if self.bumped == true then
            -- gSounds['power-up']:play()
        end
        if self.bumped == true and (love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')) then
            self.player:changeState('pickup-pot')
            table.remove(self.objects, 2)
        end
    end
    -- add to list of objects in scene
    table.insert(self.objects, pot)
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER

            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end

            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:update(dt)

    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0 + potentially spawn heart
        if entity.health <= 0 then
            entity.dead = true
            -- create a dead timer? or some kind of entity counter?
            -- here is where we can insert hearts
            if entity.dead == true and entity.hearts_num == 0 and math.random(10) == entity.random_num and
            math.random(10) == entity.random_num and #self.objects < 3 and self.player.health <= 4 then
                --spawn a heart
                entity.hearts_num = entity.hearts_num + 1
                Timer.after(0.25, function ()
                local heart = GameObject(
                    GAME_OBJECT_DEFS['heart'],
                    entity.x, entity.y
                )
                table.insert(self.objects, heart)
                end)
            end
        elseif not entity.dead then
            entity:processAI({room = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the room
        if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
            -- add something here if entity.ENTITY_DEFS == 'coins' then give the player a bunch of points and add it
            -- to the thing
            gSounds['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                gStateMachine:change('game-over')
            end
        end
        if self.player.objects[1] and not entity.dead and entity:collides(self.player.objects[1]) then
            gSounds['hit-player']:play()
            entity:damage(1)

            if entity.health == 0 then
                entity.dead = true
                table.remove(self.player.objects, 1)
                self.player.score = self.player.score + 100
            end
        end
    end

    if self.player.objects[1] then
        -- if pot travels more than 4 tiles away from the player
        if self.player.objects[1].x <= self.player.x + (4 * TILE_SIZE) or self.player.objects[1].x >= self.player.x - (4 * TILE_SIZE) then
            Timer.after(1, function () table.remove(self.player.objects, 1) end)
        elseif self.player.objects[1].y <= self.player.y + (4 * TILE_SIZE) or self.player.objects[1].y >= self.player.y - (4 * TILE_SIZE) then
            Timer.after(1, function () table.remove(self.player.objects, 1) end)
        else
            -- assume we didn't hit a wall
            local wall_bump = false

            -- wall collision detection
            if self.player.direction == 'left' then

                if self.player.objects[1].x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
                    -- self.player.objects[1].x = MAP_RENDER_OFFSET_X + TILE_SIZE
                    wall_bump = true
                end
            elseif self.player.direction == 'right' then

                if self.player.objects[1].x + 16 >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
                    self.player.objects[1].x = VIRTUAL_WIDTH - TILE_SIZE * 2 - 16
                    wall_bump = true
                end
            elseif self.player.direction == 'up' then

                if self.player.objects[1].y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - 8 then
                    -- self.player.objects[1].y = MAP_RENDER_OFFSET_Y + TILE_SIZE - 8
                    wall_bump = true
                end
            elseif self.player.direction == 'down' then

                local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE)
                    + MAP_RENDER_OFFSET_Y - TILE_SIZE

                if self.player.objects[1].y + 16 >= bottomEdge then
                    -- self.player.objects[1].y = bottomEdge - 16
                    wall_bump = true
                end
            end

            if wall_bump == true then
                Timer.after(0.5, function () table.remove(self.player.objects, 1) end)
            end
        end

    end

    for k, object in pairs(self.objects) do
        object:update(dt)

        -- trigger collision callback on object
        if self.player:collides(object) then
            if object.state == 'ground' then
                -- do pot stuff
                object:onCollide(object)
            elseif object.consumable then
                -- adjust such that health can't go above 6
                if self.player.health <= 6 then
                    self.player.health = math.min(6, self.player.health + 2)
                    for i = #self.objects, 3, -1 do
                        self.player.score = self.player.score + 100
                        table.remove(self.objects, i)
                        gSounds['power-up']:play()
                    end
                else
                    for i = #self.objects, 3, -1 do
                        table.remove(self.objects, i)
                    end
                end
            else
                if object.state == 'unpressed' then
                    object.state = 'pressed'
                       -- open every door in the room if we press the switch
                    for k, doorway in pairs(self.doorways) do
                           doorway.open = true
                    end
                    gSounds['door']:play()
                end
            end
        end
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX,
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.player.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()

        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)

        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE),
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)

        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)

    if self.player then
        self.player:render()
    end

    love.graphics.setStencilTest()
end
