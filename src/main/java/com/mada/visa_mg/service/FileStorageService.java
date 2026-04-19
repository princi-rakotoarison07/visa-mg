package com.mada.visa_mg.service;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageService {

    @Value("${file.upload-dir}")
    private String uploadDir;

    private Path rootLocation;

    @PostConstruct
    public void init() {
        rootLocation = Paths.get(uploadDir);
        try {
            Files.createDirectories(rootLocation);
        } catch (IOException e) {
            throw new RuntimeException("Impossible de créer le répertoire d'upload : " + uploadDir, e);
        }
    }

    /**
     * Stocke un fichier uploadé et retourne le chemin relatif.
     * Le nom est rendu unique via UUID pour éviter les collisions.
     */
    public String store(MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("Le fichier est vide");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String uniqueName = UUID.randomUUID().toString() + extension;

        try {
            Path destinationFile = rootLocation.resolve(uniqueName).normalize().toAbsolutePath();
            Files.copy(file.getInputStream(), destinationFile, StandardCopyOption.REPLACE_EXISTING);
            return uniqueName;
        } catch (IOException e) {
            throw new RuntimeException("Impossible de stocker le fichier : " + originalFilename, e);
        }
    }

    /**
     * Retourne le chemin absolu d'un fichier stocké.
     */
    public Path getFilePath(String filename) {
        return rootLocation.resolve(filename).normalize().toAbsolutePath();
    }
}
