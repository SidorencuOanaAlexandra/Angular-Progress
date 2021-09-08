 
/*------------------------------------------------------------------------
   File        : BEArticleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:30:08 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEArticleType INHERITS src.BE.BEGeneric: 
  {src\include\dsArticleType.i}
  DEFINE PRIVATE VARIABLE daArticleType AS src.da.DAArticleType NO-UNDO.

  CONSTRUCTOR PUBLIC BEArticleType (  ):
    SUPER ().
    daArticleType = NEW src.da.DAArticleType().
  END CONSTRUCTOR.

  METHOD PUBLIC VOID ReadArticleType (INPUT filter AS CHARACTER, OUTPUT DATASET dsArticleType):
      DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
      DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
      DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
      SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
      daArticleType:ReadTable(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsArticleType BY-REFERENCE).
  END.
    
  METHOD PUBLIC VOID CountArticleType(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows,OUTPUT iSkipRows).
    daArticleType:count(INPUT cWhere, OUTPUT numRecs).
  END METHOD.
    
  METHOD PUBLIC VOID CreateArticleType(INPUT-OUTPUT DATASET dsArticleType):
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE BUFFER bArticleType FOR ArticleType.
        
    FOR EACH ttArticleType NO-LOCK 
      WHERE ROW-STATE (ttArticleType) = ROW-CREATED:
              
      FIND FIRST bArticleType WHERE bArticleType.Description = ttArticleType.Description NO-ERROR.
      IF AVAILABLE bArticleType THEN 
        cErrorMessage = cErrorMessage + "This article type already exists.".             
                
      IF (ttArticleType.Description = "" OR ttArticleType.Description = ?) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce a description.".                            
    END.         
    IF cErrorMessage <> "" THEN
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
                
    daArticleType:createArticleType(INPUT-OUTPUT DATASET dsArticleType BY-REFERENCE).        
        
        
  END METHOD.
    
  METHOD PUBLIC VOID UpdateArticleType(INPUT-OUTPUT DATASET dsArticleType):
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
       
    FOR EACH ttArticleType NO-LOCK 
      WHERE ROW-STATE (ttArticleType) = ROW-MODIFIED:
            
      IF (ttArticleType.Description = "" OR ttArticleType.Description = ?) THEN 
        cErrorMessage = cErrorMessage + "You need to introduce a description".
    END.     
    IF cErrorMessage <> "" THEN
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
                
    daArticleType:updateArticleType(INPUT-OUTPUT DATASET dsArticleType BY-REFERENCE).  
             
  END METHOD.
    
  METHOD PUBLIC VOID DeleteArticleType(INPUT-OUTPUT DATASET dsArticleType):

    daArticleType:DeleteArticleType(INPUT-OUTPUT DATASET dsArticleType BY-REFERENCE).

  END METHOD.

END CLASS.