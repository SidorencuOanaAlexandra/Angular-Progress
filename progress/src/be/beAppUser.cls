USING Progress.Lang.*.
USING src.da.*.
USING  Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.beAppUser INHERITS src.be.BEGeneric: 
    
  {src/include/dsAppUser.i}
  {src/include/dsUserRole.i}

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  DEFINE PRIVATE VARIABLE daAppUser  AS src.da.daAppUser  NO-UNDO.
  DEFINE PRIVATE VARIABLE daUserRole AS src.da.daUserRole NO-UNDO.
  
  CONSTRUCTOR PUBLIC beAppUser (  ):
    daAppUser = NEW daAppUser().
    daUserRole = NEW daUserRole().
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC beAppUser ( ):
    DELETE OBJECT daAppUser NO-ERROR.
    DELETE OBJECT daUserRole NO-ERROR.
  END DESTRUCTOR.
    
  METHOD PUBLIC VOID GetData(INPUT filter AS CHARACTER, OUTPUT DATASET dsAppUser):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
    daAppUser:ReadTable(cWhere, iMaxRows, iSkipRows, OUTPUT dataset dsAppUser BY-REFERENCE).        
  END METHOD.
  
  //check for unique username
  METHOD PUBLIC LOGICAL uniqueUsername(INPUT username AS CHARACTER):
    DEFINE BUFFER BufUser FOR AppUser.
    IF CAN-FIND(FIRST BufUser NO-LOCK WHERE BufUser.UserName = username) THEN
      RETURN FALSE.
    MESSAGE "este unic"
      VIEW-AS ALERT-BOX.
    RETURN TRUE.
      
  END METHOD.

     
  //add
  METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO .
        
    FOR EACH ttAppUser NO-LOCK:
            
      IF ttAppUser.Name = ? OR ttAppUser.Name = "" THEN 
        cErrorMessage = cErrorMessage + "Name cannot be empty.~n".
            
      IF ttAppUser.UserName= ? OR ttAppUser.UserName = "" THEN 
        cErrorMessage = cErrorMessage + "Username cannot be empty.~n". 
        
      IF NOT uniqueUsername(ttAppUser.UserName) THEN 
        cErrorMessage = cErrorMessage + "Username must be unique!~n".
                
      IF ttAppUser.Password= ? OR ttAppUser.Password = "" THEN 
        cErrorMessage = cErrorMessage + "Password cannot be empty.~n".    
    END.
    
    MESSAGE cErrorMessage
      VIEW-AS ALERT-BOX.    
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).

    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
       
    daAppUser:CreateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
  
  END METHOD.
  
  //update
  METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO .
        
    FOR EACH ttAppUser NO-LOCK:
            
      IF ttAppUser.Name = ? OR ttAppUser.Name = "" THEN 
        cErrorMessage = cErrorMessage + "Name cannot be empty.~n".
            
      IF ttAppUser.UserName= ? OR ttAppUser.UserName = "" THEN 
        cErrorMessage = cErrorMessage + "Username cannot be empty.~n".  
                
      IF ttAppUser.Password= ? OR ttAppUser.Password = "" THEN 
        cErrorMessage = cErrorMessage + "Password cannot be empty.~n".    
    END.
        
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        
    daAppUser:UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        
  END.
  
  //delete 
  METHOD PUBLIC VOID DeleteAppUser (INPUT-OUTPUT DATASET dsAppUser, INPUT-OUTPUT dataset dsUserRole):
    DEFINE BUFFER bufUser FOR AppUser.
    daUserRole:FetchUserRoles(OUTPUT DATASET dsUserRole).

    FOR EACH bttAppUser NO-LOCK 
      WHERE ROW-STATE(bttAppUser) = ROW-DELETED:
      FIND FIRST bufUser NO-LOCK WHERE bufUser.AppUserId = bttAppUser.AppUserId NO-ERROR.
      IF AVAILABLE bufUser THEN 
      DO:
        FOR EACH ttUserRole NO-LOCK WHERE ttUserRole.AppUserId = bttAppUser.AppUserId:
          MESSAGE ttUserRole.UserRoleId
            VIEW-AS ALERT-BOX.
          TEMP-TABLE ttUserRole:TRACKING-CHANGES = YES . 
          DELETE ttUserRole.
          TEMP-TABLE ttUserRole:TRACKING-CHANGES = NO.
        END.
        daUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
      END.
      ELSE
        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the App User to delete!").
    END.
    
    daAppUser:DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).    
  END.
  
  //count  
  METHOD PUBLIC VOID CountAppUsers( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER, INPUT DATASET dsAppUser):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
    SUPER:ExtractABLFilter(INPUT filter,OUTPUT cWhere,OUTPUT  iMaxRows , OUTPUT iSkipRows ).
    daAppUser:count(INPUT cWhere, OUTPUT numRecs).
  END METHOD. 
  
  METHOD PUBLIC LOGICAL CheckIfAppUserIdExist(INPUT ipcAppUserId AS CHARACTER ):
        
    RETURN daAppUser:CheckIfAppUserIdExist(INPUT ipcAppUserId).
        
  END METHOD.
  
  //login
  METHOD PUBLIC CHARACTER login(INPUT username AS CHARACTER, INPUT password AS CHARACTER):
    RETURN daAppUser:login(username, password).
  END METHOD. 
  
  //report
  METHOD PUBLIC VOID getTopStores():
    daAppUser:getTopUsers().
  END METHOD.

END CLASS.
