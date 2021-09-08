
/*------------------------------------------------------------------------
    File        : ttRentArticle
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Wed Aug 04 10:51:40 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttRentArticle NO-UNDO
    BEFORE-TABLE bttRentArticle
    FIELD RentArticleId    AS CHARACTER  
    FIELD RentId           AS CHARACTER  
    FIELD ArticleId        AS CHARACTER  
    FIELD NumberOfArticles AS INTEGER 
    FIELD id               AS CHARACTER 
    FIELD seq              AS INTEGER.