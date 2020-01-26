# Retrieve mouse records with incorrect mouse ages at the time of blood collection (collection_age)
SELECT DISTINCT mice.mouse_id,
                project_types.name,
                necropsies.comment,
                necropsies.datetime                                      AS necrospies_datetime,
                DATEDIFF(necropsies.datetime, mice.birth_date) / 7       AS necropsies_age,
                mice.birth_date,
                hemas.sacrifice_datetime,
                DATEDIFF(hemas.sacrifice_datetime, mice.birth_date) / 7  AS sacrifice_age,
                hemas.collection_datetime,
                DATEDIFF(hemas.collection_datetime, mice.birth_date) / 7 AS collection_age,
                pp.scheduled,
                DATEDIFF(pp.scheduled, mice.birth_date) / 7              AS expected_age,
                hemas.datetime,
                hemas.created,
                hemas.modified,
                projects.start_date                                      AS project_start_date,
                DATEDIFF(projects.start_date, mice.birth_date)           AS days_from_project_start_date
FROM mice
         INNER JOIN hemas ON mice.mouse_id = hemas.mouse_name
         INNER JOIN projects ON projects.id = mice.project_id
         INNER JOIN project_procedures pp ON pp.id = hemas.project_procedure_id
         INNER JOIN project_types ON project_types.id = projects.project_type_id
         INNER JOIN necropsies ON necropsies.mouse_name = mice.mouse_id
WHERE (DATEDIFF(hemas.sacrifice_datetime, mice.birth_date) / 7 < 14 OR
       DATEDIFF(hemas.sacrifice_datetime, mice.birth_date) / 7 > 18)
  AND (DATEDIFF(hemas.sacrifice_datetime, mice.birth_date) / 7 < 57 OR
       DATEDIFF(hemas.sacrifice_datetime, mice.birth_date) / 7 > 61)
  AND project_types.name IN ('KOMP2', 'K2P2EA', 'K2P2LA', 'K2P2LWT');