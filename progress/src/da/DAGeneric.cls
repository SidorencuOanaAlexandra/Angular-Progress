 
/*------------------------------------------------------------------------
   File        : DAGeneric
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Thu Jul 29 16:10:31 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAGeneric: 
        
  DEFINE PUBLIC VARIABLE tableName     AS CHARACTER NO-UNDO.
  DEFINE PUBLIC VARIABLE tempTableName AS CHARACTER NO-UNDO.
    
  METHOD PUBLIC VOID ReadTable(INPUT cWhere AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET-HANDLE hDataset):
    DEFINE VARIABLE hQuery    AS HANDLE  NO-UNDO.
    DEFINE VARIABLE hBuffer   AS HANDLE  NO-UNDO.
    DEFINE VARIABLE httBuffer AS HANDLE  NO-UNDO.
    DEFINE VARIABLE iCount    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iSeq      AS INTEGER NO-UNDO.
        
    CREATE BUFFER hBuffer FOR TABLE tableName.
    CREATE BUFFER httBuffer FOR TABLE hDataset:GET-BUFFER-HANDLE(tempTableName).
        
    hDataset:EMPTY-DATASET().
    CREATE QUERY hQuery.
        
    hQuery:SET-BUFFERS(hBuffer).
    hQuery:QUERY-PREPARE(SUBSTITUTE("for each &1 no-lock &2", hBuffer:NAME, cWhere)).
        
    hQuery:QUERY-OPEN().
    hQuery:REPOSITION-TO-ROW(iSkipRows).
    iCount = 0.
    iSeq = 0.
    REPEAT:
      hQuery:GET-NEXT(NO-LOCK).
      IF hQuery:QUERY-OFF-END THEN 
        LEAVE.
      httBuffer:BUFFER-CREATE.
      httBuffer:BUFFER-COPY(hBuffer).
      ASSIGN
        httBuffer:BUFFER-FIELD('id'):BUFFER-VALUE  = STRING(hBuffer:ROWID)
        iSeq                                       = iSeq + 1
        httBuffer:BUFFER-FIELD('seq'):BUFFER-VALUE = iSeq.
      iCount = iCount + 1.
      IF (iCount EQ iMaxRows) THEN 
        LEAVE.               
    END.
    hQuery:QUERY-CLOSE().
        
    FINALLY:
      DELETE OBJECT hQuery.    
      DELETE OBJECT hBuffer. 
      DELETE OBJECT httBuffer. 
    END FINALLY.
        
  END.  
    
  METHOD PUBLIC VOID count(INPUT cWhere AS CHARACTER, OUTPUT numRecs AS INTEGER):
    DEFINE VARIABLE hQuery  AS HANDLE NO-UNDO.
    DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
        
    CREATE BUFFER hBuffer FOR TABLE tableName.
    CREATE QUERY hQuery.
        
    hQuery:SET-BUFFERS (hBuffer).
    hQuery:QUERY-PREPARE (SUBSTITUTE("preselect each &1 no-lock &2", hbuffer:NAME, cWhere)).
    hQuery:QUERY-OPEN ().
            
    numRecs = hQuery:NUM-RESULTS.        
        
    hQuery:QUERY-CLOSE (). 
        
    FINALLY:
      DELETE OBJECT hQuery.
      DELETE OBJECT hBuffer.     
    END FINALLY.  
  END METHOD.

END CLASS.