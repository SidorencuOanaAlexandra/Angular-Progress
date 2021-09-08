 
/*------------------------------------------------------------------------
   File        : RentArticle
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 19:16:27 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BERentArticle INHERITS src.be.BEGeneric: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

  {include/dsRentArticle.i}
  {include/dsRent.i}
  {include/dsArticleStock.i}
  {include/dsStoreAgency.i}
    
  DEFINE PRIVATE VARIABLE daRentArticle  AS src.da.DARentArticle  NO-UNDO.  
  DEFINE PRIVATE VARIABLE beRent         AS src.be.BERent         NO-UNDO.
  DEFINE PRIVATE VARIABLE beArticle      AS src.be.BEArticle      NO-UNDO.
  DEFINE PRIVATE VARIABLE beArticleStock AS src.be.BEArticleStock NO-UNDO.
  DEFINE PRIVATE VARIABLE beStoreAgency  AS src.be.BEStoreAgency  NO-UNDO.

  CONSTRUCTOR PUBLIC BERentArticle (  ):
    SUPER ().
    daRentArticle = NEW src.da.DARentArticle().
  END CONSTRUCTOR.

  METHOD PUBLIC VOID GetData(INPUT cfilter AS CHARACTER,OUTPUT DATASET dsRentArticle):
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
    ExtractABLFilter(INPUT cfilter,OUTPUT cWhere,OUTPUT  iMaxRows , OUTPUT iSkipRows ).
                
    daRentArticle:ReadTable(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows,OUTPUT DATASET  dsRentArticle BY-REFERENCE).
  END METHOD.

  METHOD PUBLIC VOID AddRentArticle(INPUT-OUTPUT DATASET dsRentArticle):

    DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE BUFFER buffRentArticle FOR Rent.
    beArticle = NEW src.be.BEArticle().
    beRent = NEW src.be.BERent().
    MESSAGE "add"
      VIEW-AS ALERT-BOX.
    FOR EACH ttRentArticle NO-LOCK
      WHERE ROW-STATE(ttRentArticle) = ROW-CREATED:
                                
      IF ttRentArticle.RentId = ? OR ttRentArticle.RentId = "" THEN
        cErrorMessage = cErrorMessage + "RentId invalid! ~n".

      IF beRent:CheckIdRentIdExist(INPUT ttRentArticle.RentId) = FALSE THEN
        cErrorMessage = cErrorMessage + "RentId does not exist! ~n".
                
      MESSAGE "dupa rent id"
        VIEW-AS ALERT-BOX.

      IF beArticle:CheckIdArticleIdExist(INPUT ttRentArticle.ArticleId) = FALSE THEN
        cErrorMessage = cErrorMessage + "Article does not exist! ~n".

      MESSAGE "dupa articleid"
        VIEW-AS ALERT-BOX.

      IF ttRentArticle.NumberOfArticles = ? OR ttRentArticle.NumberOfArticles < 0 THEN
        cErrorMessage = cErrorMessage + "NumberOfArticles invalid! ~n".


      IF cErrorMessage <> "" THEN
        UNDO , THROW NEW Progress.Lang.AppError(cErrorMessage,100).

    END.
 
    daRentArticle:AddRentArticle(INPUT-OUTPUT  DATASET dsRentArticle).

                
    CATCH err AS Progress.Lang.Error :
      MESSAGE err:GetMessage(1)
        VIEW-AS ALERT-BOX.
      UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1),100).
    END CATCH.
        

  END METHOD.


  METHOD PUBLIC VOID RemoveRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):

    FOR EACH bttRentArticle NO-LOCK
      WHERE ROW-STATE(bttRentArticle) = ROW-DELETED:
      daRentArticle:RemoveRentArticle(INPUT-OUTPUT  DATASET dsRentArticle).
    END.

  END METHOD.

  METHOD PUBLIC VOID UpdateRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):

    DEFINE VARIABLE cErrorMessage       AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE VARIABLE iNumberArticleStock AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iNumberArticleAdded AS INTEGER   NO-UNDO.
    DEFINE VARIABLE httSource AS HANDLE       NO-UNDO.
    DEFINE VARIABLE httTarget  AS HANDLE      NO-UNDO.
      
    beRent = NEW src.be.BERent().
    beArticle = NEW src.be.BEArticle().
    
    beRent:FetchAllRent(OUTPUT DATASET dsRent BY-REFERENCE).


    MESSAGE "ceva5_up"
      VIEW-AS ALERT-BOX.
    FOR EACH ttRentArticle NO-LOCK
      WHERE ROW-STATE(ttRentArticle) =  ROW-MODIFIED:
                
      IF ttRentArticle.RentId = ? OR ttRentArticle.RentId = "" THEN
        cErrorMessage = cErrorMessage + "RentId invalid! ~n".
       
      IF beRent:CheckIdRentIdExist(INPUT ttRentArticle.RentId) = FALSE THEN
        cErrorMessage = cErrorMessage + "RentId is not exist! ~n".
                
            
      IF beArticle:CheckIdArticleIdExist(INPUT ttRentArticle.ArticleId) = FALSE THEN
        cErrorMessage = cErrorMessage + "ArticleId does not exist! ~n".
        
            
      IF ttRentArticle.NumberOfArticles = ? OR ttRentArticle.NumberOfArticles < 0 THEN 
        cErrorMessage = cErrorMessage + "NumberOfArticles invalid! ~n".

      IF ttRentArticle.NumberOfArticles = ? OR ttRentArticle.NumberOfArticles = 0 THEN
        cErrorMessage = cErrorMessage + "NumberOfArticles invalid! ~n".
        
      FIND FIRST ttRent NO-LOCK
        WHERE ttRent.RentId = ttRentArticle.RentId NO-ERROR.
      
/*    assign                                          */
/*      httSource = TEMP-TABLE ttRentArticle:HANDLE . */
/*      httTarget = TEMP-TABLE ttRentArticle2:HANDLE .*/
/*                                                    */
/*      httTarget:Copy-temp-table(httSource,?,?,?,?). */
      
      //iNumberArticleStock = GetStocKFromAnArticle(INPUT ttRentArticle.ArticleId,input ttRentArticle.RentId,input ttRent.DateFrom, INPUT ttRent.DateTo).
           
/*      IF iNumberArticleStock < iNumberArticleAdded THEN          */
/*        cErrorMessage = cErrorMessage + "insufficient stock! ~n".*/
                          
      IF cErrorMessage <> "" THEN
        UNDO , THROW NEW Progress.Lang.AppError(cErrorMessage,100).

    END.
    
/*    assign                                          */
/*      httSource = TEMP-TABLE ttRentArticle2:HANDLE .*/
/*      httTarget = TEMP-TABLE ttRentArticle:HANDLE . */
/*                                                    */
/*    httTarget:Copy-temp-table(httSource,?,?,?,?).   */

    daRentArticle:UpdateRentArticle(INPUT-OUTPUT DATASET dsRentArticle BY-REFERENCE).
   


  END METHOD.
    
  METHOD PUBLIC VOID GetNumberRow(INPUT cfilter AS CHARACTER, OUTPUT  iNumberRow AS INTEGER , INPUT DATASET dsRentArticle):        
    DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
    ExtractABLFilter(INPUT cfilter,OUTPUT cWhere,OUTPUT  iMaxRows , OUTPUT iSkipRows ).
       
    daRentArticle:count(INPUT cWhere,OUTPUT iNumberRow).
  END.
    
    
  METHOD PUBLIC VOID FetchAllRentArticle(OUTPUT DATASET dsRentArticle):
    daRentArticle:FetchAllRentArticle(OUTPUT DATASET dsRentArticle BY-REFERENCE ).
  END METHOD.

  METHOD PUBLIC INTEGER  GetStocKFromAnArticle(INPUT ipcArticleId AS CHARACTER, INPUT ipcRentid AS CHARACTER ,INPUT ipdDateFrom AS DATE, INPUT ipdDateTo AS DATE):
      
    DEFINE VARIABLE cStoreAgencyId AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iStockAmount   AS INTEGER   NO-UNDO .
    DEFINE VARIABLE iok            AS INTEGER   NO-UNDO.
    iStockAmount = 0.
    iok = 0.
      
    beRent = NEW src.be.BERent().
    beArticleStock = NEW src.be.BEArticleStock().
    beStoreAgency = NEW src.be.BEStoreAgency().
    
    cStoreAgencyId = beRent:GetStoreAgencyIdFromRent(INPUT ipcRentId).
    MESSAGE "cStoreAgencyId" cStoreAgencyId
    VIEW-AS ALERT-BOX.
    iStockAmount = beArticleStock:GetArticleAmountForArticle(INPUT ipcArticleId,INPUT cStoreAgencyId).
    MESSAGE "iStockAmount" STRING(iStockAmount)
    VIEW-AS ALERT-BOX.
    
    beRent:FetchAllRent(OUTPUT DATASET dsRent BY-REFERENCE ).
    beArticleStock:FetchAllArticleStock(OUTPUT DATASET dsArticleStock BY-REFERENCE ).
    beStoreAgency:FetchAllStoreAgency(OUTPUT DATASET dsStoreAgency BY-REFERENCE ).
    daRentArticle:FetchAllRentArticle(OUTPUT DATASET dsRentArticle BY-REFERENCE ).

    
    FOR EACH ttRentArticle NO-LOCK
      WHERE ttRentArticle.ArticleId EQ ipcArticleId:
      MESSAGE "ttRentArticle"
        VIEW-AS ALERT-BOX.
      FOR EACH ttRent NO-LOCK
        WHERE ttRentArticle.RentId EQ ttRent.RentId AND ttRent.RentStatus NE 2:
        FOR EACH ttStoreAgency NO-LOCK
          WHERE ttRent.StoreAgencyId EQ ttStoreAgency.StoreAgencyId:
          MESSAGE "am ajuns1"
            VIEW-AS ALERT-BOX.
            
          IF ipdDateTo - ttRent.DateFrom GE 0 THEN
          DO:
            iok = 1.
            iStockAmount = iStockAmount - ttRentArticle.NumberOfArticles.
          END.
          IF ttRent.DateTo - ipdDateFrom GE 0 AND iok EQ 0 THEN
          DO:
            iok = 1.
            iStockAmount = iStockAmount - ttRentArticle.NumberOfArticles.
          END.
        END.
            
      END.
    END.
    MESSAGE "stock" STRING(iStockAmount)
      VIEW-AS ALERT-BOX.

    RETURN iStockAmount.     
      
      
  END METHOD.
    
  METHOD PUBLIC VOID RemoveAllRentArticlesFromRent(INPUT ipcRentId AS CHARACTER ):
    daRentArticle:RemoveAllRentArticlesFromRent(INPUT-OUTPUT ipcRentId).
  END METHOD.

  DESTRUCTOR PUBLIC BERentArticle ( ):
    DELETE OBJECT daRentArticle NO-ERROR.
    DELETE OBJECT beRent NO-ERROR.
    DELETE OBJECT beArticle NO-ERROR.
    DELETE OBJECT beStoreAgency NO-ERROR.
    DELETE OBJECT beArticleStock NO-ERROR.
  END DESTRUCTOR.


END CLASS.