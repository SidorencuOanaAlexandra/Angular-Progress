USING Progress.Lang.*.
USING src.da.*.
USING  Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.beRoleType INHERITS src.be.BEGeneric: 
  {src/include/dsRoleType.i}
    

  DEFINE PRIVATE VARIABLE daRoleType AS src.da.daRoleType NO-UNDO.

  CONSTRUCTOR PUBLIC beRoleType ():
    daRoleType = NEW daRoleType().
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC beRoleType ( ):
    DELETE OBJECT daRoleType NO-ERROR.
  END DESTRUCTOR.
    
    //fetch data
  METHOD PUBLIC VOID GetData(INPUT filter AS CHARACTER, OUTPUT DATASET dsRoleType):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
    daRoleType:ReadTable(cWhere, iMaxRows, iSkipRows, OUTPUT dataset dsRoleType BY-REFERENCE).        
  END METHOD.
    
    //add
  METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
    daRoleType:CreateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
  END METHOD.
    
    //update
  METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
    daRoleType:UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE). 
  END.
    
    //delete
  METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
    daRoleType:DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
  END.
    
  METHOD PUBLIC VOID CountRoleTypes( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER, INPUT DATASET dsRoleType):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
    SUPER:ExtractABLFilter(INPUT filter,OUTPUT cWhere,OUTPUT  iMaxRows , OUTPUT iSkipRows ).
    daRoleType:count(INPUT cWhere, OUTPUT numRecs).
  END METHOD. 

END CLASS.