package com.mada.visa_mg.controller.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DemandeWebController {

    @GetMapping("/demande/nouveau")
    public String nouveauDemandeView() {
        return "demande/nouveau";
    }

    @GetMapping("/demande/duplicata")
    public String duplicataDemandeView() {
        return "demande/duplicata";
    }

    @GetMapping("/demande/transfert")
    public String transfertPasseportView() {
        return "demande/transfert";
    }

    @GetMapping("/demande/liste")
    public String listeDemandeView() {
        return "demande/liste";
    }

    @GetMapping("/demande/detail")
    public String detailDemandeView() {
        return "demande/detail";
    }

    @GetMapping("/")
    public String indexView() {
        return "index";
    }
}
