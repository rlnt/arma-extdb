// ===========================================================================
// :: Credits: Bryan "Tonic" Boardwine (mresString), Declan Ireland (fn_strip.sqf)
// ---------------------------------------------------------------------------
// :: Package is prepared for shared mode > multiple addon authors using extDB3
// :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
// :: Ported for DayzEpoch 1.0.6.2+ by @iben
// :: last update [2017-11-23]
// ===========================================================================

// ---------------------------------------------------------------------------
#include "EXTDB_cfg_format.hpp"

// ---------------------------------------------------------------------------
private ["_s","_b"];
_s = _this;

// ---------------------------------------------------------------------------
private "_p";
_p = [("EXTDB_fnc_sanitize"),[(count [_s]),1],[_s],["STRING"]] call EXTDB_fnc_paramCheck;
if !(_p) exitWith { /* See RPT log*/ };

// ---------------------------------------------------------------------------
_s = (toArray _s);
{
  if (_x in BADCHARSTOSTRIP) then {
    _s set [_forEachIndex, -1];
  };
} forEach _s;

// ---------------------------------------------------------------------------
_s = _s - [-1];
_s = (toString _s);

// ---------------------------------------------------------------------------
_s
