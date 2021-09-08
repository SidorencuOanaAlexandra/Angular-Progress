 
/*------------------------------------------------------------------------
   File        : DAArticleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:31:17 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAArticleType INHERITS src.DA.DAGeneric: 
  {src\include\dsArticleType.i}

  CONSTRUCTOR PUBLIC DAArticleType (  ):
    SUPER ().
    tableName = "ArticleType".
    tempTableName = "ttArticleType".
  END CONSTRUCTOR.
    
  METHOD PUBLIC VOID createArticleType (INPUT-OUTPUT DATASET dsArticleType):
      
      FOR EACH ttArticleType NO-LOCK
          WHERE ROW-STATE (ttArticleType) = ROW-CREATED:
          CREATE ArticleType.
          BUFFER-COPY ttArticleType EXCEPT ttArticleType.ArticleTypeId TO ArticleType.
      END.
      
  END METHOD.
  
  METHOD PUBLIC VOID updateArticleType (INPUT-OUTPUT DATASET dsArticleType):
    DEFINE BUFFER bArticleType FOR ArticleType.
    
    DO TRANSACTION:
      FOR EACH ttArticleType NO-LOCK 
        WHERE ROW-STATE (ttArticleType) = ROW-MODIFIED:
        FIND FIRST bArticleType EXCLUSIVE-LOCK 
          WHERE bArticleType.ArticleTypeId = ttArticleType.ArticleTypeId NO-ERROR.
        BUFFER-COPY ttArticleType TO bArticleType.
      END.
    END.
        
  END METHOD.
    
  METHOD PUBLIC VOID deleteArticleType (INPUT-OUTPUT DATASET dsArticleType):
    DEFINE BUFFER bArticleType FOR ArticleType.
    
    DO TRANSACTION:
      FOR EACH bttArticleType NO-LOCK 
        WHERE ROW-STATE (bttArticleType) = ROW-DELETED:
        FIND FIRST bArticleType EXCLUSIVE-LOCK
          WHERE bArticleType.ArticleTypeId = bttArticleType.ArticleTypeId NO-ERROR.
        DELETE bArticleType.
      END.
    END.

  END METHOD.
END CLASS.