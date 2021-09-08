@program FILE(name="SIStoreAgency.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIStoreAgency", URI="/SIStoreAgency", schemaName="dsStoreAgency", schemaFile="").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIStoreAgency: 
  {src/include/dsStoreAgency.i}
  DEFINE PRIVATE VARIABLE beStoreAgency AS src.be.BEStoreAgency NO-UNDO.
    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC SIStoreAgency (  ):
    beStoreAgency = NEW src.be.BEStoreAgency() .
        
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC SIStoreAgency ( ):
    DELETE OBJECT beStoreAgency NO-ERROR.

  END DESTRUCTOR.
    
  METHOD PUBLIC VOID ReadStoreAgency(OUTPUT DATASET dsStoreAgency, INPUT ipcStoreAgencyId AS CHARACTER ):
        
    beStoreAgency:ReadStoreAgency(OUTPUT DATASET dsStoreAgency BY-REFERENCE, INPUT ipcStoreAgencyId) .
        
    CATCH err AS Progress.Lang.Error :
            
      MESSAGE err:GetMessage(1) VIEW-AS ALERT-BOX.
         
    END CATCH.
         
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  METHOD PUBLIC VOID ReadStoreAgencies(INPUT filter AS CHARACTER, OUTPUT DATASET dsStoreAgency):
        
    DATASET dsStoreAgency:empty-dataset(). 
    MESSAGE "DEBUG SI: Start ReadStoreAgency".
    beStoreAgency:ReadStoreAgencies(INPUT filter, OUTPUT DATASET dsStoreAgency BY-REFERENCE) .
    MESSAGE "DEBUG SI: End ReadStoreAgency".  
         
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json"). 
  METHOD PUBLIC VOID CreateStoreAgency (INPUT-OUTPUT DATASET dsStoreAgency):
        
    MESSAGE "DEBUG SI: Start CreateStoreAgency".  
    beStoreAgency:CreateStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency BY-REFERENCE).
    MESSAGE "DEBUG SI: End CreateStoreAgency". 
       
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency):
        
    MESSAGE "DEBUG SI: Start UpdateStoreAgency".  
    beStoreAgency:UpdateStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency BY-REFERENCE).
    MESSAGE "DEBUG SI: End UpdateStoreAgency".
       
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID DeleteStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency):
        
    MESSAGE "DEBUG SI: Start DeleteStoreAgency".  
    beStoreAgency:DeleteStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency BY-REFERENCE).
    MESSAGE "DEBUG SI: End DeleteStoreAgency".
    
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
    beStoreAgency:CountStoreAgency(INPUT filter, OUTPUT numRecs, INPUT DATASET dsStoreAgency).

  END METHOD.
  
    
END CLASS.