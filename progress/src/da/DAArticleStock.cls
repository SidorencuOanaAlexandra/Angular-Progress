 
/*------------------------------------------------------------------------
   File        : DAArticleStock
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:30:26 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAArticleStock INHERITS src.DA.DAGeneric: 
  {src\include\dsArticleStock.i}
    
  CONSTRUCTOR PUBLIC DAArticleStock (  ):
    SUPER ().
    tableName = "ArticleStock".
    tempTableName = "ttArticleStock".
  END CONSTRUCTOR.

  METHOD PUBLIC VOID createArticleStock (INPUT-OUTPUT DATASET dsArticleStock):
    DEFINE BUFFER bArticleStock FOR ArticleStock. 
    
    FOR EACH ttArticleStock NO-LOCK
      WHERE ROW-STATE (ttArticleStock) = ROW-CREATED:
      CREATE bArticleStock.
      BUFFER-COPY ttArticleStock EXCEPT ttArticleStock.ArticleStockId TO bArticleStock.
    END.
    
  END METHOD.
  
  METHOD PUBLIC VOID FetchAllArticleStock(OUTPUT DATASET dsArticleStock):
    DEFINE BUFFER buffArticleStock FOR ArticleStock.
    DATASET dsArticleStock:EMPTY-DATASET ().
        
    FOR EACH buffArticleStock NO-LOCK:
      CREATE ttArticleStock.
      BUFFER-COPY buffArticleStock TO ttArticleStock.
    END.
  END METHOD.
        
  METHOD PUBLIC INTEGER GetArticleAmountForArticle(INPUT ipcArticleId AS character, INPUT ipcStoreAgecyId AS character):
    
    DEFINE BUFFER buffArticleStock FOR ArticleStock.
    
    FIND FIRST buffArticleStock NO-LOCK WHERE buffArticleStock.StoreAgencyId EQ ipcStoreAgecyId AND buffArticleStock.ArticleId EQ ipcArticleId NO-ERROR.
    IF available(buffArticleStock) THEN 
      RETURN buffArticleStock.StockAmount.
      
    
  END METHOD.    
    
  METHOD PUBLIC VOID updateArticleStock (INPUT-OUTPUT DATASET dsArticleStock):
    DEFINE BUFFER bArticleStock FOR ArticleStock. 
    
    DO TRANSACTION:
      FOR EACH ttArticleStock NO-LOCK
        WHERE ROW-STATE (ttArticleStock) = ROW-MODIFIED: 
        FIND FIRST bArticleStock EXCLUSIVE-LOCK
          WHERE bArticleStock.ArticleStockId = ttArticleStock.ArticleStockId NO-ERROR.
        IF AVAILABLE bArticleStock THEN 
          BUFFER-COPY ttArticleStock TO bArticleStock.
      END.
    END.
        
  END METHOD.
    
  METHOD PUBLIC VOID deleteArticleStock (INPUT-OUTPUT DATASET dsArticleStock):
    DEFINE BUFFER bArticleStock FOR ArticleStock.
     
    DO TRANSACTION:
      FOR EACH bttArticleStock NO-LOCK
        WHERE ROW-STATE (bttArticleStock) = ROW-DELETED:
        FIND FIRST bArticleStock EXCLUSIVE-LOCK
          WHERE bArticleStock.ArticleStockId = bttArticleStock.ArticleStockId NO-ERROR.
        IF AVAILABLE bArticleStock THEN 
          DELETE bArticleStock.
      END.
    END.
        
  END METHOD.
END CLASS.
