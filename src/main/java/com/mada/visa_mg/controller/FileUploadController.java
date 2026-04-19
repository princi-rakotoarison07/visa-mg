package com.mada.visa_mg.controller;

import com.mada.visa_mg.service.FileStorageService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/uploads")
public class FileUploadController {

    private final FileStorageService fileStorageService;

    public FileUploadController(FileStorageService fileStorageService) {
        this.fileStorageService = fileStorageService;
    }

    /**
     * Upload temporaire d'un fichier.
     * Retourne le nom unique du fichier stocké (sera rattaché à la demande lors de la soumission).
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Map<String, String> uploadFile(@RequestParam("file") MultipartFile file) {
        String storedFilename = fileStorageService.store(file);
        return Map.of("fichierPath", storedFilename);
    }
}
