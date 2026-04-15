package com.mada.visa_mg.domain.converter;

import com.mada.visa_mg.domain.enums.StatutPiece;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class StatutPieceConverter implements AttributeConverter<StatutPiece, String> {

    @Override
    public String convertToDatabaseColumn(StatutPiece attribute) {
        return attribute == null ? null : attribute.getDbValue();
    }

    @Override
    public StatutPiece convertToEntityAttribute(String dbData) {
        return StatutPiece.fromDbValue(dbData);
    }
}
