@program FILE(name="SIUserRole.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="true").
@progress.service.resource FILE(name="SIUserRole", URI="/SIUserRole", schemaName="dsUserRole", schemaFile="").

USING Progress.Lang.*.
USING src.be.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.siUserRole:

  {src/include/dsUserRole.i}
    
  DEFINE VARIABLE beUserRole AS beUserRole NO-UNDO.

  /*------------------------------------------------------------------------------
  Purpose:
  Notes:
  ------------------------------------------------------------------------------*/
  CONSTRUCTOR PUBLIC siUserRole():

    beUserRole = NEW beUserRole().

  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
  Purpose: Get one or more records, based on a filter string
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  METHOD PUBLIC VOID ReadUserRole( INPUT filter AS CHARACTER, OUTPUT DATASET dsUserRole):
    DATASET dsUserRole:empty-dataset(). 
    MESSAGE "DEBUG SI: Start ReadUserRole".  
    beUserRole:GetData(INPUT filter, OUTPUT dataset dsUserRole).
    MESSAGE "DEBUG SI: End ReadUserRole".  
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Create one or more new records
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
         
    MESSAGE "DEBUG SI: Start CreateUserRole".  
         
    beUserRole:CreateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
         
    MESSAGE "DEBUG SI: End CreateUserRole".  
         
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Update one or more records
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        
    MESSAGE "DEBUG SI: Start UpdateUserRole".  
        
    beUserRole:UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End UpdateUserRole". 
        
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Delete a record
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
        
    MESSAGE "DEBUG SI: Start DeleteUserRole". 
        
    beUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End DeleteUserRole".
        
  END METHOD.
    
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
    beUserRole:CountUserRoles(INPUT filter, OUTPUT numRecs, INPUT DATASET dsUserRole).
  END METHOD.

END CLASS.