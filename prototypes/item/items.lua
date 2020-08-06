-- vim: et sw=2 ts=2

function generate_transformer_item(limit)
  local item = table.deepcopy(data.raw["item"]["accumulator"])
  item.name = "yoyobuae-transformer-" .. limit .. "W"
  item.icons = { {icon = "__base__/graphics/icons/accumulator.png", tint = {r=0.8, g=1, b=0.8, a=1}} }
  item.subgroup = "energy-pipe-distribution"
  item.order = "a[energy]-e[transformer]"
  item.place_result = "yoyobuae-transformer-" .. limit .. "W"
  return item
end

data:extend(
{
  generate_transformer_item("6M"),
})
