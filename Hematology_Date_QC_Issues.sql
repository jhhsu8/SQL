--Hematology Timepoint QC Issues

--Blood collection/sacrifice date is more than 14 days earlier or later than timepoint specified by impress:

--set the 4 mice’s incorrect blood collection and sacrifice dates to correct datetime
UPDATE hemas SET hemas.collection_datetime = hemas.datetime, hemas.sacrifice_datetime = hemas.datetime
WHERE hemas.mouse_name IN (
'ET8220-121',
'BL4984-106',
'ET9197-109',
'ET9197-110');

--Fix blood collection/sacrifice dates that occur after date of experiment

--Verify all hemas collection_datetime and sacrifice_datetime are the same
SELECT * FROM hemas WHERE hemas.collection_datetime <> hemas.sacrifice_datetime

--Set incorrect blood collection and sacrifice dates to correct hemas.datetime where datetime matches Mosaic
UPDATE hemas
JOIN mbp.labtracks_animal_mirror ltam ON hemas.mouse_name = CONCAT(stock, '-', pedigree_number)
SET hemas.collection_datetime = hemas.datetime,
    hemas.sacrifice_datetime  = hemas.datetime
WHERE hemas.collection_datetime != hemas.datetime
AND hemas.sacrifice_datetime != hemas.datetime
AND DATE(hemas.datetime) = ltam.death_date;
 
--Update necropsies to match hemas.datetime for consistent timestamps
UPDATE hemas
JOIN necropsies ON hemas.mouse_name = necropsies.mouse_name
JOIN mbp.labtracks_animal_mirror ltam ON hemas.mouse_name = CONCAT(stock, '-', pedigree_number)
SET  necropsies.datetime = hemas.datetime
WHERE hemas.collection_datetime != hemas.datetime
AND hemas.sacrifice_datetime != hemas.datetime
AND DATE(hemas.datetime) = ltam.death_date
AND necropsies.datetime != hemas.datetime;

--Set incorrect datetimes to correct blood collection/sacrifice dates where collection_datetime matches Mosaic
UPDATE hemas
JOIN mbp.labtracks_animal_mirror ltam ON hemas.mouse_name = CONCAT(stock, '-', pedigree_number)
SET hemas.datetime = hemas.collection_datetime,
WHERE hemas.collection_datetime != hemas.datetime
AND DATE(hemas.collection_datetime) = DATE(ltam.death_date);

-- Summary of cases where mosaic death_date !=  hemas.datetime
SELECT count(*) count, DATEDIFF(datetime, ltam.death_date) date_diff, ltam.death_date, datetime, 
collection_datetime, sacrifice_datetime 
FROM hemas 
JOIN mbp.labtracks_animal_mirror ltam ON hemas.mouse_name = CONCAT(stock, '-', pedigree_number) 
WHERE DATE(hemas.datetime) != DATE(ltam.death_
date) AND DATE(hemas.sacrifice_datetime) != DATE(ltam.death_date) AND DATE(hemas.collection_datetime) != DATE(ltam.death_date) 
GROUP BY date_diff ORDER BY count DESC;

