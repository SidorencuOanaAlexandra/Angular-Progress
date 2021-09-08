
/*------------------------------------------------------------------------
    File        : ttRent
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Tue Aug 03 19:35:29 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttRent NO-UNDO
    BEFORE-TABLE bttRent
    FIELD RentId        AS CHARACTER  
    FIELD AppUserId     AS CHARACTER  
    FIELD StoreAgencyId AS CHARACTER  
    FIELD DateFrom      AS DATE 
    FIELD DateTo        AS DATE 
    FIELD RentStatus    AS INTEGER 
    FIELD id            AS CHARACTER 
    FIELD seq           AS INTEGER.