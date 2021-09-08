@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRentArticle", URI="/SIRentArticle", schemaName="dsRentArticle", schemaFile="").
 
/*------------------------------------------------------------------------
   File        : SIRentArticle
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 19:22:56 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIRentArticle: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

  {include/dsRentArticle.i}
    
  DEFINE PRIVATE VARIABLE beRentArticle AS src.be.BERentArticle NO-UNDO.
    
  CONSTRUCTOR PUBLIC SIRentArticle (  ):
    SUPER ().
    beRentArticle = NEW src.BE.BERentArticle().
  END CONSTRUCTOR.


  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID GetData(INPUT filter AS CHARACTER, OUTPUT DATASET dsRentArticle):
    beRentArticle:GetData(filter, OUTPUT DATASET dsRentArticle BY-REFERENCE).
              
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID AddRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):

    beRentArticle:AddRentArticle(INPUT-OUTPUT  DATASET dsRentArticle by-reference).

    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
      undo, THROW new PROGRESS.Lang.AppError(err:GetMessage(1),100).
    END CATCH.
    
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID RemoveRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):
        
    beRentArticle:RemoveRentArticle(INPUT-OUTPUT  DATASET dsRentArticle BY-REFERENCE).
       
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
      undo, THROW NEW PROGRESS.Lang.AppError(err:GetMessage(1),100).
    END CATCH.
        
  END METHOD.
   
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):
    .
    beRentArticle:UpdateRentArticle(INPUT-OUTPUT  DATASET dsRentArticle BY-REFERENCE).
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
      undo, THROW NEW PROGRESS.Lang.AppError(err:GetMessage(1),100).
    END CATCH.
        
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
    beRentArticle:GetNumberRow(INPUT filter,output numRecs,input DATASET dsRentArticle).

  END METHOD.

  DESTRUCTOR PUBLIC SIRentArticle ():
    DELETE OBJECT beRentArticle NO-ERROR .
  END DESTRUCTOR.
    

END CLASS.