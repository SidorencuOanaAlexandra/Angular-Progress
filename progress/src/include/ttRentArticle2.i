
/*------------------------------------------------------------------------
    File        : ttRentArticle2
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Thu Aug 19 05:01:43 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttRentArticle2 NO-UNDO
    BEFORE-TABLE bttRentArticle2
    FIELD RentArticleId    AS CHARACTER  
    FIELD RentId           AS CHARACTER  
    FIELD ArticleId        AS CHARACTER  
    FIELD NumberOfArticles AS INTEGER 
    FIELD id               AS CHARACTER 
    FIELD seq              AS INTEGER.