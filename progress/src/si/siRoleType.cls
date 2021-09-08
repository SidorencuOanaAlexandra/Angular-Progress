@program FILE(name="SIRoleType.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="true").
@progress.service.resource FILE(name="SIRoleType", URI="/SIRoleType", schemaName="dsRoleType", schemaFile="").

USING Progress.Lang.*.
USING src.be.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.siRoleType:

  {src/include/dsRoleType.i}
    
  DEFINE VARIABLE beRoleType AS beRoleType NO-UNDO.

  /*------------------------------------------------------------------------------
  Purpose:
  Notes:
  ------------------------------------------------------------------------------*/
  CONSTRUCTOR PUBLIC siRoleType():

    beRoleType = NEW beRoleType().

  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
  Purpose: Get one or more records, based on a filter string
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  METHOD PUBLIC VOID ReadRoleType( INPUT filter AS CHARACTER, OUTPUT DATASET dsRoleType):
    DATASET dsRoleType:empty-dataset(). 
    MESSAGE "DEBUG SI: Start ReadRoleType".  
    beRoleType:GetData(INPUT filter, OUTPUT dataset dsRoleType).
    MESSAGE "DEBUG SI: End ReadRoleType".  
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Create one or more new records
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
         
    MESSAGE "DEBUG SI: Start CreateRoleType".  
         
    beRoleType:CreateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
         
    MESSAGE "DEBUG SI: End CreateRoleType".  
         
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Update one or more records
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        
    MESSAGE "DEBUG SI: Start UpdateRoleType".  
        
    beRoleType:UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End UpdateRoleType". 
        
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Delete a record
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
        
    MESSAGE "DEBUG SI: Start DeleteRoleType". 
        
    beRoleType:DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End DeleteRoleType".
        
  END METHOD.
    
      
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
    beRoleType:CountRoleTypes(INPUT filter, OUTPUT numRecs, INPUT DATASET dsRoleType).
  END METHOD.

END CLASS.