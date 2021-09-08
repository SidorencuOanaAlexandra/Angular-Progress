 
/*------------------------------------------------------------------------
   File        : beStoreAgency
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 14:44:18 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING System.Windows.Forms.Message FROM ASSEMBLY.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEStoreAgency INHERITS src.be.BEGeneric: 
  {src/include/dsStoreAgency.i}
    
  DEFINE PRIVATE VARIABLE daStoreAgency AS src.da.DAStoreAgency NO-UNDO.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC BEStoreAgency (  ):
    SUPER ().
    daStoreAgency = NEW src.da.DAStoreAgency().
        
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC BEStoreAgency ( ):
    DELETE OBJECT daStoreAgency NO-ERROR.

  END DESTRUCTOR.
    
  METHOD PUBLIC VOID readStoreAgency(OUTPUT DATASET dsStoreAgency, INPUT ipcStoreAgencyId AS CHARACTER) :
        
    daStoreAgency:fetchStoreAgency(OUTPUT DATASET dsStoreAgency BY-REFERENCE, INPUT ipcStoreAgencyId) .
        
  END METHOD.
  
  METHOD PUBLIC VOID FetchAllStoreAgency(OUTPUT DATASET dsStoreAgency).
  END METHOD.

  METHOD PUBLIC VOID readStoreAgencies(INPUT filter AS CHARACTER, OUTPUT DATASET dsStoreAgency) :
        
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    SUPER:extractABLfilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows) .
    daStoreAgency:ReadTable(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsStoreAgency BY-REFERENCE).
    
  END METHOD .
    
  METHOD PUBLIC VOID CreateStoreAgency (INPUT-OUTPUT DATASET dsStoreAgency) :

    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    FOR EACH ttStoreAgency NO-LOCK:
            
      IF ttStoreAgency.StoreId=? OR ttStoreAgency.StoreId="" THEN 
        cErrorMessage = cErrorMessage + "StoreId cand not be empty." .
      IF ttStoreAgency.Address = ? OR ttStoreAgency.Address = "" THEN 
        cErrorMessage = cErrorMessage + "Address can not be empty." .
    END.
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage,100) .
    daStoreAgency:CreateStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency BY-REFERENCE).
       
  END METHOD.
     
  METHOD PUBLIC VOID UpdateStoreAgency (INPUT-OUTPUT DATASET dsStoreAgency) :
         
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
    FOR EACH ttStoreAgency NO-LOCK
      WHERE ROW-STATE(ttStoreAgency) = ROW-MODIFIED:
      IF ttStoreAgency.StoreAgencyId=? OR ttStoreAgency.StoreAgencyId="" THEN 
        cErrorMessage = cErrorMessage + "StoreAgencyId can not be empty." .
      IF ttStoreAgency.StoreId=? OR ttStoreAgency.StoreId="" THEN 
        cErrorMessage = cErrorMessage + "StoreId can not be empty." .
      IF ttStoreAgency.Address = ? OR ttStoreAgency.Address = "" THEN 
        cErrorMessage = cErrorMessage + "Address can not be empty." .
    END .
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage,100) .
    daStoreAgency:UpdateStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency BY-REFERENCE).
             
        
  END METHOD.
     
  METHOD PUBLIC VOID DeleteStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency ) :
    
    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    FOR EACH bttStoreAgency NO-LOCK :
      IF bttStoreAgency.StoreAgencyId=? OR bttStoreAgency.StoreAgencyId="" THEN 
        cErrorMessage = cErrorMessage + "StoreAgencyId can not be empty." .
    END. 
    IF cErrorMessage <> "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage,100) .
    daStoreAgency:DeleteStoreAgency(INPUT-OUTPUT DATASET dsStoreAgency BY-REFERENCE) .
            
  END METHOD. 
     
  METHOD PUBLIC VOID CountStoreAgency( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER, INPUT DATASET dsStoreAgency):
    
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
    ExtractABLFilter(INPUT filter,OUTPUT cWhere,OUTPUT  iMaxRows , OUTPUT iSkipRows ).
    daStoreAgency:count(INPUT cWhere, OUTPUT numRecs).

  END METHOD.   
   

END CLASS.