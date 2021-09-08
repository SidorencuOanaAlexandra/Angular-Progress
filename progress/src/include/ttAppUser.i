
/*------------------------------------------------------------------------
    File        : ttAppUser.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Thu Aug 12 14:19:11 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */


  
define temp-table ttAppUser no-undo
    before-table bttAppUser
    field AppUserId as character 
    field Name      as character 
    field UserName  as character 
    field Password  as character 
    FIELD id        AS CHARACTER 
    FIELD seq       AS INTEGER
    
    index idxAppUserId is primary unique AppUserId
    .