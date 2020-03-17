--Clinical Chemistry Date QC Issues
 
--Dates of Experiment: 4/16/2013 – 5/29/2018

/* 1. The DCC says the mouse name ET9306-88 has the sacrifice date that occurs after the datetime (date of experiment):
However, I have found that the sacrifice date for ET9306-88 the same as the datetime.*/

--Reupload the CBC data for ET9306-88 to the DCC.
UPDATE DCC_uploads
SET status = 'reupload', modified = '2020-02-04'
WHERE assay like 'UCD_001.IMPC_CBC%'
AND mouse_name = 'ET9306-88';

--2. Mice have incorrect blood collection dates but have correct sacrifice and Mosaic death dates.

--Change those incorrect blood collection dates to the correct sacrifice dates (same as Mosaic death dates).
UPDATE cbcs
    INNER JOIN mbp.labtracks_animal_mirror ltam ON cbcs.mouse_name = CONCAT(ltam.stock, '-', ltam.pedigree_number)
SET cbcs.collection_datetime = cbcs.sacrifice_datetime,
    cbcs.modified = '2020-02-03 14:08:00'
WHERE DATE(cbcs.sacrifice_datetime) = ltam.death_date
  AND DATE(cbcs.collection_datetime) <> DATE(cbcs.sacrifice_datetime);

--3. Mice have incorrect blood collection and sacrifice dates that are after datetimes.

--Change those incorrect blood collection/sacrifice dates or datetimes to correct necropsies dates.
UPDATE cbcs INNER JOIN necropsies ON necropsies.mouse_name = cbcs.mouse_name
SET cbcs.collection_datetime = necropsies.datetime,
    cbcs.sacrifice_datetime = necropsies.datetime,
    cbcs.modified = '2020-02-03 15:20:00'
WHERE DATE(cbcs.collection_datetime) > DATE(cbcs.datetime);
 
UPDATE cbcs INNER JOIN necropsies ON necropsies.mouse_name = cbcs.mouse_name
SET cbcs.sacrifice_datetime = necropsies.datetime,
    cbcs.collection_datetime = necropsies.datetime,
    cbcs.datetime = necropsies.datetime,
    cbcs.modified = '2020-02-03 16:00:00'
WHERE cbcs.mouse_name = 'CR1488-379';

UPDATE cbcs INNER JOIN necropsies ON necropsies.mouse_name = cbcs.mouse_name
SET cbcs.sacrifice_datetime = necropsies.datetime,
    cbcs.collection_datetime = necropsies.datetime,
    cbcs.datetime = necropsies.datetime,
    cbcs.modified = '2020-02-04 9:05:00'
WHERE cbcs.mouse_name = 'CR1381-169';
 Reuploaded fixed CBC data to the DCC.
 
--4. Mice have incorrect ages at dates of blood collection/sacrifice dates or Mosaic death dates.

--Figure out how to fix those dates where mice have incorrect ages (See the result from the query below). Status code?
SELECT DISTINCT cbcs.mouse_name,
                ltam.death_date,
                DATEDIFF(ltam.death_date, ltam.birth_date) / 7  AS death_age,
                ltam.birth_date,
                cbcs.sacrifice_datetime,
                DATEDIFF(cbcs.sacrifice_datetime, ltam.birth_date) / 7  AS sacrifice_age,
                cbcs.collection_datetime,
                DATEDIFF(cbcs.collection_datetime, ltam.birth_date) / 7 AS collection_age,
                cbcs.datetime,
                cbcs.created,
                cbcs.modified
FROM mice
         INNER JOIN cbcs ON mice.mouse_id = cbcs.mouse_name
         INNER JOIN mbp.labtracks_animal_mirror ltam ON cbcs.mouse_name = CONCAT(ltam.stock, '-', ltam.pedigree_number)
WHERE (DATEDIFF(cbcs.collection_datetime, ltam.birth_date) < 98 OR
       DATEDIFF(cbcs.collection_datetime, ltam.birth_date) > 126)
  AND (DATEDIFF(cbcs.collection_datetime, ltam.birth_date) < 399 OR
       DATEDIFF(cbcs.collection_datetime, ltam.birth_date) > 427);

-- BL1601-425, BL1601-426, BL1601-432, BL1601-427 are not found in both Mosaic and necropsies tables.
SELECT * from cbcs WHERE DATE(cbcs.collection_datetime) > DATE(cbcs.datetime);

SELECT *
FROM cbcs
         INNER JOIN mbp.labtracks_animal_mirror ltam ON cbcs.mouse_name = CONCAT(ltam.stock, '-', ltam.pedigree_number)
WHERE mouse_name IN ('BL1601-425', 'BL1601-426', 'BL1601-432', 'BL1601-427');
SELECT *
FROM cbcs
         INNER JOIN necropsies ON necropsies.mouse_name = cbcs.mouse_name
WHERE cbcs.mouse_name IN ('BL1601-425','BL1601-426', 'BL1601-432', 'BL1601-427');
