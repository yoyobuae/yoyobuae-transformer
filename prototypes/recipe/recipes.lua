-- vim: et sw=2 ts=2

function generate_transformer_recipe(limit, cost_factor)
  local recipe = table.deepcopy(data.raw["recipe"]["big-electric-pole"])
  recipe.name = "yoyobuae-transformer-" .. limit .. "W"
  recipe.ingredients =
  {
    {"iron-stick", 4 * cost_factor},
    {"steel-plate", 5 * cost_factor},
    {"copper-cable", 20 * cost_factor},
  }
  recipe.result = "yoyobuae-transformer-" .. limit .. "W"
  return recipe
end

data:extend(
{
  generate_transformer_recipe("6M", 1),
})
