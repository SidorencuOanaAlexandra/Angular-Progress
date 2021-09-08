 
/*------------------------------------------------------------------------
   File        : daStore
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 14:43:17 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING System.Windows.Forms.Message FROM ASSEMBLY.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAStore INHERITS src.da.DAGeneric: 
  {src/include/dsStore.i}
  {src/include/dsStoreAgency.i}
  {src/include/dsArticle.i}
  {src/include/dsArticleStock.i}
  {src/include/dsArticleType.i}
  {src/include/dsRentArticle.i}
  {src/include/ttStoreReport.i}
  DEFINE PRIVATE VARIABLE daStoreAgency AS src.da.DAStoreAgency NO-UNDO.
  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC DAStore (  ):
    TableName = "Store" .
    TempTableName = "ttStore" .
    daStoreAgency = NEW src.da.DAStoreAgency().   
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC DAStore ( ):
    DELETE OBJECT daStoreAgency NO-ERROR.
  END DESTRUCTOR.
    
  METHOD PUBLIC VOID FetchAllStores(OUTPUT DATASET dsStore):
        
    DATASET dsStore:EMPTY-DATASET () .
    FOR EACH Store NO-LOCK :
      CREATE ttStore.
      BUFFER-COPY Store TO ttStore.
    END.                

  END METHOD.
    
  METHOD PUBLIC VOID FetchStore(OUTPUT DATASET dsStore, INPUT ipcStoreId AS CHARACTER ) :
        
    DATASET dsStore:EMPTY-DATASET ().
    FIND FIRST Store NO-LOCK 
      WHERE Store.StoreId = ipcStoreId .
    IF AVAILABLE Store THEN 
    DO :
      CREATE Store.
      BUFFER-COPY Store TO ttStore .
    END.
    ELSE 
      UNDO, THROW NEW Progress.Lang.AppError("Can not find the store",100) .
     
  END METHOD.
    
  METHOD PUBLIC VOID CreateStore(INPUT-OUTPUT DATASET dsStore):
    
    DEFINE BUFFER buffStore FOR Store .
    FOR EACH ttStore NO-LOCK
      WHERE ROW-STATE(ttStore) = ROW-CREATED:
      FIND FIRST buffStore NO-LOCK 
        WHERE buffStore.Description = ttStore.Description NO-ERROR.
      IF AVAILABLE buffStore THEN  
        UNDO, THROW NEW Progress.Lang.AppError("STORE EXISTS",100) .   
      ELSE 
      DO:
        CREATE Store.
        BUFFER-COPY ttStore EXCEPT StoreId TO Store . 
      END.
    END.  
    
  END METHOD.
    
  METHOD PUBLIC VOID UpdateStore(INPUT-OUTPUT DATASET dsStore):
      
    DEFINE BUFFER buffStore FOR Store . 
    FOR EACH ttStore NO-LOCK 
      WHERE ROW-STATE (ttStore) = ROW-MODIFIED :
      FIND FIRST buffStore EXCLUSIVE-LOCK
        WHERE buffStore.StoreId = ttStore.StoreId NO-ERROR.
      IF AVAILABLE buffStore THEN 
        BUFFER-COPY ttStore EXCEPT StoreId TO buffStore. 
      ELSE 
        UNDO, THROW NEW Progress.Lang.AppError("Can not find the store",100) .
    END.    
  END METHOD.
    
  METHOD PUBLIC VOID DeleteStore(INPUT-OUTPUT  DATASET dsStore):
    
    DEFINE BUFFER buffStore FOR Store .
        
    FOR EACH bttStore NO-LOCK 
      WHERE ROW-STATE(bttStore) = ROW-DELETED :
      FIND FIRST buffStore EXCLUSIVE-LOCK 
        WHERE buffStore.StoreId= bttStore.StoreId NO-ERROR.
                    
      IF AVAILABLE buffStore THEN 
        DELETE buffStore.
      ELSE 
        UNDO, THROW NEW Progress.Lang.AppError("Can not find the store",100) .
    END.
  
  END METHOD.

 //report on top 10 articles
  METHOD PUBLIC VOID getTopArticles(INPUT ipcStoreId AS CHARACTER ):
    DATASET dsStoreAgency:EMPTY-DATASET ().
    DATASET dsArticleStock:EMPTY-DATASET ().
    DATASET dsArticle:EMPTY-DATASET().
    DATASET dsArticleType:EMPTY-DATASET().
    DATASET dsRentArticle:EMPTY-DATASET().
    EMPTY TEMP-TABLE ttStoreReport NO-ERROR.
    
    DEFINE BUFFER bufArticle      FOR Article.
    DEFINE BUFFER bufArticleStock FOR ArticleStock.
    DEFINE BUFFER bufArticleType  FOR ArticleType.
    DEFINE BUFFER bufRentArticle  FOR RentArticle.
    DEFINE BUFFER bufStore        FOR Store.
    DEFINE BUFFER bufStoreAgency  FOR StoreAgency.
    DEFINE VARIABLE cModel         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cArticleName   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cArticleType   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iTotalArticles AS INTEGER   NO-UNDO.  
      
    FOR EACH bufArticle NO-LOCK:
      CREATE ttArticle.
      BUFFER-COPY bufArticle TO ttArticle.
    END.  
    FOR EACH bufArticleStock NO-LOCK:
      CREATE ttArticleStock.
      BUFFER-COPY bufArticleStock TO ttArticleStock.
    END.
    FOR EACH bufArticleType NO-LOCK:
      CREATE ttArticleType.
      BUFFER-COPY bufArticleType TO ttArticleType.
    END.  
    FOR EACH bufStoreAgency NO-LOCK:
      CREATE ttStoreAgency.
      BUFFER-COPY bufStoreAgency TO ttStoreAgency.
    END. 
    FOR EACH bufRentArticle NO-LOCK:
      CREATE ttRentArticle.
      BUFFER-COPY bufRentArticle TO ttRentArticle.
    END. 
    FIND FIRST ttStoreAgency WHERE ttStoreAgency.StoreId=ipcStoreId NO-ERROR.
    IF AVAILABLE ttStoreAgency THEN 
    DO:
      FOR EACH ttArticleStock
        WHERE ttArticleStock.StoreAgencyId = ttStoreAgency.StoreAgencyId:
        iTotalArticles = 0.
        FOR EACH ttRentArticle 
          WHERE ttRentArticle.ArticleId = ttArticleStock.ArticleId :
          iTotalArticles = iTotalArticles + 1 .
        END.
        FIND FIRST ttArticle WHERE ttArticle.ArticleId = ttArticleStock.ArticleId NO-ERROR.
        IF AVAILABLE ttArticle THEN 
        DO:
          cModel = ttArticle.Manufacturer .
          cArticleName = ttArticle.Model .
          FIND FIRST ttArticleType WHERE ttArticleType.ArticleTypeId = ttArticle.ArticleTypeId NO-ERROR.
          IF AVAILABLE ttArticleType THEN 
            cArticleType = ttArticleType.Description .
          CREATE ttStoreReport.
          ttStoreReport.ArticleName = cArticleName.
          ttStoreReport.Model = cModel.
          ttStoreReport.ArticleType = cArticleType.
          ttStoreReport.NoRents = iTotalArticles.
        END.
      END.
    END.
    
    DEFINE VARIABLE cOutputFile AS CHARACTER NO-UNDO.
    cOutputFile = "C:\Users\wayfaretraining\OneDrive\Documents\articole-sportive\server\storeReport.csv".

    OUTPUT TO VALUE(cOutputFile) .
    MESSAGE cOutputFile
      VIEW-AS ALERT-BOX.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
    FOR EACH ttStoreReport NO-LOCK BY ttStoreReport.NoRents DESC:
      PUT ttStoreReport.ArticleName "," ttStoreReport.Model "," ttStoreReport.ArticleType "," ttStoreReport.NoRents .
      PUT SKIP.
      IF iCounter = 10 THEN 
        LEAVE.
    END.
       
  END METHOD.

END CLASS.