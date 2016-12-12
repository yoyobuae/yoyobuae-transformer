transparent_pic =
{
  filename = "__yoyobuae-transformer__/graphics/transparent.png",
  priority = "extra-high",
  width = 1,
  height = 1,
  frame_count = 1
}

data:extend(
{	
  {
    type = "constant-combinator",
    name = "yoyobuae-transformer",
    icon = "__base__/graphics/icons/accumulator.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "yoyobuae-transformer"},
    max_health = 150,
    corpse = "medium-remnants",
    collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
    selection_box = {{-1, -1}, {1, 1}},
    item_slot_count = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1W",
--    picture =
--    {
--      filename = "__base__/graphics/entity/accumulator/accumulator.png",
--      priority = "extra-high",
--      width = 124,
--      height = 103,
--      shift = {0.6875, -0.203125}
--    },
    sprites =
    {
      north =
      {
        filename = "__base__/graphics/entity/accumulator/accumulator.png",
        priority = "extra-high",
        width = 124,
        height = 103,
        shift = {0.6875, -0.203125}
      },
      east =
      {
        filename = "__base__/graphics/entity/accumulator/accumulator.png",
        priority = "extra-high",
        width = 124,
        height = 103,
        shift = {0.6875, -0.203125}
      },
      south =
      {
        filename = "__base__/graphics/entity/accumulator/accumulator.png",
        priority = "extra-high",
        width = 124,
        height = 103,
        shift = {0.6875, -0.203125}
      },
      west =
      {
        filename = "__base__/graphics/entity/accumulator/accumulator.png",
        priority = "extra-high",
        width = 124,
        height = 103,
        shift = {0.6875, -0.203125}
      },
    },

    activity_led_sprites =
    {
      north = transparent_pic,
      east = transparent_pic,
      south = transparent_pic,
      west = transparent_pic,
    },
    activity_led_light_offsets =
    {
      {0.0, 0.0},
      {0.0, 0.0},
      {0.0, 0.0},
      {0.0, 0.0}
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    circuit_wire_connection_points =
    {
      {
        shadow =
        {
          red = {0.984375, 1.10938},
          green = {0.890625, 1.10938}
        },
        wire =
        {
          red = {0.6875, 0.59375},
          green = {0.6875, 0.71875}
        }
      },
      {
        shadow =
        {
          red = {0.984375, 1.10938},
          green = {0.890625, 1.10938}
        },
        wire =
        {
          red = {0.6875, 0.59375},
          green = {0.6875, 0.71875}
        }
      },
      {
        shadow =
        {
          red = {0.984375, 1.10938},
          green = {0.890625, 1.10938}
        },
        wire =
        {
          red = {0.6875, 0.59375},
          green = {0.6875, 0.71875}
        }
      },
      {
        shadow =
        {
          red = {0.984375, 1.10938},
          green = {0.890625, 1.10938}
        },
        wire =
        {
          red = {0.6875, 0.59375},
          green = {0.6875, 0.71875}
        }
      },
    },
    circuit_connector_sprites = get_circuit_connector_sprites({0.46875, 0.5}, {0.46875, 0.8125}, 26),
    circuit_wire_max_distance = 7.5,
  },
  {
    type = "electric-energy-interface",
    name = "yoyobuae-transformer-interface",
    icon = "__base__/graphics/icons/accumulator.png",
    flags = {"placeable-neutral", "player-creation"},
    max_health = -1,
    corpse = "medium-remnants",
    collision_mask = {"ghost-layer"},
    collision_box = {{-0.4, -0.9}, {0.4, 0.9}},
    selection_box = {{-0.5, -1}, {0.5, 1}},
    energy_source =
    {
      type = "electric",
      buffer_capacity = "6MJ",
      usage_priority = "terciary",
      input_flow_limit = "6MW",
      output_flow_limit = "6MW"
    },
    picture = transparent_pic,
    order = "z",
  },
})
