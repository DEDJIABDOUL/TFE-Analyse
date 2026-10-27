# Atelier RStudio : analyse des données d'un mémoire (TFE)

**Sujet :** Fréquence et facteurs associés à la prééclampsie chez les femmes enceintes prises en charge dans une structure hospitalière de Kara, Togo.

![R](https://img.shields.io/badge/R-%E2%89%A5%204.2-276DC3?logo=r&logoColor=white)
![RStudio](https://img.shields.io/badge/RStudio-Desktop-75AADB?logo=rstudio&logoColor=white)
![Données](https://img.shields.io/badge/donn%C3%A9es-synth%C3%A9tiques-orange)

<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMKeRvx4g3rWud0lngNOAK1_4w64Ky44Va8uzy0A_Hl10ncSu7UooHH4U&s=10" alt="Illustration 1" width="300" height="200">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUtnbrIXYwRAvQjpoJ4VM-NhyO1n4zcRGROk31nckUhw&s=10" alt="Illustration 2" width="300" height="200">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDu4-S3VhC8_hIeeoqperXPfxlhp1WT-xhdddm7258XQ&s=10" alt="Illustration 3" width="300" height="200">
</p>

> [!WARNING]
> **Toutes les données sont synthétiques.**
> Elles ne proviennent d'aucune patiente ni d'aucun hôpital réel. Elles servent uniquement à apprendre l'analyse de données. **Ne citez aucun résultat comme réel.**

## Sommaire

1. [Contenu du projet](#1-contenu-du-projet)
2. [Logiciels nécessaires](#2-logiciels-nécessaires)
3. [Ouvrir le projet dans RStudio](#3-ouvrir-le-projet-dans-rstudio)
4. [Importer les données](#4-importer-les-données)
5. [Exécuter le script](#5-exécuter-le-script)
6. [Où retrouver les résultats](#6-où-retrouver-les-résultats)
7. [Adapter le script à un autre sujet de mémoire](#7-adapter-le-script-à-un-autre-sujet-de-mémoire)
8. [Notes de transparence](#notes-de-transparence)

---

## 1. Contenu du projet

```text
.
├── Atelier_TFE.Rproj                  # à ouvrir pour démarrer le projet dans RStudio
├── 01_DONNEES/
│   ├── donnees_TFE_preeclampsie_Kara.csv   # 400 femmes, 22 variables
│   └── dictionnaire_variables.pdf
├── 02_SCRIPTS_R/
│   ├── 01_generation_donnees.R        # recrée les données
│   └── 02_analyse_TFE.R               # l'analyse complète
├── 03_FICHES_PEDAGOGIQUES/
│   ├── Fiche_questions_recherche_TFE.pdf
│   ├── Fiche_corrigee_questions_recherche.pdf
│   └── Mini_protocole_recherche_TFE.pdf
├── 04_GUIDE_FORMATEUR/
│   └── Guide_formateur_analyse_TFE_R.pdf
└── 05_RESULTATS/
    ├── tableaux/
    └── graphiques/
```

## 2. Logiciels nécessaires

Tous sont gratuits.

| Logiciel | Version | Lien |
|---|---|---|
| **R** | 4.2 ou plus récente | <https://cran.r-project.org> |
| **RStudio Desktop** | dernière version | <https://posit.co/download/rstudio-desktop/> |
| **ggplot2** (package) | — | installé automatiquement par le script |

> [!IMPORTANT]
> Installer **R avant RStudio**.
> Une connexion Internet est requise la première fois pour installer `ggplot2`. Aucun autre package n'est nécessaire.

## 3. Ouvrir le projet dans RStudio

1. Décompresser l'archive ZIP (clic droit › *Extraire tout*). **Ne pas travailler à l'intérieur du ZIP.**
2. Double-cliquer sur `Atelier_TFE.Rproj`. RStudio s'ouvre sur le bon dossier.
3. Dans le volet **Files**, ouvrir `02_SCRIPTS_R` puis `02_analyse_TFE.R`.

> [!TIP]
> Si les accents s'affichent mal : **File › Reopen with Encoding › UTF-8**.

## 4. Importer les données

L'importation est faite par la **Section 1** du script (ligne `read.csv2`). Le fichier CSV utilise :

- le **point-virgule** comme séparateur ;
- la **virgule** comme séparateur décimal (format français).

Les chemins sont relatifs : **rien à modifier** si le projet est ouvert avec le fichier `.Rproj`.

> [!NOTE]
> Il n'est pas nécessaire d'exécuter `01_generation_donnees.R`.

## 5. Exécuter le script

| Action | Raccourci |
|---|---|
| Exécuter ligne par ligne (curseur sur la ligne) | `Ctrl` + `Entrée` |
| Exécuter tout le script d'un coup | `Ctrl` + `Maj` + `Entrée` |

Le script est organisé en sections :

1. Préparation
2. Exploration
3. Les dix questions de recherche
4. Tableaux
5. Synthèse des tests
6. Graphiques
7. Exportation

## 6. Où retrouver les résultats

| Dossier | Contenu |
|---|---|
| `05_RESULTATS/tableaux/` | Fichiers CSV (Tableau 1 à Tableau 5, synthèses), lisibles dans Excel |
| `05_RESULTATS/graphiques/` | 5 graphiques PNG (300 dpi, 16 × 10 cm) à insérer dans Word |

Les dossiers sont créés automatiquement s'ils n'existent pas.

## 7. Adapter le script à un autre sujet de mémoire

1. Placer votre fichier CSV dans `01_DONNEES/`.
2. **Section 1** : remplacer le nom du fichier. Si votre CSV utilise la virgule comme séparateur et le point comme décimale, remplacer `read.csv2` par `read.csv`.
3. Remplacer les noms de variables par les vôtres (vérifier avec `names(donnees)`).
4. Adapter les modalités (`factor` / `levels`) et les classes (`cut`) à vos variables.
5. Pour chaque nouveau facteur, copier le bloc de la **Question 5** et changer uniquement le nom de la variable.
6. Votre variable de résultat doit avoir les modalités `"Non"` et `"Oui"`.
7. Relancer tout le script : tableaux et graphiques sont refaits automatiquement.

Détails dans `04_GUIDE_FORMATEUR/` (**Annexe B**).

> [!NOTE]
> Pour me contacter,  dbatinou@gmail.com.
> N'hésiter pas à m'envoyer vos questions ou inquiétudes
