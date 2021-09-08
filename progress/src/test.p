BLOCK-LEVEL ON ERROR UNDO, THROW.

{src/include/dsStore.i}
{src/include/dsStoreAgency.i}
DEFINE VARIABLE siStore AS src.si.SIStore NO-UNDO.
DEFINE VARIABLE siStoreAgency AS src.si.SIStoreAgency NO-UNDO.

siStore = NEW src.si.SIStore() .
siStoreAgency = NEW src.si.SIStoreAgency().

TEMP-TABLE ttStore:TRACKING-CHANGES = YES .

CREATE ttStore.
ASSIGN 
    ttStore.Description = "Zara is a Spanish clothing retailer." .   
TEMP-TABLE ttStore:TRACKING-CHANGES = NO.
siStore:CreateStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE) .
FOR EACH ttStore:
        DISPLAY ttStore .
END .


/*
// ----- DELETE STORE WORKS
TEMP-TABLE ttStore:TRACKING-CHANGES = YES .
FIND FIRST ttStore NO-LOCK 
            WHERE ttStore.StoreId='1' NO-ERROR.
IF AVAILABLE ttStore THEN 
DO:
    TEMP-TABLE ttStore:TRACKING-CHANGES = YES . 
    DELETE ttStore .
    TEMP-TABLE ttStore:TRACKING-CHANGES = NO.
    siStore:DeleteStore(INPUT-OUTPUT DATASET dsStore BY-REFERENCE ) .
    siStore:ReadStores(OUTPUT DATASET dsStore BY-REFERENCE) .
    FOR EACH ttStore:
        DISPLAY ttStore .
    END .
END.  */
