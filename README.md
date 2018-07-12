# ControlM V7 - Automation via CLI

Shell scripts for automating tasks in a CONTROL M V7 using utilities provided by BMC.

| Script | What does it do? | Usage |
|---|------|---|
|`create_node_groups.sh` | Reads through a properties file (example: `properties/nodegroups_create.properties`) and create node groups. | ```./create_node_groups.sh PATH_TO_PROPERTIES``` |
|`delete_node_groups.sh` | Deletes all node groups in the properties file (example: `properties/nodegroups_delete.properties`). | ```./delete_node_groups.sh PATH_TO_PROPERTIES``` |
|`hold_all_jobs.sh` | Holds all jobs in a table from AJF (or control m EM). | ```./hold_all_jobs.sh TABLE_NAME``` |
|`delete_all_jobs.sh` | Deletes all jobs in a table from AJF (or control m EM). Only jobs in held state are deleted, so script to hold jobs needs to be run first. | ```./delete_all_jobs.sh TABLE_NAME``` |
