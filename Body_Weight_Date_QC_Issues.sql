--Body Weight Date QC Issues

--The SQL statement below retrieves mice with incorrect ages and datetimes in the body weight procedure. Most incorrect ages and datetimes occur in the gross pathology procedure. See the queried data in Body_Weight_Timepoint_QC_Issues.xlsx (attached).

SELECT DISTINCT wts.mouse_name,
                project_types.name,
                mice.birth_date,
                wts.weight,
                datediff(date(wts.datetime), mice.birth_date) / 7 AS mouse_age,
                wts.datetime,
                wts.created,
                wts.modified,
                pp.scheduled,
                wts.type,
                wts.week
FROM wts
         INNER JOIN project_procedures pp ON pp.id = wts.project_procedure_id
         INNER JOIN mice ON mice.mouse_id = wts.mouse_name
         INNER JOIN projects ON projects.id = mice.project_id
         INNER JOIN project_types ON project_types.id = projects.project_type_id
WHERE project_types.name IN ('KOMP2', 'K2P2EA')
  AND datediff(wts.datetime, mice.birth_date) > 124 OR datediff(wts.datetime, mice.birth_date) < 23
GROUP BY wts.mouse_name, pp.scheduled, wts.datetime
ORDER BY wts.mouse_name, wts.datetime;

--The SQL statement below retrieves data showing that mice with incorrect ages and datetimes have duplicated body weights and duplicated scheduled dates in the gross pathology procedure. See the queried data in Duplicated_Body_Weights_Scheduled_Dates_Gross_Pathology.xlsx (attached).

SELECT wts1.mouse_name,
       project_types.name,
       mice.birth_date,
       wts1.weight,
       datediff(date(wts1.datetime), mice.birth_date) / 7 AS mouse_age,
       wts1.datetime,
       wts1.created,
       wts1.modified,
       pp.scheduled,
       wts1.type,
       wts1.week
FROM wts wts1
         INNER JOIN project_procedures pp ON pp.id = wts1.project_procedure_id
         INNER JOIN mice ON mice.mouse_id = wts1.mouse_name
         INNER JOIN projects ON projects.id = mice.project_id
         INNER JOIN project_types ON project_types.id = projects.project_type_id
         INNER JOIN (
    SELECT DISTINCT wts.mouse_name
    FROM wts
             INNER JOIN project_procedures pp ON pp.id = wts.project_procedure_id
             INNER JOIN mice ON mice.mouse_id = wts.mouse_name
             INNER JOIN projects ON projects.id = mice.project_id
             INNER JOIN project_types ON project_types.id = projects.project_type_id
    WHERE project_types.name IN ('KOMP2', 'K2P2EA')
        AND datediff(wts.datetime, mice.birth_date) > 124
       OR datediff(wts.datetime, mice.birth_date) < 23
    GROUP BY wts.mouse_name, pp.scheduled) AS wts2
                    ON wts2.mouse_name = wts1.mouse_name
ORDER BY wts1.mouse_name, wts1.datetime;
