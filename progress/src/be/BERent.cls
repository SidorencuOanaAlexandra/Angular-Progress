 
/*------------------------------------------------------------------------
   File        : BERent
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 22:04:26 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BERent INHERITS src.be.BEGeneric: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

  {include/dsRent.i}
    
  DEFINE PRIVATE VARIABLE daRent        AS src.da.DARent        NO-UNDO.
  DEFINE PRIVATE VARIABLE beRentArticle AS src.be.BERentArticle NO-UNDO.  
  DEFINE PRIVATE VARIABLE beAppUser     AS src.be.beAppUser     NO-UNDO.

  CONSTRUCTOR PUBLIC BERent (  ):
    SUPER ().
    daRent = NEW src.da.DARent().
  END CONSTRUCTOR.

  METHOD PUBLIC VOID GetData(INPUT cfilter AS CHARACTER,OUTPUT DATASET dsRent):
        
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    UpdateRentsStatus().
        
    ExtractABLFilter(INPUT cfilter,output cWhere,output  iMaxRows , OUTPUT iSkipRows ).
                
    daRent:ReadTable(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows,OUTPUT DATASET  dsRent BY-REFERENCE).
  END METHOD.
  
  METHOD PUBLIC VOID FetchAllRent(OUTPUT DATASET dsRent):
    daRent:FetchAllRent(OUTPUT DATASET dsRent BY-REFERENCE ).
  END METHOD.
    
  METHOD PUBLIC VOID UpdateRentsStatus():
      
    DEFINE VARIABLE dCurentDate AS DATE NO-UNDO.
      
    dCurentDate = NOW.
      
    daRent:FetchAllRent(OUTPUT DATASET dsRent BY-REFERENCE ).
      
    FOR EACH ttRent NO-lock:
        
      IF ttRent.DateFrom - dCurentDate > 0 then
        daRent:UpdateStatusRent(INPUT ttRent.RentId, 0).
      ELSE 
      IF dCurentDate - ttRent.DateFrom ge 0  AND ttRent.DateTo - dCurentDate ge 0 then
        daRent:UpdateStatusRent(INPUT ttRent.RentId, 1).
      else
      IF dCurentDate - ttRent.DateTo  > 0 then
        daRent:UpdateStatusRent(INPUT ttRent.RentId, 2).
        
    END.
      
  END METHOD.

  METHOD PUBLIC VOID AddRent(INPUT-OUTPUT  DATASET dsRent):

    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE BUFFER buffRent for Rent.

    FOR EACH ttRent no-lock
      WHERE ROW-STATE(ttRent) = ROW-CREATED:
            
      IF ttRent.DateFrom = ? then
        cErrorMessage = cErrorMessage + "DateFrom invalid! ~n".
      IF ttRent.DateTo = ? then
        cErrorMessage = cErrorMessage + "DateTo invalid! ~n".
                                
      IF cErrorMessage <> "" THEN
        UNDO , THROW NEW PROGRESS.Lang.AppError(cErrorMessage,100).

    END.
    daRent:AddRent(INPUT-OUTPUT DATASET dsRent).

  END METHOD.


  METHOD PUBLIC VOID RemoveRent(INPUT-OUTPUT DATASET dsRent):
        
    beRentArticle = NEW src.be.BERentArticle().

    FOR EACH bttRent no-lock
      WHERE row-state(bttRent) = ROW-DELETED:
      beRentArticle:RemoveAllRentArticlesFromRent(INPUT bttRent.RentId).
      daRent:RemoveRent(INPUT-OUTPUT DATASET dsRent).
    END.

  END METHOD.

  METHOD PUBLIC VOID UpdateRent(INPUT-OUTPUT DATASET dsRent):

    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    beAppUser = NEW src.be.BEAppUser().

    FOR EACH ttRent no-lock
      WHERE row-state(ttRent) =  ROW-MODIFIED:

      IF ttRent.DateTo - ttRent.DateFrom le 0 then
        cErrorMessage = cErrorMessage + "DateTo must be greater than DateFrom! ~n".
      IF ttRent.DateFrom = ? then
        cErrorMessage = cErrorMessage + "DateFrom invalid! ~n".
      IF ttRent.DateTo = ? then
        cErrorMessage = cErrorMessage + "DateTo invalid! ~n".
      IF ttRent.Rentstatus < 0 OR ttRent.Rentstatus > 3 THEN 
        cErrorMessage = cErrorMessage + "RentStatus invalid! ~n".
      IF beAppUser:CheckIfAppUserIdExist(INPUT ttRent.AppUserId) = FALSE then
        cErrorMessage = cErrorMessage + "AppUserId is not exist! ~n".

      IF cErrorMessage <> "" THEN
        UNDO , THROW NEW PROGRESS.Lang.AppError(cErrorMessage,100).

    END.

    daRent:UpdateRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).


  END METHOD.
    
  METHOD PUBLIC void GetNumberRow(INPUT cfilter AS CHARACTER, OUTPUT  iNumberRow AS INTEGER , INPUT DATASET dsRent):        
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
    ExtractABLFilter(INPUT cfilter,output cWhere,output  iMaxRows , OUTPUT iSkipRows ).
       
    daRent:count(INPUT cWhere,output iNumberRow).
  END.

  METHOD PUBLIC LOGICAL CheckIdRentIdExist(INPUT ipcRentId AS CHARACTER):
       
    RETURN daRent:CheckIdRentIdExist(INPUT ipcRentId). 
       
  END METHOD.   
  
  METHOD PUBLIC CHARACTER GetStoreAgencyIdFromRent(INPUT ipcRentId AS character):
    
    RETURN daRent:GetStoreAgencyIdFromRent(INPUT ipcRentId).
    
  END METHOD.  
    

  DESTRUCTOR PUBLIC BERent ( ):
    DELETE OBJECT daRent NO-ERROR.
    DELETE OBJECT beRentArticle NO-ERROR.
    DELETE OBJECT beAppUser NO-ERROR.
  END DESTRUCTOR.


END CLASS.