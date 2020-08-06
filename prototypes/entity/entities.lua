-- vim: et sw=2 ts=2

require ("util")

transparent_pic =
{
  filename = "__yoyobuae-transformer__/graphics/transparent.png",
  priority = "extra-high",
  width = 1,
  height = 1,
  frame_count = 1
}

function accumulator_picture(tint, repeat_count)
  return
  {
    layers =
    {
      {
        filename = "__base__/graphics/entity/accumulator/accumulator.png",
        priority = "high",
        width = 66,
        height = 94,
        repeat_count = repeat_count,
        shift = util.by_pixel(0, -10),
        tint = tint,
        animation_speed = 0.5,
        hr_version =
        {
          filename = "__base__/graphics/entity/accumulator/hr-accumulator.png",
          priority = "high",
          width = 130,
          height = 189,
          repeat_count = repeat_count,
          shift = util.by_pixel(0, -11),
          tint = tint,
          animation_speed = 0.5,
          scale = 0.5
        }
      },
      {
        filename = "__base__/graphics/entity/accumulator/accumulator-shadow.png",
        priority = "high",
        width = 120,
        height = 54,
        repeat_count = repeat_count,
        shift = util.by_pixel(28, 6),
        draw_as_shadow = true,
        hr_version =
        {
          filename = "__base__/graphics/entity/accumulator/hr-accumulator-shadow.png",
          priority = "high",
          width = 234,
          height = 106,
          repeat_count = repeat_count,
          shift = util.by_pixel(29, 6),
          draw_as_shadow = true,
          scale = 0.5
        }
      }
    }
  }
end

function generate_transformer_main_body(limit)
  local main_body = table.deepcopy(data.raw["accumulator"]["accumulator"])
  main_body.energy_source = nil
  main_body.picture = nil
  main_body.charge_animation = nil
  main_body.charge_cooldown = nil
  main_body.charge_light = nil
  main_body.discharge_animation = nil
  main_body.discharge_cooldown = nil
  main_body.discharge_light = nil
  main_body.working_sound = nil
  main_body.default_output_signal = nil
  main_body.circuit_wire_connection_points =
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
  }
  main_body.circuit_connector_sprites = nil

  main_body.name = "yoyobuae-transformer-" .. limit .."W"
  main_body.icons = { {icon = "__base__/graphics/icons/accumulator.png", tint = {r=0.8, g=1, b=0.8, a=1}} }

  main_body.type = "constant-combinator"
  main_body.item_slot_count = 1
  main_body.sprites =
  {
    north = accumulator_picture({ r=0.8, g=1, b=0.8, a=1 }),
    east = accumulator_picture({ r=0.8, g=1, b=0.8, a=1 }),
    south = accumulator_picture({ r=0.8, g=1, b=0.8, a=1 }),
    west = accumulator_picture({ r=0.8, g=1, b=0.8, a=1 }),
  }
  main_body.activity_led_sprites =
  {
    north = transparent_pic,
    east = transparent_pic,
    south = transparent_pic,
    west = transparent_pic,
  }
  main_body.activity_led_light_offsets =
  {
    {0.0, 0.0},
    {0.0, 0.0},
    {0.0, 0.0},
    {0.0, 0.0}
  }
  return main_body
end

function generate_transformer_interface(limit, kind, direction)
  local interface = table.deepcopy(data.raw["electric-energy-interface"]["electric-energy-interface"])
  interface.name = "yoyobuae-transformer-" .. limit .. "W-" .. kind .. "-" .. direction
  interface.icons = { {icon = "__base__/graphics/icons/accumulator.png", tint = {r=1, g=0.8, b=0.8, a=1}} }
  interface.flags = {"placeable-neutral", "not-selectable-in-game", "hidden", "not-on-map", "not-repairable", "not-flammable", "not-upgradable", "no-automated-item-removal", "no-automated-item-insertion"}
  interface.minable = nil
  interface.collision_mask = {"ghost-layer"}
  if direction == "east-west" then
    interface.collision_box = {{-0.4, -0.9}, {0.4, 0.9}}
    interface.selection_box = {{-0.5, -1}, {0.5, 1}}
  elseif direction == "north-south" then
    interface.collision_box = {{-0.9, -0.4}, {0.9, 0.4}}
    interface.selection_box = {{-1, -0.5}, {1, 0.5}}
  end
  interface.gui_mode = nil
  interface.allow_copy_paste = false
  interface.energy_production = "0W"
  interface.energy_usage = "0W"
  if kind == "drain" then
    interface.energy_source =
    {
      type = "electric",
      buffer_capacity = limit .. "J",
      usage_priority = "secondary-input",
      input_flow_limit = limit .. "W",
      output_flow_limit = "0W"
    }
  elseif kind == "source" then
    interface.energy_source =
    {
      type = "electric",
      buffer_capacity = limit .. "J",
      usage_priority = "secondary-output",
      input_flow_limit = "0W",
      output_flow_limit = limit .. "W"
    }
  end
  interface.picture = transparent_pic
  interface.order = "z"
  return interface
end

function generate_transformer_arrow()
  local arrow = table.deepcopy(data.raw["inserter"]["inserter"])
  arrow.name = "yoyobuae-transformer-arrow"
  arrow.icons = { {icon = "__base__/graphics/icons/accumulator.png", tint = {r=1, g=1, b=0.8, a=1}} }
  arrow.flags = {"placeable-neutral", "placeable-off-grid", "not-selectable-in-game", "hidden", "not-on-map", "not-repairable", "not-flammable", "not-upgradable", "no-automated-item-removal", "no-automated-item-insertion"}
  arrow.minable = nil
  arrow.selectable_in_game = false
  arrow.collision_mask = {"ghost-layer"}
  arrow.rotation_speed = 0.0
  arrow.extension_speed = 0.0
  arrow.platform_picture =
  {
    sheet = transparent_pic,
  }
  arrow.hand_base_picture = transparent_pic
  arrow.hand_closed_picture = transparent_pic
  arrow.hand_open_picture = transparent_pic
  arrow.hand_base_shadow = transparent_pic
  arrow.hand_closed_shadow = transparent_pic
  arrow.hand_open_shadow = transparent_pic
  arrow.energy_per_movement = "0J"
  arrow.energy_per_rotation = "0J"
  arrow.energy_source =
  {
    type = "burner",
    effectivity = 1,
    fuel_inventory_size = 0,
  }
  arrow.next_upgrade = nil
  return arrow
end

data:extend(
{	
  generate_transformer_main_body("6M"),
  generate_transformer_interface("6M", "drain", "east-west"),
  generate_transformer_interface("6M","source", "east-west"),
  generate_transformer_interface("6M","drain", "north-south"),
  generate_transformer_interface("6M","source", "north-south"),
  generate_transformer_arrow(),
})
