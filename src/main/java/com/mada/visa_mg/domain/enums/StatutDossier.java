package com.mada.visa_mg.domain.enums;

public enum StatutDossier {
    BROUILLON("brouillon"),
    SOUMIS("soumis"),
    EN_INSTRUCTION("en_instruction"),
    VALIDE("valide"),
    REJETE("rejete");

    private final String dbValue;

    StatutDossier(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static StatutDossier fromDbValue(String dbValue) {
        if (dbValue == null) {
            return null;
        }
        for (StatutDossier s : values()) {
            if (s.dbValue.equals(dbValue)) {
                return s;
            }
        }
        throw new IllegalArgumentException("Unknown StatutDossier dbValue: " + dbValue);
    }
}
