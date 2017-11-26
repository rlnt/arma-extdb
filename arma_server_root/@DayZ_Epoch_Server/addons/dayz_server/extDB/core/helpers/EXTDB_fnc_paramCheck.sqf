// ===========================================================================
// :: Adopted for EXTDB from IBEN's private config fnc library (EXTDB_fnc_paramCheck)
// ===========================================================================
// FUNCTIONS LIBRARY >> DEBUG >> fnc_paramCheck.sqf
// ===========================================================================
// @Function name: EXTDB_fnc_paramCheck
// ===========================================================================
// @Info:
//  - Created by @iben for DayzEpoch 1.0.6.2+
//  - Version: 1.0, Last Update [2017-09-27]
//  - Credits:
//    * Bohemia Interactive
//    * DayZ Epoch developers, collaborators and contributors
//     (thank you guys for your excellent work!)
// @Remarks:
//  - Designed to be used in scripts as params check procedure.
//    * Included checks for number of params, typeNames and isNil-isNull test
//    * Can be called multiple times in one function so you can design passed
//      params to fit your needs
//    * '__EXTDBGEN__' :: Enable general RPT log (EXTDB_FNCFG.hpp)
//    * '__EXTDBINT__'   :: Enable debug log output on the screen via systemChat
//      in 'EXTDB_fnc_callDebugLog'
//    * Self params check included :)
// @Parameters:
//  - _ID (caller ID): Custom string to help identify script
//    calling 'EXTDB_fnc_paramCheck' in RPT log                       | string
//  - Array of params numbers: [caller current, expected]             | array
//  - Array of local vars representing passed params (_this)          | array
//  - Array of required typeNames for passed params (_this)           | array
// @Prerequisities:
//  - 'EXTDB_FNCFG.hpp'
//  - 'EXTDB_fnc_callDebugLog'
// @Example:
//  - #Example01: 1 param :: 1 typeName
//    * ["_callerID",[(count _this),1],[_lvar],['STRING']] call EXTDB_fnc_paramCheck;
//  - #Example02: 1 param :: multiple acceptable typeNames
//    * ["_callerID",[(count _this),2],[_lvar1,_lvar2],['STRING',['SCALAR','ARRAY']]] call EXTDB_fnc_paramCheck;
//  - #Example03: Real world usage :: Your function
/*    _myFNC = {
        private ["_bool","_arr","_scalar","_return"];
        // :: Variables with expected typeNames
        _callerID = (_this select 0);
        _bool = (_this select 1);
        _arr = (_this select 2);
        _scalar = (_this select 3);
        _return = false;
        // :: First we need to check if 3 params are passed into fnc
        //    (all 4 are mandatory), next we need to check if first layer of params
        //    meets expected typeNames:
        private "_firstLayerCheck";
        _firstLayerCheck = [                          // Top level check (use once)
           _callerID
          ,[(count _this),4]                          // [(current status),(expected status)]
          ,[_callerID,_bool,_arr,_scalar]             // [(current status)
          ,["STRING","BOOL","ARRAY","SCALAR"]         // [(expected status)]
        ] call _EXTDB_fnc_paramCheck;
        if !(_firstLayerCheck) exitWith {
           // log on screen and in RPT
          _return
        };
        // :: Later we for example need to check second layer: let's say, '_arr' variable
        //    has to include only specific typeNames:
        private "_secondLayerCheck";
        _secondLayerCheck = [                        // Specific check (use as you need)
           (format ["%1 >> '_arr test'",_callerID])
          ,[(count _arr),2]                          // [(current status),(expected status)]
          ,[(_arr select 0),(_arr select 1)]         // [(current status)
          ,["STRING","SCALAR"]                       // [(expected status)]
        ] call _EXTDB_fnc_paramCheck;
          if !(_secondLayerCheck) exitWith {
            /* log on screen and in RPT
            _return
          };
        // :: Rest of your procedure
        if (_bool) then {
          systemChat "Hello world!";
          _return = true;
        };
        // :: Return
        _return
      };
      // :: Now you calling '_myFNC' from somewhere in your files
      _null = ["MyScriptFile",true,["Hello",4],4] call _myFNC;
      // :: If there is a problem, you will see it...
*/
// @Returns:
//  - Boolean
// ===========================================================================

// EXTDB_fnc_paramCheck = {

  // -------------------------------------------------------------------------
  // :: Preprocessor limitation for defining paths... Leave it this way
  #include "EXTDB_cfg_format.hpp"

  // -------------------------------------------------------------------------
  // :: Initiate  lvars
  private ["_callerID","_callersParams","_callersArg","_callersTypeN"];
  _callerID = ["UNKNOWN CALLER", (_this select 0)] select ((typeName (_this select 0)) == "STRING");
  _callersParams = (_this select 1);
  _callersArg = (_this select 2);
  _callersTypeN = (_this select 3);

  // -------------------------------------------------------------------------
  // :: Source ID
  private "_sourceID";
  _sourceID = "EXTDB_fnc_paramCheck";

  // -------------------------------------------------------------------------
  private ["_return","_callersParamsCheckFailed"];
  _callersParamsCheckFailed = false;
  _return = true;

  // -------------------------------------------------------------------------
  // :: Helper _fnc for '(4) Check params for nil'
  private "_fnc_is_NilNull";
  _fnc_is_NilNull = {
    private ["_nilIndexArr","_callersArgArr","_y","_param"];
    _nilIndexArr = [];
    _callersArgArr = (_this select 2);
    // -----------------------------------------------------------------------
    // :: We need to check '_callersParams' elements first so we can assign
    // :: proper check msg output. Let's check it and store to lvar, so we
    // :: don't need to do it again later when testing params logic
    if ((_callersParams select 0) != (_callersParams select 1)) exitWith {
      _callersParamsCheckFailed = true;
      _nilIndexArr
    };
    // -----------------------------------------------------------------------
    for "_y" from 0 to ((count _callersArgArr) - 1) do {
      _param = (_callersArgArr select _y);
      if (isNil "_param") then {
        _nilIndexArr set [count _nilIndexArr, _y];
      };
      if ((typeName _param) == "OBJECT") then {
        if (isNull _param) then {
          _nilIndexArr set [count _nilIndexArr, _y];
        };
      };
    };
    // -----------------------------------------------------------------------
    _nilIndexArr
  };

  // -------------------------------------------------------------------------
  // :: Basic internal param check: Exit immediatelly on the first error
  private ["_m","_mtype","_msgArr1","_infostring1","_null"];
  call {
    // -----------------------------------------------------------------------
    // :: (1) Num of params has to be 4 mandatory
    if ((count _this) < 4) exitWith {
      _m = FSTR1("Wrong number of params. Expected >> [4], received >> [%1]", (count _this));
      _return = false;
    };

    // -----------------------------------------------------------------------
    // :: (2) The first argument (sender identification) has to be
    // ::     non-empty string (no anonym debug log)
    if ((typeName (_this select 0)) != "STRING") exitWith {
      _m = FSTR1("Cannot read caller ID. Caller ID is the first argument which should be >> ['STRING'], received >> [%1]. For caller ID use something descriptive (..what are you testing when calling this fnc?), make your life easier :)", (typeName (_this select 0)));
      _return = false;
    };

    // -----------------------------------------------------------------------
    // :: (3) Second, third and fourth argument has to be an array:
    // ::     [[args],[expected typeNames]]
    if (((typeName (_this select 1)) != "ARRAY") || {(typeName (_this select 2)) != "ARRAY"} || {(typeName (_this select 3)) != "ARRAY"}) exitWith {
      _m = FSTR3("Wrong typeName(s)! The second ,third and fourth param are expected to be >> ['ARRAY','ARRAY','ARRAY'], received >> [%1,%2,%3]", (typeName (_this select 1)),(typeName (_this select 2)),(typeName (_this select 3)));
      _return = false;
    };

    // -----------------------------------------------------------------------
    // :: (4) Check if all params are defined
    _msgArr1 = call _fnc_is_NilNull; // Checking '_callersArg'
    if ((count _msgArr1) > 0) exitWith {
      _infostring1 = "";
      {_infostring1 = FSTR2("%1 >> [_this select %2]", _infostring1, _x);} count _msgArr1;
      _m = FSTR1("'isNil-isNull' test failed! These params are not defined or doesn't exists in your current passed params%1", _infostring1);
      _return = false;
    };

    // -----------------------------------------------------------------------
    // :: Default: all OK, true
    _return
  };

  // -------------------------------------------------------------------------
  // :: Exit and send msg to client RPT if something goes wrong
  // :: during Basic internal param check
  if (!_return) exitWith {
    // -----------------------------------------------------------------------
    // :: Debug log
    _mtype = FSTR1("%1 || Param basic test failure!", _sourceID);
    _null = [_callerID,_mtype,_m] call EXTDB_fnc_callDebugLog;

    // -----------------------------------------------------------------------
   _return
  };

  // :: >> Basic internal check done...
  // :: >> Checking logic of sender params

  // -------------------------------------------------------------------------
  // :: Helpers
  private ["_callersArgCnt","_callersTypeNCnt"];
  _callersArgCnt = (count _callersArg);
  _callersTypeNCnt = (count _callersTypeN);

  // -------------------------------------------------------------------------
  // :: Inside logic check
  call {
    // -----------------------------------------------------------------------
    // :: Number of caller params counts arr elements has to be 2 ['SCALAR','SCALAR']
    if ((count _callersParams) != 2) exitWith {
      _m = FSTR3("Second parameter is array and it's expected to have >> [2] scalars [(count _this),scalar]. Received >> [%1] scalar(s) [%2,%3]", (count _callersParams),(typeName (_callersParams select 0)),(typeName (_callersParams select 1)));
      _return = false;
    };

    // -----------------------------------------------------------------------
    // :: Number of caller current number of params (count _this) has to be equal
    // :: to number of expected params
    if (_callersParamsCheckFailed) exitWith {
      _m = FSTR2("Current number of params >> [%1] doesn't match expected number of arguments >> [%2]!", (_callersParams select 0),(_callersParams select 1));
      _return = false;
    };
    // -----------------------------------------------------------------------
    // :: Number of callers current number of params has to be equal to number of defined arguments and number of required typeNames
    if (((_callersParams select 0) != _callersArgCnt) || {(_callersParams select 0) != _callersTypeNCnt}) exitWith {
      _m = FSTR3("Current number of callers params >> [%1] doesn't match provided number of param(s) for check >> [%2], or number of requiring typeName(s) >> [%3]!", (_callersParams select 0), _callersArgCnt, _callersTypeNCnt);
      _return = false;
    };
    // -----------------------------------------------------------------------
    // :: Default: All ok, true
    _return
  };

  // -------------------------------------------------------------------------
  // :: Exit and send msg to client RPT if something goes wrong
  // :: during inside logic check
  if (!_return) exitWith {
    // -----------------------------------------------------------------------
    // :: Debug log
    _mtype = FSTR1("%1 || Params logic test failure!", _sourceID);
    _null = [_callerID,_mtype,_m] call EXTDB_fnc_callDebugLog;

    // -----------------------------------------------------------------------
   _return
  };

  // :: Inside logic done
  // :: Let's check all typeNames

  // -------------------------------------------------------------------------
  // :: Scan all, give complete info:
  // :: [(index (+1 to balance zero based)),(given typeName),(expected typeName)]
  private ["_msgArr2","_x","_isVal","_isArr","_callCheck"];
  _msgArr2 = [];
  for "_x" from 0 to (_callersArgCnt - 1) do {
    // -----------------------------------------------------------------------
    _isVal = {
      if ((typeName (_callersArg select _x)) != (_callersTypeN select _x)) then {
        _msgArr2 set [count _msgArr2, [_x,(typeName (_callersArg select _x)),(_callersTypeN select _x)]];
      }
    };
    // -----------------------------------------------------------------------
    _isArr = {
      if !((typeName (_callersArg select _x)) in (_callersTypeN select _x)) then {
        _msgArr2 set [count _msgArr2, [_x,(typeName (_callersArg select _x)),(_callersTypeN select _x)]];
      };
    };
    // -----------------------------------------------------------------------
    _callCheck = [_isVal,_isArr] select ((typeName (_callersTypeN select _x)) == "ARRAY");
    // -----------------------------------------------------------------------
    call _callCheck;
  };

  // -------------------------------------------------------------------------
  // :: Check if there is any error msg. If so, generate infostring
  private "_infostring2";
  _infostring2 = "";
  if ((count _msgArr2) > 0) then {
    {
      _infostring2 = FSTR4("%1 >> [_this select %2] param is expected to be >> [%4], received >> [%3]", _infostring2, (_x select 0),(_x select 1),(_x select 2));
    } count _msgArr2;
    _return = false;
  };

  // -------------------------------------------------------------------------
  // :: In case of check failure log to RPT
  if (!_return) exitWith {
    _m = FSTR1("Caller script params test failure! Wrong typeName!%1", _infostring2);
    _null = [_callerID,_sourceID,_m] call EXTDB_fnc_callDebugLog;

    // -----------------------------------------------------------------------
    // :: Return boolean
    _return
  };

  // -------------------------------------------------------------------------
  // :: Return boolean
  _return

// };


// === :: FUNCTIONS LIBRARY >> DEBUG >> fnc_paramCheck.sqf :: END
