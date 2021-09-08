DEFINE TEMP-TABLE ttStore BEFORE-TABLE bttStore
    FIELD StoreId AS CHARACTER INITIAL "1" LABEL "StoreId" FORMAT 'X(60)'
    FIELD Description AS CHARACTER LABEL "Description" FORMAT 'X(60)'
        FIELD id            AS CHARACTER 
    FIELD seq           AS INTEGER
    INDEX StoreId IS PRIMARY UNIQUE StoreId.