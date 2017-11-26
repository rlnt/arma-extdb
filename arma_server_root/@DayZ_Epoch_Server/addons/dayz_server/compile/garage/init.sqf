// ===========================================================================
// VIRTUAL GARAGE
// @by oiad (AKA salival)
// Original source files: https://github.com/oiad/virtualGarage
// This file original source: https://github.com/oiad/virtualGarage/blob/master/dayz_server/compile/garage/init.sqf
// ---------------------------------------------------------------------------
// :: This files is used just as an example of extDB3 implementation
// :: original source last commit [https://github.com/oiad/virtualGarage/commit/c9a255de80bbec669159d3c56923cb6023b25ad4]
// :: last update [2017-11-23]
// ===========================================================================

// ---------------------------------------------------------------------------
server_queryVehicle = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_queryVehicle.sqf";
server_spawnVehicle = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_spawnVehicle.sqf";
server_storeVehicle = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_storeVehicle.sqf";

// ---------------------------------------------------------------------------
"PVDZE_queryVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_queryVehicle};
"PVDZE_spawnVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_spawnVehicle};
"PVDZE_storeVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_storeVehicle};
