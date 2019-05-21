query ="INSERT INTO `users` (`id`, `email`, `cas_user_id`, `first_name`, `last_name`, `created_at`, `updated_at`, `role`)
  VALUES
  (1, 'e.agnew@tukaiz.com', 2591, NULL, NULL, NULL, NULL, 4),
  (2, 'a.tobiasiewicz@tukaiz.com', 2813, NULL, NULL, NULL, NULL, 4),
  (3, 'm.glaz@tukaiz.com', 3199, NULL, NULL, NULL, NULL, 4),
  (4, 'l.krueger@tukaiz.com', 3398, NULL, NULL, NULL, NULL, 4),
  (5, 'm.khan@tukaiz.com', 2788, NULL, NULL, NULL, NULL, 4),
  (6, 'c.weisman@tukaiz.com', 81, NULL, NULL, NULL, NULL, 4),
  (7, 'j.johnson@tukaiz.com', 3523, NULL, NULL, NULL, NULL, 4),
  (8, 'm.ishikawa@tukaiz.com', 32, 'Miki', 'Ishikawa', NULL, NULL, 4),
  (9, 'c.soler-rodriguez@tukaiz.com', 3560, 'Processor', 'User', NULL, NULL, 4),
  (10, 'e.lee@tukaiz.com', 4025, NULL, NULL, NULL, NULL, 4);"


results = ActiveRecord::Base.connection.execute(query);
