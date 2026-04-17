package com.mada.visa_mg.dto;

import com.mada.visa_mg.entity.Demandeur;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DossierListDTO {
    private Integer id; 
    private Demandeur demandeur;
    private LocalDateTime createdAt;
    private String statutCode;
    private String statutLibelle;
    private Integer stepToContinue;
}
