// ===========================================================================
// :: Package is prepared for shared mode > multiple addon authors using extDB3
// :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
// :: Ported for DayzEpoch 1.0.6.2+ by @iben
// :: last update [2017-11-23]
// ===========================================================================

// ---------------------------------------------------------------------------
#include "helpers\EXTDB_cfg_admin.hpp"
#include "helpers\EXTDB_cfg_format.hpp"

// ---------------------------------------------------------------------------
private ["_iTime","_sourceID","_re","_null"];
_iTime = (diag_tickTime);
_sourceID = "EXTDB_postConnect";
_re = false;

// ---------------------------------------------------------------------------
// :: Exit, if there is no connection at all
if (isNil "EXTDB_connected") exitWith {
  _null = [
     "SYSTEM",_sourceID
    ,"ERROR >> Processing DB cleaning procedure refused. No connection alive!"
  ] call EXTDB_fnc_callDebugLog;
  _re
};

// ---------------------------------------------------------------------------
// :: Exit, if connection is not 100% OK
if (EXTDB_connected in [FATALSTR,0]) exitWith {
  _null = [
     "SYSTEM",_sourceID
    ,"ERROR >> Processing DB cleaning procedure refused. Check your extDB configuration!"
  ] call EXTDB_fnc_callDebugLog;
  _re
};

// ---------------------------------------------------------------------------
// :: Processing stored procedures
_null = ["SYSTEM",_sourceID,"INFO >> DB procedures initiated..."] call EXTDB_fnc_callDebugLog;

private ["_activeSCP","_x","_pr","_paramCheck"];
_activeSCP = [];

for "_x" from 0 to ((count EXTDB_PR_POOL) - 1) do {
  _pr = (EXTDB_PR_POOL select _x); // If not valid arr, parsion error pops-up

  _paramCheck = [
     (format ["EXTDB_PR_POOL, item [%1]",_x])
    ,[(count _pr),4]
    ,[(_pr select 0),(_pr select 1),(_pr select 2),(_pr select 3)]
    ,["SCALAR","STRING","STRING","STRING"]
  ] call EXTDB_fnc_paramCheck;

  if (_paramCheck) then {
    _null = [(_pr select 0),(_pr select 1),(_pr select 2)] call EXTDB_fnc_APICall;
    _activeSCP set [count _activeSCP, _x];
    _null = [
       "SYSTEM",_sourceID
      ,FSTR2("INFO >> Stored procedure [%1-%2] fired...",_x,(_pr select 3))
    ] call EXTDB_fnc_callDebugLog;

  };
};

// ---------------------------------------------------------------------------
// :: Final evaluation
if ((count EXTDB_PR_POOL) == (count _activeSCP)) then {_re = true;};
_null = [
   "SYSTEM",_sourceID
  ,FSTR2("INFO >> Cleaning procedure finished in [%1 seconds] with status [%2].", (diag_tickTime - _iTime),_re)
] call EXTDB_fnc_callDebugLog;

// ---------------------
_re
