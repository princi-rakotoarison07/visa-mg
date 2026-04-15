package com.mada.visa_mg.domain.converter;

import com.mada.visa_mg.domain.enums.StatutDossier;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class StatutDossierConverter implements AttributeConverter<StatutDossier, String> {

    @Override
    public String convertToDatabaseColumn(StatutDossier attribute) {
        return attribute == null ? null : attribute.getDbValue();
    }

    @Override
    public StatutDossier convertToEntityAttribute(String dbData) {
        return StatutDossier.fromDbValue(dbData);
    }
}
