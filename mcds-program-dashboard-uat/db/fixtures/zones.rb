Zone.seed(:name) do |t|
  t.name = "Exterior Zone"
  t.sort_order = 1
  t.archived = false
end

Zone.seed(:name) do |t|
  t.name = "Drive Thru Zone"
  t.sort_order = 2
  t.archived = false
end

Zone.seed(:name) do |t|
  t.name = "Counter Zone"
  t.sort_order = 3
  t.archived = false
end

Zone.seed(:name) do |t|
  t.name = "Lobby Zone"
  t.sort_order = 4
  t.archived = false
end

Zone.seed(:name) do |t|
  t.name = "DMB"
  t.sort_order = 5
  t.archived = false
end
