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
0. I **really** wanted to implement a pause state! So I did that. see new PauseState.lua.
1. Implemented the score keeper in the upper right hand side of the screen. I created a **teeny** zelda font to be small enough, because I really like it!
2. Implemented a 'coins' entity which moves fast, but otherwise serves no real purpose.
3. Changed the speeds of other entities so that it added variety + **sort of** made sense? (entity_defs.lua)
4. Then I found this cool dungeon sprite sheet here: https://0x72.itch.io/dungeontileset-ii, so I decided to make custom gold, silver, and bronze keys and coins by slightly modifying what they had in GIMP. (Show keys-coins.png)
5. Created key placeholders for bronze, silver, and gold keys that randomly spawn from entites that are killed with the pots. (PlayState.lua line 121)
6. Set it up such that every 3rd enemy you kill with a "pot", a key is dropped, first bronze, then silver, then gold. As you pickup the keys, the heads up display created in PlayState.lua (above) shows you your keys. (Show game_objects.lua 'keys' + Room.lua line 275)
7. As you pick up the keys, chests will also randomly appear and are unlocked if you are holding the correct key!

James, Colton, Heidi (and David) thanks so much for a great semester, I learned a lot!!

<!-- Walkthrough: -->
<!-- 1. Start game play, show how pause works. Pause/ unpause -->
<!-- 2. Show the score keeper - top right hand corner -->
<!-- 3. Point out speeds of different entities, and if coins shows up - discuss how pointless that is. -->
<!-- 4. Point out key placeholders + start killing enemies with the pot to grab the keys (note that I made keys drop every enemy, rather than every third enemy - change this back on line 277) -->
<!-- 5. Point out chest generation -->

<!-- #### Other ideas: -->
<!-- - get 3 keys + then a magical ladder appears in the middle of the next floor. It takes you to a sweet boss. -->
<!-- - do I want to make a pot appear in every room? -->
<!-- - the idea of adding more entities to each room as you progress! So start w/ 10 + increment by 1 every time you change rooms. -->
<!-- - incorporate an easter egg w/ Games People Play by Alan Parsons... -->
