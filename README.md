Lua inputMovement 

The library turns keys W, A, S, D, Ctrl, Space into a [normalized Vector3](https://en.wikipedia.org/wiki/Unit_vector), which can be immediately applied to the unit.

- Normalization secure management of all of these strifes and bunnyhopping uniformly directing a unit to any of the combinations of directions.
- For convenience, it uses eventDispatcher, so you can connect to it literally in the GUI.
- Itself registers on all players-people.
- You can set your own set of keys.

## Installation

### Manual
- Install https://github.com/Indaxia/lua-eventDispatcher
- Install https://github.com/Indaxia/lua-wGeometry
- Copy code from /src and use eventDispatcher and inputMovement global

### *OR* use [WLPM](https://github.com/Indaxia/wc3-wlpm-module-manager)
```
wlpm install https://github.com/Indaxia/lua-inputMovement
```

## Demo

https://www.youtube.com/watch?v=d4r4qZIZg_0

## Usage

see /test

```
eventDispatcher.on("input.movement", function(event)
    -- Player pressed the key
    event.data.player

    -- Vector3 destination normal
    event.data.destination
    
    -- Vector3 current pressed/unpressed key normal (e.g. for jump)
    event.data.rawVector
    
    -- string key id
    event.data.keyId
end)
```

## Custom key map

Call this on initialization 

```
inputMovement.changeKeyMap({
    FORWARD = OSKEY_W,
    BACKWARD = OSKEY_S,
    LEFT = OSKEY_A,
    RIGHT = OSKEY_D,
    UP = OSKEY_SPACE,
    DOWN = OSKEY_LCONTROL
})
```

[See on XGM/Russian](https://xgm.guru/p/wc3/lua-inputmovement)
