 
/*------------------------------------------------------------------------
   File        : DARentArticle
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 10:51:21 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DARentArticle INHERITS src.da.DAGeneric:

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

  {include/dsRentArticle.i}

  CONSTRUCTOR PUBLIC DARentArticle ( ):
    SUPER ().
    TableName = "RentArticle".
    TempTableName = "ttRentArticle".    
  END CONSTRUCTOR.
    
  METHOD PUBLIC VOID FetchAllRentArticle(OUTPUT DATASET dsRentArticle):
    DEFINE BUFFER buffRentArticle FOR RentArticle.
    DATASET dsRentArticle:EMPTY-DATASET ().
        
    FOR EACH buffRentArticle NO-LOCK:
      CREATE ttRentArticle.
      BUFFER-COPY buffRentArticle TO ttRentArticle.
    END.
  END METHOD.
  
 

  METHOD PUBLIC VOID AddRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):

    FOR EACH ttRentArticle no-lock
      WHERE row-state(ttRentArticle) = ROW-CREATED:
      CREATE RentArticle.
      BUFFER-COPY ttRentArticle EXCEPT RentArticleId TO RentArticle.
            
    END.

  END METHOD.
    
  METHOD PUBLIC VOID RemoveRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):

    DEFINE BUFFER buffRentArticle FOR RentArticle.
        
    FOR EACH bttRentArticle no-lock
      WHERE row-state(bttRentArticle) = ROW-DELETED:
      FOR FIRST buffRentArticle EXCLUSIVE-LOCK
        WHERE buffRentArticle.RentArticleId = bttRentArticle.RentArticleId:
        DELETE  buffRentArticle.
      END.
    END.

  END METHOD.

  METHOD PUBLIC VOID UpdateRentArticle(INPUT-OUTPUT  DATASET dsRentArticle):

    DEFINE BUFFER buffRentArticle FOR RentArticle.

    FOR EACH ttRentArticle no-lock
      WHERE ROW-STATE(ttRentArticle) = ROW-MODIFIED:
      DO TRANSACTION.
        FOR FIRST buffRentArticle EXCLUSIVE-LOCK 
          WHERE buffRentArticle.RentArticleId = ttRentArticle.RentArticleId:
          BUFFER-COPY ttRentArticle EXCEPT RentArticleId TO buffRentArticle.
                    
        END.
      END.
    END.

  END METHOD.
        
  METHOD PUBLIC VOID RemoveAllRentArticlesFromRent(INPUT-OUTPUT  ipcRentId AS CHARACTER ):
        
    DEFINE BUFFER buffRentArticle FOR RentArticle.
        
    FOR EACH buffRentArticle EXCLUSIVE-LOCK 
      WHERE buffRentArticle.RentId = ipcRentId:
      DELETE buffRentArticle.
    END.
        
  END METHOD.    
    
    
    

  DESTRUCTOR PUBLIC DARentArticle ():

  END DESTRUCTOR.

END CLASS.