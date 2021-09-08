@program FILE(name="SIArticle.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIArticle", URI="/SIArticle", schemaName="dsArticle", schemaFile="").
/*------------------------------------------------------------------------
   File        : SIArticle
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:31:44 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIArticle: 
  {src\include\dsArticle.i}
  DEFINE VARIABLE beArticle AS src.be.BEArticle NO-UNDO.
    
  CONSTRUCTOR PUBLIC SIArticle (  ):
    SUPER ().
    beArticle = NEW src.be.BEArticle().    
  END CONSTRUCTOR.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  METHOD PUBLIC VOID ReadArticle(INPUT filter AS CHARACTER, OUTPUT DATASET dsArticle):
        
    DATASET dsArticle:empty-dataset(). 
    MESSAGE "DEBUG SI: Start ReadArticle".  
    beArticle:ReadArticle(INPUT filter, OUTPUT DATASET dsArticle BY-REFERENCE).
       
    MESSAGE "DEBUG SI: End ReadArticle".  

  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
    beArticle:CountArticle(INPUT filter, OUTPUT numRecs).

  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID CreateArticle(INPUT-OUTPUT DATASET dsArticle):
         
    MESSAGE "DEBUG SI: Start CreateArticle".  
         
    beArticle:CreateArticle(INPUT-OUTPUT DATASET dsArticle BY-REFERENCE).
         
    MESSAGE "DEBUG SI: End CreateArticle".  
         
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateArticle(INPUT-OUTPUT DATASET dsArticle):
        
    MESSAGE "DEBUG SI: Start UpdateArticle".  
        
    beArticle:UpdateArticle(INPUT-OUTPUT DATASET dsArticle BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End UpdateArticle".
        
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID DeleteArticle(INPUT-OUTPUT DATASET dsArticle):
        
    MESSAGE "DEBUG SI: Start DeleteArticle". 
        
    beArticle:DeleteArticle(INPUT-OUTPUT DATASET dsArticle BY-REFERENCE).
        
    MESSAGE "DEBUG SI: End DeleteArticle".
        
  END METHOD.

END CLASS.