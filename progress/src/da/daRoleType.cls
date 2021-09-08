USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.daRoleType INHERITS src.da.DAGeneric: 
  {src/include/dsRoleType.i}

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC daRoleType (  ):
    SUPER ().
    TableName = "RoleType".
    TempTableName = "ttRoleType". 
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC daRoleType ( ):

  END DESTRUCTOR.
    
  //get all
  METHOD PUBLIC VOID FetchRoleTypes(OUTPUT DATASET dsRoleType):
    DATASET dsRoleType:EMPTY-DATASET ().
    DEFINE BUFFER bufRole FOR RoleType.
        
    FOR EACH bufRole NO-LOCK:
      CREATE ttRoleType.
      BUFFER-COPY bufRole TO ttRoleType.
    END.                      
  END METHOD.

  //add
  METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
    DEFINE BUFFER bufRole FOR RoleType.
    FOR EACH ttRoleType NO-LOCK
      WHERE ROW-STATE(ttRoleType) = ROW-CREATED:
      CREATE bufRole.
      BUFFER-COPY ttRoleType EXCEPT RoleTypeId TO bufRole.
      MESSAGE bufRole.RoleTypeId
        VIEW-AS ALERT-BOX.
    END.               
  END METHOD.
    
  //update
  METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT dataset dsRoleType):
    DEFINE BUFFER bufRole FOR RoleType.
    FOR EACH ttRoleType NO-LOCK
      WHERE ROW-STATE(ttRoleType) = ROW-MODIFIED:
      FIND FIRST bufRole EXCLUSIVE-LOCK WHERE bufRole.RoleTypeId = ttRoleType.RoleTypeId NO-ERROR.
      IF AVAILABLE bufRole THEN 
        BUFFER-COPY ttRoleType EXCEPT RoleTypeId TO bufRole.
      ELSE
        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the Role Type to update", 100).
    END.
  END METHOD. 
    
  //delete
  METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT dataset dsRoleType):
    DEFINE BUFFER bufRole FOR RoleType.
    FOR EACH bttRoleType NO-LOCK 
      WHERE ROW-STATE(bttRoleType) = ROW-DELETED:
      FIND FIRST bufRole EXCLUSIVE-LOCK WHERE bufRole.RoleTypeId = bttRoleType.RoleTypeId NO-ERROR.
      IF AVAILABLE bufRole THEN 
        DELETE bufRole. 
      ELSE
        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the Role Type to delete", 100).
    END.          
  END METHOD.
    

END CLASS.