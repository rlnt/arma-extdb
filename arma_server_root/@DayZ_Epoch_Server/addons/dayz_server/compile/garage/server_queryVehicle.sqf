// ===========================================================================
// VIRTUAL GARAGE
// @by oiad (AKA salival)
// Original source files: https://github.com/oiad/virtualGarage
// This file original source: https://github.com/oiad/virtualGarage/blob/master/dayz_server/compile/garage/server_queryVehicle.sqf
// ---------------------------------------------------------------------------
// :: This files is used just as an example of extDB3 implementation
// :: original source last commit [https://github.com/oiad/virtualGarage/commit/c9a255de80bbec669159d3c56923cb6023b25ad4]
// :: last update [2017-11-23]
// ===========================================================================
private ["_player","_result","_clientID","_playerUID"];

// ---------------------------------------------------------------------------
_player = _this select 0;
_clientID = owner _player;
_playerUID = [(getPlayerUID _player),(_this select 1)] select (count _this > 1);

// ---------------------------------------------------------------------------
// :: @extDB3
_result = [2,"VGAR",(format ["queryVehicle:%1",_playerUID])] call EXTDB_fnc_APICall;

// ---------------------------------------------------------------------------
PVDZE_queryVehicleResult = _result;
if (!isNull _player) then {
  _clientID publicVariableClient "PVDZE_queryVehicleResult";
};
