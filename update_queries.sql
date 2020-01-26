-- set hematology blood collection and sacrifice dates to necropsies dates.
UPDATE hemas INNER JOIN necropsies ON necropsies.mouse_name = hemas.mouse_name
SET hemas.collection_datetime = necropsies.datetime,
    hemas.sacrifice_datetime  = necropsies.datetime
WHERE hemas.collection_datetime > hemas.datetime 
  AND hemas.sacrifice_datetime > hemas.datetime 
  AND necropsies.datetime <= hemas.datetime;
