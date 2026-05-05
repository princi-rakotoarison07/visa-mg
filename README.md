# Visa-MG (Back-Office)

Ce projet est le Back-Office du système **Visa-Flow**, conçu pour gérer les demandes de titres de séjour et de visas à Madagascar. Il fournit une API robuste pour le suivi des dossiers, la gestion des demandeurs et le traitement des flux complexes (Duplicata, Transfert de Passeport).

## 🎯 Objectifs
- Centraliser la gestion des demandes de visa.
- Automatiser le suivi des pièces justificatives.
- Gérer l'historique des statuts des dossiers.
- Assurer la cohérence des données entre demandeurs, passeports et visas.

## 🛠️ Stack Technique
- **Framework** : Java Spring Boot 3
- **Gestion de dépendances** : Maven
- **Base de données** : PostgreSQL
- **ORM** : Spring Data JPA (Hibernate)
- **Validation** : Jakarta Validation

## ⚙️ Configuration du Projet

### 1. Prérequis
- Java 17 ou supérieur.
- PostgreSQL installé et en cours d'exécution.
- Maven installé.

### 2. Configuration de la Base de Données
1. Créez une base de données PostgreSQL nommée `visa_flow`.
2. Exécutez le script SQL initial situé dans : `database/basev2.sql`.
3. Modifiez le fichier `src/main/resources/application.properties` (ou `application.yml`) pour configurer vos identifiants :
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/visa_flow
   spring.datasource.username=VOTRE_USERNAME
   spring.datasource.password=VOTRE_PASSWORD
   ```

### 3. Lancer l'application
Exécutez la commande suivante à la racine du projet :
```bash
mvn spring-boot:run
```
L'API sera accessible par défaut sur `http://localhost:8080`.

## 📂 Structure du Backend
- `com.mada.visa_mg.controller` : Endpoints REST.
- `com.mada.visa_mg.entity` : Modèles de données JPA.
- `com.mada.visa_mg.repository` : Interfaces d'accès aux données.
- `com.mada.visa_mg.dto` : Objets de transfert de données pour les flux complexes.

## 🔗 Repository Source
Retrouvez les sources et les mises à jour sur : [GitHub - Visa-MG](https://github.com/princi-rakotoarison07/visa-mg)
