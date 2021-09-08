DEFINE TEMP-TABLE ttRoleType NO-UNDO
    BEFORE-TABLE bttRoleType
    FIELD RoleTypeId AS CHARACTER
    FIELD Description AS CHARACTER
    FIELD id        AS CHARACTER 
    FIELD seq       AS INTEGER 
    
    INDEX idxRoleTypeId IS PRIMARY UNIQUE RoleTypeId
    .
    