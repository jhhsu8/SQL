-- retrieve mice that have incorrect necropsies, collection and sacrifice dates occurring after datetimes.
SELECT DISTINCT hemas.mouse_name,
                necropsies.datetime,
                hemas.sacrifice_datetime,
                hemas.collection_datetime,
                hemas.datetime
FROM hemas
         INNER JOIN necropsies ON necropsies.mouse_name = hemas.mouse_name
WHERE hemas.collection_datetime > hemas.datetime AND necropsies.datetime > hemas.datetime
ORDER BY hemas.datetime;

