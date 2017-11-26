// ===========================================================================
// VIRTUAL GARAGE
// @by oiad (AKA salival)
// Original source files: https://github.com/oiad/virtualGarage
// This file original source: https://github.com/oiad/virtualGarage/blob/master/dayz_server/compile/garage/server_storeVehicle.sqf
// ---------------------------------------------------------------------------
// :: This files is used just as an example of extDB3 implementation
// :: original source last commit [https://github.com/oiad/virtualGarage/commit/c9a255de80bbec669159d3c56923cb6023b25ad4]
// :: last update [2017-11-23]
// ===========================================================================
private ["_vehicle","_player","_clientID","_playerUID","_name","_class",
"_charID","_damage","_fuel","_hit","_inventory","_query","_array","_hit",
"_selection","_colour","_colour2","_displayName","_dateFormat"];

// ---------------------------------------------------------------------------
_vehicle = _this select 0;
_player = _this select 1;
_woGear = _this select 2;
_clientID = owner _player;
_playerUID = [(getPlayerUID _player),(_this select 3)] select (count _this > 3);

// ---------------------------------------------------------------------------
// :: extDB3
private "_locTime";
_locTime = [] call EXTDB_fnc_getLocalTime;
_dateFormat = format ["%1-%2-%3",(_locTime select 2),(_locTime select 1),(_locTime select 0)];

// ---------------------------------------------------------------------------
// :: extDB3
_class = typeOf _vehicle;
_displayName = ((getText(configFile >> "cfgVehicles" >> _class >> "displayName")) call EXTDB_fnc_sanitize);
_name = ["unknown player",((name _player) call EXTDB_fnc_sanitize)] select (alive _player); // @info: tested with username: 'dev:"Test'

// ---------------------------------------------------------------------------
_charID = _vehicle getVariable ["CharacterID","0"];
_damage = damage _vehicle;
_fuel = fuel _vehicle;
_colour = _vehicle getVariable ["Colour","0"];
_colour2 = _vehicle getVariable ["Colour2","0"];

// ---------------------------------------------------------------------------
_array = [];
_inventory = [[[],[]],[[],[]],[[],[]]];

if (isNil "_colour") then {_colour = "0";};
if (isNil "_colour2") then {_colour2 = "0";};

_hitpoints = _vehicle call vehicle_getHitpoints;

{
  _hit = [_vehicle,_x] call object_getHit;
  _selection = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "HitPoints" >> _x >> "name");
  if (_hit > 0) then {_array set [count _array,[_selection,_hit]]};
} count _hitpoints;

if (!_woGear) then {_inventory = [getWeaponCargo _vehicle,getMagazineCargo _vehicle,getBackpackCargo _vehicle];};

// ---------------------------------------------------------------------------
// :: extDB3
private "_null";
_query = format [
   "storeVehicle:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12"
  ,_playerUID,_name,_displayName,_class,_dateFormat,_charID,_inventory,_array,_fuel,_damage,_colour,_colour2
];
_null = [1,"VGAR",_query] call EXTDB_fnc_APICall;

// ---------------------------------------------------------------------------
PVDZE_storeVehicleResult = true;
if (!isNull _player) then {_clientID publicVariableClient "PVDZE_storeVehicleResult";};

// ---------------------------------------------------------------------------
// :: extDB3 > Addon specific logfile
private "_m";
_m = format ["GARAGE: %1 (%2) stored %3 @%4 %5",_name,_playerUID,_class,mapGridPosition (getPosATL _player),getPosATL _player];
_null = ["server_storeVehicle","VIRGA",_m] call EXTDB_fnc_callEXTLog;
