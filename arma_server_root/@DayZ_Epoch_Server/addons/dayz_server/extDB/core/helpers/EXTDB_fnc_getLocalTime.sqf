// ===========================================================================
// :: Package is prepared for shared mode > multiple addon authors using extDB3
// :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
// :: Ported for DayzEpoch 1.0.6.2+ by @iben
// :: last update [2017-11-23]
// ===========================================================================

// ---------------------------------------------------------------------------
// :: Get local time || local time + specific period
// :: _nic = [Y,M,D,h,m,s] call EXTDB_fnc_getLocalTime.sqf
// :: returns ARR
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
#include "EXTDB_cfg_format.hpp"

// ---------------------------------------------------------------------------
private "_prm";
_prm = _this;

// ---------------------------------------------------------------------------
if ((typeName _prm) != "ARRAY") then {_prm = [_prm];};

// ---------------------------------------------------------------------------
private ["_cnt","_ret"];
_cnt = (count _this);

// ---------------------------------------------------------------------------
// :: User is requesting local time only
if (_cnt == 0) exitWith {
  _ret = (call compile (EXTDB callExtension "9:LOCAL_TIME")) select 1;
  _ret
};

// ---------------------------------------------------------------------------
// :: User is requesting some datetime math, but provided wrong number of params
// :: return local time only + 1day, send info
private ["_nic","_msg"];
if (_cnt < 6) exitWith {
  _ret = (call compile (EXTDB callExtension "9:LOCAL_TIME:[0,0,1,0,0,0]")) select 1;
  _msg = format[
     "ERROR >> Wrong number of params. Expected (6 - [Y,M,D,h,m,s]) > Received [%1]! Returning local time + 1DAY by default..."
    ,_cnt
  ];
  _nic = ["EXTDB_fnc_getLocalTime","VIRGA",_msg] call EXTDB_fnc_callEXTLog;
  _ret
};

// ---------------------------------------------------------------------------
// :: All OK
_ret = (call compile (EXTDB callExtension format ["9:LOCAL_TIME:%1",_prm])) select 1;
_ret
