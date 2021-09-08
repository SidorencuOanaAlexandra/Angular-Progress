
/*------------------------------------------------------------------------
    File        : ttArticleType.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Wed Aug 04 09:28:22 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttArticleType NO-UNDO 
  BEFORE-TABLE bttArticleType
  FIELD ArticleTypeId AS CHARACTER 
  FIELD Description   AS CHARACTER 
  FIELD id            AS CHARACTER 
  FIELD seq           AS INTEGER

  INDEX PKseq IS PRIMARY UNIQUE seq. 