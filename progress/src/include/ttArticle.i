
/*------------------------------------------------------------------------
    File        : ttArticle.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Wed Aug 04 09:27:52 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttArticle NO-UNDO
  BEFORE-TABLE bttArticle
  FIELD ArticleId     AS CHARACTER
  FIELD ArticleTypeId AS CHARACTER
  FIELD Model         AS CHARACTER
  FIELD Manufacturer  AS CHARACTER
  FIELD id            AS CHARACTER 
  FIELD seq           AS INTEGER

  INDEX PKseq IS PRIMARY UNIQUE seq.