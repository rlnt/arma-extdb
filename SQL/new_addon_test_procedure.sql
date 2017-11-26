-- ===========================================================================
-- :: Package is prepared for shared mode > multiple addon authors using extDB3
-- :: This package distribution is for testing only - still WIP (but fully working - improvements will come)
-- :: Ported for DayzEpoch 1.0.6.2+ by @iben
-- :: last update [2017-11-23]
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- CLEAN OLD VEHICLES FROM VIRTUAL GARAGE
-- ---------------------------------------------------------------------------
-- Prevent conflict if procedure already exists
DROP PROCEDURE IF EXISTS `RemoveOldVG`;
-- Procedure def
DELIMITER ;;
CREATE PROCEDURE `RemoveOldVG`()
COMMENT 'Removes old Virtual Garage Vehicles'
BEGIN
  DELETE FROM
    `garage`
  WHERE `DateStamp` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 35 DAY);
END
;;

-- ---------------------------------------------------------------------------
-- BELLOW IS TEMPLATE FOR NEW PROCEDURE
-- ---------------------------------------------------------------------------
-- DELIMITER ;
-- DROP PROCEDURE IF EXISTS `newProcedure`;
-- DELIMITER ;;
-- CREATE PROCEDURE `newProcedure`()
-- COMMENT 'Here comes your procedure comment'
-- BEGIN
--   -- Here comes your code to be executed
-- END
-- ;;
