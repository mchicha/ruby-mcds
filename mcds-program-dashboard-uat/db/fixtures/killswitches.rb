Killswitch.seed(:name) do |t|
  t.name = "email"
  t.killed = false
  t.description = 'This blocks the message center for non-TKML. (Hides link too)'
end

Killswitch.seed(:name) do |t|
  t.name = "new_user_notification"
  t.killed = false
  t.description = 'Blocks notifications for new users. Use when thousands start on same day'
end

Killswitch.seed(:name) do |t|
  t.name = "capture_behavior"
  t.killed = false
  t.description = 'Blocks Captures (user behavior records) from saving'
end
