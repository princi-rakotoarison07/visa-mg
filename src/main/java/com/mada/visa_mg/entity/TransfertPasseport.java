package com.mada.visa_mg.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "transfert_passeport")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransfertPasseport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ancien_passeport_id")
    private Passeport ancienPasseport;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nouveau_passeport_id")
    private Passeport nouveauPasseport;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}
