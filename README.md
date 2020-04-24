Lua inputMovement 

## Installation

### Manual
- Install https://github.com/Indaxia/lua-eventDispatcher
- Install https://github.com/Indaxia/lua-wGeometry
- Copy code from /src and use inputMovement global

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
    -- Vector3 destination normal
    event.data.destination
    
    -- Vector3 current pressed/unpressed key normal (e.g. for jump)
    event.data.rawVector
    
    -- string key id
    event.data.keyId
end)
```

