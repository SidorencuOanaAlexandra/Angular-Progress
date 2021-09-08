@program FILE(name="SIArticleType.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIArticleType", URI="/SIArticleType", schemaName="dsArticleType", schemaFile="").
/*------------------------------------------------------------------------
   File        : SIArticleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 09:31:58 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIArticleType: 
    {src\include\dsArticleType.i}
    DEFINE VARIABLE beArticleType AS src.be.BEArticleType NO-UNDO.
    
    CONSTRUCTOR PUBLIC SIArticleType (  ):
        SUPER ().
        beArticleType = NEW src.be.BEArticleType().    
    END CONSTRUCTOR.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadArticleType(INPUT filter AS CHARACTER, OUTPUT DATASET dsArticleType):
        
        DATASET dsArticleType:empty-dataset(). 
        MESSAGE "DEBUG SI: Start ReadArticleType".  
        beArticleType:ReadArticleType(INPUT filter, OUTPUT DATASET dsArticleType BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadArticleType".  

    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beArticleType:CountArticleType(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateArticleType(INPUT-OUTPUT DATASET dsArticleType):
         
        MESSAGE "DEBUG SI: Start CreateArticleType".  
         
        beArticleType:CreateArticleType(INPUT-OUTPUT DATASET dsArticleType BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateArticleType".  
         
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateArticleType(INPUT-OUTPUT DATASET dsArticleType):
        
        MESSAGE "DEBUG SI: Start UpdateArticleType".  
        
        beArticleType:UpdateArticleType(INPUT-OUTPUT DATASET dsArticleType BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateArticleType".

    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteArticleType(INPUT-OUTPUT DATASET dsArticleType):
        
        MESSAGE "DEBUG SI: Start DeleteArticleType". 
        
        beArticleType:DeleteArticleType(INPUT-OUTPUT DATASET dsArticleType BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End DeleteArticleType".
        
    END METHOD.

END CLASS.