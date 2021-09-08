USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.daAppUser INHERITS src.da.DAGeneric: 
  {src/include/dsAppUser.i}
  {src/include/dsStore.i}
  {src/include/dsStoreAgency.i}
  {src/include/dsUserRole.i}
  {src/include/ttUserReport.i}

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC daAppUser (  ):
    SUPER ().
    TableName = "AppUser".
    TempTableName = "ttAppUser". 
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC daAppUser ( ):

  END DESTRUCTOR.
    
  //get all
  METHOD PUBLIC VOID FetchAppUsers (OUTPUT DATASET dsAppUser):
    DATASET dsAppUser:EMPTY-DATASET ().
    DEFINE BUFFER bufUser FOR AppUser.
        
    FOR EACH bufUser NO-LOCK:
      CREATE ttAppUser.
      BUFFER-COPY bufUser TO ttAppUser.
    END.                      
  END METHOD.

  //add
  METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
    DEFINE BUFFER bufUser FOR AppUser.
    FOR EACH ttAppUser NO-LOCK
      WHERE ROW-STATE(ttAppUser) = ROW-CREATED:
      CREATE bufUser.
      BUFFER-COPY ttAppUser EXCEPT AppUserId TO bufUser.
      MESSAGE bufUser.AppUserId
        VIEW-AS ALERT-BOX.
    END.               
  END METHOD.
    
  //update
  METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT dataset dsAppUser):
    DEFINE BUFFER bufUser FOR AppUser.
    FOR EACH ttAppUser NO-LOCK
      WHERE ROW-STATE(ttAppUser) = ROW-MODIFIED:
      FIND FIRST bufUser EXCLUSIVE-LOCK WHERE bufUser.AppUserId = ttAppUser.AppUserId NO-ERROR.
      IF AVAILABLE bufUser THEN 
        BUFFER-COPY ttAppUser EXCEPT AppUserId TO bufUser.
      ELSE
        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the App User to update", 100).
    END.
       
  END METHOD. 
    
  //delete
  METHOD PUBLIC VOID DeleteAppUser (INPUT-OUTPUT dataset dsAppUser):
    DEFINE BUFFER bufUser FOR AppUser.
    FOR EACH bttAppUser NO-LOCK 
      WHERE ROW-STATE(bttAppUser) = ROW-DELETED:
      FIND FIRST bufUser EXCLUSIVE-LOCK WHERE bufUser.AppUserId = bttAppUser.AppUserId NO-ERROR.
      IF AVAILABLE bufUser THEN
        DELETE bufUser.
      ELSE
        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the App User to delete!", 100).
    END.       
  END METHOD.
    
  METHOD PUBLIC LOGICAL CheckIfAppUserIdExist(INPUT ipcAppUserId AS CHARACTER ):
    DEFINE BUFFER buffAppUser FOR AppUser.
        
    FIND FIRST buffAppUser NO-LOCK WHERE buffAppUser.AppUserId = ipcAppUserId NO-ERROR.
    IF AVAILABLE (buffAppUser) THEN 
      RETURN TRUE.
    ELSE 
      RETURN FALSE.
        
  END METHOD.
  
  //login
  METHOD PUBLIC CHARACTER login(INPUT username AS CHARACTER, INPUT password AS CHARACTER):
    DEFINE BUFFER bufUser FOR AppUser.
    IF CAN-FIND(FIRST bufUser NO-LOCK WHERE bufUser.username = username AND bufUser.password = password) THEN DO:
      FIND FIRST bufUser NO-LOCK WHERE bufUser.username = username AND bufUser.password = password.
      RETURN bufUser.AppUserId.
    END.
    ELSE
      RETURN "false".
  END METHOD.
  
  //report on top 10 users
  METHOD PUBLIC VOID getTopUsers():
    //clearing and repopulating the tables I need
    DATASET dsAppUser:EMPTY-DATASET ().
    DATASET dsStore:EMPTY-DATASET ().
    DATASET dsStoreAgency:EMPTY-DATASET ().
    DATASET dsUserRole:EMPTY-DATASET().
    EMPTY TEMP-TABLE ttUserReport NO-ERROR.
    
    DEFINE BUFFER bufUser FOR AppUser.
    DEFINE BUFFER bufStore FOR Store.
    DEFINE BUFFER bufStoreAgency FOR StoreAgency.
    DEFINE BUFFER bufUserRole FOR UserRole.
        
    FOR EACH bufUser NO-LOCK:
      CREATE ttAppUser.
      BUFFER-COPY bufUser TO ttAppUser.
    END.  
    
    FOR EACH bufStore NO-LOCK:
      CREATE ttStore.
      BUFFER-COPY bufStore TO ttStore.
    END. 
    
    FOR EACH bufStoreAgency NO-LOCK:
      CREATE ttStoreAgency.
      BUFFER-COPY bufStoreAgency TO ttStoreAgency.
    END. 
    
    FOR EACH bufUserRole NO-LOCK:
      CREATE ttUserRole.
      BUFFER-COPY bufUserRole TO ttUserRole.
    END. 
    
    DEFINE VARIABLE iTotalAgencies AS INTEGER NO-UNDO.
    DEFINE VARIABLE iTotalUsers AS INTEGER NO-UNDO.
    
    FOR EACH ttStore NO-LOCK:
        iTotalUsers = 0.
        iTotalAgencies = 0.
        FOR EACH ttAppUser NO-LOCK:
          IF CAN-FIND(FIRST ttUserRole WHERE ttUserRole.StoreId = ttStore.StoreId) THEN 
              iTotalUsers = iTotalUsers + 1 .
        END.
        
        FOR EACH ttStoreAgency NO-LOCK WHERE ttStoreAgency.StoreId = ttStore.StoreId:
           iTotalAgencies = iTotalAgencies + 1 .
        END.
        
        CREATE ttUserReport.
        ttUserReport.StoreName = ttStore.Description.
        ttUserReport.NoUsers = iTotalUsers.
        ttUserReport.NoStoreAgencies = iTotalAgencies.
        
    END.
    
    DEFINE VARIABLE cOutputFile AS CHARACTER NO-UNDO.
/*    SYSTEM-DIALOG GET-FILE cOutputFile.      */
/*    FILE-INFORMATION:FILE-NAME = cOutputFile.*/
/*    OUTPUT TO value(FILE-INFORMATION:FULL-PATHNAME).*/
    cOutputFile = "C:\workspace\FINAL_PROJECT\server\userReport.csv".

    OUTPUT TO VALUE(cOutputFile) .
    MESSAGE cOutputFile
    VIEW-AS ALERT-BOX.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
    FOR EACH ttUserReport NO-LOCK BY ttUserReport.NoUsers DESC:
        PUT ttUserReport.StoreName "," ttUserReport.NoUsers "," ttUserReport.NoStoreAgencies .
        PUT SKIP.
      IF iCounter = 10 THEN 
        LEAVE.
    END.
    
    OUTPUT CLOSE.
    
    
  END METHOD.

END CLASS.