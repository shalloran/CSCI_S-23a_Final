--[[
    A simple state used to display a pause screen before transitioning
    the player back into the play state right where they left off.
]]

PauseState = Class{__includes = BaseState}

function PauseState:update(dt)
    gSounds['music']:pause()
    gSounds['pause']:setLooping(true)
    gSounds['pause']:play() --start the pause music

    -- if p is pressed again, go back to play state
    if love.keyboard.wasPressed('p') then
        gSounds['pause']:pause()
        gSounds['music']:setLooping(true)
        gSounds['music']:play()
        gStateMachine:change('play', {
            player = self.player,
            dungeon = self.dungeon,
            currentRoom = self.currentRoom
        })
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function PauseState:render()
    -- tell the player that the game is paused
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('||', 0, 100, VIRTUAL_WIDTH, 'center')

    -- love.graphics.setFont(flappyFont)
    love.graphics.printf('Pause!', 0, 50, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press p to play some more!', 0, 150, VIRTUAL_WIDTH, 'center')
end

function PauseState:enter(params)
    self.player = params.player
    self.dungeon = params.dungeon
    self.currentRoom = params.currentRoom
    self.player.stateMachine = params.player.stateMachine
end
