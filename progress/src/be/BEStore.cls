/*------------------------------------------------------------------------
   File        : beStore
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 14:43:59 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING System.Windows.Forms.MessageBox FROM ASSEMBLY.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEStore INHERITS src.be.BEGeneric: 
  {src/include/dsStore.i}
  {src/include/dsStoreAgency.i}
    
  DEFINE PRIVATE VARIABLE daStore       AS src.da.DAStore       NO-UNDO.
  DEFINE PRIVATE VARIABLE daStoreAgency AS src.da.DAStoreAgency NO-UNDO.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC BEStore (  ):
        
    daStore = NEW src.da.DAStore().
    daStoreAgency = NEW src.da.DAStoreAgency().
        
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC BEStore ( ):
        
    DELETE OBJECT daStore NO-ERROR.
    DELETE OBJECT daStoreAgency NO-ERROR.

  END DESTRUCTOR.
    
  METHOD PUBLIC VOID ReadStore(OUTPUT DATASET dsStore, INPUT ipcStoreId AS CHARACTER) :
    daStore:fetchStore(OUTPUT DATASET dsStore BY-REFERENCE, INPUT ipcStoreId) .
        
  END METHOD.
    
  METHOD PUBLIC VOID ReadStores(INPUT filter AS CHARACTER, OUTPUT DATASET dsStore) :
        
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:extractABLfilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows) .
    daStore:ReadTable(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsStore BY-REFERENCE).
        
  END METHOD .
    
  METHOD PUBLIC VOID CreateStore (INPUT-OUTPUT DATASET dsStore) :
        
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
    FOR EACH ttStore:
      IF ttStore.Description = ? OR ttStore.Description = "" THEN 
        cErrorMessage = cErrorMessage + "Description can not be empty." .
            
    END.
        
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage,100) .
            
    daStore:CreateStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE).
        
  END METHOD.
     
  METHOD PUBLIC VOID UpdateStore (INPUT-OUTPUT DATASET dsStore) :
         
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.

    FOR EACH ttStore:
                
      IF ttStore.StoreId=? OR ttStore.StoreId="" THEN 
        cErrorMessage = cErrorMessage + "StoreId can not be empty." .
      IF ttStore.Description = ? OR ttStore.Description = "" THEN 
        cErrorMessage = cErrorMessage + "Description can not be empty." .
    END.
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage,100) .
        
    daStore:UpdateStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE).         
       
  END METHOD.
     
  METHOD PUBLIC VOID DeleteStore(INPUT-OUTPUT DATASET dsStore ) :
    
    DEFINE BUFFER buffStore       FOR Store .
    DEFINE BUFFER buffStoreAgency FOR StoreAgency.
    DEFINE VARIABLE lDeleted      AS LOGICAL   NO-UNDO.     
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
    FOR EACH ttStore:
      IF ttStore.StoreId=? OR ttStore.StoreId="" THEN 
        cErrorMessage = cErrorMessage + "StoreId can not be empty." .
      IF ttStore.Description = ? OR ttStore.Description = "" THEN 
        cErrorMessage = cErrorMessage + "Description can not be empty." .
    END.
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage,100) .
      
    daStoreAgency:FetchAllStoreAgencies(OUTPUT DATASET dsStoreAgency BY-REFERENCE).
    FOR EACH bttStore NO-LOCK
      WHERE ROW-STATE(bttStore)= ROW-DELETED :
      lDeleted = FALSE.
      FIND FIRST buffStore EXCLUSIVE-LOCK
        WHERE buffStore.StoreId = bttStore.StoreId NO-ERROR.
      IF AVAILABLE buffStore THEN 
      DO:
        FOR EACH ttStoreAgency
          WHERE ttStoreAgency.StoreId = buffStore.StoreId :
          IF daStoreAgency:HasRents(INPUT ttStoreAgency.StoreAgencyId) = FALSE THEN 
          DO:
            DELETE ttStoreAgency .
            lDeleted = TRUE  .
          END.
        END.
      END.
      ELSE 
        UNDO, THROW NEW Progress.Lang.AppError("Can not find the store",100).
    END.
    IF lDeleted = TRUE  THEN 
    DO :
      daStoreAgency:DeleteStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency BY-REFERENCE).
    END. 
    daStore:DeleteStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE ).
       
  END METHOD.  
    
  METHOD PUBLIC VOID CountStore( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER, INPUT DATASET dsStore):

    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
    SUPER:ExtractABLFilter(INPUT filter,OUTPUT cWhere,OUTPUT  iMaxRows , OUTPUT iSkipRows ).
    daStore:count(INPUT cWhere, OUTPUT numRecs).

  END METHOD.
  
  //report
  METHOD PUBLIC VOID getTopArticles(INPUT ipcStoreId AS CHARACTER ):
    daStore:getTopArticles(INPUT ipcStoreId).
  END METHOD. 

END CLASS.
