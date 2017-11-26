// ===========================================================================
// :: Package is prepared for shared mode > multiple addon authors using extDB3
// :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
// :: Ported for DayzEpoch 1.0.6.2+ by @iben
// :: last update [2017-11-23]
// ===========================================================================

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                            CFG SETTINGS
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// ---------------------------------------------------------------------------
// :: Required extDB version
#define EXTDB_REQ_VERSION 1.032

// ---------------------------------------------------------------------------
// :: Database(s)
//    > I've just created table(s) inside default Epoch database >> Leave this part alone - go to Protocol section bellow!
//    > I've just created new database for my project >> Add database name to array (follow first example)
//    + (_this select 0) : Database name
//    + (_this select 1) : Alias to be shown in RPT log (any string - it's for you)

// -- Template for database pool:
// #define EXTDB_DB_POOL [ \
//    ["database_name1","database_name_alias1"] \
//   ,["database_name2","database_name_alias2"] \
// ]
#define EXTDB_DB_POOL [ \
   ["vehicle_manager","myCodeNameForDB1"] \
  ,["new_addon_db","myCodeNameForDB2"] \
]

// ---------------------------------------------------------------------------
// :: Database session protocol definition
//    > (_this select 0) : Database name you're using (make sure it's already in 'EXTDB_DB_POOL')
//    > (_this select 1) : Protocol unique ID (name) for your session
//    > (_this select 2) : Your custom addon ini file inside 'sql_custom' folder
//    > (_this select 3) : Alias for (_this select 0) to be shown in RPT log (any string - it's for you)
// :: Put most used protocols at the top - there is a tiny performace benefit!

// -- Template for session protocol pool:
// #define EXTDB_PS_POOL [ \
//    ["database_name1","unique_procol_name1","addon1-conf.ini","protocol_name_alias1"] \
//   ,["database_name1","unique_procol_name2","addon2-conf.ini","protocol_name_alias2"] \
//   ,["database_name2","unique_procol_name3","addon3-conf.ini","protocol_name_alias3"] \
// ]

#define EXTDB_PS_POOL [ \
   ["vehicle_manager","VGAR","vg-conf.ini","Garage"] \
  ,["vehicle_manager","ADDON2","addon2-conf.ini","protocolAlias2"] \
  ,["new_addon_db","ADDON3","addon3-conf.ini","protocolAlias3"] \
]

// ---------------------------------------------------------------------------
// :: Custom LOG protocol definition
//    > (_this select 0) : Database name you're using (make sure it's already in 'EXTDB_DB_POOL' and 'EXTDB_PS_POOL')
//    > (_this select 1) : Unique name for your log protocol
//    > (_this select 2) : Unique filename for separate logfile inside "logs" folder
// :: Leave it alone, if you are about to use 'diag_log' to RPT log only

// -- Template for LOG protocol:
// #define EXTDB_LG_POOL [ \
//    ["database_name1","unique_log_protocol_name1","unique_logfile_name1"] \
//   ,["database_name2","unique_log_protocol_name2","unique_logfile_name2"] \
//   ,["database_name3","unique_log_protocol_name3","unique_logfile_name3"] \
// ]

#define EXTDB_LG_POOL [ \
   ["vehicle_manager","VIRGA","virtual_garage"] \
  ,["new_addon_db","NEWAD","new_addon_logfile"] \
]

// ---------------------------------------------------------------------------
// :: Set you stored procedures run request (if any...)
//    > You procedures has to already exists inside your config file 'addon-conf.ini'
//      inside 'sql_custom' folder

// --- Template for stored procedures pool:
// #define EXTDB_PR_POOL [ \
//    [SCALAR(async_call_type),"unique_procol_name1","query","procedure_alias1"] \
//   ,[SCALAR(async_call_type),"unique_procol_name2","query","procedure_alias2"] \
//   ,[SCALAR(async_call_type),"unique_procol_name3","query","procedure_alias3"] \
// ]

#define EXTDB_PR_POOL [ \
  [1,"VGAR","RemoveOldVG","VG Cleanup"] \
]
