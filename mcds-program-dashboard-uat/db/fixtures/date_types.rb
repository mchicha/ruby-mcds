DateType.seed(:name) do |t|
  t.name = "kit_delivery_between"
  t.end_date_required = true
  t.required = true
  t.sort_order = 1
end

DateType.seed(:name) do |t|
  t.name = "pop_install"
  t.end_date_required = true
  t.required = true
  t.show_on_calendar = true
  t.sort_order = 1
  t.display_name = "P.O.P. Install"
  t.fa_icon = 'fa-chevron-up'
  t.icon_color = '#0000FF'
end

DateType.seed(:name) do |t|
  t.name = "advertised_start"
  t.sort_order = 1
end

DateType.seed(:name) do |t|
  t.name = "pop_take_down"
  t.end_date_required = true
  t.required = true
  t.show_on_calendar = true
  t.fa_icon = 'fa-chevron-down'
  t.icon_color = '#FF0000'
  t.sort_order = 1
  t.display_name = "P.O.P. Take Down"
end

DateType.seed(:name) do |t|
  t.name = "product_in_store"
  t.sort_order = 1
end

DateType.seed(:name) do |t|
  t.name = "soft_sell_between"
  t.end_date_required = true
  t.sort_order = 1
end

DateType.seed(:name) do |t|
  t.name = "all_store_sell"
  t.sort_order = 1
end

DateType.seed(:name) do |t|
  t.name = "product_phase_out"
  t.end_date_required = true
  t.sort_order = 1
end

DateType.seed(:name) do |t|
  t.name = "archive_program_on"
  t.sort_order = 1
end
