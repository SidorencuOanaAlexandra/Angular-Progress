@program FILE(name="SIStore.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIStore", URI="/SIStore", schemaName="dsStore", schemaFile="").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIStore: 
  {src/include/dsStore.i}
  DEFINE PRIVATE VARIABLE beStore AS src.be.BEStore NO-UNDO.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC SIStore (  ):
    beStore = NEW src.be.BEStore() .
        
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC SIStore ( ):
    DELETE OBJECT beStore NO-ERROR.

  END DESTRUCTOR.
    
  METHOD PUBLIC VOID ReadStore(OUTPUT DATASET dsStore, INPUT ipcStoreId AS CHARACTER ):
        
    beStore:ReadStore(OUTPUT DATASET dsStore BY-REFERENCE, INPUT ipcStoreId) .
        
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1) VIEW-AS ALERT-BOX.
    END CATCH.
         
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  METHOD PUBLIC VOID ReadStores(INPUT filter AS CHARACTER ,OUTPUT DATASET dsStore):
        
    DATASET dsStore:empty-dataset(). 
    MESSAGE "DEBUG SI: Start ReadStore".
    beStore:ReadStores(INPUT filter, OUTPUT DATASET dsStore BY-REFERENCE) .
    MESSAGE "DEBUG SI: End ReadStore".  
         
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json"). 
  METHOD PUBLIC VOID CreateStore (INPUT-OUTPUT DATASET dsStore):
       
    MESSAGE "DEBUG SI: Start CreateStore".  
    beStore:CreateStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE).
    MESSAGE "DEBUG SI: End CreateStore". 
       
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateStore(INPUT-OUTPUT DATASET dsStore):
        
    MESSAGE "DEBUG SI: Start UpdateStore".  
    beStore:UpdateStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE).
    MESSAGE "DEBUG SI: End UpdateStore".
       
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID DeleteStore(INPUT-OUTPUT DATASET dsStore):
        
    MESSAGE "DEBUG SI: Start DeleteStore".  
    beStore:DeleteStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE).
    MESSAGE "DEBUG SI: End DeleteStore".
       
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
    beStore:CountStore(INPUT filter, OUTPUT numRecs, INPUT DATASET dsStore).

  END METHOD.
  
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/report-store?", alias="", mediaType="application/json").
  METHOD PUBLIC VOID getTopArticles(INPUT ipcStoreId AS CHARACTER ):
    MESSAGE "DEBUG SI: Start working on report".
    
    beStore:getTopArticles(INPUT ipcStoreId).
    
    MESSAGE "DEBUG SI: End working on report".
     
  END METHOD.
    
END CLASS.