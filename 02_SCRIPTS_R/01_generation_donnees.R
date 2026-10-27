# ==========================================================================
# 01_generation_donnees.R
# GÉNÉRATION D'UN JEU DE DONNÉES SYNTHÉTIQUE (FICTIF) POUR L'ENSEIGNEMENT
#
# ATTENTION : toutes les données produites ici sont ENTIÈREMENT FICTIVES.
# Elles ne proviennent d'aucun dossier de patiente ni d'aucun hôpital réel.
# Elles servent uniquement à la formation à l'analyse de données avec R.
#
# Ce script est destiné au formateur. Les étudiantes n'ont pas besoin de
# l'exécuter : le fichier CSV est déjà fourni dans 01_DONNEES.
# set.seed() garantit que l'on obtient exactement les mêmes données à chaque fois.
# La graine (135) a été retenue après essai de plusieurs graines, afin d'obtenir un
# profil pédagogiquement équilibré (certaines associations significatives, d'autres non).
# Les effets simulés ci-dessous sont des choix de simulation, pas des résultats réels.
#
# CRITÈRES DIAGNOSTIQUES SIMULÉS (inspirés ACOG 2020 / ISSHP 2021)
#  - Prééclampsie : hypertension apparue après 20 SA chez une femme non
#    hypertendue (PAS >= 140 et/ou PAD >= 90 mmHg) ET
#      * protéinurie >= 1+ à la bandelette, OU
#      * signe de gravité / atteinte d'organe en l'absence de protéinurie.
#  - Prééclampsie surajoutée : même chose chez une femme avec HTA chronique
#    (apparition d'une protéinurie ou de signes de gravité, ou aggravation
#    de la PA après 20 SA).
#  - HTA gestationnelle : hypertension après 20 SA, sans protéinurie ni signe
#    de gravité.
#  - HTA chronique seule : HTA connue avant la grossesse, sans prééclampsie.
#  - Normotendue : aucun trouble hypertensif.
# La protéinurie n'est donc PAS obligatoire pour poser le diagnostic.
# ==========================================================================

set.seed(135)
n <- 400

# --- Localiser le dossier du projet (fonctionne depuis la racine ou 02_SCRIPTS_R)
if (dir.exists("01_DONNEES")) {
  dossier_projet <- "."
} else if (dir.exists("../01_DONNEES")) {
  dossier_projet <- ".."
} else {
  stop("Dossier 01_DONNEES introuvable. Ouvrez le projet (fichier .Rproj) dans RStudio.")
}

# ==========================================================================
# A. CARACTÉRISTIQUES SOCIODÉMOGRAPHIQUES
# ==========================================================================
id_patiente <- sprintf("F%03d", 1:n)

age_ans <- round(15 + rgamma(n, shape = 5, rate = 0.42))
age_ans <- pmin(pmax(age_ans, 15), 45)

milieu_residence <- sample(c("Urbain", "Rural"), n, replace = TRUE, prob = c(0.58, 0.42))
urbain <- milieu_residence == "Urbain"

niveau_instruction <- character(n)
niveau_instruction[urbain]  <- sample(c("Aucun", "Primaire", "Secondaire", "Supérieur"),
                                      sum(urbain), TRUE, prob = c(0.08, 0.22, 0.52, 0.18))
niveau_instruction[!urbain] <- sample(c("Aucun", "Primaire", "Secondaire", "Supérieur"),
                                      sum(!urbain), TRUE, prob = c(0.25, 0.32, 0.38, 0.05))
niveau_instruction[age_ans < 21 & niveau_instruction == "Supérieur"] <- "Secondaire"

profession <- character(n)
liste_prof <- c("Ménagère", "Commerçante", "Agricultrice", "Élève/Étudiante",
                "Artisane", "Salariée")
profession[urbain]  <- sample(liste_prof, sum(urbain), TRUE,
                              prob = c(0.28, 0.32, 0.02, 0.12, 0.14, 0.12))
profession[!urbain] <- sample(liste_prof, sum(!urbain), TRUE,
                              prob = c(0.32, 0.22, 0.28, 0.06, 0.08, 0.04))
profession[age_ans < 20 & runif(n) < 0.55] <- "Élève/Étudiante"
profession[profession == "Salariée" & niveau_instruction %in% c("Aucun", "Primaire")] <- "Commerçante"
profession[profession == "Élève/Étudiante" & niveau_instruction == "Aucun"] <- "Ménagère"
profession[profession == "Élève/Étudiante" & age_ans > 30] <- "Commerçante"

liste_situation <- c("Mariée", "Union libre", "Célibataire", "Veuve/divorcée")
situation_matrimoniale <- ifelse(
  age_ans < 20,
  sample(liste_situation, n, TRUE, prob = c(0.15, 0.20, 0.62, 0.03)),
  sample(liste_situation, n, TRUE, prob = c(0.62, 0.20, 0.15, 0.03)))

# ==========================================================================
# B. ANTÉCÉDENTS OBSTÉTRICAUX ET MÉDICAUX
# ==========================================================================
# Parité = nombre d'accouchements antérieurs (>= 28 SA). La grossesse actuelle n'est pas comptée.
lambda_parite <- 0.15 * pmax(0, age_ans - 17) * ifelse(urbain, 1, 1.25)
parite <- rpois(n, lambda_parite)
parite <- pmin(parite, pmax(0, floor((age_ans - 16) / 2)), 9)

# Gestité = parité + grossesse actuelle + éventuelles pertes (fausses couches, avortements)
pertes <- rbinom(n, size = 2, prob = 0.08)
gestite <- parite + 1 + pertes

# Indice de masse corporelle (kg/m2) mesuré à la 1re consultation prénatale
imc <- exp(rnorm(n, log(23.8) + 0.004 * (age_ans - 27), 0.16))
imc <- round(pmin(pmax(imc, 16), 45), 1)

# HTA chronique connue, diabète préexistant, antécédent familial d'HTA
p_hta <- plogis(-3.0 + 0.06 * (age_ans - 27) + 0.05 * (imc - 24))
hta_chronique <- rbinom(n, 1, p_hta)
p_diab <- plogis(-3.6 + 0.04 * (age_ans - 27) + 0.06 * (imc - 24))
diabete <- rbinom(n, 1, p_diab)
atcd_familial_hta <- rbinom(n, 1, 0.20 + 0.10 * hta_chronique)

# Antécédent personnel de prééclampsie : possible seulement si parité >= 1
atcd_pe <- ifelse(parite >= 1, rbinom(n, 1, 0.08), NA)

# ==========================================================================
# C. CARACTÉRISTIQUES DE LA GROSSESSE
# ==========================================================================
age_gestationnel_sa <- round(20 + 21 * rbeta(n, 3, 1.4))
age_gestationnel_sa <- pmin(age_gestationnel_sa, 41)

lambda_cpn <- pmax(0.3, 1 + 0.10 * (age_gestationnel_sa - 14) +
                     0.5 * (niveau_instruction %in% c("Secondaire", "Supérieur")) +
                     0.4 * urbain)
nb_cpn <- pmin(rpois(n, lambda_cpn), 10)

grossesse_multiple <- rbinom(n, 1, 0.03)

# ==========================================================================
# D. STATUT DIAGNOSTIQUE (simulé selon les règles ci-dessus)
# ==========================================================================
# Risque de prééclampsie (toutes formes) : modèle logistique.
# Les effets ci-dessous sont des choix de simulation (plausibles, non issus de données réelles).
# Pas d'effet pour : milieu de résidence, niveau d'instruction, situation matrimoniale.
eta <- -2.75 +
  0.45 * (age_ans >= 35) + 0.30 * (age_ans < 20) +
  0.65 * (parite == 0) +
  1.50 * ifelse(is.na(atcd_pe), 0, atcd_pe) +
  1.20 * hta_chronique +
  1.00 * grossesse_multiple +
  0.045 * (imc - 24) +
  0.35 * atcd_familial_hta +
  0.60 * diabete +
  0.05 * (age_gestationnel_sa - 34)
est_pe <- runif(n) < plogis(eta)

type_diagnostic <- rep("Normotendue", n)
hta_gest <- rbinom(n, 1, 0.04) == 1
type_diagnostic[hta_gest] <- "HTA gestationnelle"
type_diagnostic[hta_chronique == 1] <- "HTA chronique seule"
type_diagnostic[est_pe & hta_chronique == 0] <- "Prééclampsie"
type_diagnostic[est_pe & hta_chronique == 1] <- "Prééclampsie surajoutée"

# --- Pression artérielle (mmHg) selon le statut
pas_mmhg <- numeric(n)
pad_mmhg <- numeric(n)

i <- which(type_diagnostic == "Normotendue")
pas_mmhg[i] <- pmin(pmax(round(rnorm(length(i), 110, 9)), 90), 134)
pad_mmhg[i] <- round(32 + 0.33 * pas_mmhg[i] + rnorm(length(i), 0, 4.5))
pad_mmhg[i] <- pmin(pmax(pad_mmhg[i], 52), 84)

i <- which(type_diagnostic == "HTA gestationnelle")
pas_mmhg[i] <- pmin(pmax(round(rnorm(length(i), 146, 5)), 140), 158)
pad_mmhg[i] <- pmin(pmax(round(rnorm(length(i), 92, 4.5)), 78), 105)
iso <- i[runif(length(i)) < 0.10]            # hypertension diastolique isolée
pas_mmhg[iso] <- sample(128:139, length(iso), TRUE)
pad_mmhg[iso] <- sample(90:98, length(iso), TRUE)

i <- which(type_diagnostic == "HTA chronique seule")
pas_mmhg[i] <- pmin(pmax(round(rnorm(length(i), 142, 12)), 110), 158)   # certaines sont traitées
pad_mmhg[i] <- round(32 + 0.40 * pas_mmhg[i] + rnorm(length(i), 0, 5))
pad_mmhg[i] <- pmin(pmax(pad_mmhg[i], 60), 104)

est_pe_type <- type_diagnostic %in% c("Prééclampsie", "Prééclampsie surajoutée")
i <- which(est_pe_type)
pa_severe <- runif(length(i)) < 0.30
pas_mmhg[i] <- ifelse(pa_severe, round(rnorm(length(i), 168, 8)), round(rnorm(length(i), 150, 6)))
pas_mmhg[i] <- pmin(pmax(pas_mmhg[i], ifelse(pa_severe, 160, 140)), ifelse(pa_severe, 200, 159))
pad_mmhg[i] <- round(32 + 0.42 * pas_mmhg[i] + rnorm(length(i), 0, 5))
pad_mmhg[i] <- pmin(pmax(pad_mmhg[i], 70), 125)
iso <- i[!pa_severe & runif(length(i)) < 0.08]
pas_mmhg[iso] <- sample(128:139, length(iso), TRUE)
pad_mmhg[iso] <- sample(90:98, length(iso), TRUE)

# Pression différentielle (PAS - PAD) toujours physiologiquement plausible
pad_mmhg <- pmin(pad_mmhg, pas_mmhg - 25)

# --- Protéinurie (bandelette urinaire)
proteinurie <- character(n)
i <- which(type_diagnostic == "Normotendue")
proteinurie[i] <- sample(c("Négative", "Traces", "1+"), length(i), TRUE, prob = c(0.93, 0.055, 0.015))
i <- which(type_diagnostic %in% c("HTA gestationnelle", "HTA chronique seule"))
proteinurie[i] <- sample(c("Négative", "Traces"), length(i), TRUE, prob = c(0.90, 0.10))
i <- which(est_pe_type)
avec_prot <- runif(length(i)) < 0.80
proteinurie[i] <- ifelse(avec_prot,
                         sample(c("1+", "2+", "3+"), length(i), TRUE, prob = c(0.55, 0.32, 0.13)),
                         sample(c("Négative", "Traces"), length(i), TRUE, prob = c(0.60, 0.40)))

# --- Signes de gravité (PA >= 160/110 ou signe clinique/biologique d'atteinte d'organe)
# Sans protéinurie, le diagnostic de prééclampsie exige un signe d'atteinte d'organe.
signe_clinique <- rbinom(n, 1, 0.35)
sans_prot <- proteinurie %in% c("Négative", "Traces")
signe_clinique[est_pe_type & sans_prot] <- 1
signes_gravite <- rep("Non applicable", n)
grave <- pas_mmhg >= 160 | pad_mmhg >= 110 | signe_clinique == 1
signes_gravite[est_pe_type] <- ifelse(grave[est_pe_type], "Oui", "Non")

preeclampsie <- ifelse(est_pe_type, "Oui", "Non")

# ==========================================================================
# E. ASSEMBLAGE DU TABLEAU DE DONNÉES
# ==========================================================================
donnees <- data.frame(
  id_patiente            = id_patiente,
  age_ans                = age_ans,
  situation_matrimoniale = situation_matrimoniale,
  niveau_instruction     = niveau_instruction,
  profession             = profession,
  milieu_residence       = milieu_residence,
  gestite                = gestite,
  parite                 = parite,
  atcd_preeclampsie      = ifelse(is.na(atcd_pe), "Non applicable", ifelse(atcd_pe == 1, "Oui", "Non")),
  atcd_hta_chronique     = ifelse(hta_chronique == 1, "Oui", "Non"),
  atcd_familial_hta      = ifelse(atcd_familial_hta == 1, "Oui", "Non"),
  atcd_diabete           = ifelse(diabete == 1, "Oui", "Non"),
  age_gestationnel_sa    = age_gestationnel_sa,
  nb_cpn                 = nb_cpn,
  type_grossesse         = ifelse(grossesse_multiple == 1, "Multiple", "Unique"),
  imc                    = imc,
  pas_mmhg               = pas_mmhg,
  pad_mmhg               = pad_mmhg,
  proteinurie            = proteinurie,
  signes_gravite         = signes_gravite,
  type_diagnostic        = type_diagnostic,
  preeclampsie           = preeclampsie,
  stringsAsFactors = FALSE
)

# ==========================================================================
# F. VÉRIFICATIONS DE COHÉRENCE (le script s'arrête si une règle est violée)
# ==========================================================================
stopifnot(nrow(donnees) == 400)
stopifnot(all(donnees$parite <= donnees$gestite - 1))                        # parité < gestité
stopifnot(all(donnees$atcd_preeclampsie[donnees$parite == 0] == "Non applicable"))
stopifnot(all(donnees$pas_mmhg - donnees$pad_mmhg >= 20))                    # pression différentielle plausible
stopifnot(all(donnees$age_gestationnel_sa >= 20 & donnees$age_gestationnel_sa <= 41))
hta_valeur <- donnees$pas_mmhg >= 140 | donnees$pad_mmhg >= 90
pe <- donnees$preeclampsie == "Oui"
prot_pos <- donnees$proteinurie %in% c("1+", "2+", "3+")
stopifnot(all(hta_valeur[pe]))                                               # PE => PA élevée
stopifnot(all((prot_pos | donnees$signes_gravite == "Oui")[pe]))             # PE => protéinurie OU gravité
stopifnot(all(donnees$signes_gravite[!pe] == "Non applicable"))
stopifnot(all(donnees$type_diagnostic[donnees$atcd_hta_chronique == "Non"] != "Prééclampsie surajoutée"))
stopifnot(all(donnees$type_diagnostic[donnees$atcd_hta_chronique == "Oui"] != "Prééclampsie"))
stopifnot(all(!hta_valeur[donnees$type_diagnostic == "Normotendue"]))

# ==========================================================================
# G. INTRODUCTION DE VALEURS MANQUANTES (après le calcul du diagnostic)
# ==========================================================================
donnees$imc[sample(n, 30)]                        <- NA   # IMC non mesuré (~7,5 %)
donnees$profession[sample(n, 8)]                  <- NA
donnees$niveau_instruction[sample(n, 6)]          <- NA
donnees$nb_cpn[sample(n, 10)]                     <- NA
donnees$atcd_familial_hta[sample(n, 12)]          <- NA
donnees$atcd_diabete[sample(n, 5)]                <- NA
i_multi <- which(donnees$parite >= 1)
donnees$atcd_preeclampsie[sample(i_multi, 6)]     <- NA  # antécédent non renseigné

# ==========================================================================
# H. EXPORTATION (séparateur ; et virgule décimale : format français, UTF-8)
# ==========================================================================
fichier_sortie <- file.path(dossier_projet, "01_DONNEES", "donnees_TFE_preeclampsie_Kara.csv")
write.csv2(donnees, fichier_sortie, row.names = FALSE, fileEncoding = "UTF-8")

cat("Fichier créé :", fichier_sortie, "\n")
cat("Observations :", nrow(donnees), " | Variables :", ncol(donnees), "\n")
cat("Prééclampsie (toutes formes) :", sum(donnees$preeclampsie == "Oui"), "cas\n")
