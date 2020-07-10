Lua inputMovement 

The library turns **W, A, S, D, Ctrl, Space** keys into a [unit Vector3](https://en.wikipedia.org/wiki/Unit_vector), which can be immediately applied to the unit.

- Normalization secures of all of these strifes and bunnyhopping uniformly directing a unit to any of combined directions.
- For convenience, it uses **eventDispatcher**, so you can connect to it literally using GUI.
- automatically registers on all human players.
- You can set your own key set

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

https://xgm.guru/files/100/245047/0.png

https://xgm.guru/files/100/245047/1.png

the map is included at [/test](/test)

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

Call this on 0.01 game timer expiration

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
