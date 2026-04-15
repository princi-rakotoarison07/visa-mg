package com.mada.visa_mg.domain.enums;

public enum StatutPiece {
    NON_FOURNI("non_fourni"),
    FOURNI("fourni"),
    NON_APPLICABLE("non_applicable");

    private final String dbValue;

    StatutPiece(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static StatutPiece fromDbValue(String dbValue) {
        if (dbValue == null) {
            return null;
        }
        for (StatutPiece s : values()) {
            if (s.dbValue.equals(dbValue)) {
                return s;
            }
        }
        throw new IllegalArgumentException("Unknown StatutPiece dbValue: " + dbValue);
    }
}
