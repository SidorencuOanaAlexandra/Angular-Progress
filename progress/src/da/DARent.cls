 
/*------------------------------------------------------------------------
   File        : DARent
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 20:03:33 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DARent INHERITS src.da.DAGeneric: 

  {include/dsRent.i}

  CONSTRUCTOR PUBLIC DARent ( ):
    SUPER ().
    TableName = "Rent".
    TempTableName = "ttRent".    
  END CONSTRUCTOR.


  METHOD PUBLIC VOID AddRent(INPUT-OUTPUT  DATASET dsRent):

    FOR EACH ttRent no-lock
      WHERE row-state(ttRent) = ROW-CREATED:
      CREATE Rent.
      BUFFER-COPY ttRent EXCEPT RentId TO Rent.
    END.

  END METHOD.
  
  METHOD PUBLIC VOID FetchAllRent(OUTPUT DATASET dsRent):
    
    DEFINE BUFFER buffRent FOR Rent.
    DATASET dsRent:EMPTY-DATASET ().
        
    FOR EACH buffRent NO-LOCK:
      CREATE ttRent.
      BUFFER-COPY buffRent TO ttRent.
    END.
  
  END METHOD.
  
  METHOD PUBLIC CHARACTER GetStoreAgencyIdFromRent(INPUT ipcRentId AS character):
    
    DEFINE BUFFER buffRent FOR Rent.
    
    FIND FIRST buffRent NO-LOCK WHERE buffRent.RentId = ipcRentId NO-ERROR.
    IF AVAILABLE(buffRent) THEN 
      RETURN buffRent.StoreAgencyId.
      
    
  END METHOD.  
    
  METHOD PUBLIC VOID RemoveRent(INPUT-OUTPUT  DATASET dsRent):

    DEFINE BUFFER buffRent FOR Rent.
        
    FOR FIRST  bttRent no-lock
      WHERE row-state(bttRent) = ROW-DELETED:
      FOR FIRST buffRent EXCLUSIVE-LOCK
        WHERE buffRent.RentId = bttRent.RentId:
        DELETE  buffRent.
      END.
    END.

  END METHOD.

  METHOD PUBLIC VOID UpdateRent(INPUT-OUTPUT  DATASET dsRent):

    DEFINE BUFFER buffRent FOR Rent.

    FOR EACH ttRent no-lock
      WHERE ROW-STATE(ttRent) = ROW-MODIFIED:
      DO TRANSACTION.
        FOR FIRST buffRent EXCLUSIVE-LOCK 
          WHERE buffRent.RentId = ttRent.RentId:
          BUFFER-COPY ttRent EXCEPT RentId TO buffRent.
        END.
      END.
    END.

  END METHOD.
    
  METHOD PUBLIC VOID UpdateStatusRent (INPUT ipcRentId AS CHARACTER, INPUT ipiNewRentStatus AS INTEGER ):
      
    DEFINE BUFFER buffRent FOR Rent.

    DO TRANSACTION.
      FOR FIRST buffRent EXCLUSIVE-LOCK 
        WHERE buffRent.RentId = ipcRentId:
        buffRent.RentStatus = ipiNewRentStatus.
      END.     
    END.
      
  END METHOD.
        
  METHOD PUBLIC LOGICAL CheckIdRentIdExist(INPUT ipcRentId AS CHARACTER):
        
    DEFINE BUFFER buffRent FOR Rent.
                
    FIND FIRST buffRent NO-LOCK WHERE buffRent.RentId = ipcRentId NO-ERROR.
    IF AVAILABLE (buffRent) THEN 
      RETURN TRUE.
    ELSE 
      RETURN FALSE.
        
  END METHOD.    


  DESTRUCTOR PUBLIC DARent ():

  END DESTRUCTOR.
END CLASS.