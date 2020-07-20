if(_G["WM"] == nil) then WM = (function(m,h) h(nil,(function() end), (function(e) _G[m] = e end)) end) end -- WLPM MM fallback

-- Warcraft 3 inputMovement module by ScorpioT1000 / 2020
-- Thanks to NazarPunk for common.j.lua
-- Converts pressed keys to Vector3
-- Fires "input.movement" event with the data.destination, data.rawVector params of type wGeometry.Vector3 and data.keyId
WM("inputMovement", function(import, export, exportDefault)
  local eventDispatcher = (_G["eventDispatcher"] == nil) and import("eventDispatcher") or eventDispatcher
  local wGeometry = (_G["wGeometry"] == nil) and import("wGeometry") or wGeometry
  local Vector3 = wGeometry.Vector3

  inputMovementInitTrigger = CreateTrigger()
  inputMovementTriggers = {}
  
  local DEFAULT_KEY_MAP = {
    FORWARD = OSKEY_W,
    BACKWARD = OSKEY_S,
    LEFT = OSKEY_A,
    RIGHT = OSKEY_D,
    UP = OSKEY_SPACE,
    DOWN = OSKEY_LCONTROL
  }
  
  local keyMap = {}
  local keyMapInverted = {}
  local keyToVectorMap = {
    FORWARD =   Vector3:new(0.,  1.,  0.),
    BACKWARD =  Vector3:new(0., -1.,  0.),
    LEFT =      Vector3:new(-1., 0.,  0.),
    RIGHT =     Vector3:new(1.,  0.,  0.),
    UP =        Vector3:new(0.,  0.,  1.),
    DOWN =      Vector3:new(0.,  0., -1.)
  }
  
  --- @var states table of tables of Vector3
  local states = {}
  
  local onUserKeyEvent = function()
    local pl = GetTriggerPlayer()
    local pressedKeyId = keyMapInverted[BlzGetTriggerPlayerKey()]
    if(pressedKeyId ~= nil) then
      local newKeyVector = BlzGetTriggerPlayerIsKeyDown() 
        and keyToVectorMap[pressedKeyId] 
        or Vector3:new()
      
      if(states[pl][pressedKeyId] == newKeyVector) then
        return -- avoid duplicate events
      end
      
      states[pl][pressedKeyId] = newKeyVector
      
      local destination = Vector3:new()
      for keyId, keyVector in pairs(states[pl]) do
        destination = destination + keyVector
      end
      if(not destination:isZero()) then
        destination = destination:normalize()
      end
      
      eventDispatcher.dispatch("input.movement", {
        player = pl,
        destination = destination,
        rawVector = newKeyVector,
        keyId = pressedKeyId
      })
    else
      print("inputMovement Error: onUserKeyEvent non-registered key event")
    end
  end
  
  -- Registers input for all active players when it's imported
  local registerForUserPlayers = function()
    ForForce(GetPlayersByMapControl(MAP_CONTROL_USER), function ()
      local id = #inputMovementTriggers + 1
      local trigger = CreateTrigger()
      local pl = GetEnumPlayer()
      for keyId,key in pairs(keyMap) do
        BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key, 0, true)
        BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key, 0, false)
        BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key, 1, true)
        BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key, 1, false)  
        BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key, 2, true)
        BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key, 2, false)  
      end
      TriggerAddAction(trigger, onUserKeyEvent)
      inputMovementTriggers[id] = trigger
      states[pl] = {
        FORWARD =   Vector3:new(),
        BACKWARD =  Vector3:new(),
        LEFT =      Vector3:new(),
        RIGHT =     Vector3:new(),
        UP =        Vector3:new(),
        DOWN =      Vector3:new()
      }
    end)
  end
  
  -- un-registers all events
  local unRegisterForUserPlayers = function()
    for i, trigger in ipairs(inputMovementTriggers) do
      DestroyTrigger(trigger)
    end
    inputMovementTriggers = {}
    states = {}
  end
  
  local inverseKeyMap = function(m)
     local s={}
     for k,v in pairs(m) do
       s[v]=k
     end
     return s
  end
  
  -- Defines a new key map and re-registers triggers for all user players
  --- @param newKeyMap table in format {
  ---  FORWARD = OSKEY_*,
  ---  BACKWARD = OSKEY_*,
  ---  LEFT = OSKEY_*,
  ---  RIGHT = OSKEY_*,
  ---  UP = OSKEY_*,
  ---  DOWN = OSKEY_*
  --- }
  --- @see https://github.com/nazarpunk/cheapack/blob/master/sdk/common.j.lua#L1287
  local changeKeyMap = function(newKeyMap)
    if(newKeyMap["FORWARD"] == nil
      or newKeyMap["BACKWARD"] == nil
      or newKeyMap["LEFT"] == nil
      or newKeyMap["RIGHT"] == nil
      or newKeyMap["UP"] == nil
      or newKeyMap["DOWN"] == nil) then
      print("inputMovement Error: changeKeyMap wrong input")
    end
    keyMap = newKeyMap
    keyMapInverted = inverseKeyMap(keyMap)
    
    unRegisterForUserPlayers()
    registerForUserPlayers()
  end
  
  TriggerRegisterTimerEventSingle(inputMovementInitTrigger, 0.)
  TriggerAddAction(inputMovementInitTrigger, function()
    changeKeyMap(DEFAULT_KEY_MAP)
  end)

  exportDefault({
    changeKeyMap = changeKeyMap,
    unRegisterForUserPlayers = unRegisterForUserPlayers,
    registerForUserPlayers = registerForUserPlayers
  })
end)