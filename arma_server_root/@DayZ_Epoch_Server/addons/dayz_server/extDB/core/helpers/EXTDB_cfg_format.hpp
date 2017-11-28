// ===========================================================================
// :: Package is prepared for shared mode > multiple addon authors using extDB3
// :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
// :: Ported for DayzEpoch 1.0.6.2+ by @iben
// :: last update [2017-11-23]
// ===========================================================================

// ---------------------------------------------------------------------------
// :: Function lib identification
#define MODULENAME "EXTDB"

// ---------------------------------------------------------------------------
// :: extDB codename
#define EXTDB "extDB3"

// ---------------------------------------------------------------------------
// :: Bad chars for strip. Why?
//    > SQL friendly code
//    > SQL safe code (SQL injections - client side inputs i.e. player name:
//      we will not force admins to setup BEC config (player name restriction)
//    > To convert char just use > diag_log format ["%1",(toArray(yourBadChar))];
//    > Bellow definition is: '/\`:|;,{}-""<>
// :: Important: has to be ARRAY!
#define BADCHARSTOSTRIP [60,62,38,123,125,91,93,59,58,39,96,126,44,46,47,63,124,92,34]

// ---------------------------------------------------------------------------
// :: Common strings
#define FATALSTR "FATAL ERROR"

// ---------------------------------------------------------------------------
// :: Debug logging
// :: There are 3 main debug log types:
// :: (1) '__EXTDBGEN__' >> enable/disable in this file (bellow). If enabled,
//        you can see general log in RPT file
// :: (2) '__EXTDBINT__'   >> enable/disable inside 'helpers\EXTDB_fnc_callDebugLog'.
//        If enabled, you can see general log in RPT file + on user display screen
// :: NOTE_1: Do not define these macros inside functions! Leave this job for global
//            'EXTDB_fnc_callDebugLog' function. This way you can generally toggle
//            your 'log to RPT' or 'log on screen' option from one place,
//            instead of each fnc separately.
// :: (3) '__ROOTDBG__' >> enable/disable in this file (bellow). If enabled,
//        you can see autodiscovered addon root path in RPT file
// ***************************************************************************
#define __EXTDBGEN__
#define __ROOTDBG__
// ***************************************************************************

// ---------------------------------------------------------------------------
// :: Common formatting patterns
#define FSTR1(ST,p1) (format [ST,p1])
#define FSTR2(ST,p1,p2) (format [ST,p1,p2])
#define FSTR3(ST,p1,p2,p3) (format [ST,p1,p2,p3])
#define FSTR4(ST,p1,p2,p3,p4) (format [ST,p1,p2,p3,p4])
#define FSTR5(ST,p1,p2,p3,p4,p5) (format [ST,p1,p2,p3,p4,p5])
#define FSTR6(ST,p1,p2,p3,p4,p5,p6) (format [ST,p1,p2,p3,p4,p5,p6])

// ---------------------------------------------------------------------------
// :: Debug msg format
//    >> CALLER : File making call
//    >> SRC    : Source script processing call
#define DBG(CALLER,SRC,MSG) diag_log format ["=== [%1, [%2]] || DEBUG :: [%3] >> %4",MODULENAME,CALLER,SRC,MSG]
#define DBS(CALLER,SRC,MSG) systemChat format ["=== [%1, [%2]] || DEBUG :: [%3] >> %4",MODULENAME,CALLER,SRC,MSG]
