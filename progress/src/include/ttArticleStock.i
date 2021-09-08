
/*------------------------------------------------------------------------
    File        : ttArticleStock.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Wed Aug 04 09:18:53 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttArticleStock NO-UNDO
  BEFORE-TABLE bttArticleStock
  FIELD ArticleStockId AS CHARACTER
  FIELD ArticleId      AS CHARACTER
  FIELD StoreAgencyId  AS CHARACTER
  FIELD StockAmount    AS INTEGER
  FIELD ValidFrom      AS DATE
  FIELD ValidTo        AS DATE 
  FIELD id            AS CHARACTER 
  FIELD seq           AS INTEGER.

  //INDEX PKseq IS PRIMARY UNIQUE seq.