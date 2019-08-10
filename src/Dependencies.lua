--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Hitbox'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Doorway'
require 'src/world/Dungeon'
require 'src/world/Room'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerSwingSwordState'
require 'src/states/entity/player/PlayerWalkState'
require 'src/states/entity/player/PlayerPickupPotState'
require 'src/states/entity/player/PlayerWalkWithPotState'
require 'src/states/entity/player/PlayerIdleWithPotState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/PauseState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['character-walk'] = love.graphics.newImage('graphics/character_walk.png'),
    ['character-swing-sword'] = love.graphics.newImage('graphics/character_swing_sword.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['switches'] = love.graphics.newImage('graphics/switches.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['character-pickup-pot'] = love.graphics.newImage('graphics/character_pot_lift.png'),
    ['walk-pot'] = love.graphics.newImage('graphics/character_pot_walk3.png'),
    -- custom graphic I made from: https://0x72.itch.io/dungeontileset-ii
    ['coins'] = love.graphics.newImage('graphics/coins.png'),
    -- https://opengameart.org/content/monsterboy-in-wonder-world-mockup-assets,
    ['keys-coins'] = love.graphics.newImage('graphics/keys-coins.png'),
    -- stole the chest from sprite sheet + combined with coins above
    ['chests'] = love.graphics.newImage('graphics/chests.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 32),
    ['character-swing-sword'] = GenerateQuads(gTextures['character-swing-sword'], 32, 32),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['switches'] = GenerateQuads(gTextures['switches'], 16, 18),
    ['character-pickup-pot'] = GenerateQuads(gTextures['character-pickup-pot'], 16, 32),
    ['walk-pot'] = GenerateQuads(gTextures['walk-pot'], 16, 32),
    ['coins'] = GenerateQuads(gTextures['coins'], 8, 8),
    ['keys-coins'] = GenerateQuads(gTextures['keys-coins'], 16, 16),
    ['chests'] = GenerateQuads(gTextures['chests'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['zelda-teeny'] = love.graphics.newFont('fonts/zelda.otf', 16)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3'),
    ['sword'] = love.audio.newSource('sounds/sword.wav'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav'),
    ['door'] = love.audio.newSource('sounds/door.wav'),
    ['power-up'] = love.audio.newSource('sounds/powerup-reveal.wav'),
    -- https://freesound.org/people/B_Lamerichs/sounds/265229/
    ['pause'] = love.audio.newSource('sounds/pause.mp3')
}
