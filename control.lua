script.on_init(function()
  if global["yoyobuae-transformers"] == nil then
    global["yoyobuae-transformers"] = {}
  end
end)

script.on_load(function()
  if global["yoyobuae-transformers"] == nil then
    global["yoyobuae-transformers"] = {}
  end
end)


script.on_event(defines.events.on_robot_built_entity, function(event) OnBuilt(event.created_entity) end)
script.on_event(defines.events.on_built_entity, function(event) OnBuilt(event.created_entity) end)

script.on_event(defines.events.on_preplayer_mined_item, function(event) OnRemoved(event.entity) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) OnRemoved(event.entity) end)
script.on_event(defines.events.on_entity_died, function(event) OnRemoved(event.entity) end)

local function transformerIstransformer(entity)
	if (entity.name == "yoyobuae-transformer") then
		return true
	else
		return false
	end
end

function OnBuilt(entity)
  if transformerIstransformer(entity) then
    -- game.players[1].print("Transformer built at {" .. entity.position.x .. ", " .. entity.position.y .. "}")
    -- entity.operable = false
    local struct = { transformer = entity }
    local drain_pos = { x = entity.position.x - 0.5, y = entity.position.y }
    local source_pos = { x = entity.position.x + 0.5, y = entity.position.y }
    local create = entity.surface.create_entity
    local drain = create{name = "yoyobuae-transformer-interface", position = drain_pos, force = entity.force}
    local source = create{name = "yoyobuae-transformer-interface", position = source_pos, force = entity.force}
    -- game.players[1].print("Created drain at {" .. drain.position.x .. ", " .. drain.position.y .. "}")
    -- game.players[1].print("Created source at {" .. source.position.x .. ", " .. source.position.y .. "}")
    struct.drain = drain
    struct.source = source
    table.insert(global["yoyobuae-transformers"], struct)
  end
end

function OnRemoved(entity)
  if transformerIstransformer(entity) then
    local found_struct
    local index

    for key, struct in pairs(global["yoyobuae-transformers"]) do
      if struct.transformer == entity then
        found_struct = struct
        index = key
        break
      end
    end
    --game.players[1].print("Transformer removed from {" .. found_struct.transformer.position.x .. ", " .. found_struct.transformer.position.y .. "}")
    table.remove(global["yoyobuae-transformers"], index)
    --game.players[1].print("drain removed from {" .. found_struct.drain.position.x .. ", " .. found_struct.drain.position.y .. "}")
    --game.players[1].print("source removed from {" .. found_struct.source.position.x .. ", " .. found_struct.source.position.y .. "}")
    found_struct.drain.destroy()
    found_struct.drain = nil
    found_struct.source.destroy()
    found_struct.source = nil
  end
end


function my_on_tick()
  if game.tick % 60 == 0 then
    for _, struct in pairs(global["yoyobuae-transformers"]) do
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
      struct.drain.electric_drain = power_transfer / 60.0
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
end
script.on_event(defines.events.on_tick, my_on_tick)
