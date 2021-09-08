USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.daUserRole INHERITS src.da.DAGeneric: 
    
  {src/include/dsUserRole.i}

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC daUserRole (  ):
    SUPER ().
    TableName = "UserRole".
    TempTableName = "ttUserRole". 
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC daUserRole ( ):

  END DESTRUCTOR.
    
  //get all
  METHOD PUBLIC VOID FetchUserRoles(OUTPUT DATASET dsUserRole):
    DATASET dsUserRole:EMPTY-DATASET ().
    DEFINE BUFFER bufUserRole FOR UserRole.
        
    FOR EACH bufUserRole NO-LOCK:
      CREATE ttUserRole.
      BUFFER-COPY bufUserRole TO ttUserRole.
    END.     
  END METHOD.

  //add
  METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
    DEFINE BUFFER bufUser FOR UserRole.
    FOR EACH ttUserRole NO-LOCK
      WHERE ROW-STATE(ttUserRole) = ROW-CREATED:
      CREATE bufUser.
      BUFFER-COPY ttUserRole EXCEPT UserRoleId TO bufUser.
      MESSAGE bufUser.UserRoleId
        VIEW-AS ALERT-BOX.
    END.               
  END METHOD.
    
  //update
  METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT dataset dsUserRole):
    DEFINE BUFFER bufUser FOR UserRole.
    FOR EACH ttUserRole NO-LOCK
      WHERE ROW-STATE(ttUserRole) = ROW-MODIFIED:
      FIND FIRST bufUser EXCLUSIVE-LOCK WHERE bufUser.UserRoleId = ttUserRole.UserRoleId NO-ERROR.
      IF AVAILABLE bufUser THEN 
        BUFFER-COPY ttUserRole EXCEPT UserRoleId TO bufUser.
      ELSE
        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the User Role to update", 100).
    END.
  END METHOD. 
    
  //delete
  METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT dataset dsUserRole):
    DEFINE BUFFER bufUser FOR UserRole.
    FOR EACH bttUserRole NO-LOCK 
      WHERE ROW-STATE(bttUserRole) = ROW-DELETED:
      FIND FIRST bufUser EXCLUSIVE-LOCK WHERE bufUser.UserRoleId = bttUserRole.UserRoleId NO-ERROR.
      IF AVAILABLE bufUser THEN 
        DELETE bufUser. 
      ELSE
        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the User Role to delete!", 100).
    END.  
  END METHOD.
    

END CLASS.