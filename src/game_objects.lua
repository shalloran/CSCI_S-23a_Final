--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        collidable = true,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'tiles',
        texture = 'tiles',
        frame = 16,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'ground',
        collidable = true,
        consumable = false,
        states = {
            ['ground'] = {
                texture = 'tiles'
              },
            ['picked-up'] = {
                texture = nil
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'initiate',
        collidable = false,
        consumable = true,
        states = {
            ['initiate'] = {
                texture = 'hearts'
              },
            ['used-up'] = {
                texture = nil
            }
        }
    },
    ['keys'] = {
        type = 'keys',
        texture = 'keys-coins',
        frame = 3,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'bronze',
        collidable = false,
        consumable = true,
        states = {
            ['bronze'] = {
                frame = 3
            },
            ['silver'] = {
                frame = 2
            },
            ['gold'] = {
                frame = 1
            }
        }
    },
    ['chest'] = {
        type = 'chest',
        texture = 'chests',
        frame = 1,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'bronze',
        collidable = false,
        consumable = true,
        states = {
            ['bronze'] = {
                frame = 1
            },
            ['silver'] = {
                frame = 2
            },
            ['gold'] = {
                frame = 3
            }
        }
    }
}
