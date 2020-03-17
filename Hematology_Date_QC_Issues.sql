
--Hematology Timepoint QC Issues

--These are the three most reliable death dates, or at least I've found them to be the least wrong:

--1. Mosaic Website (could be entered incorrectly but is almost always most reliable since there is no auto-update or parsing involved)
mbp.labtracks_animal_mirror.death_date (copies recently changed Mosaic data every 15 minutes, but can be wrong if it misses something)
--2. hemas.datetime (hematology is always done same day as necropsy, but this is parsed value so could be parsed or entered incorrectly)
--3. necropsies.datetime (this should be correct ever since 2017 when we moved necropsy to the new LIMS. Old entries were done in an old system and may be unreliable since it used Today's Date as the default, but old entries were also cleaned up and should mostly be correct)


--Blood collection/sacrifice date is more than 14 days earlier or later than timepoint specified by impress:

--set the 4 mice’s incorrect blood collection and sacrifice dates to correct datetimes.
UPDATE hemas SET hemas.collection_datetime = hemas.datetime, hemas.sacrifice_datetime = hemas.datetime
WHERE hemas.mouse_name IN (
'ET8220-121',
'BL4984-106',
'ET9197-109',
'ET9197-110');

--Update all LIMS death dates to match the Mosaic death date. BL4447-188 has a CBC comment about being necropsied early at 14 weeks, so that date is the accurate one. Mosaic confirms a death date of 2016-12-21 which is about 14 weeks of age. Hemas datetime confirms 2016-12-21 12:25:00 so we can use that datetime to update the rest. Note: CBC datetime doesn't need to match the death date because blood samples are frozen and done later.
UPDATE hemas SET sacrifice_datetime = datetime, collection_datetime = datetime WHERE mouse_name = 'BL4447-188';
UPDATE cbcs, hemas SET cbcs.sacrifice_datetime = hemas.datetime, cbcs.collection_datetime = hemas.datetime WHERE cbcs.mouse_name = hemas.mouse_name AND cbcs.mouse_name  = 'BL4447-188';

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
