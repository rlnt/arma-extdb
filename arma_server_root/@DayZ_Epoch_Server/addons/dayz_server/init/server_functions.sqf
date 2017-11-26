// ...
// EPOCH ADDITIONS
// ...
// spawn_vehicles = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_vehicles.sqf";
// ... add bellow 'EPOCH ADDITIONS' >>

// ---------------------------------------------------------------------------
// :: EXTDB3 init
call compile preprocessFileLineNumbers "\z\addons\dayz_server\extDB\EXTDB_init.sqf";

// :: Virtual Garage implementation example (only serverside files needs update...)
call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\init.sqf";

// ---------------------------------------------------------------------------
// server_medicalSync = { ...

