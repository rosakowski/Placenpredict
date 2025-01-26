library(shiny)
library(neuralnet)
library(DT)

ui <- fluidPage(
  titlePanel("Placental Permeability Predictor: (92.2% Accuracy)"),
  sidebarLayout(
    sidebarPanel(
      numericInput("molecular_weight", "Molecular Weight:", 100),
      numericInput("logP", "LogP:", 1),
      numericInput("PSA", "PSA:", 100),
      numericInput("HD", "HDonor:", 1),
      numericInput("HA", "HAcceptor:", 1),
      selectInput("ECCS", "ECCS:", choices = list("1" = "1", "1A" = "1.1", "1B" = "1.2", "2" = "2", "2A" = "2.1", "2B" = "2.2", "3" = "3", "3A" = "3.1", "3B" = "3.2", "4" = "4", "4A" = "4.1", "4B" = "4.2")),
      actionButton("predict", "Predict")
    ),
    mainPanel(
      DTOutput("table"),  # Displays the data frame as a table
      textOutput("prediction"),  # Displays the prediction
      tags$div(style = "border: 1px solid; padding: 10px; margin-top: 20px;", "Legend: ECCS Class: .1 = A, .2 = B. Placental Crossing: 1 = Drug crosses placenta, 0 = Drug does not cross placenta."),
      tags$div(style = "border: 1px solid; padding: 10px; margin-top: 20px;",
               "Molecular descriptor values have been sourced from well-established databases such as PubChem and DrugBank. The categorization into ECCS Classes was performed using GastroPlus PBPK and PBBM Modeling Simulation estimations."),
      tags$div(style = "border: 1px solid; padding: 10px; margin-top: 20px;",
               tags$ul(
                 "Placental Crossing References",
                 tags$li("(Di Filippo JI, Bollini M, Cavasotto CN. A Machine Learning Model to Predict Drug Transfer Across the Human Placenta Barrier. Front Chem. 2021;9:714678. Published 2021 Jul 20. doi:10.1109/fchem.2021.714678)"),
                 tags$li("1. Abman, R.P., and Steven (2017). Fetal and Neonatal Physiology. Fifth Edition. Elsevier Ltd."),
                 tags$li("2. Ali-Melkkilä, T., Kaila, T., Kanto, J., and Iisalo, E. (1990). Pharmacokinetics of glycopyrronium in
parturients. Anaesthesia 45, 634-637."),
                 tags$li("3. Allegaert, K., and Van Den Anker, J.N. (2017). '20 - Physicochemical and Structural Properties Regulating Placental Drug Transfer,'' eds. R.A. Polin, S.H. Abman, D.H. Rowitch, W.E. Benitz, W.W.B.T.F. Fox & P. Neonatal. Elsevier), 208-221.e204."),
                 tags$li("4. Ando, M., Saito, H., and Wakisaka, I. (1985). Transfer of polychlorinated biphenyls (PCBs) to newborn infants through the placenta and mothers' milk. Arch. Environ. Contam. Toxicol. 14, 51-57."),tags$li("5. Baker, H., Frank, O., Deangelis, B., Feingold, S., and Kaminetzky, H.A. (1981). Role of placenta in maternal-fetal vitamin transfer in humans. Am. J. Obstet. Gynecol. 141, 792-796."),
                 tags$li("6. Bank, A.M., Stowe, Z.N., Newport, D.J., Ritchie, J.C., and Pennell, P.B. (2017). Placental passage of antiepileptic drugs at delivery and neonatal outcomes. Epilepsia 58, e82-e86."),tags$li("7. Barceloux, D.G. (2012). Medical Toxicology of Drug Abuse: Synthesized Chemicals and Psychoactive Plants. Wiley."),
                 tags$li("8. Beermann, B., Groschinsky-Grind, M., Fåhraeus, L., and Lindström, B. (1978). Placental transfer of furosemide. Clin. Pharmacol. Ther. 24, 560-562."),tags$li("9. Boyce, P.M., Hackett, L.P., and Ilett, K.F. (2011). Duloxetine transfer across the placenta during pregnancy and into milk during lactation. Arch. Womens Ment. Health 14, 169-172."),
                 tags$li("10. Brown, Walter u., Bell, George c., Lurie, Aron o., Weiss, Jess b., Scanlon, John w., and Alper, Milton h. (1975). Newborn Blood Levels of Lidocaine and Mepivacaine in the First Postnatal Day Following Maternal Epidural Anesthesia. Anesthesiology 42, 698-707."),tags$li("11. Caballero, T., Canabal, J., Rivero-Paparoni, D., and Cabañas, R. (2014). Management of hereditary angioedema in pregnant women: a review. International journal of women's health 6, 839- 848."),
                 tags$li("12. Cetin, I., Marconi, A.M., Baggiani, A.M., Buscaglia, M., Pardi, G., Fennessey, P.V., and Battaglia, F.C. (1995). In vivo placental transport of glycine and leucine in human pregnancies. Pediatr. Res. 37, 571-575."),tags$li("13. Cho, N., Fukunaga, K., Kunii, K., and Deguchi, K. (1988). [Bacteriological, pharmacokinetic and clinical studies on the use of ceftriaxone in the perinatal period]. The Japanese journal of antibiotics 41, 180-195."),
                 tags$li("14. Chow, A.W., and Jewesson, P.J. (1985). Pharmacokinetics and safety of antimicrobial agents during pregnancy. Rev. Infect. Dis. 7, 287-313."),tags$li("15. Craft, I., Mullinger, B.M., and Kennedy, M.R. (1981). Placental transfer of cefuroxime. Br. J. Obstet. Gynaecol. 88, 141-145."),
                 tags$li("16. Cressey, T.R., Stek, A., Capparelli, E., Bowonwatanuwong, C., Prommas, S., Sirivatanapa, P., Yuthavisuthi, P., Neungton, C., Huo, Y., Smith, E., Best, B.M., Mirochnick, M., and Team, I.P. (2012). Efavirenz pharmacokinetics during the third trimester of pregnancy and postpartum. Journal of acquired immune deficiency syndromes (1999) 59, 245-252."),tags$li("17. Dancis, J., Kammerman, S., Jansen, V., and Levitz, M. (1983). The effect of ouabain on placental transport of 86Rb. Placenta 4, 351-359."),
                 tags$li("18. Dancis, J., Lehanka, J., and Levitz, M. (1985). Transfer of Riboflavin by the Perfused Human Placenta. Pediatr. Res. 19, 1143-1146."),tags$li("9. Fauchet, F., Treluyer, J.-M., Illamola, S.M., Pressiat, C., Lui, G., Valade, E., Mandelbrot, L., Lechedanec, J., Delmas, S., Blanche, S., Warszawski, J., Urien, S., Tubiana, R., and Hirt, D. (2015). Population Approach To Analyze the Pharmacokinetics of Free and Total Lopinavir in HIV-Infected Pregnant Women and Consequences for Dose Adjustment. Antimicrob. Agents Chemother. 59, 5727-5735."),
                 tags$li("20. Fortunato, S.J., Bawdon, R.E., Swan, K.F., Bryant, E.C., and Sobhi, S. (1992). Transfer of Timentin (ticarcillin and clavulanic acid) across the in vitro perfused human placenta: comparison with other agents. Am. J. Obstet. Gynecol. 167, 1595-1599."),tags$li("21. Freyer, A.M. (2009). Drugs in Pregnancy and Lactation 8th Edition: A Reference Guide to Fetal and Neonatal Risk. Obstetric Medicine 2, 89-89."),
                 tags$li("22. Fujimoto, S., Tanaka, T., and Akahane, M. (1991). Levels of ritodrine hydrochloride in fetal blood and amniotic fluid following long-term continuous administration in late pregnancy. European Journal of Obstetrics & Gynecology and Reproductive Biology 38, 15-18."),tags$li("23. Fullerton, G.M., Black, M., Shetty, A., and Bhattacharya, S. (2011). Atosiban in the Management of Preterm Labour. Clinical Medicine Insights: Women's Health 4, CMWH.S5125."),
                 tags$li("24. Gedeon, C., and Koren, G. (2006). Designing Pregnancy Centered Medications: Drugs Which Do Not Cross the Human Placenta. Placenta 27, 861-868."),tags$li("25. Ghabrial, H., Czuba, M.A., Stead, C.K., Smallwood, R.A., and Morgan, D.J. (1991). Transfer of acipimox across the isolated perfused human placenta. Placenta 12, 653-661."),
                 tags$li("26. Giaginis, C., Zira, A., Theocharis, S., and Tsantili-Kakoulidou, A. (2009). Application of quantitative structure-activity relationships for modeling drug and chemical transport across the human placenta barrier: a multivariate data analysis approach. J. Appl. Toxicol. 29, 724-733.
"),tags$li("27. Gilstrap, L.C., Bawdon, R.E., Roberts, S.W., and Sobhi, S. (1994). The transfer of the nucleoside analog ganciclovir across the perfused human placenta. Am. J. Obstet. Gynecol. 170, 967-973."),
                 tags$li("28. Grosso, L.M., Triche, E.W., Belanger, K., Benowitz, N.L., Holford, T.R., and Bracken, M.B. (2006). Caffeine Metabolites in Umbilical Cord Blood, Cytochrome P-450 1A2 Activity, and Intrauterine Growth Restriction. Am. J. Epidemiol. 163, 1035-1041."),tags$li("29. Heikkinen, T., Laine, K., Neuvonen, P.J., and Ekblad, U. (2000). The transplacental transfer of the macrolide antibiotics erythromycin, roxithromycin and azithromycin. BJOG : an international journal of obstetrics and gynaecology 107, 770-775."),
                 tags$li("30. Herman, N.L., Li, A.-T., Van Decar, T.K., Johnson, R.F., Bjoraker, R.W., Downing, J.W., and Jones, D. (2000). Transfer of methohexital across the perfused human placenta. J. Clin. Anesth. 12, 25-30."),tags$li("31. Hewitt, M., Madden, J.C., Rowe, P.H., and Cronin, M.T.D. (2007). Structure-based modelling in reproductive toxicology: (Q)SARs for the placental barrier. SAR QSAR Environ. Res. 18, 57- 76."),
                 tags$li("32. Ho, P.C., Stephens, I.D., and Triggs, E.J. (1981). Caesarean Section and Placental Transfer of Alcuronium. Anaesth. Intensive Care 9, 113-118."),tags$li("33. Hollier, L.P., Keelan, J.A., Hickey, M., Maybery, M.T., and Whitehouse, A.J.O. (2014). Measurement of Androgen and Estrogen Concentrations in Cord Blood: Accuracy, Biological Interpretation, and Applications to Understanding Human Behavioral Development. Frontiers in endocrinology 5, 64-64."),
                 tags$li("34. Howe, J.P., Mcgowan, W.a.W., Moore, J., Mccaughey, W., and Dundee, J.W. (1981). The placental transfer of cimetidine. Anaesthesia 36, 371-375."),tags$li("35. Ivanovic, J., Bellagamba, R., Nicastri, E., Signore, F., Vallone, C., Tempestilli, M., Tommasi, C., Mazzitelli, L., and Narciso, P. (2010). Use of darunavir/ritonavir once daily in treatment- naive pregnant woman: pharmacokinetics, compartmental exposure, efficacy and safety. AIDS 24.
"),
                 tags$li("36. Jacobson, R.L., Brewer, A., Eis, A., Siddiqi, T.A., and Myatt, L. (1991). Transfer of aspirin across the perfused human placental cotyledon. Am. J. Obstet. Gynecol. 165, 939-944."),tags$li("37. Johnson, R.F., Cahana, A., Olenick, M., Herman, N., Paschall, R.L., Minzter, B., Ramasubramanian, R., Gonzalez, H., and Downing, J.W. (1999). A Comparison of the Placental Transfer of Ropivacaine Versus Bupivacaine. Anesth. Analg. 89, 703."),
                 tags$li("38. Kanto, J.H. (1982). Use of Benzodiazepines during Pregnancy, Labour and Lactation, with Particular Reference to Pharmacokinetic Considerations. Drugs 23, 354-380."),tags$li("39. Kokki, H., and Kokki, M. (2016). 'Chapter 45 - Central Nervous System Penetration of the Opioid Oxycodone,' eds. V.R.B.T.N.O.D.A. Preedy & M. Substance. (San Diego: Academic Press), 457-466."),
                 tags$li("40. Lagrange, F.J., Brun, J.L., Clot, P.F., Leng, J.J., Saux, M.C., Kieffer, G., and Bannwarth, B.G. (2001). Placental Transfer of SR49059 in the Human Dually Perfused Cotyledon In Vitro. Placenta 22, 870-875."),tags$li("41. Lancz, K., Murínová, L., Patayová, H., Drobná, B., Wimmerová, S., Sovčíková, E., Kováč, J., Farkašová, D., Hertz-Picciotto, I., Jusko, T.A., and Trnovec, T. (2015). Ratio of cord to maternal serum PCB concentrations in relation to their congener-specific physicochemical properties. Int. J. Hyg. Environ. Health 218, 91-98."),
                 tags$li("42. Littleford, J. (2004). Effects on the fetus and newborn of maternal analgesia and anesthesia: a review. Canadian journal of anaesthesia = Journal canadien d'anesthesie 51, 586-609."),tags$li("43. Loftus, J.R., Hill, H., and Cohen, S.E. (1995). Placental Transfer and Neonatal Effects of Epidural Sufentanil and Fentanyl Administered with Bupivacaine during Labor. Anesthesiology 83, 300-308."),
                 tags$li("44. Malek, A., and Mattison, D.R. (2010). Drug development for use during pregnancy: impact of the placenta. Expert Review of Obstetrics & Gynecology 5, 437-454."),tags$li("45. Mandelbrot, L., Duro, D., Belissa, E., and Peytavin, G. (2014). Placental Transfer of Darunavir in an <em>Ex Vivo</em> Human Cotyledon Perfusion Model. Antimicrob. Agents Chemother. 58, 5617-5620.
"),
                 tags$li("46. Mccormack, S.A., and Best, B.M. (2014). Protecting the fetus against HIV infection: a systematic review of placental transfer of antiretrovirals. Clin. Pharmacokinet. 53, 989-1004."),tags$li("47. Miyamoto, S., Yamada, M., Kasai, Y., Miyauchi, A., and Andoh, K. (2016). Anticancer drugs during pregnancy. Jpn. J. Clin. Oncol. 46, 795-804."),
                 tags$li("48. Morselli, P.L., Boutroy, M.J., Bianchetti, G., Zipfel, A., Boutroy, J.L., and Vert, P. (1990). Placental transfer and perinatal pharmacokinetics of betaxolol. Eur. J. Clin. Pharmacol. 38, 477-483."),tags$li("49. Mosby (2017). Mosby's Drug Reference for Health Professions 6th Edition. Elsevier Mosby."),
                 tags$li("50. Mose, T., Kjaerstad, M.B., Mathiesen, L., Nielsen, J.B., Edelfors, S., and Knudsen, L.E. (2008). Placental Passage of Benzoic acid, Caffeine, and Glyphosate in an Ex Vivo Human Perfusion System. J. Toxicol. Environ. Health, Part A 71, 984-991."),tags$li("51. Murad, S.H.N., Conklin, K.A., Tabsh, K.M.A., Brinkman, C.R.I.I.I., Erkkola, R., and Nuwayhid, B. (1981). Atropine and Glycopyrrolate: Hemodynamic Effects and Placental Transfer in the Pregnant Ewe. Anesth. Analg. 60."),
                 tags$li("52. Örberg, J. (1977). Placental and Mammary Transfer of Two PCBs (2,4′, 5-TCB and 2,2′, 4,4′, 5,5′- HCB) and Their Effect on Reproductive Capacity in Mice. Ambio 6, 278-280.
"),tags$li("53. Ormerod, P. (2001). Tuberculosis in pregnancy and the puerperium. Thorax 56, 494-499."),
                 tags$li("54. Pacifici, G.M. (2006). Placental transfer of antibiotics administered to the mother: a review. Int. J.
Clin. Pharm. Ther. 44, 57-63.
"),tags$li("55. Pacifici, G.M., Cuoci, L., Guarneri, M., Fornaro, P., Arcidiacono, G., Cappelli, N., Moggi, G., and Placidi, G.F. (1984). Placental transfer of pinazepam and its metabolite N-desmethyldiazepam in women at term. Eur. J. Clin. Pharmacol. 27, 307-310."),
                 tags$li("56. Pacifici, G.M., and Nottoli, R. (1995). Placental transfer of drugs administered to the mother. Clin. Pharmacokinet. 28, 235-269."),tags$li("57. Paolini, C.L., Marconi, A.M., Ronzoni, S., Di Noio, M., Fennessey, P.V., Pardi, G., and Battaglia, F.C. (2001). Placental transport of leucine, phenylalanine, glycine, and proline in intrauterine growth-restricted pregnancies. J. Clin. Endocrinol. Metab. 86, 5427-5432."),
                 tags$li("58. Park, H.S., Ahn, B.-J., and Jun, J.K. (2012). Placental transfer of clarithromycin in human pregnancies with preterm premature rupture of membranes. J. Perinat. Med. 40, 641-646."),tags$li("59. Pilkington, T., and Brogden, R.N. (1992). Acitretin : A Review of its Pharmacology and Therapeutic Use. Drugs 43, 597-627.
"),
                 tags$li("60. Rey, E., Giraux, P., D'athis, P., Turquais, J.M., Chavinie, J., and Olive, G. (1979). Pharmacokinetics of the placental transfer and distribution of clorazepate and its metabolite nordiazepam in the feto-placental unit and in the neonate. Eur. J. Clin. Pharmacol. 15, 181-185."),tags$li("61. Roberts, S., Bawdon, R., Sobhi, S., Dax, J., Gilstrap Iii, L., and Wimberly, D. (1995). The maternal- fetal transfer of bisheteroypiperazine (U-87201-E) in the ex vivo human placenta. Am. J. Obstet. Gynecol. 172, 88-91.
"),
                 tags$li("62. Root, B., Eichner, E., and Sunshine, I. (1961). Blood secobarbital levels and their clinical correlation in mothers and newborn infants. Am. J. Obstet. Gynecol. 81, 948-956."),tags$li("63. Sastry, B.V.R. (1999). Techniques to study human placental transport. Adv. Drug Delivery Rev. 38, 17-39."),
                 tags$li("64. Schenker, S., Johnson, R.F., Mahuren, J.D., Henderson, G.I., and Coburn, S.P. (1992). Human placental vitamin B6 (pyridoxal) transport: normal characteristics and effects of ethanol. The American journal of physiology 262, R966-974."),tags$li("65. Sodha, R.J., and Schneider, H. (1983). Transplacental transfer of beta-adrenergic drugs studied by an in vitro perfusion method of an isolated human placental lobule. Am. J. Obstet. Gynecol. 147, 303-310.
"),
                 
                 tags$li("66. Sudhakaran, S., Ghabrial, H., Nation, R.L., Kong, D.C.M., Gude, N.M., Angus, P.W., and Rayner, C.R. (2005). Differential bidirectional transfer of indinavir in the isolated perfused human placenta. Antimicrob. Agents Chemother. 49, 1023-1028."),tags$li("67. Takaku, T., Nagahori, H., Sogame, Y., and Takagi, T. (2015). Quantitative structure-activity relationship model for the fetal-maternal blood concentration ratio of chemicals in humans. Biol. Pharm. Bull. 38, 930-934."),
                 tags$li("68. Thakur, A., Harman Kaur, G., Ajay, S., Nipun, M., and Shruti, R. (2011). PHARMACY AND PREGNANCY: A REVIEW. 2, 1997-2009."),tags$li("69. Thiessen, J.J., Salama, R.B., Coceani, F., and Olley, P.M. (1984). Placental drug transfer in near-term ewes: acetylsalicylic and salicylic acid. Can. J. Physiol. Pharmacol. 62, 441-445."),
                 tags$li("70. Tomson, G., Garle, R.I., Thalme, B., Nisell, H., Nylund, L., and Rane, A. (1982). Maternal kinetics and transplacental passage of pethidine during labour. Br. J. Clin. Pharmacol. 13, 653-659."),tags$li("71. Vafaei, H., Kaveh Baghbahadorani, F., Asadi, N., Kasraeian, M., Faraji, A., Roozmeh, S., Zare, M., and Bazrafshan, K. (2021). The impact of betamethasone on fetal pulmonary, umbilical and middle cerebral artery Doppler velocimetry and its relationship with neonatal respiratory distress syndrome. BMC Pregnancy and Childbirth 21, 188.
"),
                 tags$li("72. Valenzuela, G.J., Craig, J., Bernhardt, M.D., and Holland, M.L. (1995). Placental passage of the oxytocin antagonist atosiban. Am. J. Obstet. Gynecol. 172, 1304-1306."),tags$li("73. Van Calsteren, K. (2010). Chemotherapy during pregnancy: pharmacokinetics and impact on foetal neurological development. Facts, views & vision in ObGyn 2, 278-286."),
                 tags$li("74. Vinot, C., Gavard, L., Tréluyer, J.M., Manceau, S., Courbon, E., Scherrmann, J.M., Declèves, X., Duro, D., Peytavin, G., Mandelbrot, L., and Giraud, C. (2013). Placental transfer of maraviroc in an ex vivo human cotyledon perfusion model and influence of ABC transporter expression. Antimicrob. Agents Chemother. 57, 1415-1420.
"),tags$li("75. Ward, R.M. (1996). Pharmacology of the maternal-placental-fetal-unit and fetal therapy. Progress in Pediatric Cardiology 5, 79-89.
"),
                 tags$li("76. Weiner, C. (2019). Drugs for Pregnant and Lactating Women 3rd Edition. Elsevier."),tags$li("77. Zarek, J., Degorter, M.K., Lubetsky, A., Kim, R.B., Laskin, C.A., Berger, H., and Koren, G. (2013).
The transfer of pravastatin in the dually perfused human placenta. Placenta 34, 719-721."),
               ))
    )
  )
)

server <- function(input, output) {
  # Load the libraries inside the server function
  library(caret)
  library(neuralnet)
  
  # Define the data
  df <- data.frame(
    drug = c("Valproic acid", "Acetaminophen", "Amoxicillin", "Methicillin", "Betaxolol", "Acyclovir", "Amikacin", "Caffeine", "Theophylline", "Ampicillin", "Azlocillin", "Cefmenoxime", "Cefoxitin", "Cephradine", "Cephaloridine", "Cefotiam", "Ceftizoxime", "Ceftriaxone", "Diazepam", "Clorazepate", "Lorazepam", "Midazolam", "Nitrazepam", "Oxazepam", "Pinazepam", "Chloroquine", "Indomethacin", "Sotalol", "Methyldopa", "Phenobarbitone", "Phenytoin", "Morphine", "Secobarbital", "Thiamylal (Tiamil)", "Prilocaine", "Methoxyflurane", "Ketamine", "Propofol", "Nitrous Oxide", "Zidovudine (AZT)", "Stavudine (d4T)", "Lamivudine (3TC)", "Didanosine", "Nevirapine", "Zalcitabine", "Acebutolol", "Atenolol", "Clonidine", "Isradipine", "Lignocaine (Lidocaine)", "Mepivacaine", "Kanamycin", "Pentazocine", "Pethidine (Meperidine)", "Carbamazepine", "Primidone", "Hydrochlorothiazide", "Digoxin", "Terbutaline", "Atropine", "Antipyrine", "Fosfomycin", "Griseofulvin", "Sulfasalazine", "Thiamphenicol", "Pentobarbitone", "Isoflurane", "Methohexital", "1.2-Dichlorobenzene", "Fentanyl", "Ethanol", "Nicotine", "Pyrimethamine", "Thiopentone (Thiopental)", "L-Alphacetylmethadol", "Mefloquine", "Efavirenz", "Thalidomide", "Benazepril", "Fosinopril", "Lisinopril", "Moexipril", "Quinapril", "Ramipril", "Captopril", "Enalapril", "Acitretin", "Isotretinoin", "Dicoumarol", "Acenocoumarol", "Warfarin", "Lovastatin", "Fluvastatin", "Simvastatin", "Atorvastatin", "Cerivastatin", "Acetohydroxamic acid", "Finasteride", "Diethylstilbestrol", "Methimazole", "Tretinoin", "Testoterone", "Stanozolol", "Metenolone", "Nandrolone", "Tetracycline", "Oxytetracycline", "Valsartan", "Losartan", "Dexamethasone", "2-Chlorobiphenyl", "3-Chlorobiphenyl", "4-Chlorobiphenyl", "Flurazepam", "Triazolam", "Penicillamine", "Trimethadione", "Streptomycin", "Abacavir", "Alfentanil", "Buprenorphine", "Chloroprocaine", "Clavulanic acid", "Cortisone", "Diclofenac", "Hydralazine", "Metoclopramide", "Methadone", "Naloxone", "Riboflavin", "Ketoprofen", "Sulindac", "Sulindac Sulfide", "Triamterene", "Acipimox", "Biotin (Vitamin H)", "Atevirdine", "L-Leucine", "Cocaethylene", "Cocaine", "Ritodrine", "Pyridoxine", "1.4-Dichlorobenzene", "Prednisolone", "PCB-52", "Chlorpyrifos", "Diazinon", "Flecainide", "Isoniazid", "Metoprolol", "Etidocaine", "Metronidazole", "Carnitine", "Clonazepam", "Procainamide", "Norbuprenorphine", "Clindamycin", "Nifedipine", "Remifentanil", "Pyridoxal", "Ethambutol HCl", "Oxprenolol", "Heptachlor Epoxide", "SR49059 (Relcovaptan)", "Cimetidine", "Atosiban", "Maraviroc", "Metformin", "Cefoperazone", "Pyridoxal 5 جپ-phosphate", "Ganciclovir", "Ticarcillin", "Trovafloxacin", "Mezlocilline", "Sulbenicillin", "Cefacetrile", "Cefradine", "Chlordiazepoxide", "Clomocycline", "Limecycline", "Chloramphenicol", "Colistimethate", "Vancomycin", "Doxorubicin", "Procaine", "Salicylates (Aspirin)", "N-acetyl-acebutolol", "Furosemide", "Tubocurarine", "Tetrahydrocannabinol", "Carboxylic Acid-", "Pravastatin", "Amprenavir", "Ritonavir", "Saquinavir", "Indinavir", "Atracurium Besilate", "Suxamethonium", "Dimethyl-Tubocurarine (Metocurine)", "Vecuronium", "Noradrenaline", "Erythromycin", "Azithromycin", "Roxithromycin", "Fenoterol", "Hexoprenaline", "Salbutamol", "Glibenclamide", "Glycopyrrolate", "Meropenem", "Oseltamivir (Phosphate)", "Sufentanil", "Clarithromycin", "Quabain", "Duloxetine", "Prazosin", "Chlorthalidone", "Thyroxine", "Liothyronine", "Cephalotin", "Cefuroxime", "Betamethasone", "Cyclophosphamide", "Bupivacaine", "Ropivacaine", "Lopinavir", "Darunavir", "Amiodarone", "Alcuronium", "Dantrolene", "Aminophylline", "Tetrahydrocannabinol-9-", "Emtricitabine", "Tenofovir", "Rilpivirine", "Etravirine", "Tipranavir", "Raltegravir", "Cyclosporine", "Nafcillin", "Oxycodone", "Clomipramine", "Mestranol"),
    molecular_weight = c(144.21, 151.16, 365.4, 380.4, 307.4, 225.20, 585.6, 194.19, 180.16, 349.4, 461.5, 511.6, 427.5, 349.4, 415.5, 525.6, 383.4, 554.6, 284.74, 314.72, 321.2, 325.8, 281.27, 286.71, 308.8, 319.9, 357.8, 272.37, 211.21, 232.23, 252.27, 285.34, 238.28, 254.35, 220.31, 164.96, 237.72, 178.27, 44.013, 267.24, 224.21, 229.26, 236.23, 266.30, 211.22, 336.4, 266.34, 230.09, 371.4, 234.34, 246.35, 484.50, 285.4, 283.79, 236.27, 218.25, 297.7, 780.9, 225.28, 289.4, 188.23, 138.06, 352.8, 398.4, 356.2, 226.27, 184.49, 262.30, 147.00, 336.5, 46.07, 162.23, 248.7, 242.34, 353.5, 378.31, 315.67, 258.23, 424.5, 563.7, 405.5, 498.6, 453.52, 416.51, 217.29, 376.4, 326.4, 300.4, 336.3, 353.3, 308.3, 404.5, 411.5, 418.6, 558.6, 459.5, 75.07, 372.5, 268.3, 114.17, 300.4, 288.4, 328.5, 302.5, 274.4, 444.4, 460.4, 435.5, 422.9, 392.5, 188.65, 188.65, 188.65, 387.9, 343.2, 149.21, 143.14, 581.6, 286.33, 416.5, 467.64, 270.75, 199.16, 360.4, 296.1, 160.18, 299.79, 309.4, 327.4, 376.4, 254.28, 356.41, 340.4, 253.26, 154.12, 244.31, 379.5, 131.17, 317.4, 303.35, 287.36, 169.18, 147.00, 360.4, 292.0, 350.6, 304.35, 414.34, 137.14, 267.36, 276.42, 171.15, 161.20, 315.71, 235.33, 413.5, 425.0, 346.3, 376.45, 167.1, 204.31, 265.35, 389.3, 620.5, 252.34, 994.2, 513.7, 129.16, 645.7, 247.14, 255.23, 384.4, 416.4, 539.6, 414.5, 339.33, 349.4, 299.75, 508.9, 602.6, 323.13, 1749.8, 1449.2, 543.5, 236.31, 180.16, 378.5, 330.74, 609.73, 314.5, 344.4, 424.5, 505.6, 720.9, 670.8, 613.8, 1243.5, 290.40, 652.8, 557.8, 169.18, 733.9, 749.0, 837.0, 303.35, 420.5, 239.31, 494.0, 398.3, 383.5, 410.4, 386.6, 748.0, 584.7, 297.4, 383.4, 338.8, 776.87, 650.97, 396.4, 424.39, 392.5, 261.08, 288.4, 274.4, 628.8, 547.7, 645.3, 666.9, 314.25, 420.43, 344.4, 247.25, 287.21, 366.4, 435.3, 602.7, 444.4, 1202.6, 414.5, 315.4, 314.9, 310.4), 
    logP = c(2.800, 0.500, -2.000, 1.200, 2.800, -1.9, -3.2, -0.100, 0.000, -1.100, 0.100, 0.000, 0.000, 0.400, 1.900, -2.400, 0.000, -1.300, 3.000, 3.300, 2.400, 2.73, 2.200, 2.200, 3.100, 4.600, 4.300, 0.200, -1.9, 1.47, 2.500, 0.800, 2.000, 3.200, 2.100, 2.200, 2.200, 3.800, 0.5, 0.000, -0.800, -0.900, -1.200, 2.0, -1.300, 1.700, 0.200, 1.600, 4.300, 2.300, 1.900, -6.3, 4.64, 2.720, 2.77, 0.900, -0.100, 1.300, 0.900, 1.800, 0.400, -1.4, 2.200, -0.700, -0.300, 2.100, 2.100, 2.300, 3.400, 4.000, -0.100, 1.200, 2.700, 2.900, 4.300, 3.6, 4.0, 0.300, 1.3, 6.2, -2.900, 1.2, 1.2, 1.400, 0.300, -0.100, 6.1, 5.66, 2.07, 1.98, 2.70, 4.300, 3.5, 4.700, 5.0, 3.6, -1.600, 3.000, 5.100, -0.300, 6.300, 3.300, 4.5, 3.9, 2.600, -1.30, -1.600, 4.4, 4.3, 1.900, 4.500, 4.600, 4.600, 3.000, 2.400, -1.800, 0.3, -8.0, 0.9, 2.200, 4.98, 2.900, -1.200, 2.10, 4.400, 0.700, 2.600, 3.900, 2.100, -1.500, 3.100, 3.400, 4.800, 1.000, -1.0, 0.3, 3.000, -1.8, 2.53, 2.30, 2.3, -0.800, 3.400, 1.600, 6.100, 5.300, 3.800, 3.800, -0.700, 1.900, 3.700, 0.000, -0.2, 2.400, 0.900, 3.800, 2.200, 2.200, 1.9, 0.000, -0.1, 2.100, 3.7, 3.800, 0.400, -1.9, 5.1, -1.3, -0.700, -1.1, -2.5, 0.800, 0.300, -0.200, 1.100, -0.500, 0.400, 2.400, -1.500, -1.70, 1.100, -1.0, -2.6, 1.300, 1.900, 1.200, 1.600, 2.000, 6.0, 7.000, 6.300, 1.600, 2.9, 6.0, 4.2, 2.8, -0.96, 0.600, 6.7, 6.5, -1.24, 2.700, 4.000, 3.100, 2.000, 1.1, 0.300, 4.800, -1.4, -2.4, 1.1, 4.000, 3.200, -1.700, 4.3, 2.000, 0.9, 2.4, 1.7, -0.400, -0.200, 1.900, 0.8, 3.400, 2.900, 5.9, 2.9, 7.600, 3.1, 1.700, -0.77, 6.300, -0.600, -1.600, 4.5, 4.500, 7.0, 1.1, 7.5, 2.900, 1.200, 5.200, 4.000),
    HDonor = c(1, 2, 4, 2, 2, 3, 13, 0, 1, 3, 4, 3, 3, 3, 1, 3, 3, 4, 0, 2, 2, 0, 1, 2, 0, 1, 1, 3, 4, 2, 2, 2, 2, 2, 2, 0, 1, 1, 0, 2, 2, 2, 2, 1, 2, 3, 3, 2, 1, 1, 1, 11, 1, 1, 1, 2, 3, 6, 4, 1, 0, 2, 0, 3, 3, 2, 0, 1, 0, 0, 1, 0, 2, 2, 0, 2, 1, 1, 2, 1, 4, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1, 1, 3, 1, 4, 3, 2, 2, 2, 1, 1, 1, 2, 1, 1, 6, 7, 2, 2, 3, 0, 0, 0, 0, 0, 3, 0, 12, 3, 0, 2, 1, 2, 2, 2, 2, 2, 0, 2, 5, 1, 1, 1, 3, 1, 3, 2, 2, 0, 0, 4, 3, 0, 3, 0, 0, 0, 2, 2, 2, 1, 1, 1, 1, 2, 3, 4, 1, 0, 2, 4, 2, 0, 2, 3, 11, 1, 3, 4, 3, 4, 3, 2, 3, 3, 2, 3, 1, 7, 9, 3, 18, 19, 6, 1, 1, 2, 3, 2, 1, 2, 4, 3, 4, 5, 4, 0, 0, 0, 0, 4, 5, 5, 5, 5, 8, 4, 3, 1, 3, 2, 0, 4, 8, 1, 1, 3, 3, 3, 2, 3, 3, 1, 1, 1, 4, 3, 0, 2, 1, 4, 2, 3, 3, 2, 2, 2, 3, 5, 2, 1, 0, 1),
    HAcceptor = c(2, 2, 7, 7, 4, 5, 17, 3, 3, 6, 7, 14, 9, 6, 6, 13, 10, 13, 2, 4, 3, 3, 4, 3, 2, 3, 4, 4, 5, 3, 2, 4, 3, 3, 2, 3, 2, 1, 2, 6, 4, 4, 5, 4, 3, 5, 4, 1, 8, 2, 2, 15, 2, 3, 1, 2, 7, 14, 4, 4, 2, 4, 6, 9, 5, 3, 6, 3, 0, 2, 1, 2, 4, 3, 3, 9, 5, 4, 6, 7, 7, 7, 5, 6, 4, 6, 3, 2, 6, 6, 3, 5, 5, 5, 6, 7, 2, 2, 2, 1, 2, 2, 2, 2, 2, 9, 10, 6, 5, 6, 0, 1, 0, 4, 3, 4, 3, 15, 6, 6, 5, 3, 5, 5, 3, 4, 4, 2, 5, 7, 3, 5, 4, 7, 4, 4, 5, 3, 5, 3, 4, 4, 0, 5, 0, 5, 6, 4, 3, 4, 2, 4, 3, 4, 3, 5, 7, 5, 6, 4, 4, 4, 1, 7, 5, 15, 6, 1, 13, 7, 6, 8, 10, 9, 8, 8, 6, 3, 10, 13, 5, 33, 26, 12, 4, 4, 5, 7, 7, 2, 4, 7, 8, 6, 7, 7, 18, 4, 6, 5, 4, 14, 14, 17, 5, 8, 4, 5, 4, 7, 4, 4, 14, 12, 3, 8, 5, 5, 4, 5, 10, 5, 1, 2, 2, 5, 9, 4, 4, 6, 8, 4, 5, 8, 6, 7, 10, 9, 12, 6, 5, 2, 2),
    PSA = c(37.3, 49.3, 158.0, 131.0, 50.7, 115.0, 332.0, 58.4, 69.3, 138.0, 173.0, 270.0, 202.0, 138.0, 147.0, 251.0, 201.0, 288.0, 32.7, 78.8, 61.7, 30.2, 87.3, 61.7, 32.7, 28.2, 68.5, 86.8, 104.0, 75.3, 58.2, 52.9, 75.3, 90.3, 41.1, 9.2, 29.1, 20.2, 19.1, 93.2, 78.9, 113.0, 88.7, 58.1, 88.2, 87.7, 84.6, 36.4, 104.0, 32.3, 32.3, 282.6, 23.5, 29.5, 46.3, 58.2, 135.0, 203.0, 72.7, 49.8, 23.6, 70.1, 71.1, 150.0, 112.0, 75.3, 9.2, 66.5, 0.0, 23.6, 20.2, 16.1, 77.8, 90.3, 29.5, 45.2, 38.3, 83.6, 95.9, 110.0, 133.0, 114.0, 95.9, 95.9, 58.6, 95.9, 46.5, 37.3, 93.1, 109.0, 63.6, 72.8, 82.7, 72.8, 112.0, 99.9, 49.3, 58.2, 40.5, 47.4, 37.3, 37.3, 48.9, 37.3, 37.3, 182.0, 202.0, 112.0, 92.5, 94.8, 0.0, 0.0, 0.0, 35.9, 43.1, 64.3, 46.6, 336.0, 102.0, 81.0, 62.2, 55.6, 87.1, 91.7, 49.3, 63.8, 67.6, 20.3, 70.0, 155.0, 54.4, 73.6, 54.4, 129.6, 75.6, 104.0, 73.5, 63.3, 55.8, 55.8, 72.7, 73.6, 0.0, 94.8, 0.0, 72.7, 85.6, 59.6, 68.0, 50.7, 32.3, 81.2, 60.4, 84.6, 58.4, 71.0, 128.0, 110.0, 76.2, 70.4, 64.5, 50.7, 12.5, 139.5, 88.9, 416.0, 63.0, 91.5, 271.0, 117.0, 135.0, 178.0, 99.8, 207.0, 175.0, 162.0, 138.0, 48.2, 188.0, 243.0, 115.0, 706.7, 531.0, 206.0, 55.6, 63.6, 95.9, 131.0, 80.6, 29.5, 66.8, 124.0, 140.0, 145.8, 167.0, 118.0, 258.0, 52.6, 55.4, 55.8, 86.7, 194.0, 180.0, 217.0, 93.0, 145.0, 72.7, 122.0, 46.5, 136.0, 90.6, 61.0, 183.0, 207.0, 49.5, 107.0, 118.0, 92.8, 92.8, 113, 199.0, 94.8, 41.6, 32.3, 32.3, 120.0, 149.0, 42.7, 46.9, 118.1, 191.0, 66.8, 113.0, 136.0, 97.4, 121.0, 114.0, 150.0, 279.0, 121.0, 59.0, 6.5, 29.5),
    ECCS = c(1.1, 2, 3.1, 3.1, 2, 4, 4, 2, 2, 3.1, 3.2, 3.2, 3.2, 3.1, 3.2, 3.2, 3.1, 3.2, 2, 1.1, 2, 2, 2, 2, 2, 2, 1.1, 4, 3.1, 2, 2, 2, 2, 1.1, 2, 2, 2, 2, 2, 4, 2, 4, 2, 2, 4, 4, 4, 2, 2, 2, 2, 4, 2, 2, 2, 2, 4, 4, 4, 2, 2, 3.1, 2, 1.1, 4, 2, 2, 2, 2, 2, 2, 2, 2, 1.1, 2, 2, 2, 2, 3.2, 3.2, 3.2, 3.2, 3.2, 3.2, 3.1, 3.1, 1.1, 1.1, 1.1, 1.1, 1.1, 2, 1.2, 2, 3.2, 3.2, 2, 4, 2, 2, 1.1, 2, 2, 2, 2, 3.2, 3.2, 3.2, 3.2, 2, 4, 4, 4, 2, 2, 3.1, 2, 4, 2, 2, 2, 2, 3.1, 2, 1.1, 2, 2, 2, 2, 4, 1.1, 1.1, 1.1, 4, 1.1, 3.1, 2, 3.1, 2, 2, 2, 2, 2, 2, 4, 2, 2, 4, 2, 2, 2, 2, 3.1, 2, 4, 2, 2, 2, 2, 2, 4, 2, 2, 4, 4, 4, 4, 4, 3.2, 3.1, 4, 3.1, 3.2, 3.2, 3.2, 3.1, 3.1, 2, 3.2, 3.2, 2, 3.2, 4, 3.2, 2, 1.1, 4, 3.1, 2, 2, 1.1, 3.2, 4, 4, 4, 4, 4, 4, 4, 2, 4, 4, 4, 4, 4, 4, 4, 3.2, 2, 3.1, 2, 2, 4, 4, 2, 2, 4, 3.2, 3.2, 3.1, 3.2, 2, 2, 2, 2, 4, 4, 4, 4, 2, 2, 1.1, 4, 3.1, 2, 2, 3.2, 1.2, 4, 3.2, 2, 2, 2),
    placental_permeability = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
  )
  
  # Normalize all features except ECCS
  features <- df[, c('molecular_weight', 'logP', 'PSA', 'HDonor', 'HAcceptor')]
  features_normalized <- as.data.frame(scale(features))
  
  # Add ECCS and the target variable to the normalized features
  df_normalized <- cbind(features_normalized, ECCS = df$ECCS, placental_permeability = df$placental_permeability)
  
  # Select specific rows for training
  train_set <- df_normalized[51:220, ]  # Selects rows 51 to 220
  
  # Set aside remaining rows for testing
  test_set <- df_normalized[-c(51:220), ]
  
  # Set the parameters
  stepmax <- 1e+06  # maximum steps, too many leads to overfitting. Increasing this always increases accuracy, but it's a variable more likely to cause overfitting than the others
  learningrate <- 0.003  # learning rate, rate of adjustment to correct via its error (cross entropy in this model)
  threshold <- 0.001  # threshold, stops the model when the threshold of change is 0.001
  
  # Training
  net <- neuralnet(placental_permeability ~ molecular_weight + logP + PSA + HDonor + HAcceptor + ECCS, 
                   data = train_set,  
                   hidden = c(70, 30, 65, 75, 20, 40), # 3 layers, 10 nodes in each. Experimenting with increasing the amount of layers drastically increases time, decreases accuracy.
                   linear.output = FALSE,  # set to FALSE for a classification problem
                   stepmax = stepmax,
                   learningrate = learningrate,
                   threshold = threshold,
                   err.fct = "ce",  # use the cross-entropy error function
                   act.fct = "logistic", # use the logistic activation function because the outcome is binary
                   rep = 15, # Runs 10 versions of itself, uses the most accurate repetition
                   algorithm = 'rprop+')
  
  output$table <- renderDT({
    # Changing column names for display
    display_df <- df
    colnames(display_df) <- c("Drug", "MW", "logP", "# of H+ Donors", "# of H+ Acceptors", "PSA", "ECCS Class", "Placental Crossing")
    datatable(display_df, 
              options = list(
                pageLength = 10, 
                autoWidth = TRUE,
                columnDefs = list(list(width = '300px', targets = 5))  # increase the width of the 6th column
              ),
              caption = htmltools::tags$caption(style = "caption-side: top; text-align: center; font-size: 24px; font-weight: bold; color: black;",
                                                "Neural Network's Data Frame")) 
  })
  observeEvent(input$predict, {
    # When the 'Predict' button is clicked, a new prediction is made
    new_drug <- data.frame(molecular_weight = input$molecular_weight, logP = input$logP, PSA = input$PSA, HD = input$HD, HA = input$HA) 
    new_drug_normalized <- as.data.frame(scale(new_drug, center = colMeans(features), scale = apply(features, 2, sd)))
    new_drug_normalized$ECCS <- as.numeric(input$ECCS)  # Add ECCS value for new drug
    
    prediction <- compute(net, new_drug_normalized)
    prediction_binary <- round(prediction$net.result)
    
    prediction_percent <- prediction$net.result * 100
    output$prediction <- renderText({
      # Calculate the prediction as a percentage
      prediction_percent <- prediction$net.result * 100
      # Create a conditional statement for the binary prediction
      if (prediction_binary == 1) {
        prediction_text <- "The drug is predicted to cross the placenta and "
      } else {
        prediction_text <- "The drug is not predicted to cross the placenta and "
      }
      paste(prediction_text, "the predicted likelihood is ", round(prediction_percent, 2), "%")
    })
  })
}

shinyApp(ui = ui, server = server)

