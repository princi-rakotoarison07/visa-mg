package com.mada.visa_mg.controller.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DemandeWebController {

    @GetMapping("/demande/nouveau")
    public String nouveauDemandeView() {
        return "demande/nouveau";
    }

    @GetMapping("/demande/liste")
    public String listeDemandeView() {
        return "demande/liste";
    }

    @GetMapping("/")
    public String indexView() {
        return "index";
    }
}
