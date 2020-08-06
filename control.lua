script.on_init(function()
  if global["transformers"] == nil then
    global["transformers"] = {}
  end
end)

script.on_load(function()
  if global["transformers"] == nil then
    global["transformers"] = {}
  end
end)


script.on_event(defines.events.on_robot_built_entity, function(event) OnBuilt(event.created_entity) end)
script.on_event(defines.events.on_built_entity, function(event) OnBuilt(event.created_entity) end)

script.on_event(defines.events.on_pre_player_mined_item, function(event) OnRemoved(event.entity) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) OnRemoved(event.entity) end)
script.on_event(defines.events.on_entity_died, function(event) OnRemoved(event.entity) end)

local function transformerIstransformer(entity)
  if (string.sub(entity.name, 1, 21) == "yoyobuae-transformer-") then
    return true
  else
    return false
  end
end

local function transformerLimit(entity)
  return string.sub(string.sub(entity.name, 22), 1, -2)
end

local function transformerGetDrainPosition(direction)
  if direction == defines.direction.north then return {x = 0, y = -0.5}   -- north
  elseif direction == defines.direction.east then return {x = 0.5, y = 0}  -- east
  elseif direction == defines.direction.south then return {x = 0, y = 0.5}  -- south
  elseif direction == defines.direction.west then return {x = -0.5, y = 0}   -- west
  else return {x = 0, y = -0.5}   -- default to north
  end
end

local function transformerGetSourcePosition(direction)
  if direction == defines.direction.north then return {x = 0, y = 0.5}   -- north
  elseif direction == defines.direction.east then return {x = -0.5, y = 0}  -- east
  elseif direction == defines.direction.south then return {x = 0, y = -0.5}  -- south
  elseif direction == defines.direction.west then return {x = 0.5, y = 0}   -- west
  else return {x = 0, y = 0.5}   -- default to north
  end
end

local function transformerGetSourceDrainType(direction)
  if direction == defines.direction.north then return "north-south"   -- north
  elseif direction == defines.direction.east then return "east-west"  -- east
  elseif direction == defines.direction.south then return "north-south"  -- south
  elseif direction == defines.direction.west then return "east-west"   -- west
  else return "north-south"   -- default to north
  end
end

function OnBuilt(entity)
  if transformerIstransformer(entity) then
    -- game.players[1].print("Transformer built at {" .. entity.position.x .. ", " .. entity.position.y .. "}")
    -- entity.operable = false
    local limit = transformerLimit(entity)
    local struct = { transformer = entity }
    local drain_pos = transformerGetDrainPosition(entity.direction)
    local source_pos = transformerGetSourcePosition(entity.direction)
    drain_pos.x = drain_pos.x + entity.position.x
    drain_pos.y = drain_pos.y + entity.position.y
    source_pos.x = source_pos.x + entity.position.x
    source_pos.y = source_pos.y + entity.position.y
    local source_drain_type = transformerGetSourceDrainType(entity.direction)
    local create = entity.surface.create_entity
    local drain = create{name = "yoyobuae-transformer-" .. limit .."W-drain-"..source_drain_type, position = drain_pos, force = entity.force}
    local source = create{name = "yoyobuae-transformer-" .. limit .."W-source-"..source_drain_type, position = source_pos, force = entity.force}
    local arrow = create{name = "yoyobuae-transformer-arrow", position = entity.position, force = entity.force}
    arrow.direction = entity.direction
    -- game.players[1].print("Created drain at {" .. drain.position.x .. ", " .. drain.position.y .. "}")
    -- game.players[1].print("Created source at {" .. source.position.x .. ", " .. source.position.y .. "}")
    struct.drain = drain
    struct.source = source
    struct.arrow = arrow
    table.insert(global["transformers"], struct)
  end
end

function OnRemoved(entity)
  if transformerIstransformer(entity) then
    local found_struct
    local index

    for key, struct in pairs(global["transformers"]) do
      if struct.transformer == entity then
        found_struct = struct
        index = key
        break
      end
    end
    --game.players[1].print("Transformer removed from {" .. found_struct.transformer.position.x .. ", " .. found_struct.transformer.position.y .. "}")
    table.remove(global["transformers"], index)
    --game.players[1].print("drain removed from {" .. found_struct.drain.position.x .. ", " .. found_struct.drain.position.y .. "}")
    --game.players[1].print("source removed from {" .. found_struct.source.position.x .. ", " .. found_struct.source.position.y .. "}")
    found_struct.drain.destroy()
    found_struct.drain = nil
    found_struct.source.destroy()
    found_struct.source = nil
    found_struct.arrow.destroy()
    found_struct.arrow = nil
  end
end

script.on_event(defines.events.on_player_rotated_entity, function(event)
  local entity = event.entity;
  if transformerIstransformer(entity) then
    for _, struct in pairs(global["transformers"]) do
      if struct.transformer == entity then
        -- entity.direction = struct.direction
        -- game.players[1].print("Transformer rotated to direction " .. entity.direction)
        local limit = transformerLimit(entity)
        local drain_energy = struct.drain.energy
        local source_energy = struct.source.energy
        struct.drain.destroy()
        struct.drain = nil
        struct.source.destroy()
        struct.source = nil

        local drain_pos = transformerGetDrainPosition(entity.direction)
        local source_pos = transformerGetSourcePosition(entity.direction)
        drain_pos.x = drain_pos.x + entity.position.x
        drain_pos.y = drain_pos.y + entity.position.y
        source_pos.x = source_pos.x + entity.position.x
        source_pos.y = source_pos.y + entity.position.y
        local source_drain_type = transformerGetSourceDrainType(entity.direction)
        local create = entity.surface.create_entity
        local drain = create{name = "yoyobuae-transformer-" .. limit .."W-drain-"..source_drain_type, position = drain_pos, force = entity.force}
        local source = create{name = "yoyobuae-transformer-" .. limit .."W-source-"..source_drain_type, position = source_pos, force = entity.force}

        drain.energy = drain_energy
        source.energy = source_energy

        struct.drain = drain
        struct.source = source
        struct.arrow.direction = entity.direction
        break
      end
    end
  end
end)


function my_on_tick()
  for _, struct in pairs(global["transformers"]) do
    local input_storage = struct.drain.energy
    local output_storage = struct.source.energy
    local max_power = (struct.drain.energy)
    local min_power = ((6 * 10^6) - struct.source.energy)
    local power_transfer = 0
    if (max_power < min_power) then
      power_transfer = max_power
    else
      power_transfer = min_power
    end
    struct.drain.power_usage = power_transfer / 60.0
    --struct.drain.electric_drain = power_transfer / 60.0
    struct.source.power_production = power_transfer / 60.0

    local behavior = struct.transformer.get_or_create_control_behavior()
    if behavior then
      -- local params = {{signal={type = "virtual", name = "signal-A"}, count = math.floor(power_transfer), index = 1}}
      local params = behavior.parameters.parameters
      if params[1].signal and params[1].signal.type and params[1].signal.name and params[1].index then
        params[1].count = math.floor(power_transfer)
        behavior.parameters = {parameters = params}
      end
    end

    local energy_transfer = 0
    if (struct.drain.energy > power_transfer) and (struct.source.energy == 0) then
      energy_transfer = struct.drain.energy - power_transfer
    end
    struct.drain.energy = struct.drain.energy - energy_transfer
    struct.source.energy = struct.source.energy + energy_transfer
  end
end
script.on_nth_tick(60, my_on_tick)
