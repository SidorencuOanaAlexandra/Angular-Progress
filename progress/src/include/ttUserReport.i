
/*------------------------------------------------------------------------
    File        : ttUserReport.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Thu Aug 19 04:47:43 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttUserReport NO-UNDO
  FIELD StoreName AS CHARACTER
  FIELD NoUsers AS INTEGER
  FIELD NoStoreAgencies AS INTEGER.