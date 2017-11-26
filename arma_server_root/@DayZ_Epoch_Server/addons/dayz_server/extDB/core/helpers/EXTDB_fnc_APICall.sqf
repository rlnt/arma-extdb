// ===========================================================================
// extDB3 author: Bryan "Tonic" Boardwine
// extDB3 source: https://bitbucket.org/torndeco/extdb3/src
// extDB3 licence: https://bitbucket.org/torndeco/extdb3/wiki/Home
// ! Read licence information !
// ---------------------------------------------------------------------------
// :: Package is prepared for shared mode > multiple addon authors using extDB3
// :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
// :: Ported for DayzEpoch 1.0.6.2+ by @iben
// :: last update [2017-11-23]
// ===========================================================================

// ---------------------------------------------------------------------------
#include "EXTDB_cfg_format.hpp"

// ---------------------------------------------------------------------------
private ["_callType","_protocol","_querySTR"];
_callType = (_this select 0);
_protocol = (_this select 1);
_querySTR = (_this select 2);

private "_paramCheck";
_paramCheck = [
   ("EXTDB_fnc_APICall")
  ,[(count _this),3]
  ,[_callType,_protocol,_querySTR]
  ,["SCALAR","STRING","STRING"]
] call EXTDB_fnc_paramCheck;

if !(_paramCheck) exitWith { /* Check RPT log */ };

// ---------------------------------------------------------------------------
private "_key";
_key = EXTDB callExtension format ["%1:%2:%3",_callType,_protocol,_querySTR];

// ---------------------------------------------------------------------------
// :: Exit if we do not expect any return from query
if (_callType == 1) exitWith {true;};

// ---------------------------------------------------------------------------
_key = call compile format ["%1",_key];
_key = (_key select 1);

uiSleep (random .03);
// ---------------------------------------------------------------------------
// :: Retreive single / multipart msg [4,5] - watch wait status [3]
private ["_queryRe","_loop","_pipe"];
_queryRe = "";
_loop = true;

while {_loop} do {
  _queryRe = EXTDB callExtension format ["4:%1",_key];
  if (_queryRe == "[5]") then {
    _queryRe = "";
    while {1 == 1} do {
      _pipe = EXTDB callExtension format ["5:%1",_key];
      if (_pipe == "") exitWith {_loop = false;};
      _queryRe = _queryRe + _pipe;
    };
  } else {
    if (_queryRe == "[3]") then {
      uiSleep .1;
    } else {
      _loop = false;
    };
  };
};

// ---------------------------------------------------------------------------
_queryRe = call compile _queryRe;

// ---------------------------------------------------------------------------
// :: extDB error check > inform if somenthing goes wrong
private "_null";
if ((_queryRe select 0) == 0) exitWith {
  _null = [
     "SYSTEM","EXTDB_fnc_APICall"
    ,format ["Cannot process your API call. Reason > Protocol [%1] ERROR! > %2",_protocol,_queryRe]
  ] call EXTDB_fnc_callDebugLog;
  []
};

// ---------------------------------------------------------------------------
// :: Output
private "_return";
_return = (_queryRe select 1);
_return
