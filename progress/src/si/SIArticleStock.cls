@program FILE(name="SIArticleStock.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIArticleStock", URI="/SIArticleStock", schemaName="dsArticleStock", schemaFile="").
 /*------------------------------------------------------------------------
    File        : SIArticleStock
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Wed Aug 04 09:31:33 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIArticleStock: 
    {src\include\dsArticleStock.i}
    DEFINE VARIABLE beArticleStock AS src.be.BEArticleStock NO-UNDO.
    
    CONSTRUCTOR PUBLIC SIArticleStock (  ):
        SUPER ().
        beArticleStock = NEW src.be.BEArticleStock().    
    END CONSTRUCTOR.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadArticleStock(INPUT filter AS CHARACTER, OUTPUT DATASET dsArticleStock):
        
       DATASET dsArticleStock:EMPTY-DATASET(). 
       MESSAGE "DEBUG SI: Start ReadArticleStock".  
       beArticleStock:ReadArticleStock(INPUT filter, OUTPUT DATASET dsArticleStock BY-REFERENCE).
       
       MESSAGE "DEBUG SI: End ReadArticleStock".  

    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beArticleStock:CountArticleStock(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateArticleStock(INPUT-OUTPUT DATASET dsArticleStock):
         
         MESSAGE "DEBUG SI: Start CreateArticleStock".  
         
         beArticleStock:CreateArticleStock(INPUT-OUTPUT DATASET dsArticleStock BY-REFERENCE).
         
         MESSAGE "DEBUG SI: End CreateArticleStock".  
         
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateArticleStock(INPUT-OUTPUT DATASET dsArticleStock):
        
        MESSAGE "DEBUG SI: Start UpdateArticleStock".  
        
        beArticleStock:UpdateArticleStock(INPUT-OUTPUT DATASET dsArticleStock BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateArticleStock". 
        
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteArticleStock(INPUT-OUTPUT DATASET dsArticleStock):
        
        MESSAGE "DEBUG SI: Start DeleteArticleStock". 
        
        beArticleStock:DeleteArticleStock(INPUT-OUTPUT DATASET dsArticleStock BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End DeleteArticleStock".
        
    END METHOD.
END CLASS.