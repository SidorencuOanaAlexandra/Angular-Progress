 
/*------------------------------------------------------------------------
   File        : daStoreAgency
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 14:43:38 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAStoreAgency INHERITS src.da.DAGeneric: 
  {src/include/dsStoreAgency.i}

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC DAStoreAgency(  ):
    TableName = "StoreAgency" .
    TempTableName = "ttStoreAgency" .
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC DAStoreAgency( ):

  END DESTRUCTOR.
    
  METHOD PUBLIC VOID FetchAllStoreAgencies(OUTPUT DATASET dsStoreAgency):
        
    DATASET dsStoreAgency:EMPTY-DATASET () .
    FOR EACH StoreAgency NO-LOCK :
      CREATE ttStoreAgency.
      BUFFER-COPY StoreAgency TO ttStoreAgency.
    END.                

  END METHOD.
    
  METHOD PUBLIC VOID FetchStoreAgency(OUTPUT DATASET dsStoreAgency, INPUT ipcStoreId AS CHARACTER ) :
        
    DATASET dsStoreAgency:EMPTY-DATASET ().
    FIND FIRST StoreAgency NO-LOCK 
      WHERE StoreAgency.StoreId = ipcStoreId .
    IF AVAILABLE StoreAgency THEN 
    DO :
      CREATE ttStoreAgency.
      BUFFER-COPY StoreAgency TO ttStoreAgency .
    END.
    ELSE 
      UNDO, THROW NEW Progress.Lang.AppError("Can not find the store agency",100) .
     
  END METHOD.
    
  METHOD PUBLIC VOID CreateStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency):
    
    DEFINE BUFFER buffStoreAgency FOR StoreAgency .   
    FOR EACH ttStoreAgency NO-LOCK 
      WHERE ROW-STATE (ttStoreAgency) = ROW-CREATED :
      FIND FIRST buffStoreAgency NO-LOCK 
        WHERE buffStoreAgency.Address = ttStoreAgency.Address NO-ERROR.
      IF AVAILABLE buffStoreAgency THEN 
        UNDO, THROW NEW Progress.Lang.AppError("STORE AGENCY EXISTS",100) . 
      ELSE 
      DO: 
        FIND FIRST Store NO-LOCK 
          WHERE Store.StoreId=ttStoreAgency.StoreId NO-ERROR .
        IF AVAILABLE Store THEN 
        DO:
          CREATE StoreAgency.
          BUFFER-COPY ttStoreAgency EXCEPT StoreAgencyId TO StoreAgency .
        END.
        ELSE 
          UNDO, THROW NEW Progress.Lang.AppError("Can not find the store for the store agency.",100).
      END .
    END.
    
  END METHOD.
    
  METHOD PUBLIC VOID UpdateStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency):
        
    DEFINE BUFFER buffStoreAgency FOR StoreAgency .
    
    FOR EACH ttStoreAgency NO-LOCK
      WHERE ROW-STATE (ttStoreAgency) = ROW-MODIFIED :
      FIND FIRST buffStoreAgency EXCLUSIVE-LOCK
        WHERE buffStoreAgency.StoreAgencyId = ttStoreAgency.StoreAgencyId NO-ERROR.
      IF AVAILABLE buffStoreAgency THEN 
        BUFFER-COPY ttStoreAgency EXCEPT StoreAgencyId TO buffStoreAgency.            
      ELSE 
        UNDO, THROW NEW Progress.Lang.AppError("Can not find the store agency.",100).  
    END.
    
  END METHOD.
    
  METHOD PUBLIC VOID DeleteStoreAgency(INPUT-OUTPUT  DATASET dsStoreAgency):
        
    DEFINE BUFFER buffStoreAgency FOR StoreAgency .
    DEFINE BUFFER buffRent        FOR Rent. 
        
    FOR EACH bttStoreAgency NO-LOCK
      WHERE ROW-STATE(bttStoreAgency)= ROW-DELETED :
      FIND FIRST buffStoreAgency EXCLUSIVE-LOCK
        WHERE buffStoreAgency.StoreAgencyId = bttStoreAgency.StoreAgencyId NO-ERROR.
      IF AVAILABLE buffStoreAgency THEN 
      DO:
        FIND FIRST buffRent NO-LOCK
          WHERE buffRent.StoreAgencyId = buffStoreAgency.StoreAgencyId NO-ERROR.
        IF AVAILABLE buffRent THEN 
          UNDO, THROW NEW Progress.Lang.AppError("Can not delete STORE AGENCY. It has RENTS",100).  
        ELSE 
          DELETE buffStoreAgency.
      END.
      ELSE 
        UNDO, THROW NEW Progress.Lang.AppError("Can not find the store agency",100).
    END.
            
  END METHOD.
  
  METHOD PUBLIC LOGICAL HasRents(INPUT ipcStoreAgencyId AS CHARACTER):
    
    DEFINE BUFFER buffRent FOR Rent.
    MESSAGE "am ajuns in hasRents"
      VIEW-AS ALERT-BOX.
    FIND FIRST buffRent NO-LOCK 
      WHERE buffRent.StoreAgencyId = ipcStoreAgencyId NO-ERROR.
    IF AVAILABLE buffRent THEN 
    DO:
      RETURN TRUE .
    END.
    ELSE 
      RETURN FALSE .
      
  END METHOD .
     
  
    
END CLASS.