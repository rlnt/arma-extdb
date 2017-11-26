// ===========================================================================
// :: Package is prepared for shared mode > multiple addon authors using extDB3
// :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
// :: Ported for DayzEpoch 1.0.6.2+ by @iben
// :: last update [2017-11-23]
// ===========================================================================

// ---------------------------------------------------------------------------
#include "EXTDB_cfg_admin.hpp"
#include "EXTDB_cfg_format.hpp"

// ---------------------------------------------------------------------------
// :: Initiate params
private ["_s","_o","_m"];
_s = (_this select 0); // source
_o = (_this select 1); // extDB LOG protocol
_m = (_this select 2); // message

// ---------------------------------------------------------------------------
// :: Intitiate return
private "_r";
_r = false;

// ---------------------------------------------------------------------------
private "_n";
if ((count EXTDB_LG_POOL) == 0) exitWith {
  _n = [_s,"EXTDB_fnc_callEXTLog",FSTR1("You're trying to call extDB LOG protocol [%1] which doesn't exists! Exiting.",_o)] call EXTDB_fnc_callDebugLog;
  _r
};

// ---------------------------------------------------------------------------
// :: Param check
private "_p";
_p = [_s,[(count _this),3],[_s,_o,_m],["STRING","STRING","STRING"]] call EXTDB_fnc_paramCheck;
if (!_p) exitWith {_r};

// ---------------------------------------------------------------------------
// :: LOG protocol validation
private "_a";
_a = [];
{_a set [count _a,(_x select 1)]} count EXTDB_LG_POOL;

if !(_o in _a) exitWith {
  _n = [_s,"EXTDB_fnc_callEXTLog",FSTR1("Your extDB LOG protocol [%1] is probably misspelled. Check config!",_o)] call EXTDB_fnc_callDebugLog;
  _r
};

// ---------------------------------------------------------------------------
// :: All ok, send request
EXTDB callExtension format ["1:%1:%2",_o,_m];
_r = true;

// ---------------------------------------------------------------------------
_r
