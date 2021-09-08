@program FILE(name="SIAppUser.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIAppUser", URI="/SIAppUser", schemaName="dsAppUser", schemaFile="").

USING Progress.Lang.*.
USING src.be.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.siAppUser:

  {src/include/dsAppUser.i}
  {src/include/dsUserRole.i}
    
  
  DEFINE VARIABLE beAppUser AS src.be.beAppUser NO-UNDO.

  /*------------------------------------------------------------------------------
  Purpose:
  Notes:
  ------------------------------------------------------------------------------*/
  CONSTRUCTOR PUBLIC siAppUser():

    beAppUser = NEW beAppUser().

  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
  Purpose: Get one or more records, based on a filter string
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  METHOD PUBLIC VOID ReadAppUser( INPUT filter AS CHARACTER, OUTPUT DATASET dsAppUser):
    DATASET dsAppUser:empty-dataset(). 
    MESSAGE "DEBUG SI: Start ReadAppUser".  
    beAppUser:GetData(INPUT filter, OUTPUT dataset dsAppUser).
    MESSAGE "DEBUG SI: End ReadAppUser".  
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Create one or more new records
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
         
    MESSAGE "DEBUG SI: Start CreateAppUser".  
         
    beAppUser:CreateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
         
    MESSAGE "DEBUG SI: End CreateAppUser".  
         
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Update one or more records
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        
    MESSAGE "DEBUG SI: Start UpdateAppUser".  
        
    beAppUser:UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End UpdateAppUser". 
        
  END METHOD.

  /*------------------------------------------------------------------------------
  Purpose: Delete a record
  Notes:
  ------------------------------------------------------------------------------*/
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser):
        
    MESSAGE "DEBUG SI: Start DeleteAppUser". 
        
    beAppUser:DeleteAppUser (INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE, INPUT-OUTPUT dataset dsUserRole BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End DeleteAppUser".
        
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
    beAppUser:CountAppUsers(INPUT filter, OUTPUT numRecs, INPUT DATASET dsAppUser).
  END METHOD.
  
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/login?", alias="", mediaType="application/json").
  METHOD PUBLIC CHARACTER login(INPUT username AS CHARACTER, INPUT password AS CHARACTER):
    MESSAGE "DEBUG SI: Start login". 
  
    RETURN beAppUser:login(INPUT username, INPUT password).
    
  END METHOD.
  
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/report-user?", alias="", mediaType="application/json").
  METHOD PUBLIC VOID getTopStores():
    MESSAGE "DEBUG SI: Start working on report".
    
    beAppUser:getTopStores().
    
    MESSAGE "DEBUG SI: End working on report".
     
  END METHOD.
     

END CLASS.