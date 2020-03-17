/* Fixed the open field data where whole arena average speeds and total distances travelled are zero
but the center/periphery speeds and distances travelled are not zero */

UPDATE open_fields
SET open_fields.whole_arena_average_speed_series =
            (open_fields.periphery_distance_travelled_series + open_fields.center_distance_travelled_series) /
            (open_fields.center_permanence_time_series + open_fields.periphery_permanence_time_series),
    open_fields.distance_travelled               = open_fields.periphery_distance_travelled_series +
                                                   open_fields.center_distance_travelled_series,
    open_fields.modified                         = '2020-03-03 12:10:00'
WHERE open_fields.whole_arena_average_speed_series = 0
  AND open_fields.periphery_permanence_time_series <> 0
  AND open_fields.center_permanence_time_series <> 0;
