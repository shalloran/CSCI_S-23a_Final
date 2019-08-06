# CSCI_S-23a_Final

## GD50 / CSCI S-23a Final Project: Sean Halloran (github: shalloran)

### Initial outline, approved by James, 28 July 2019:

#### For my final project for CSCI S-23a I would like to implement a few things in Zelda, as follows:

1. Implement a score keeper perhaps near the top right of the screen.
2. Implement keys that are randomly dropped from killed enemies - but perhaps only those that you kill with the pots.
3. Implement a way to keep track of these keys perhaps near the middle top of the screen.
4. Implement chests that are unlocked with the correct colored keys.

====================================================================================================================

#### What actually happened:
0. I *really* wanted to implement a pause state! So I did that. see new PauseState.lua.
1. Implemented the score keeper in the upper right hand side of the screen. Then I reduced the zelda font to be small enough, because I really like it!
2. Implemented a 'coins' entity which moves fast.
3. Then I found this cool dungeon sprite sheet here: https://0x72.itch.io/dungeontileset-ii , so I decided to custom make gold, silver, and bronze keys and coins by slightly modifying what they had in GIMP.


#### Definite to-do's:
1. Make the coins entity 5X stronger than the average entity, but make it a little bit slower.
2. Adjust the speeds of the different entities so that it makes sense. Bats are faster than skeletons? Slime is the slowest?
3. Try to fix the idle sword state + idle sword use issues
4. Fix the coins entity to take a bunch more damage - figure out this health issue ENTITY_DEFS, etc.
5. Implement a way to keep track of gold, silver, and bronze keys at top of screen


Idea - get 3 keys + then a magical ladder appears in the middle of the next floor. It takes you to a sweet boss.
 - do I want to make a pot appear in every room?
 - the idea of adding more entities to each room as you progress! So start w/ 10 + increment by 1 every time you change rooms.
 - incorporate an easter egg w/ Games People Play by Alan Parsons...



debugging in `PlayerSwingSwordState`:

`
    -- debug for player and hurtbox collision rects VV

    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
        self.swordHurtbox.width, self.swordHurtbox.height)
    love.graphics.setColor(255, 255, 255, 255)
`
