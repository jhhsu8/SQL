This repository contains SQL statements used for fixing, analyzing or detecting data quality issues. Please see comments in the files.

Body_Weight_Date_QC_Issues.sql:

This file contains statements for retrieving mice with incorrect ages and datetimes in the body weight procedure table. 

Clinical_Chemistry_Date_QC_Issues.sql:

This file contains statements for fixing incorrect blood collection dates.

Hematology_Date_QC_Issues.sql:

This file contains statements for fixing blood collection/sacrifice dates.

Insulin_Date_QC_Issues.sql:

This file contains statements for fixing blood collection dates.

Open_Field_QC_Issues.sql:

This file contains statements for fixing the open field data where whole arena average speeds and total distances travelled are zero but the center/periphery speeds and distances travelled are not zero.

incorrect_mouse_ages.sql:

This file contains statements for retrieving mice mouse records with incorrect mouse ages at the time of blood collection (collection_age)

incorrect_tissue_expression.sql:

This file contains statements for changing organs (e.g. brain) of mice from "tissue not available" to "expression" or "no expression"
