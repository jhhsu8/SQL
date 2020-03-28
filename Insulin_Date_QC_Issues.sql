--Insulins Date QC Issues
--Dates of Experiment: 2/2/2015 – 5/8/2019
--Note: Plasma samples can be frozen and used for insulin analysis at a later date.

--1. Blood collection/sacrifice dates are after the date of experiment:

--Change those incorrect insulin blood collection dates to the correct necropsies dates.
UPDATE insulins INNER JOIN necropsies ON necropsies.mouse_name = insulins.mouse_name
SET insulins.blood_collection_datetime = necropsies.datetime, insulins.modified = '2020-02-05 11:00:00'
WHERE necropsies.datetime = insulins.datetime
  AND insulins.blood_collection_datetime > insulins.datetime
  
--Change those incorrect insulin datetimes to the correct blood collection dates.
UPDATE insulins INNER JOIN necropsies ON necropsies.mouse_name = insulins.mouse_name
SET insulins.datetime = insulins.blood_collection_datetime, insulins.modified = '2020-02-05 11:47:00'
WHERE insulins.blood_collection_datetime > insulins.datetime
  AND DATE(insulins.blood_collection_datetime) = DATE(necropsies.datetime)

/* There are mismatched Mosaic death dates, necropsies dates, insulin datetimes, 
insulin blood collection dates which are after insulin datetimes */
SELECT insulins.mouse_name,
       ltam.death_date,
       insulins.blood_collection_datetime,
       insulins.datetime,
       insulins.modified
FROM insulins
         INNER JOIN mbp.labtracks_animal_mirror ltam
                    ON insulins.mouse_name = CONCAT(ltam.stock, '-', ltam.pedigree_number)
WHERE insulins.blood_collection_datetime > insulins.datetime;

SELECT insulins.mouse_name,
       necropsies.datetime,
       insulins.blood_collection_datetime,
       insulins.datetime,
       insulins.modified
FROM insulins
         INNER JOIN necropsies ON necropsies.mouse_name = insulins.mouse_name
WHERE insulins.blood_collection_datetime > insulins.datetime;

--2. Blood collection date is more than 14 days earlier or later than timepoint specified by impress:

--Status code those incorrect blood collection dates as shown in the results from the SQL query below
SELECT insulins.mouse_name, ltam.death_date, insulins.blood_collection_datetime, insulins.datetime, insulins.modified
FROM insulins
         INNER JOIN mbp.labtracks_animal_mirror ltam
                    ON insulins.mouse_name = CONCAT(ltam.stock, '-', ltam.pedigree_number)
WHERE (DATEDIFF(insulins.blood_collection_datetime, ltam.birth_date) / 7 < 14 OR
       DATEDIFF(insulins.blood_collection_datetime, ltam.birth_date) / 7 > 18)
  AND (DATEDIFF(insulins.blood_collection_datetime, ltam.birth_date) / 7 < 57 OR
       DATEDIFF(insulins.blood_collection_datetime, ltam.birth_date) / 7 > 61);
