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
private ["_iTime","_sourceID","_null","_m"];
_iTime = (diag_tickTime);
_sourceID = "EXTDB_connect";

// ---------------------------------------------------------------------------
if (isNil "EXTDB_connected") then {
  // -------------------------------------------------------------------------
  // :: [STEP-A] Ping
  _null = ["SYSTEM",_sourceID,"Connection procedure initiated..."] call EXTDB_fnc_callDebugLog;

  private "_result";
  _result = EXTDB callExtension "9:VERSION";

  if (_result == "") exitWith {
    _null = [
       "SYSTEM",_sourceID
      ,"ERROR >> Connection not found. Reason: <Probably missing dll library(-ies), wrong file placement etc. Check documentation - follow all required steps!>. Exiting."
    ] call EXTDB_fnc_callDebugLog;
    EXTDB_connected = FATALSTR;
  };

  if ((parseNumber _result) < EXTDB_REQ_VERSION) exitWith {
    _null = [
       "SYSTEM",_sourceID
      ,"ERROR >> Connection rejected. Reason: <Wrong version!>. Exiting."
    ] call EXTDB_fnc_callDebugLog;
    EXTDB_connected = FATALSTR;
  };

  // -------------------------------------------------------------------------
  // :: [STEP-B] Connect to database(es)
  _null = ["SYSTEM",_sourceID,"INFO >> DB pool processing started..."] call EXTDB_fnc_callDebugLog;

  private ["_activeDBS","_x","_db","_paramCheck"];
  _activeDBS = [];

  for "_x" from 0 to ((count EXTDB_DB_POOL) - 1) do {
    _db = (EXTDB_DB_POOL select _x); // If not valid arr, parsion error pops-up

    _paramCheck = [
       (format ["EXTDB_DB_POOL, item [%1]",_x])
      ,[(count _db),2]
      ,[(_db select 0),(_db select 1)]
      ,["STRING","STRING"]
    ] call EXTDB_fnc_paramCheck;

    if (_paramCheck) then {
      _result = call compile (EXTDB callExtension format ["9:ADD_DATABASE:%1",(_db select 0)]);

      if ((_result select 0) == 0) exitWith {
        _null = [
           "SYSTEM",_sourceID
          ,FSTR3("ERROR >> Failed to connect to database [%1-%2] > %3",_x,(_db select 1),_result)
        ] call EXTDB_fnc_callDebugLog;
      };

      _activeDBS set [count _activeDBS,(_db select 0)];
      _null = [
         "SYSTEM",_sourceID
        ,FSTR2("INFO >> Connection to database [%1-%2] set.",_x,(_db select 1))
      ] call EXTDB_fnc_callDebugLog;

    };
  };

  // -------------------------------------------------------------------------
  // :: Exit if there is not at least one alive database
  if ((count _activeDBS) == 0) exitWith {
    _null = ["SYSTEM",_sourceID,"INFO >> No database available. Exiting EXTDB initiation."] call EXTDB_fnc_callDebugLog;
    EXTDB_connected = FATALSTR;
  };

  // -------------------------------------------------------------------------
  // :: [STEP-C] Load 'SQL_CUSTOM' protocol(s) for session
  _null = ["SYSTEM",_sourceID,"INFO >> PS pool protocol started..."] call EXTDB_fnc_callDebugLog;

  private ["_activePTS","_y","_ps"];
  _activePTS = [];

  for "_y" from 0 to ((count EXTDB_PS_POOL) - 1) do {
    _ps = (EXTDB_PS_POOL select _y); // If not valid arr, parsing error pops-up

    _paramCheck = [
       (format ["EXTDB_PS_POOL, item [%1]",_y])
      ,[(count _ps),4]
      ,[(_ps select 0),(_ps select 1),(_ps select 2),(_ps select 3)]
      ,["STRING","STRING","STRING","STRING"]
    ] call EXTDB_fnc_paramCheck;

    if (_paramCheck && {(_ps select 0) in _activeDBS}) then { // if user's addon db is messed up, fuck him and force to fix
      _result = call compile (EXTDB callExtension format ["9:ADD_DATABASE_PROTOCOL:%1:SQL_CUSTOM:%2:%3",(_ps select 0),(_ps select 1),(_ps select 2)]);

      if ((_result select 0) == 0) exitWith {
        _null = [
           "SYSTEM",_sourceID
          ,FSTR3("ERROR >> Failed to set session protocol [%1-%2] > %3",_y,(_ps select 3),_result)
        ] call EXTDB_fnc_callDebugLog;
      };

      _activePTS set [count _activePTS, _y];
      _null = [
         "SYSTEM",_sourceID
        ,FSTR2("INFO >> Session protocol [%1-%2] set.",_y,(_ps select 3))
      ] call EXTDB_fnc_callDebugLog;

    };
  };

  // -------------------------------------------------------------------------
  // :: [STEP-D] Load 'LOG' protocol(s) for session
  _null = ["SYSTEM",_sourceID,"INFO >> LOG pool protocol started..."] call EXTDB_fnc_callDebugLog;

  private ["_activeLOG","_w","_lg"];
  _activeLOG = [];

  for "_w" from 0 to ((count EXTDB_LG_POOL) - 1) do {
    _lg = (EXTDB_LG_POOL select _w); // If not valid arr, parsing error pops-up

    _paramCheck = [
       (format ["EXTDB_LG_POOL, item [%1]",_w])
      ,[(count _lg),3]
      ,[(_lg select 0),(_lg select 1),(_lg select 2)]
      ,["STRING","STRING","STRING"]
    ] call EXTDB_fnc_paramCheck;

    if (_paramCheck && {(_lg select 0) in _activeDBS}) then { // if user's addon db is messed up, fuck him and force to fix
      _result = call compile (EXTDB callExtension format ["9:ADD_PROTOCOL:LOG:%1:%2",(_lg select 1),(_lg select 2)]);

      if ((_result select 0) == 0) exitWith {
        _null = [
           "SYSTEM",_sourceID
          ,FSTR3("ERROR >> Failed to set LOG protocol [%1-%2] > %3",_w,(_lg select 1),_result)
        ] call EXTDB_fnc_callDebugLog;
      };

      _activeLOG set [count _activeLOG, _w];
      _null = [
         "SYSTEM",_sourceID
        ,FSTR2("INFO >> LOG protocol [%1-%2] set.",_w,(_lg select 1))
      ] call EXTDB_fnc_callDebugLog;

    };
  };

  // -------------------------------------------------------------------------
  // :: [STEP-E] Lock (can be lock with password later if neccessary for further dev)
  _null = ["SYSTEM",_sourceID,"INFO >> Locking API..."] call EXTDB_fnc_callDebugLog;
  EXTDB callExtension "9:LOCK";

  // -------------------------------------------------------------------------
  // :: Final evaluation
  private ["_expDBS","_expPTS","_expLOG","_cndDBS","_cndPTS","_cndLOG"];
  _expDBS = (count EXTDB_DB_POOL);
  _expPTS = (count EXTDB_PS_POOL);
  _expLOG = (count EXTDB_LG_POOL);
  _cndDBS = (count _activeDBS);
  _cndPTS = (count _activePTS);
  _cndLOG = (count _activeLOG);

  EXTDB_connected = [0,1] select ((_expDBS == _cndDBS) && {_expPTS == _cndPTS} && {_expLOG == _cndLOG});
  _null = [
     "SYSTEM",_sourceID
    ,FSTR6("INFO >> Result: [%1/%2] databas(es) connected, [%3/%4] session protocol(s) set, [%5/%6] log protocol(s) set.", _cndDBS,_expDBS,_cndPTS,_expPTS,_cndLOG,_expLOG)
  ] call EXTDB_fnc_callDebugLog;

} else {
  // -------------------------------------------------------------------------
  if (EXTDB_connected != FATALSTR) then {
    _null = ["SYSTEM",_sourceID,"INFO >> Already setup and locked. Exiting."] call EXTDB_fnc_callDebugLog;
  };
};

// ---------------------------------------------------------------------------
_null = [
   "SYSTEM",_sourceID
  ,FSTR2("INFO >> Connection procedure finished in [%1 seconds] with status [%2].", (diag_tickTime - _iTime),EXTDB_connected)
] call EXTDB_fnc_callDebugLog;

// ---------------------
true
