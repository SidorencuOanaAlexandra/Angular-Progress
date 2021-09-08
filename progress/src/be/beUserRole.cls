USING Progress.Lang.*.
USING src.da.*.
USING  Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.beUserRole INHERITS src.be.BEGeneric: 
  {src/include/dsUserRole.i}

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE PRIVATE VARIABLE daUserRole AS daUserRole NO-UNDO.
    
  CONSTRUCTOR PUBLIC beUserRole (  ):
    daUserRole = NEW daUserRole().
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC beUserRole ( ):
    DELETE OBJECT daUserRole NO-ERROR.
  END DESTRUCTOR.
    
    //fetch data
  METHOD PUBLIC VOID GetData(INPUT filter AS CHARACTER, OUTPUT DATASET dsUserRole):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
    daUserRole:ReadTable(cWhere, iMaxRows, iSkipRows, OUTPUT dataset dsUserRole BY-REFERENCE).        
  END METHOD.
    
    //add
  METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO .
        
    FOR EACH ttUserRole NO-LOCK:
            
      IF ttUserRole.RoleTypeId = ? OR ttUserRole.RoleTypeId = "" THEN 
        cErrorMessage = cErrorMessage + "Role Type ID cannot be empty.~n".
            
      IF ttUserRole.AppUserId = ? OR ttUserRole.AppUserId = "" THEN 
        cErrorMessage = cErrorMessage + "App User Id cannot be empty.~n".  
                
      IF ttUserRole.StoreId = ? OR ttUserRole.StoreId = "" THEN 
        cErrorMessage = cErrorMessage + "Store Id cannot be empty.~n".     
    END.
        
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
       
    daUserRole:CreateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
  
  END METHOD.
    
    //update
  METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO .
        
    FOR EACH ttUserRole NO-LOCK:
            
      IF ttUserRole.RoleTypeId = ? OR ttUserRole.RoleTypeId = "" THEN 
        cErrorMessage = cErrorMessage + "Role Type ID cannot be empty.~n".
            
      IF ttUserRole.AppUserId = ? OR ttUserRole.AppUserId = "" THEN 
        cErrorMessage = cErrorMessage + "App User Id cannot be empty.~n".  
                
      IF ttUserRole.StoreId = ? OR ttUserRole.StoreId = "" THEN 
        cErrorMessage = cErrorMessage + "Store Id cannot be empty.~n".    
    END.
        
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        
    daUserRole:UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
  END.
    
    //delete
  METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
    daUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
  END.
    
  METHOD PUBLIC VOID CountUserRoles( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER, INPUT DATASET dsUserRole):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
    SUPER:ExtractABLFilter(INPUT filter,OUTPUT cWhere,OUTPUT  iMaxRows , OUTPUT iSkipRows ).
    daUserRole:count(INPUT cWhere, OUTPUT numRecs).
  END METHOD.

END CLASS.