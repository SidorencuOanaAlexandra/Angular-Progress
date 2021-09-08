DEFINE TEMP-TABLE ttStoreAgency BEFORE-TABLE bttStoreAgency
    FIELD StoreAgencyId AS CHARACTER INITIAL "1" LABEL "StoreAgencyId" FORMAT 'X(60)'
    FIELD StoreId       AS CHARACTER INITIAL "1" LABEL "StoreId" FORMAT 'X(60)'
    FIELD Address   AS CHARACTER LABEL "Description"
        FIELD id            AS CHARACTER 
    FIELD seq           AS INTEGER
    INDEX StoreAgencyId IS PRIMARY UNIQUE StoreAgencyId.