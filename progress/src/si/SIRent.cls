@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRent", URI="/SIRent", schemaName="dsRent", schemaFile="").
 
/*------------------------------------------------------------------------
   File        : SIRent
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 20:36:43 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIRent: 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  {include/dsRent.i}
  {include/dsRentArticle.i}
    
  DEFINE PRIVATE VARIABLE beRent AS src.be.BERent NO-UNDO.
    
  CONSTRUCTOR PUBLIC SIRent (  ):
    SUPER ().
    beRent = NEW src.BE.BERent().
  END CONSTRUCTOR.


  @openapi.openedge.method.property (name="mappingType", value="JFP").
  @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID GetData(INPUT filter AS CHARACTER, OUTPUT DATASET dsRent):
    beRent:GetData(filter, OUTPUT DATASET dsRent BY-REFERENCE).
              
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID AddRent(INPUT-OUTPUT DATASET dsRent):

    beRent:AddRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).

    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
      UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1),100).
    END CATCH.
    
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID RemoveRent(INPUT-OUTPUT DATASET dsRent):
        
    beRent:RemoveRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
       
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
      UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1),100).
    END CATCH.
        
  END METHOD.
   
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
  @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
  METHOD PUBLIC VOID UpdateRent(INPUT-OUTPUT DATASET dsRent):
    .
    beRent:UpdateRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
      UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1),100).
    END CATCH.
        
  END METHOD.
    
  @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
  @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
  METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
    beRent:GetNumberRow(INPUT filter,OUTPUT numRecs,INPUT DATASET dsRent).

  END METHOD.

  DESTRUCTOR PUBLIC SIRent ():
    DELETE OBJECT beRent NO-ERROR .
  END DESTRUCTOR.


END CLASS.