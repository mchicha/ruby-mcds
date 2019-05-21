PredefinedAttribute.find_or_create_by(value: "brian.dekowzan@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1100, 1101, 1102, 1103, 1201, 1203, 1204]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jon.burke@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1100, 1101, 1102, 1103, 1201, 1203, 1204]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "danica.cunningham@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1100, 1101, 1102, 1103, 1201, 1203, 1204]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "steve.johnson@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1100, 1101, 1102, 1103, 1201, 1203, 1204]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Suzanne.Pingeton@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [101, 102, 201, 202, 205, 301, 401, 601, 705, 711]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Ramon.Colon@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [101, 102, 201, 202, 205, 301, 401, 601, 705, 711]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "lindsay.greene@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [101, 102, 201, 202, 205, 301, 401, 601, 705, 711]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "chelsea.obrien@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [101, 102, 201, 202, 205, 301, 401, 601, 705, 711]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "zoe.hamburger@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [709]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "monique.salas@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [709]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Elizabeth.Campbell@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [709]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jennifer.renna@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [701, 901, 902, 903]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "toka.akiyama@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [701, 901, 902, 903]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Kimberly.Whitehill@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [701, 901, 902, 903]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "pam.koren@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [702, 707, 904, 905, 906, 1101, 2002, 2103]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "amy.schillinger@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [702, 707, 904, 905, 906, 1101, 2002, 2103]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "josh.flaim@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [702, 707, 904, 905, 906, 1101, 2002, 2103]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Milagros.Vergara@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1402, 1403, 1501, 1502, 1503, 1504, 1505, 1507, 1640, 1701, 1702, 1703, 1704, 1804]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "scott.robinson@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1402, 1403, 1501, 1502, 1503, 1504, 1505, 1507, 1640, 1701, 1702, 1703, 1704, 1804]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Brittney.Wright@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1402, 1403, 1501, 1502, 1503, 1504, 1505, 1507, 1640, 1701, 1702, 1703, 1704, 1804]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "kaci.stewart@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1402, 1403, 1501, 1502, 1503, 1504, 1505, 1507, 1640, 1701, 1702, 1703, 1704, 1804]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "mona.yarnell@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1507, 1601, 1603, 1605, 1606, 1607, 1608, 1630, 1631]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "rudy.vivas@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1507, 1601, 1603, 1605, 1606, 1607, 1608, 1630, 1631]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Nathaniel.Jacobson@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1507, 1601, 1603, 1605, 1606, 1607, 1608, 1630, 1631]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "stephanie.allen@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1507, 1601, 1603, 1605, 1606, 1607, 1608, 1630, 1631]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "april.jones@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1602, 1802, 2401, 2403, 2404, 2410, 2411, 2412, 3001, 3101, 3102, 3103, 3104, 3105, 3107, 3108, 3223]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "gaines.conaway@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1602, 1802, 2401, 2403, 2404, 2410, 2411, 2412, 3001, 3101, 3102, 3103, 3104, 3105, 3107, 3108, 3223]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jacqueline.erale@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1602, 1802, 2401, 2403, 2404, 2410, 2411, 2412, 3001, 3101, 3102, 3103, 3104, 3105, 3107, 3108, 3223]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "katrice.jackson@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1602, 1802, 2401, 2403, 2404, 2410, 2411, 2412, 3001, 3101, 3102, 3103, 3104, 3105, 3107, 3108, 3223]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "kate.owens@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3201, 3203, 3204, 3205, 3206, 3208, 3210, 3211, 3213, 3215, 3217, 3220, 3221, 3225, 3233]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "erik.roesh@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3201, 3203, 3204, 3205, 3206, 3208, 3210, 3211, 3213, 3215, 3217, 3220, 3221, 3225, 3233]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cindy.schlesener@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3201, 3203, 3204, 3205, 3206, 3208, 3210, 3211, 3213, 3215, 3217, 3220, 3221, 3225, 3233]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "marimar.velez@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3201, 3203, 3204, 3205, 3206, 3208, 3210, 3211, 3213, 3215, 3217, 3220, 3221, 3225, 3233]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jada.snodgrass@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1202, 1301, 1302, 1303, 1304, 1401, 1404, 1405, 1406, 1801, 1805]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "diva.desai@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1202, 1301, 1302, 1303, 1304, 1401, 1404, 1405, 1406, 1801, 1805]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Thomas.Frederick@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1202, 1301, 1302, 1303, 1304, 1401, 1404, 1405, 1406, 1801, 1805]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "trista.munster@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1202, 1301, 1302, 1303, 1304, 1401, 1404, 1405, 1406, 1801, 1805]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "rick.nance@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501, 2502, 2503, 2504, 2602]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "derrick.ross@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501, 2502, 2503, 2504, 2602]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "barbara.thompson@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501, 2502, 2503, 2504, 2602]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "patrice.devaughn@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501, 2502, 2503, 2504, 2602]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "randy.bates@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2901, 2902, 2903, 2904, 2905, 2906, 3402, 3404]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "katie.klinksick@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2901, 2902, 2903, 2904, 2905, 2906, 3402, 3404]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Maureen.Boesen@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2901, 2902, 2903, 2904, 2905, 2906, 3402, 3404]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "michael.hillsman@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1803, 1901, 2301, 2302, 2303, 2304, 2305, 2505]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "annette.coulombe@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1803, 1901, 2301, 2302, 2303, 2304, 2305, 2505]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Mariblanca.Rosa@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1803, 1901, 2301, 2302, 2303, 2304, 2305, 2505]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Kathleen.Shurtz@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1803, 1901, 2301, 2302, 2303, 2304, 2305, 2505]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "audrey.stone@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2201, 2202]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "karen.scott@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2201, 2202]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "tiffany.curry@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2201, 2202]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "tami.peterman@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2601, 2603, 2604, 2605, 2610, 2701, 2801, 2802, 2803, 2804, 2808, 3501, 3601, 3602, 3701, 3702]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "brian.gist@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2601, 2603, 2604, 2605, 2610, 2701, 2801, 2802, 2803, 2804, 2808, 3501, 3601, 3602, 3701, 3702]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "lance.moore@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2601, 2603, 2604, 2605, 2610, 2701, 2801, 2802, 2803, 2804, 2808, 3501, 3601, 3602, 3701, 3702]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "sarah.olson@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2601, 2603, 2604, 2605, 2610, 2701, 2801, 2802, 2803, 2804, 2808, 3501, 3601, 3602, 3701, 3702]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "james.nice@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1902, 2101, 2102, 2104, 2106, 2107, 2108]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "lisa.brown@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1902, 2101, 2102, 2104, 2106, 2107, 2108]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "tyson.yirak@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1902, 2101, 2102, 2104, 2106, 2107, 2108]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "angela.atherton@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1902, 2101, 2102, 2104, 2106, 2107, 2108]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "blake.wynter@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3004, 3202, 3207, 3209, 3212, 3216, 3223, 3301, 3302, 3303, 3304, 4101]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "milica.barbir@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3004, 3202, 3207, 3209, 3212, 3216, 3223, 3301, 3302, 3303, 3304, 4101]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "edgar.padilla@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3004, 3202, 3207, 3209, 3212, 3216, 3223, 3301, 3302, 3303, 3304, 4101]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "christina.comroe@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3004, 3202, 3207, 3209, 3212, 3216, 3223, 3301, 3302, 3303, 3304, 4101]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "melanie.okazaki@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [5001, 5002]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jacob.dubin@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3801, 3803, 3804, 3805, 3806, 3807, 3808, 3809, 4401, 4402, 4403, 4617, 4701, 4702, 4704, 4801, 4802, 4803, 4902, 4905, 4908, 4909, 4910, 4911, 4913]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "holly.snapp@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3801, 3803, 3804, 3805, 3806, 3807, 3808, 3809, 4401, 4402, 4403, 4617, 4701, 4702, 4704, 4801, 4802, 4803, 4902, 4905, 4908, 4909, 4910, 4911, 4913]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Gregg.Miskiel@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3801, 3803, 3804, 3805, 3806, 3807, 3808, 3809, 4401, 4402, 4403, 4617, 4701, 4702, 4704, 4801, 4802, 4803, 4902, 4905, 4908, 4909, 4910, 4911, 4913]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "robin.doss@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4502, 4607, 4608, 4611, 4613, 4614]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "natalie.aronson@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4502, 4607, 4608, 4611, 4613, 4614]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "christine.chan@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4502, 4607, 4608, 4611, 4613, 4614]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "marta.fearon@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4000, 4001, 4002, 4003, 4202, 4203, 4301, 4303, 4305, 4501, 4615, 4616]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "paul.barrera@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4000, 4001, 4002, 4003, 4202, 4203, 4301, 4303, 4305, 4501, 4615, 4616]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "tami.liebertz@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4000, 4001, 4002, 4003, 4202, 4203, 4301, 4303, 4305, 4501, 4615, 4616]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "christine.heimbrock@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4000, 4001, 4002, 4003, 4202, 4203, 4301, 4303, 4305, 4501, 4615, 4616]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "max.gallegos@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4601, 4602, 4603, 4605]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "linda.burgess@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4601, 4602, 4603, 4605]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Rosalind.Ledesma@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4601, 4602, 4603, 4605]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end








PredefinedAttribute.find_or_create_by(value: "abarry@lavidge.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "abby@moxiedm.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [902]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [15]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "aparra@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2303]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "ksheeran@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1630]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "alexandriawitt@daviselen.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3803]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' =>  [8]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "agiese@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2603]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "ageorgiou@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4607]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "amurrin@bch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [17]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "acress@bch.co") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [17]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "acress@bch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [17]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "ametzler@bch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2301]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [17]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "anniemathys@sternadvertising.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2106]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [18]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "asari.fletcher@fahlgren.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1631]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [19]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "ashleigh.mavros@fahlgren.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2102]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [19]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "ashley.goodson@cossette.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2502]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [20]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "bwilcox@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4002]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "brandi@rw-west.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4501]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [21]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "bbrooks@bch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1103]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [17]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "bridgetb@clpmcdonalds.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1702]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [22]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "bridget@sides.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3101]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [23]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "bmoss@morochc.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3210]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "caitiewright@sternadvertising.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [904]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [24]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "calleandrus@sternadvertising.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2106]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [18]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cleitterman@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2901]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "candy.marroquin@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1601]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [25]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "chewitt@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [702]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cbwilliams@handlpartners.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [26]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "carol@adwerks.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2803]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [27]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cmontgomery@lavidge.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cveazie@tombras.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1801]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [28]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "carolynjuergens@daviselen.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3803]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' =>  [8]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cwissel@bch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2501]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [17]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cconway@daltonagency.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1601]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [29]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "clindstrom@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3209]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "christopher.cook@us.stores.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1640]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [30]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "chris@garrisonadvertising.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3102]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [31]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cwhite@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [709]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' =>  [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cblanco@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3104]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "claudia@lopezgroup.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3208]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [32]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cdailey@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [709]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "kconard@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [901]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cmartin@handlpartners.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [101]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [26]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "courtney.austin@us.mcd.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3004]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [33]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "courtneyparkin@daviselen.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3803]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [34]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "cstanderfer@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1201]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "dawn.burns@courtesycorporation.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2605]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [35]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "deborah@walker-assoc.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1802]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [36]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "dcampbell@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1304]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "dfarr@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3001]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "devar@mcdonaldsguam.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [5002]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [37]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "ejuarez@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2504]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "Elizabeth@maapsinc.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3107]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [38]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "elizabethpittman@daviselen.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1101]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [34]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "ericawong@sternadvertising.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [904]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [24]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "erin.smith@garrisonadvertising.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3223, 3102]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' =>  [31]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "evan.newman@courtesycorporation.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2605]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [35]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "pgarcia@mosaicmulticultural.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4202]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [39]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "giselle.bravo@fahlgren.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1401]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [40]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "gstamulis@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2901]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "gpearce@daltonagency.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1502]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [29]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "harrison.latisha@gmail.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2301]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [41]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "lharrison@bch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2301]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [41]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "heather@galassiniadv.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1701]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [42]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "hbaumer@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [702]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "hplendl@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [709]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jccornwall@handlpartners.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4614]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [26]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jaime.botello@porternovelli.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4601]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [43]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jakeneilson@daviselen.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3803]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [34]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jane@robertsharpassociates.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3602]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [44]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jasonelen@daviselen.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3803]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [34]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jroddy@bch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1901]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [17]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jschmatz@jsmedia.net") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [45]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jenniferdelker@daviselen.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4801]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [34]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jlyon@daltonagency.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1404]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [29]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jtracy@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1201]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jesscicasheaks@sternadvertising.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3402]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [24]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jcantrall@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3202]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jtucker@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4301]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jdevereaux@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2901]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jwolf@daltonagency.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [1603]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [29]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jsalazar@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3207]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jrocco@handlpartners.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [101]
  l['associations'] <<  {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] <<  {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [26]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "kmboswell@moroch.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [3207]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [16]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "kate.hogan@courtesycorporation.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [2605]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [35]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "kcerrito@lavidge.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end



PredefinedAttribute.find_or_create_by(value: "j.dave@tukaiz.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "e.agnew@tukaiz.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end


PredefinedAttribute.find_or_create_by(value: "e.stensland@tukaiz.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jayidave2@gmail.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "jayidave2?150@gmail.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "estensand88@gmail.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end

PredefinedAttribute.find_or_create_by(value: "estensand88?150@gmail.com") do |u|
  l = {}
  l['object_attrs'] ={}
  l['object_attrs']['role'] = 1
  l['associations'] = []
  coop_ids = [4203]
  l['associations'] << {'association' => 'geographies', 'query_key' => 'coop_id', 'query_values' => coop_ids}
  l['associations'] << {'association' => 'agencies', 'query_key' => 'id', 'query_values' => [14]}
  u.values = l
  u.column = 'email'
  u.table = 'users'
  u.send_on = PredefinedAttribute.send_ons['on_create']
end
