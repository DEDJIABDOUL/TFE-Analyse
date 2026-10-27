ATELIER RSTUDIO - ANALYSE DES DONNEES D'UN MEMOIRE (TFE)
Sujet : Frequence et facteurs associes a la preeclampsie chez les femmes enceintes
        prises en charge dans une structure hospitaliere de Kara, Togo.

*** ATTENTION : TOUTES LES DONNEES SONT SYNTHETIQUES (FICTIVES). ***
Elles ne proviennent d'aucune patiente ni d'aucun hopital reel. Elles servent
uniquement a apprendre l'analyse de donnees. Ne citez aucun resultat comme reel.

------------------------------------------------------------------
1. CONTENU DU PROJET
------------------------------------------------------------------
01_DONNEES/                  donnees_TFE_preeclampsie_Kara.csv (400 femmes, 22 variables)
                             dictionnaire_variables.pdf
02_SCRIPTS_R/                01_generation_donnees.R  (recree les donnees)
                             02_analyse_TFE.R         (l'analyse complete)
03_FICHES_PEDAGOGIQUES/      Fiche_questions_recherche_TFE.pdf       
                             Fiche_corrigee_questions_recherche.pdf 
                             Mini_protocole_recherche_TFE.pdf    
04_GUIDE_FORMATEUR/          Guide_formateur_analyse_TFE_R.pdf
05_RESULTATS/                tableaux/ et graphiques/ 
Atelier_TFE.Rproj            fichier a ouvrir pour demarrer le projet dans RStudio

------------------------------------------------------------------
2. LOGICIELS NECESSAIRES (gratuits)
------------------------------------------------------------------
- R (version 4.2 ou plus recente) : https://cran.r-project.org
  (installer R AVANT RStudio)
- RStudio Desktop : https://posit.co/download/rstudio-desktop/
- Le package ggplot2 : installe automatiquement par le script (Internet requis la
  premiere fois). Aucun autre package n'est necessaire.

------------------------------------------------------------------
3. OUVRIR LE PROJET DANS RSTUDIO
------------------------------------------------------------------
a) Decompresser l'archive ZIP (clic droit > Extraire tout). Ne pas travailler
   a l'interieur du ZIP.
b) Double-cliquer sur Atelier_TFE.Rproj. RStudio s'ouvre sur le bon dossier.
c) Dans le volet "Files", ouvrir 02_SCRIPTS_R puis 02_analyse_TFE.R.
   Si les accents s'affichent mal : File > Reopen with Encoding > UTF-8.

------------------------------------------------------------------
4. IMPORTER LES DONNEES
------------------------------------------------------------------
C'est fait par la Section 1 du script (ligne read.csv2). Le fichier CSV utilise le
point-virgule comme separateur et la virgule decimale (format francais).
Chemins relatifs : rien a modifier si le projet est ouvert avec le fichier .Rproj.
Il n'est pas necessaire d'executer 01_generation_donnees.R.

------------------------------------------------------------------
5. EXECUTER LE SCRIPT
------------------------------------------------------------------
- Ligne par ligne : placer le curseur sur la ligne, Ctrl + Entree.
- Tout le script d'un coup : Ctrl + Maj + Entree.
Le script est organise en sections : 1 Preparation, 2 Exploration, 3 Les dix
questions de recherche, 4 Tableaux, 5 Synthese des tests, 6 Graphiques,
7 Exportation.

------------------------------------------------------------------
6. OU RETROUVER LES RESULTATS
------------------------------------------------------------------
05_RESULTATS/tableaux/    fichiers CSV (Tableau1 a Tableau5, syntheses), lisibles dans Excel
05_RESULTATS/graphiques/  5 graphiques PNG (300 dpi, 16 x 10 cm) a inserer dans Word
Les dossiers sont crees automatiquement s'ils n'existent pas.

------------------------------------------------------------------
7. ADAPTER LE SCRIPT A UN AUTRE SUJET DE MEMOIRE
------------------------------------------------------------------
1) Placer votre fichier CSV dans 01_DONNEES.
2) Section 1 : remplacer le nom du fichier. Si votre CSV utilise la virgule comme
   separateur et le point comme decimale, remplacer read.csv2 par read.csv.
3) Remplacer les noms de variables par les votres (verifier avec names(donnees)).
4) Adapter les modalites (factor / levels) et les classes (cut) a vos variables.
5) Pour chaque nouveau facteur, copier le bloc de la Question 5 et changer
   uniquement le nom de la variable.
6) Votre variable de resultat doit avoir les modalites "Non" et "Oui".
7) Relancer tout le script : tableaux et graphiques sont refaits automatiquement.
Details dans 04_GUIDE_FORMATEUR (Annexe B).

------------------------------------------------------------------
NOTES DE TRANSPARENCE
------------------------------------------------------------------
- Les scripts ont ete executes et verifies avec R 4.3.3 sous Linux. Ils n'ont PAS pu
  etre testes sous Windows avec RStudio : faire un essai complet la veille.
- La graine de simulation (135) a ete retenue apres essai de plusieurs graines, pour
  obtenir un profil pedagogique equilibre. Les associations sont des choix de simulation.
- Fichiers ajoutes a l'arborescence demandee : Atelier_TFE.Rproj (racine) et
  Mini_protocole_recherche_TFE.pdf (03_FICHES_PEDAGOGIQUES).
