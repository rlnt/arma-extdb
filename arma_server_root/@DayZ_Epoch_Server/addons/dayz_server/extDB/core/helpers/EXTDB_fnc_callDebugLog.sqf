// ===========================================================================
// :: Adopted for EXTDB from IBEN's private config fnc library (IBEN_fnc_callDebugLog)
// ===========================================================================
// FUNCTIONS LIBRARY >> DEBUG >> fnc_callDebugLog.sqf
// ===========================================================================
// @Function name: EXTDB_fnc_callDebugLog
// ===========================================================================
// @Info:
//  - Created by @iben for DayzEpoch 1.0.6.2+
//  - Version: 1.0, Last Update [2017-09-27]
//  - Credits:
//    * Bohemia Interactive
//    * DayZ Epoch developers, collaborators and contributors
//     (thank you guys for your excellent work!)
// @Remarks:
//  - Designed to be universal debug logger
//    * In 'config.hpp' enable/disable '__EXTDBGEN__'
//    * In this fnc enable/disable '__EXTDBINT__'
//    * If '__EXTDBGEN__' if OFF, all logs are disabled.
//    * If '__EXTDBGEN__' is ON and '__EXTDBINT__' is OFF,
//      only RPT log is available
//    * If both are enabled, RPT log and user screen (systemChat)
//      logs are available
// @Parameters:
//  - Caller ID : What is calling script?                             | string
//  - Source ID : Who is answering call?                              | string
//  - Message                                                         | string
// @Prerequisities:
//  - 'EXTDB_FNCFG.hpp'
//  - 'EXTDB_fnc_paramCheck'
// @Example:
//  - #Example01: Scenario description
//    * _m = format ["My message (%1)",_lvar];
//    * _null = ["_callerID","_sourceID",_m] call EXTDB_fnc_callDebugLog;
// @Returns:
//  - Boolean
// ===========================================================================
// @Parameters Legend:
//  * _i  : _callerID
//  * _s  : _sourceID
//  * _m  : _msg
//  * _p  : _paramCheck
//  * _r  : _return
// ===========================================================================

// EXTDB_fnc_callDebugLog = {

  // -------------------------------------------------------------------------
  // :: Preprocessor limitation for defining paths... Leave it this way
  #include "EXTDB_cfg_format.hpp"

  // *************************************************************************
  // :: @update: Uncomment this line if you want to see debug log on your screen!
  // :: Do not use it in production server!
  #define __EXTDBINT__
  // *************************************************************************

  // -------------------------------------------------------------------------
  // :: Initiate params
  private ["_i","_s","_m"];
  _i = (_this select 0); // Caller :: What is making call?
  _s = (_this select 1); // Source :: What is answering call?
  _m = (_this select 2);

  // -------------------------------------------------------------------------
  // :: Intitiate return
  private "_r";
  _r = false;

  // -------------------------------------------------------------------------
  // :: Param check
  private "_p";
  _p = [
     _i
    ,[(count _this),3]
    ,[_i,_s,_m],["STRING","STRING","STRING"]
  ] call EXTDB_fnc_paramCheck;

  if (!_p) exitWith {
    // See RPT
    _r
  };

  // -------------------------------------------------------------------------
  // :: If general debug is enabled in 'config.hpp' file, log errors to RPT
  #ifdef __EXTDBGEN__
    DBG(_i,_s,_m);
    _r = true;
  #endif

  // -------------------------------------------------------------------------
  // :: If specific debug is enabled, log errors on player screen
  #ifdef __EXTDBINT__
    DBS(_i,_s,_m);
    _r = true;
  #endif

  // -------------------------------------------------------------------------
  // :: Output
  _r

// };


// === :: FUNCTIONS LIBRARY >> DEBUG >> fnc_callDebugLog.sqf :: END
