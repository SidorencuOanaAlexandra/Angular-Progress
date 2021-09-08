 
/*------------------------------------------------------------------------
   File        : BEArticleStock
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:29:43 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEArticleStock INHERITS src.BE.BEGeneric: 
  {src\include\dsArticleStock.i}
  DEFINE PRIVATE VARIABLE daArticleStock AS src.da.DAArticleStock NO-UNDO.

  CONSTRUCTOR PUBLIC BEArticleStock (  ):
    SUPER ().
    daArticleStock = NEW src.da.DAArticleStock().
  END CONSTRUCTOR.

  METHOD PUBLIC VOID ReadArticleStock(INPUT filter AS CHARACTER, OUTPUT DATASET dsArticleStock):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows,OUTPUT iSkipRows).
    daArticleStock:ReadTable(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsArticleStock BY-REFERENCE).
  END.
    
  METHOD PUBLIC VOID CountArticleStock(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows,OUTPUT iSkipRows).
    daArticleStock:count(INPUT cWhere, OUTPUT numRecs).
  END METHOD.
    
  METHOD PUBLIC VOID FetchAllArticleStock(OUTPUT DATASET dsArticleStock):
    daArticleStock:FetchAllArticleStock(OUTPUT DATASET dsArticleStock BY-REFERENCE ).
  END METHOD.
    
  METHOD PUBLIC VOID CreateArticleStock(INPUT-OUTPUT DATASET dsArticleStock):
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
    FOR EACH ttArticleStock NO-LOCK 
      WHERE ROW-STATE (ttArticleStock) = ROW-CREATED:

      IF (ttArticleStock.StockAmount < 0 OR ttArticleStock.StockAmount = ?) THEN
        cErrorMessage = cErrorMessage + "You need to introduce a proper stock amount.".

      IF (ttArticleStock.ValidFrom = ?) THEN
        cErrorMessage = cErrorMessage + "You need to introduce a proper valid from date.".

      IF (ttArticleStock.ValidTo = ? OR ttArticleStock.ValidTo < ttArticleStock.ValidFrom 
        OR ttArticleStock.ValidTo < TODAY) THEN
        cErrorMessage = cErrorMessage + "You need to introduce a proper valid to date. The date should be greater than today and valid from date.".
    END.
    IF cErrorMessage <> "" THEN
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
                
    daArticleStock:createArticleStock (INPUT-OUTPUT DATASET dsArticleStock BY-REFERENCE).       
        
  END METHOD.
    
  METHOD PUBLIC VOID UpdateArticleStock(INPUT-OUTPUT DATASET dsArticleStock):
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
    FOR EACH ttArticleStock NO-LOCK 
      WHERE ROW-STATE (ttArticleStock) = ROW-MODIFIED:
                
      IF (ttArticleStock.StockAmount < 0 OR ttArticleStock.StockAmount = ?) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce a proper stock amount.".
                
      IF (ttArticleStock.ValidFrom = ?) THEN   
        cErrorMessage = cErrorMessage + "You need to introduce a proper valid from date.".
                
      IF (ttArticleStock.ValidTo = ? OR ttArticleStock.ValidTo < ttArticleStock.ValidFrom) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce a proper valid to date.".
    END.                  
    IF cErrorMessage <> "" THEN
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).               
       
    daArticleStock:UpdateArticleStock(INPUT-OUTPUT DATASET dsArticleStock BY-REFERENCE).   
        
  END METHOD.
    
  METHOD PUBLIC VOID DeleteArticleStock(INPUT-OUTPUT DATASET dsArticleStock):
           
    daArticleStock:DeleteArticleStock(INPUT-OUTPUT DATASET dsArticleStock BY-REFERENCE).  

  END METHOD.
  
  METHOD PUBLIC INTEGER GetArticleAmountForArticle(INPUT ipcArticleId AS character, INPUT ipcStoreAgecyId AS character):
    
    RETURN daArticleStock:GetArticleAmountForArticle(INPUT ipcArticleId,input  ipcStoreAgecyId).
    
  END METHOD.   

END CLASS.