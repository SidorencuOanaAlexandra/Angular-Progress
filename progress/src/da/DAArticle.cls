 
/*------------------------------------------------------------------------
   File        : DAArticle
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:31:07 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAArticle INHERITS src.DA.DAGeneric: 
  {src\include\dsArticle.i}
  {src\include\dsArticleStock.i}
  
  CONSTRUCTOR PUBLIC DAArticle ():
    SUPER ().
    tableName = "Article".
    tempTableName = "ttArticle".
  END CONSTRUCTOR.
    
  METHOD PUBLIC LOGICAL existRents(INPUT articleId AS CHARACTER):
    DEFINE BUFFER bRentArticle FOR RentArticle.
    FIND FIRST bRentArticle NO-LOCK
      WHERE bRentArticle.ArticleId = articleId NO-ERROR.
    IF AVAILABLE bRentArticle THEN 
      RETURN TRUE.
    ELSE 
      RETURN FALSE.
  END METHOD. 
               
  METHOD PUBLIC VOID createArticle (INPUT-OUTPUT DATASET dsArticle):
    DEFINE BUFFER bArticle FOR Article.
  
    FOR EACH ttArticle NO-LOCK
      WHERE ROW-STATE (ttArticle) = ROW-CREATED:
      CREATE bArticle.
      BUFFER-COPY ttArticle EXCEPT ttArticle.ArticleId TO bArticle.
    END.
        
  END METHOD.
    
  METHOD PUBLIC VOID updateArticle (INPUT-OUTPUT DATASET dsArticle):
    DEFINE BUFFER bArticle FOR Article.
    
    DO TRANSACTION:
      FOR EACH ttArticle NO-LOCK
        WHERE ROW-STATE (ttArticle) = ROW-MODIFIED:
        FIND FIRST bArticle EXCLUSIVE-LOCK
          WHERE bArticle.ArticleId = ttArticle.ArticleId NO-ERROR.
        IF AVAILABLE bArticle THEN 
          BUFFER-COPY ttArticle TO bArticle.
      END.
    END.
        
  END METHOD.
    
  METHOD PUBLIC VOID deleteArticle (INPUT-OUTPUT DATASET dsArticle):
    DEFINE BUFFER bArticle FOR Article.
    
    DO TRANSACTION:
      FOR EACH bttArticle NO-LOCK 
        WHERE ROW-STATE(bttArticle) = ROW-DELETED:       
        FIND FIRST bArticle EXCLUSIVE-LOCK
          WHERE bArticle.ArticleId = bttArticle.ArticleId NO-ERROR.    
        IF AVAILABLE bArticle THEN
          IF existRents(bArticle.ArticleId) THEN  
            UNDO, THROW NEW Progress.Lang.AppError("The article has rents.", 100).
          ELSE 
            DELETE bArticle.
      END.
    END.
        
  END METHOD.
    
  METHOD PUBLIC LOGICAL CheckIdArticleIdExist(INPUT ipcArticleId AS CHARACTER):       
    DEFINE BUFFER buffArticle FOR Article.
    MESSAGE "articleId" ipcArticleId
    VIEW-AS ALERT-BOX.
        
    FIND FIRST buffArticle NO-LOCK WHERE buffArticle.ArticleId = ipcArticleId NO-ERROR.
    IF AVAILABLE (buffArticle) THEN 
      RETURN TRUE.
    ELSE 
      RETURN FALSE.
        
  END METHOD. 

END CLASS.