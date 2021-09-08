 
/*------------------------------------------------------------------------
   File        : BEArticle
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:29:55 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEArticle INHERITS src.BE.BEGeneric: 
  {src\include\dsArticle.i}
  {src\include\dsArticleStock.i}
  DEFINE PRIVATE VARIABLE daArticle      AS src.da.DAArticle      NO-UNDO.
  DEFINE PRIVATE VARIABLE beArticleStock AS src.be.BEArticleStock NO-UNDO.

  CONSTRUCTOR PUBLIC BEArticle (  ):
    SUPER ().
    daArticle = NEW src.da.DAArticle().
    beArticleStock = NEW src.be.BEArticleStock().
  END CONSTRUCTOR.

  METHOD PUBLIC VOID ReadArticle(INPUT filter AS CHARACTER, OUTPUT DATASET dsArticle):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
    daArticle:ReadTable(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsArticle BY-REFERENCE).
  END.
    
  METHOD PUBLIC VOID CountArticle(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows,OUTPUT iSkipRows).
    daArticle:count(INPUT cWhere, OUTPUT numRecs).
  END METHOD.
    
  METHOD PUBLIC VOID CreateArticle(INPUT-OUTPUT DATASET dsArticle):
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE BUFFER bArticle FOR Article.
        
    FOR EACH ttArticle NO-LOCK 
      WHERE ROW-STATE (ttArticle) = ROW-CREATED:
            
      FIND FIRST bArticle 
        WHERE bArticle.Model = ttArticle.Model AND bArticle.Manufacturer = ttArticle.Manufacturer NO-ERROR.
      IF AVAILABLE bArticle THEN 
        cErrorMessage = cErrorMessage + "The article from this manufacturer already exists.".
            
      IF (ttArticle.Model = "" OR ttArticle.Model = ?) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce a model.".
                                         
      IF (ttArticle.Manufacturer = "" OR ttArticle.Manufacturer = ?) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce the manufacturer.".                                       
           
    END.
    IF cErrorMessage <> "" THEN
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
                   
    daArticle:CreateArticle(INPUT-OUTPUT DATASET dsArticle BY-REFERENCE).        
         
  END METHOD.
    
  METHOD PUBLIC VOID UpdateArticle(INPUT-OUTPUT DATASET dsArticle):
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    
    FOR EACH ttArticle NO-LOCK 
      WHERE ROW-STATE (ttArticle) = ROW-MODIFIED:
                    
      IF (ttArticle.Model = "" OR ttArticle.Model = ?) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce a model.".
                                         
      IF (ttArticle.Manufacturer = "" OR ttArticle.Manufacturer = ?) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce the manufacturer.".                            
    END.           
    IF cErrorMessage <> "" THEN
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
                
    daArticle:UpdateArticle(INPUT-OUTPUT DATASET dsArticle BY-REFERENCE).  
                   
  END METHOD.
    
  METHOD PUBLIC VOID DeleteArticle(INPUT-OUTPUT DATASET dsArticle):
        
    daArticle:DeleteArticle(INPUT-OUTPUT DATASET dsArticle BY-REFERENCE).            
    beArticleStock:ReadArticleStock(INPUT '~{"top":0, "skip":0, "ablFilter":"", "orderBy":""}', OUTPUT DATASET dsArticleStock BY-REFERENCE).

    TEMP-TABLE ttArticleStock:TRACKING-CHANGES = TRUE.
    FOR EACH bttArticle NO-LOCK 
      WHERE ROW-STATE(bttArticle) = ROW-DELETED:
      FOR EACH ttArticleStock NO-LOCK 
        WHERE bttArticle.ArticleId = ttArticleStock.ArticleId:
        DELETE ttArticleStock. 
      END.
    END. 
    TEMP-TABLE ttArticleStock:TRACKING-CHANGES = FALSE.       
       
    beArticleStock:deleteArticleStock(INPUT-OUTPUT DATASET dsArticleStock BY-REFERENCE).   
    
  END METHOD.
    
  METHOD PUBLIC LOGICAL CheckIdArticleIdExist(INPUT ipcArticleId AS CHARACTER):
        
    RETURN daArticle:CheckIdArticleIdExist(INPUT ipcArticleId).
        
  END METHOD.    
   
END CLASS.
