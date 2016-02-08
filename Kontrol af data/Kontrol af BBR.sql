/*
Er lavet til det gamle BBR
Der skal laves omskrivning af en række af SQL'erne, for at det kan lave kontrol af det nye BBR
*/

23:
'Bygningsniveau - Bygning(er) med ikke korrekt bygningsanvendelses kode.'
'-----------------------------------------------------------------------'

SELECT     EsreJDNR , bygningsnr , BYG_ANVEND_KODE
FROM         CO40100T
WHERE     (NOT (BYG_ANVEND_KODE LIKE '110')) AND (NOT (BYG_ANVEND_KODE LIKE '120')) AND (NOT (BYG_ANVEND_KODE LIKE '130')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '140')) AND (NOT (BYG_ANVEND_KODE LIKE '150')) AND (NOT (BYG_ANVEND_KODE LIKE '160')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '190')) AND (NOT (BYG_ANVEND_KODE LIKE '210')) AND (NOT (BYG_ANVEND_KODE LIKE '220')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '230')) AND (NOT (BYG_ANVEND_KODE LIKE '290')) AND (NOT (BYG_ANVEND_KODE LIKE '310')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '320')) AND (NOT (BYG_ANVEND_KODE LIKE '330')) AND (NOT (BYG_ANVEND_KODE LIKE '410')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '490')) AND (NOT (BYG_ANVEND_KODE LIKE '510')) AND (NOT (BYG_ANVEND_KODE LIKE '520')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '530')) AND (NOT (BYG_ANVEND_KODE LIKE '540')) AND (NOT (BYG_ANVEND_KODE LIKE '590')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '910')) AND (NOT (BYG_ANVEND_KODE LIKE '920')) AND (NOT (BYG_ANVEND_KODE LIKE '930')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '390')) AND (NOT (BYG_ANVEND_KODE LIKE '420')) AND (NOT (BYG_ANVEND_KODE LIKE '430')) AND 
                      (NOT (BYG_ANVEND_KODE LIKE '440'))
Group BY EsreJDNR , bygningsnr , BYG_ANVEND_KODE
Order BY EsreJDNR 

24:
'Bygningsniveau - Bygning(er) med ikke korrekt bygningsanvendelses kode. Samlet erhvervsareal overstiger samlet boligareal.'
'--------------------------------------------------------------------------------------------------------------------------'

SELECT    EsreJDNR , bygningsnr , BYG_ANVEND_KODE, BYG_BOLIG_ARL_SAML , ERHV_ARL_SAML 
FROM         CO40100T
WHERE     ((BYG_ANVEND_KODE LIKE '110') or (BYG_ANVEND_KODE LIKE '120') or 
           (BYG_ANVEND_KODE LIKE '130') or (BYG_ANVEND_KODE LIKE '140') or 
           (BYG_ANVEND_KODE LIKE '150') or (BYG_ANVEND_KODE LIKE '190')) and 
	   (ERHV_ARL_SAML > BYG_BOLIG_ARL_SAML) 

Group BY EsreJDNR , bygningsnr , BYG_BOLIG_ARL_SAML, ERHV_ARL_SAML, BYG_ANVEND_KODE 
Order BY EsreJDNR, bygningsnr

25:
'Bygningsniveau - Bygning(er) med et ejendomsnummer der ikke' 
'eksisterer i ESR.' 
'-----------------------------------------------------------'

SELECT A.KOMMUNE_NR AS [Kommune nr.], A.EJD_NR AS [Ejendoms nr. (felt 101)], A.BYG_NR AS [Bygningsnr.]
FROM CO40100T as a
WHERE NOT EXISTS
   (SELECT *
   FROM CO11500T as b  
   WHERE   b.Kommune_nr = a.Kommune_nr and
	    b.Ejd_nr = a.Ejd_nr) AND a.Kommune_nr = @KOMNR

26:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for kilde til .'
'materialer.'
'------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.KILDE_MATR_KODE AS [Kilde til materialer (felt 215)]
FROM         CO10100T 
WHERE     (CO10100T.KILDE_MATR_KODE NOT LIKE '1') AND (CO10100T.KILDE_MATR_KODE NOT LIKE '2') AND 
          (CO10100T.KILDE_MATR_KODE NOT LIKE '3') AND (CO10100T.KILDE_MATR_KODE NOT LIKE '4') AND 
          (CO10100T.KILDE_MATR_KODE NOT LIKE '5') AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR, CO10100T.KILDE_MATR_KODE
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

27:
'Bygningsniveau - Bygning(er) med ikke korrekt Om- eller'
'tilbygningsår.'
'-------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], OMBYG_AAR AS [Om- eller tilbygningsår (felt 209)]
FROM         CO10100T
WHERE     ((OMBYG_AAR < 0) or  (OMBYG_AAR > DATEPART(yy, GETDATE()))) AND KOMMUNE_NR = @KOMNR
GROUP BY KOMMUNE_NR, EJD_NR, CO10100T.BYG_NR, OMBYG_AAR 
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

28:
'Bygningsniveau - Bygning(er) med ikke korrekt opførelsesår.'
'-----------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], BYG_NR AS [Bygningsnr.], OPFOERELSE_AAR AS [Opførelsesår (felt 207)]
FROM         CO10100T
WHERE     ((OPFOERELSE_AAR < 0)  or  (OPFOERELSE_AAR > DATEPART(yy, GETDATE()))) AND KOMMUNE_NR = @KOMNR
GROUP BY Kommune_nr, Ejd_nr, CO10100T.BYG_NR, OPFOERELSE_AAR
ORDER BY Kommune_nr, Ejd_nr, CO10100T.BYG_NR

29:
'Bygningsniveau - Bygning(er) med ikke korrekt om- eller tilbygningsår.'
'Om- eller tilbygningsår kan ikke være tidligere end opførelsesår.     ' 
'----------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], OPFOERELSE_AAR AS [Opførelsesår (felt 207)], OMBYG_AAR AS [Om- eller tilbygningsår (felt 209)]
FROM         CO10100T
WHERE     (OMBYG_AAR > 0) AND (OMBYG_AAR < OPFOERELSE_AAR) AND KOMMUNE_NR = @KOMNR
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

30:
'Bygningsniveau - Arten af det opvarmningsmiddel, der anvendes i eget anlæg skal' 
'kun indberettes hvis kode for varmeinstallation i felt 229 er 2, 3, 5, 6'
'eller 8.'
'-------------------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.OPVARMNING_KODE AS [Opvarmningsmiddel (felt 230)], varmeinstal_kode AS [Varmeinstallation (felt 229)]   
FROM         CO10100T 
WHERE     (CO10100T.OPVARMNING_KODE NOT LIKE '1') AND (CO10100T.OPVARMNING_KODE NOT LIKE '2') AND 
          (CO10100T.OPVARMNING_KODE NOT LIKE '3') AND (CO10100T.OPVARMNING_KODE NOT LIKE '4') AND 
          (CO10100T.OPVARMNING_KODE NOT LIKE '6') AND (CO10100T.OPVARMNING_KODE NOT LIKE '7') AND 
          (CO10100T.OPVARMNING_KODE  NOT LIKE '9') AND (CO10100T.OPVARMNING_KODE  NOT LIKE '')AND 
          ((CO10100T.VARMEINSTAL_KODE LIKE '2') or (CO10100T.VARMEINSTAL_KODE LIKE '3') or 
          (CO10100T.VARMEINSTAL_KODE LIKE '4') or (CO10100T.VARMEINSTAL_KODE LIKE '5') or 
          (CO10100T.VARMEINSTAL_KODE LIKE '6') or (CO10100T.VARMEINSTAL_KODE LIKE '8'))	AND 
          (BYG_ANVEND_KODE NOT LIKE '320') AND (BYG_ANVEND_KODE NOT LIKE '910') AND 
          (BYG_ANVEND_KODE NOT LIKE '920') AND  (BYG_ANVEND_KODE NOT LIKE '930')AND 
          (LOGISK_TJEK LIKE 'Y') AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.OPVARMNING_KODE, varmeinstal_kode, LOGISK_TJEK    
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

31:
'Bygningsniveau - Antallet af sikringsrumpladser kan ikke være negativt.'
'-----------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], SIKRINGSRUM_ANT  AS [Sikringsrumspladser (felt 236)] 
From CO10100T
Where SIKRINGSRUM_ANT < 0 AND (LOGISK_TJEK LIKE 'Y') AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.EJD_nr, CO10100T.BYG_NR, SIKRINGSRUM_ANT, LOGISK_TJEK 
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

32:
'Bygningsniveau - Samlet areal af tagetage kan ikke være negativt.'
'-----------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.TAGETAGE_ARL_SAML as [Samlet areal af tagetage (felt 221)]
FROM         CO10100T 
WHERE   CO10100T.TAGETAGE_ARL_SAML < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.TAGETAGE_ARL_SAML
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

33:
'Bygningsniveau - Areal af udnyttet del af tagetage kan ikke være negativt.'
'--------------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.TAGETAGE_ARL_UDNYT as [Areal af udnyttet del af tagetage (felt 222)]
FROM         CO10100T 
WHERE   CO10100T.TAGETAGE_ARL_UDNYT < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.TAGETAGE_ARL_UDNYT
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

34:
'Bygningsniveau - Areal af overdækket terrase kan ikke være negativt.'
'--------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.TERRASSE_OVERD_ARL as [Areal af overdækket terrrase (felt 246)]
FROM         CO10100T 
WHERE   CO10100T.TERRASSE_OVERD_ARL < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.TERRASSE_OVERD_ARL
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

35:
'Bygningsniveau - Bygning uden ejendom. Der eksisterer ikke en ejendom med samme ejendomsnr. '
'--------------------------------------------------------------------------------------------'

SELECT Kommune_nr as [Kommune nr.], Ejd_nr as [Ejendoms nr.], BYG_NR AS [Bygningsnr.]
FROM CO10100T as a
WHERE NOT EXISTS
   (SELECT *
   FROM CO10000T as b  
   WHERE   b.Kommune_nr = a.Kommune_nr and
	    b.Ejd_nr = a.Ejd_nr) AND a.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, BYG_NR  
Order BY kommune_nr, Ejd_nr, BYG_NR

36:
'Bygningsniveau - Areal af udestue kan ikke være negativt.'
'---------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.UDESTUE_ARL as [Areal af udestue (felt 244)]
FROM         CO10100T 
WHERE   CO10100T.UDESTUE_ARL < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.UDESTUE_ARL
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

37:
'Bygningsniveau - Areal af indbygget udehus kan ikke være negativt.'
'------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.UDHUS_INDB_ARL as [Areal af indbygget udhus (felt 243)]
FROM         CO10100T 
WHERE   CO10100T.UDHUS_INDB_ARL < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.UDHUS_INDB_ARL 
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

38:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for vandforsyning.' 
'---------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.BYG_VANDFORSY_KODE AS [Vandforsyning (felt 249)]
FROM         CO10100T 
WHERE     (CO10100T.BYG_VANDFORSY_KODE NOT LIKE '1') AND (CO10100T.BYG_VANDFORSY_KODE NOT LIKE '2') AND 
          (CO10100T.BYG_VANDFORSY_KODE NOT LIKE '3') AND (CO10100T.BYG_VANDFORSY_KODE NOT LIKE '4') AND 
          (CO10100T.BYG_VANDFORSY_KODE NOT LIKE '6') AND (CO10100T.BYG_VANDFORSY_KODE NOT LIKE '9') AND
          (CO10100T.BYG_VANDFORSY_KODE NOT LIKE '') AND  (BYG_ANVEND_KODE NOT LIKE '320') AND 
          (BYG_ANVEND_KODE NOT LIKE '910') AND (BYG_ANVEND_KODE NOT LIKE '920') AND  
          (BYG_ANVEND_KODE NOT LIKE '930') AND (LOGISK_TJEK LIKE 'Y') AND KOMMUNE_NR = @KOMNR 
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.BYG_VANDFORSY_KODE, LOGISK_TJEK
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

39:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for vandforsyning.'                                  
'---------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10000T.EJD_VANDFORSY_KODE AS [Vandforsyning ejendom (felt 103)], CO10100T.BYG_VANDFORSY_KODE AS [Vandforsyning bygning (felt 249)]
FROM         CO10000T INNER JOIN
                      CO10100T ON CO10000T.KOMMUNE_NR = CO10100T.KOMMUNE_NR AND CO10000T.EJD_NR = CO10100T.EJD_NR
WHERE     (CO10000T.EJD_VANDFORSY_KODE = '7') AND 
          (CO10100T.BYG_VANDFORSY_KODE = '') AND  
          (CO10100T.BYG_ANVEND_KODE NOT LIKE '320') AND (CO10100T.BYG_ANVEND_KODE NOT LIKE '910') AND 
          (CO10100T.BYG_ANVEND_KODE NOT LIKE '920') AND  (CO10100T.BYG_ANVEND_KODE NOT LIKE '930') AND
          (CO10100T.LOGISK_TJEK LIKE 'Y') AND CO10100T.KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, CO10100T.BYG_VANDFORSY_KODE, CO10000T.EJD_VANDFORSY_KODE, CO10100T.LOGISK_TJEK
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

40:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for supplerende varme.' 
'-------------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.VARME_SUPPL_KODE as [Supplerende varme (felt 239)]
FROM       CO10100T 
WHERE     (CO10100T.VARME_SUPPL_KODE NOT LIKE '01') AND (CO10100T.VARME_SUPPL_KODE NOT LIKE '02') AND 
          (CO10100T.VARME_SUPPL_KODE NOT LIKE '03') AND (CO10100T.VARME_SUPPL_KODE NOT LIKE '04') AND 
          (CO10100T.VARME_SUPPL_KODE NOT LIKE '05') AND (CO10100T.VARME_SUPPL_KODE NOT LIKE '06') AND 
          (CO10100T.VARME_SUPPL_KODE NOT LIKE '07') AND (CO10100T.VARME_SUPPL_KODE NOT LIKE '10') AND
          (CO10100T.VARME_SUPPL_KODE NOT LIKE '80') AND (CO10100T.VARME_SUPPL_KODE NOT LIKE '90') AND 
          (CO10100T.VARME_SUPPL_KODE NOT LIKE '') AND (CO10100T.BYG_ANVEND_KODE NOT LIKE '320') AND 
          (CO10100T.BYG_ANVEND_KODE NOT LIKE '910') AND (CO10100T.BYG_ANVEND_KODE NOT LIKE '920') AND  
          (CO10100T.BYG_ANVEND_KODE NOT LIKE '930')AND (CO10100T.LOGISK_TJEK LIKE 'Y') AND CO10100T.KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR, CO10100T.VARME_SUPPL_KODE
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

41:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for varmeinstallation.' 
'-------------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.VARMEINSTAL_KODE AS [Varmeinstallation (felt 229)]
FROM         CO10100T 
WHERE     (CO10100T.VARMEINSTAL_KODE   NOT LIKE '01') AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '02') AND 
          (CO10100T.VARMEINSTAL_KODE   NOT LIKE '03') AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '05') AND
	  (CO10100T.VARMEINSTAL_KODE   NOT LIKE '06') AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '07') AND 
	  (CO10100T.VARMEINSTAL_KODE   NOT LIKE '08') AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '09') AND 
	  (CO10100T.VARMEINSTAL_KODE   NOT LIKE '')   AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '1') AND 
          (CO10100T.VARMEINSTAL_KODE   NOT LIKE '2') AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '3') AND 
          (CO10100T.VARMEINSTAL_KODE   NOT LIKE '5') AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '6') AND 
          (CO10100T.VARMEINSTAL_KODE   NOT LIKE '7') AND (CO10100T.VARMEINSTAL_KODE   NOT LIKE '8') AND 
          (CO10100T.VARMEINSTAL_KODE   NOT LIKE '9') AND (CO10100T.BYG_ANVEND_KODE NOT LIKE '320') AND 
    	  (CO10100T.BYG_ANVEND_KODE NOT LIKE '910') AND  (CO10100T.BYG_ANVEND_KODE NOT LIKE '920') AND  
    	  (CO10100T.BYG_ANVEND_KODE NOT LIKE '930') AND (LOGISK_TJEK LIKE 'Y') AND KOMMUNE_NR = @KOMNR
Group by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR, CO10100T.VARMEINSTAL_KODE 
Order by CO10100T.Kommune_nr, CO10100T.ejd_nr, CO10100T.BYG_NR

42:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for konstruktionsforhold felt (210).' 
'---------------------------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], KONSTRUKTION_KODE AS [Konstruktionsforhold (felt 210)]
FROM         CO10100T
WHERE     (NOT (KONSTRUKTION_KODE  LIKE '1')) AND (NOT (KONSTRUKTION_KODE  LIKE '')) AND (LOGISK_TJEK LIKE 'Y') AND CO10100T.KOMMUNE_NR = @KOMNR
Group By  CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR, KONSTRUKTION_KODE
Order by  CO10100T.Kommune_nr, CO10100T.Ejd_nr, CO10100T.BYG_NR

43:
'Bygningsniveau - Kælderareal med loft < 1,25 m over terræn kan ikke være negativt.' 
'----------------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], KAELDER_ARL_U_125M AS [Kælderareal med loft < 1,25 m over terræn (felt 224)]
From CO10100T
Where KAELDER_ARL_U_125M < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, KAELDER_ARL_U_125M
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

44:
'Bygningsniveau - Samlet kælderareal kan ikke være negativt.' 
'-----------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], KAELDER_ARL_SAML AS [Samlet kælderareal (felt 223)]
From CO10100T
Where KAELDER_ARL_SAML < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, KAELDER_ARL_SAML
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

45:
'Bygningsniveau - Areal af indbygget garage kan ikke være negativt.' 
'------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], GARAGE_INDB_ARL AS [Areal af indbygget garage (felt 241)]
From CO10100T
Where GARAGE_INDB_ARL < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, GARAGE_INDB_ARL
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

46:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for fritliggende bygninger.' 
'------------------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.FRITLIG_KODE AS [Fritliggende bygninger (felt 237)]       
FROM         CO10100T
WHERE     (NOT (FRITLIG_KODE LIKE '1')) AND (NOT (FRITLIG_KODE LIKE '2')) AND (NOT (FRITLIG_KODE LIKE '')) AND (LOGISK_TJEK LIKE 'Y') AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, CO10100T.FRITLIG_KODE, LOGISK_TJEK
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

47:
'Bygningsniveau - Antal etager kan ikke være negativt.' 
'-----------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.ETAGER_ANT AS [Antal etager (felt 220)]
From CO10100T
Where ETAGER_ANT < 0 AND (LOGISK_TJEK LIKE 'Y') AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, CO10100T.ETAGER_ANT
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

48:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for afvigende etager.' 
'------------------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.ETAGER_AFVIG_KODE AS [Afvigende etager (felt 270)]   
FROM         CO10100T
WHERE     (NOT (ETAGER_AFVIG_KODE LIKE '1')) AND (NOT (ETAGER_AFVIG_KODE  LIKE '')) AND (NOT (LOGISK_TJEK LIKE 'Y')) AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, CO10100T.ETAGER_AFVIG_KODE
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

49:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for afvigende etager.' 
'------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], ERHV_ARL_SAML AS [Samlet erhvervsareal (felt 218)]
From CO10100T
Where ERHV_ARL_SAML < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, ERHV_ARL_SAML
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

50:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for elevator.' 
'----------------------------------------------------------------'

SELECT     CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CO10100T.ELEVATOR_KODE AS [Elevator (felt 231)]  
FROM         CO10100T
WHERE     (NOT (ELEVATOR_KODE LIKE '1')) AND (NOT (ELEVATOR_KODE LIKE '')) AND (LOGISK_TJEK LIKE 'Y') AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, CO10100T.ELEVATOR_KODE
ORDER BY Kommune_nr, Ejd_nr, CO10100T.BYG_NR

51:
'Bygningsniveau - Areal af indbygget carport kan ikke være negativt.' 
'-------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], CARPORT_INDB_ARL AS [Areal af indbygget carport (felt 242)]
From CO10100T
Where CARPORT_INDB_ARL < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, CARPORT_INDB_ARL
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

52:
'Bygningsniveau - Antal enkeltværelser kan ikke være negativt i stamregisteret.' 
'------------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], BYG_ENKELTVAER_ANT AS [Antal enkeltværelser (felt 206)]
From CO10100T
Where BYG_ENKELTVAER_ANT  < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, BYG_ENKELTVAER_ANT
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

53:
'Bygningsniveau - Bygningens enhedsantal kan ikke være negativt i stamregisteret.' 
'--------------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], BYG_ENH_ANT AS [Bygningens enhedsantal]
From CO10100T
Where BYG_ENH_ANT  < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, BYG_ENH_ANT
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

54:
'Bygningsniveau - Bygningens samlede boligareal kan ikke være negativt i stamregisteret.' 
'---------------------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], BYG_BOLIG_ARL_SAML AS [Samlet boligareal (felt 217)]
From CO10100T
Where BYG_BOLIG_ARL_SAML < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, BYG_BOLIG_ARL_SAML
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

55:
'Bygningsniveau - Bygningens samlede bygningsareal kan ikke være negativt i stamregisteret.' 
'------------------------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], BYG_BEBYG_ARL AS [Samlet bygningsareal (felt 216)]
From CO10100T
Where BYG_BEBYG_ARL  < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, BYG_BEBYG_ARL
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

56:
'Bygningsniveau - Bygningens antal egentlige beboelseslejligheder kan ikke være negativt i stamregisteret.' 
'---------------------------------------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], BYG_BEBOLEJL_ANT AS [Antal egentlige beboelseslejligheder (felt 205)]
From CO10100T
Where BYG_BEBOLEJL_ANT  < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, BYG_BEBOLEJL_ANT
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

57:
'Bygningsniveau - Bygningens bebygget areal kan ikke være negativt i stamregisteret.' 
'-----------------------------------------------------------------------------------'

Select CO10100T.Kommune_nr as [Kommune nr.], CO10100T.Ejd_nr as [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], BYG_ARL_SAML AS [Bebygget areal (felt 219)]
From CO10100T
Where BYG_ARL_SAML < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, BYG_ARL_SAML
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

58:
'Bygningsniveau -  Areal af lovlig beboelse i delvis frilagt kælder kan ikke være negativt i stamregisteret.' 
'-----------------------------------------------------------------------------------------------------------'

Select KOMMUNE_NR AS [Kommune nr.], EJD_NR AS [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], ANDET_ARL AS [Areal af lovlig beboelse i delvis frilagt kælder (felt 225)]
From CO10100T
Where ANDET_ARL < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, ANDET_ARL
ORDER BY kommune_nr, Ejd_nr, CO10100T.BYG_NR

59:
'Bygningsniveau -  Areal af affaldsrum i terrænniveau kan ikke være negativt i stamregisteret.' 
'---------------------------------------------------------------------------------------------'

Select KOMMUNE_NR AS [Kommune nr.], EJD_NR AS [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], AFFALDSRUM_ARL AS [Areal af affaldsrum i terrænniveau (felt 247)]
From CO10100T
Where AFFALDSRUM_ARL < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, AFFALDSRUM_ARL
Order by Kommune_nr, EJD_NR, CO10100T.BYG_NR

60:
'Bygningsniveau -  Bygning(er) med ikke korrokt kode for adgangsforhold.' 
'-----------------------------------------------------------------------'

SELECT     KOMMUNE_NR AS [Kommune nr.], EJD_NR AS [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], ADGANG_KODE AS [Adgangsforhold (felt 204)]
FROM         CO10100T
WHERE     (NOT (ADGANG_KODE LIKE '1')) AND (NOT (ADGANG_KODE LIKE '')) AND (LOGISK_TJEK LIKE 'Y') AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, ADGANG_KODE
Order by Kommune_nr, Ejd_nr, CO10100T.BYG_NR

61:
'Bygningsniveau -  Areal af lovlig beboelse i delvis frilagt kælder kan ikke være negativt i stamregisteret.' 
'-----------------------------------------------------------------------------------------------------------'

Select KOMMUNE_NR AS [Kommune nr.], EJD_NR AS [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], LOVLIG_BEBO_ARL AS [Areal af lovlig beboelse i delvis frilagt kælder (felt 245)]
From CO10100T
Where LOVLIG_BEBO_ARL < 0 AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, LOVLIG_BEBO_ARL
ORDER BY KOMMUNE_NR, EJD_NR, CO10100T.BYG_NR

62:
'Bygningsniveau -  Bygning(er) med ikke korrekt kode for fredning.' 
'-----------------------------------------------------------------'

Select KOMMUNE_NR AS [Kommune nr.], EJD_NR AS [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], FREDNING_KODE AS [Fredning (felt 238)]
from CO10100T 
where   (FREDNING_KODE NOT LIKE '1') AND (FREDNING_KODE NOT LIKE '2') AND
	(FREDNING_KODE NOT LIKE '3') AND (FREDNING_KODE NOT LIKE '4') AND
	(FREDNING_KODE NOT LIKE '5') AND (FREDNING_KODE NOT LIKE '6') AND
	(FREDNING_KODE NOT LIKE '7') AND (FREDNING_KODE NOT LIKE '8') AND
	(FREDNING_KODE NOT LIKE '9') AND (FREDNING_KODE NOT LIKE '') AND 
	(FREDNING_KODE NOT LIKE '01') AND (FREDNING_KODE NOT LIKE '02') AND
	(FREDNING_KODE NOT LIKE '03') AND (FREDNING_KODE NOT LIKE '04') AND
	(FREDNING_KODE NOT LIKE '05') AND (FREDNING_KODE NOT LIKE '06') AND
	(FREDNING_KODE NOT LIKE '07') AND (FREDNING_KODE NOT LIKE '08') AND
	(FREDNING_KODE NOT LIKE '09') AND CO10100T.KOMMUNE_NR = @KOMNR
Group by Kommune_nr, Ejd_nr, CO10100T.BYG_NR, FREDNING_KODE
ORDER BY KOMMUNE_NR, EJD_NR, CO10100T.BYG_NR

63:
'Bygningsniveau - Bygning(er) uden ejendom.' 
'------------------------------------------'
    
SELECT Kommune_nr as [Kommune nr.], Ejd_nr as [Ejendoms nr.], BYG_NR AS [Bygningsnr.]
FROM CO10100T as a
WHERE NOT EXISTS
   (SELECT *
   FROM CO10000T as b  
   WHERE   b.Kommune_nr = a.Kommune_nr and
     b.Ejd_nr = a.Ejd_nr) AND a.kommune_nr = @KOMNR 
Group by Kommune_nr, Ejd_nr, BYG_NR  
Order BY kommune_nr, Ejd_nr, BYG_NR    

64:
'Bygningsniveau - Bygning(er) med ikke korrekt kode for udlejningsforhold.' 
'-------------------------------------------------------------------------'
    
SELECT     KOMMUNE_NR AS [Kommune nr.], EJD_NR AS [Ejendoms nr.], CO10100T.BYG_NR AS [Bygningsnr.], BYG_UDLEJNING_KODE As [Udlejningsforhold (felt 261)]
FROM         dbo.CO10100T
WHERE   (BYG_UDLEJNING_KODE NOT LIKE 'E') AND 
	(BYG_UDLEJNING_KODE NOT LIKE 'H') AND 
	(BYG_UDLEJNING_KODE NOT LIKE 'L') AND 
        (BYG_UDLEJNING_KODE NOT LIKE 'M') AND 
        (NOT (BYG_UDLEJNING_KODE LIKE '')) AND CO10100T.KOMMUNE_NR = @KOMNR
GROUP BY KOMMUNE_NR, EJD_NR, CO10100T.BYG_NR, BYG_UDLEJNING_KODE 
ORDER BY KOMMUNE_NR, EJD_NR, CO10100T.BYG_NR  

65:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for bolig- og erhvervsenhedens anvendelse.'
'-----------------------------------------------------------------------------------------'

SELECT     KOMMUNE_NR AS [Kommune nr.], EJD_NR AS [Ejendoms nr.], BYG_NR AS [Bygningsnr.], VEJ_KODE AS [Vejkode], HUS_NR AS [Husnr.], ETAGE AS [Etage], SIDE_DOERNR AS [Side/dør], 
           ENH_ANVEND_KODE AS [Bolig- og erhvervsenhedens anvendelse (felt 307)]
FROM         CO10200T
WHERE     (ENH_ANVEND_KODE NOT LIKE '110') AND (ENH_ANVEND_KODE NOT LIKE '120') AND (ENH_ANVEND_KODE NOT LIKE '130') AND 
                      (ENH_ANVEND_KODE NOT LIKE '140') AND (ENH_ANVEND_KODE NOT LIKE '150') AND (ENH_ANVEND_KODE NOT LIKE '160') AND 
                      (ENH_ANVEND_KODE NOT LIKE '190') AND (ENH_ANVEND_KODE NOT LIKE '210') AND (ENH_ANVEND_KODE NOT LIKE '220') AND 
                      (ENH_ANVEND_KODE NOT LIKE '230') AND (ENH_ANVEND_KODE NOT LIKE '290') AND (ENH_ANVEND_KODE NOT LIKE '310') AND 
                      (ENH_ANVEND_KODE NOT LIKE '320') AND (ENH_ANVEND_KODE NOT LIKE '330') AND (ENH_ANVEND_KODE NOT LIKE '340') AND 
                      (ENH_ANVEND_KODE NOT LIKE '350') AND (ENH_ANVEND_KODE NOT LIKE '360') AND (ENH_ANVEND_KODE NOT LIKE '370') AND 
                      (ENH_ANVEND_KODE NOT LIKE '390') AND (ENH_ANVEND_KODE NOT LIKE '410') AND (ENH_ANVEND_KODE NOT LIKE '420') AND 
                      (ENH_ANVEND_KODE NOT LIKE '430') AND (ENH_ANVEND_KODE NOT LIKE '440') AND (ENH_ANVEND_KODE NOT LIKE '450') AND 
                      (ENH_ANVEND_KODE NOT LIKE '490') AND (ENH_ANVEND_KODE NOT LIKE '510') AND (ENH_ANVEND_KODE NOT LIKE '520') AND 
                      (ENH_ANVEND_KODE NOT LIKE '530') AND (ENH_ANVEND_KODE NOT LIKE '540') AND (ENH_ANVEND_KODE NOT LIKE '590') AND 
                      (ENH_ANVEND_KODE NOT LIKE '610') AND KOMMUNE_NR = @KOMNR
GROUP BY KOMMUNE_NR, EJD_NR, BYG_NR, VEJ_KODE, HUS_NR, ETAGE, SIDE_DOERNR, ENH_ANVEND_KODE
ORDER BY KOMMUNE_NR, EJD_NR, BYG_NR, VEJ_KODE, HUS_NR

66:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for kondemneret bolig.'
'---------------------------------------------------------------------'

Select CO10200T.KOMMUNE_NR AS [Kommune nr.], CO10200T.EJD_NR AS [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
       BOLIG_KONDEM AS [Kondemneret bolig (felt 309)]
FROM         CO10200T
WHERE     (CO10200T.BOLIG_KONDEM NOT LIKE '1') AND (CO10200T.BOLIG_KONDEM NOT LIKE ' ') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.KOmmune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.BOLIG_KONDEM 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

67:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for boligtype.'
'-------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
           CO10200T.BOLIGTYPE_KODE as [Boligtype (felt 308)]  
FROM         CO10200T 
WHERE     (CO10200T.BOLIGTYPE_KODE NOT LIKE '1') AND (CO10200T.BOLIGTYPE_KODE NOT LIKE '2') AND 
          (CO10200T.BOLIGTYPE_KODE NOT LIKE '3') AND (CO10200T.BOLIGTYPE_KODE NOT LIKE '4') AND 
	  (CO10200T.BOLIGTYPE_KODE NOT LIKE '5') AND (CO10200T.BOLIGTYPE_KODE  NOT LIKE '') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.BOLIGTYPE_KODE 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

68:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for CPR-Adresse.'
'---------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.ENH_CPR_ADR_KODE as [CPR-adresse (felt 378)]
FROM         CO10200T 
WHERE  (CO10200T.ENH_CPR_ADR_KODE NOT LIKE '9') AND 
       (CO10200T.ENH_CPR_ADR_KODE NOT LIKE '*') AND 
       (CO10200T.ENH_CPR_ADR_KODE NOT LIKE '') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.ENH_CPR_ADR_KODE
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

69:
'Enhedsniveau - Enhed(er) med ikke korrekt årstal for tidsbegrænset dispensation.'
' årstal for tidsbegrænset dispensation kan ikke være tidligere end opførelsesår.'
'--------------------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
 	   CO10200T.DISPENSATION_AAR as [årstal for tidsbegrænset dispensation. (felt 380)], CO10100T.OPFOERELSE_AAR as [Opførelsesår (felt 207)] 
FROM 	   CO10200T INNER JOIN
                      CO10100T ON CO10200T.KOMMUNE_NR = CO10100T.KOMMUNE_NR AND CO10200T.EJD_NR = CO10100T.EJD_NR

--[begin] Indsat af Steen Hulthin Rasmussen, EBST, 2008-01-03
And CO10100T.BYG_NR=CO10200T.BYG_NR
--[end]

WHERE    CO10200T.DISPENSATION_AAR < CO10100T.OPFOERELSE_AAR AND CO10200T.DISPENSATION_AAR not like '0' AND CO10200T.KOMMUNE_NR = @KOMNR 
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.DISPENSATION_AAR, CO10100T.OPFOERELSE_AAR
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

70:
'Enhedsniveau - Når kode B indberettes i lovlig anvendelse, skal årstal for dispensation'
'indberettes i årstal for tidsbegrænset dispensation.                                   '
'---------------------------------------------------------------------------------------'

SELECT     CO10200T.KOMMUNE_NR AS [Kommune nr.], CO10200T.EJD_NR AS [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   LOVLIG_ANVEND_KODE AS [Lovlig anvendelse (felt 379)], DISPENSATION_AAR AS [årstal for tidsbegrænset dispensation. (felt 380)]
FROM         CO10200T
WHERE     (CO10200T.DISPENSATION_AAR = '') AND (CO10200T.LOVLIG_ANVEND_KODE = 'B') AND KOMMUNE_NR = @KOMNR
GROUP BY CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.LOVLIG_ANVEND_KODE, CO10200T.DISPENSATION_AAR
ORDER BY CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

71:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for energiforsyning.'
'-----------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.ENERGI_KODE as [Energiforsyning (felt 321)]  
FROM         CO10200T 
WHERE     (CO10200T.ENERGI_KODE NOT LIKE '1') AND (CO10200T.ENERGI_KODE NOT LIKE '2') AND 
          (CO10200T.ENERGI_KODE NOT LIKE '3') AND (CO10200T.ENERGI_KODE NOT LIKE '4') AND 
          (CO10200T.ENERGI_KODE NOT LIKE '5') AND (CO10200T.ENERGI_KODE  NOT LIKE '6') AND 
          (CO10200T.ENERGI_KODE  NOT LIKE '') AND (LOGISK_TJEK LIKE 'Y') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.ENERGI_KODE 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

72:
'Enhedsniveau - Samlet areal for enhed kan ikke være negativt.'
'-------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.ENH_ARL_SAML as [Samlet areal (felt 311)]
FROM         CO10200T 
WHERE   CO10200T.ENH_ARL_SAML < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.ENH_ARL_SAML
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

73:
'Enhedsniveau - Enhed(er) med et ejendomsnummer der ikke' 
'eksisterer i ESR.' 
'-------------------------------------------------------'

SELECT A.KOMMUNE_NR AS [Kommune nr.], A.EJD_NR AS [Ejendoms nr.], BYG_NR AS [Bygningsnr.], VEJ_KODE AS [Vejkode], HUS_NR AS [Husnr.], ETAGE AS [Etage], SIDE_DOERNR AS [Side/dør]
FROM CO10200T as a
WHERE NOT EXISTS
   (SELECT *
   FROM CO11500T as b  
   WHERE   b.Kommune_nr = a.Kommune_nr and
	    b.Ejd_nr = a.Ejd_nr) AND a.KOMMUNE_NR = @KOMNR
GROUP BY KOMMUNE_NR, EJD_NR, BYG_NR, VEJ_KODE, HUS_NR, ETAGE, SIDE_DOERNR
ORDER BY KOMMUNE_NR, EJD_NR, BYG_NR, VEJ_KODE, HUS_NR

74:
'Enhedsniveau - Areal til erhverv for enhed kan ikke være negativt i stamregisteret.'
'-----------------------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.ENH_ERHV_ARL as [Areal til erhverv (felt 313)]
FROM         CO10200T 
WHERE   CO10200T.ENH_ERHV_ARL < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, 
CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.ENH_ERHV_ARL
Order by CO10200T.Kommune_nr, CO10200T.ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

75:
'Enhedsniveau - Enhed uden ejendom.'
'-------------------------------------------------------------------'

    
SELECT Kommune_nr as [Kommune nr.], Ejd_nr as [Ejendoms nr.], BYG_NR AS [Bygningsnr.], VEJ_KODE AS [Vejkode], HUS_NR AS [Husnr.], ETAGE AS [Etage], SIDE_DOERNR AS [Side/dør]
FROM CO10200T as a
WHERE NOT EXISTS
   (SELECT *
   FROM CO10000T as b  
   WHERE   b.Kommune_nr = a.Kommune_nr and
	    b.Ejd_nr = a.Ejd_nr) and a.kommune_nr = @komnr
GROUP BY   KOMMUNE_NR, EJD_NR, BYG_NR, VEJ_KODE, HUS_NR, ETAGE, SIDE_DOERNR
ORDER BY   KOMMUNE_NR, EJD_NR, BYG_NR, VEJ_KODE, HUS_NR

76:
'Enhedsniveau - Enhed(er) med ikke korrekt angivelse for etage.'
'--------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.ETAGE as [Etage (felt 303)]  
FROM         CO10200T 
WHERE     (CO10200T.ETAGE NOT LIKE 'K2') AND (CO10200T.ETAGE NOT LIKE 'K3') AND 
          (CO10200T.ETAGE NOT LIKE 'K4') AND (CO10200T.ETAGE NOT LIKE 'K5') AND
	  (CO10200T.ETAGE NOT LIKE 'K6') AND (CO10200T.ETAGE NOT LIKE 'K7') AND 
          (CO10200T.ETAGE NOT LIKE 'K8') AND (CO10200T.ETAGE NOT LIKE 'K9') AND
	  (CO10200T.ETAGE NOT LIKE 'KL') AND (CO10200T.ETAGE NOT LIKE 'ST') AND 
          (CO10200T.ETAGE NOT LIKE '') AND (CO10200T.ETAGE NOT LIKE '_[0-99]') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.ETAGE 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

77:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for kilde til bygningsarealer.'
'-----------------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.KILDE_ARL_KODE as [Kilde til bygningsarealer (felt 228/317)]  
FROM         CO10200T 
WHERE     (CO10200T.KILDE_ARL_KODE NOT LIKE '1') AND (CO10200T.KILDE_ARL_KODE NOT LIKE '2') AND 
          (CO10200T.KILDE_ARL_KODE NOT LIKE '3') AND (CO10200T.KILDE_ARL_KODE NOT LIKE '4') AND 
          (CO10200T.KILDE_ARL_KODE NOT LIKE '5') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.KILDE_ARL_KODE 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

78:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for Køkkenforhold.'
'-----------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.KOEKKEN_KODE as [Køkkenforhold (felt 320)]  
FROM         CO10200T 
WHERE     (CO10200T.KOEKKEN_KODE NOT LIKE 'E') AND (CO10200T.KOEKKEN_KODE NOT LIKE 'F') AND 
          (CO10200T.KOEKKEN_KODE NOT LIKE 'G') AND (CO10200T.KOEKKEN_KODE NOT LIKE 'H') AND
          (CO10200T.KOEKKEN_KODE NOT LIKE '') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.KOEKKEN_KODE 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

79:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for lovlig anvendelse.'
'---------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.LOVLIG_ANVEND_KODE as [Lovlig anvendelse (felt 379)]  
FROM         CO10200T 
WHERE     (CO10200T.LOVLIG_ANVEND_KODE NOT LIKE 'A') AND (CO10200T.LOVLIG_ANVEND_KODE NOT LIKE 'B') AND 
          (CO10200T.LOVLIG_ANVEND_KODE NOT LIKE 'C') AND (CO10200T.LOVLIG_ANVEND_KODE NOT LIKE 'D') AND
          (CO10200T.LOVLIG_ANVEND_KODE NOT LIKE '') AND (CO10200T.LOVLIG_ANVEND_KODE NOT LIKE 'E')AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.LOVLIG_ANVEND_KODE 
Order by CO10200T.Kommune_nr, CO10200T.ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

80:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for flytbare skillevægge.'
'------------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.SKILLEVAEG_KODE as [Flytbare skillevægge (felt 316)]  
FROM         CO10200T 
WHERE     (CO10200T.SKILLEVAEG_KODE NOT LIKE '1') AND (CO10200T.SKILLEVAEG_KODE NOT LIKE '') AND (LOGISK_TJEK LIKE 'Y') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.SKILLEVAEG_KODE 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

81:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for udlejningsforhold.'
'---------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.ENH_UDLEJ1_KODE as [Udlejningsforhold (felt 322)]  
FROM         CO10200T 
WHERE     (CO10200T.ENH_UDLEJ1_KODE NOT LIKE '') AND (CO10200T.ENH_UDLEJ1_KODE NOT LIKE 'L') AND 
          (CO10200T.ENH_UDLEJ1_KODE NOT LIKE 'E') AND (CO10200T.ENH_UDLEJ1_KODE NOT LIKE 'H') AND
	  (CO10200T.ENH_UDLEJ1_KODE NOT LIKE 'M') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.ENH_UDLEJ1_KODE 
Order by CO10200T.KOMMUNE_NR, CO10200T.EJD_NR, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

82:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for udlejningsforhold 2.'
'-----------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.ENH_UDLEJ2_KODE as [Udlejningsforhold 2 (felt 392)]  
FROM         CO10200T 
WHERE     (CO10200T.ENH_UDLEJ2_KODE NOT LIKE '1') AND (CO10200T.ENH_UDLEJ2_KODE NOT LIKE '2') AND 
          (CO10200T.ENH_UDLEJ2_KODE NOT LIKE '3') AND (CO10200T.ENH_UDLEJ2_KODE NOT LIKE '') AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.ENH_UDLEJ2_KODE 
Order by CO10200T.Kommune_nr, CO10200T.ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

83:
'Enhedsniveau - Antal værelser til erhverv i enheden kan ikke være negativt.'
'---------------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør], 
	   CO10200T.VAER_ERHV_ANT as [Antal værelser til erhverv i enheden (felt 315)]
FROM         CO10200T 
WHERE   CO10200T.VAER_ERHV_ANT < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.VAER_ERHV_ANT
Order by CO10200T.Kommune_nr, CO10200T.ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

84:
'Enhedsniveau - Antal værelser i bolig- eller erhvervsenheden kan ikke være negativt.'
'------------------------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør], CO10200T.VAERELSE_ANT as [Antal værelser i bolig- eller erhvervsenheden (felt 314)]
FROM         CO10200T 
WHERE   CO10200T.VAERELSE_ANT < 0 AND KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.VAERELSE_ANT
Order by CO10200T.Kommune_nr, CO10200T.ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

85:
'Enhedsniveau - Enhed(er) med ikke korrekt kode for Henvisning fra supplementsrum til moderlejlighed (felt 384).'
'---------------------------------------------------------------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   CO10200T.HENVIS_ETAGE as [Henvisning fra supplementsrum til moderlejlighed (felt 384)]  
FROM         CO10200T 
WHERE     (CO10200T.ETAGE NOT LIKE 'K2') AND (CO10200T.ETAGE NOT LIKE 'K3') AND 
          (CO10200T.ETAGE NOT LIKE 'K4') AND (CO10200T.ETAGE NOT LIKE 'K5') AND
          (CO10200T.ETAGE NOT LIKE 'K6') AND (CO10200T.ETAGE NOT LIKE 'K7') AND 
          (CO10200T.ETAGE NOT LIKE 'K8') AND (CO10200T.ETAGE NOT LIKE 'K9') AND
          (CO10200T.ETAGE NOT LIKE 'KL') AND (CO10200T.ETAGE NOT LIKE 'ST') AND 
          (CO10200T.ETAGE NOT LIKE '') AND (CO10200T.ETAGE NOT LIKE '_[0-99]') AND CO10200T.KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, CO10200T.HENVIS_ETAGE
Order by CO10200T.Kommune_nr, CO10200T.ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

86:
'Enhedsniveau - Enhed(er) med ikke korrekt dato for opførelsesår (felt 310).'
'---------------------------------------------------------------------------'


SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BYG_NR AS [Bygningsnr.], CO10200T.VEJ_KODE AS [Vejkode], CO10200T.HUS_NR AS [Husnr.], CO10200T.ETAGE AS [Etage], CO10200T.SIDE_DOERNR AS [Side/dør],
	   (DATEPART(yy,ENH_OPRET_DATO)) AS [Opførelsesår (felt 310)]
FROM         CO10200T
WHERE     (Datepart(yy, ENH_OPRET_DATO)) < 0  or  (DATEPART(yy,ENH_OPRET_DATO)) > DATEPART(yy, GETDATE()) AND CO10200T.KOMMUNE_NR = @KOMNR
GROUP BY Kommune_nr, Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR, CO10200T.ETAGE, CO10200T.SIDE_DOERNR, ENH_OPRET_DATO
ORDER BY Kommune_nr, Ejd_nr, CO10200T.BYG_NR, CO10200T.VEJ_KODE, CO10200T.HUS_NR

87:
'Enhedsniveau - Areal til beboelse kan ikke være negativt.'
'---------------------------------------------------------'

SELECT     CO10200T.Kommune_nr as [Kommune nr.], CO10200T.Ejd_nr as [Ejendoms nr.], CO10200T.BEBO_ARL as [Areal til beboelse (felt 312)]
FROM         CO10200T 
WHERE   CO10200T.BEBO_ARL < 0 AND CO10200T.KOMMUNE_NR = @KOMNR
Group by CO10200T.Kommune_nr, CO10200T.Ejd_nr, CO10200T.BEBO_ARL
Order by CO10200T.Kommune_nr, CO10200T.ejd_nr

88:
--Filen indeholder en forespørgsel om arealligningen til brug for enkeltkommunetilsyn.
--Arealligningen for X-Kommune

Select CRUD_ID as 'Byg_id',dbo.CO10100T.KOMMUNE_NR, EJD_NR, BYG_NR, 
(BYG_ARL_SAML+TAGETAGE_ARL_UDNYT)-
(BYG_BOLIG_ARL_SAML+ERHV_ARL_SAML+ANDET_ARL+GARAGE_INDB_ARL+CARPORT_INDB_ARL+UDHUS_INDB_ARL+UDESTUE_ARL) as 'arealligningsresultat',
BYG_ARL_SAML ,TAGETAGE_ARL_UDNYT ,BYG_BOLIG_ARL_SAML,ERHV_ARL_SAML,ANDET_ARL,GARAGE_INDB_ARL,
CARPORT_INDB_ARL,UDHUS_INDB_ARL,UDESTUE_ARL,BYG_BEBYG_ARL,ETAGER_ANT
From dbo.CO10100T,dbo.CO18000T
Where dbo.CO10100T.KOMMUNE_NR=dbo.CO18000T.KOMMUNE_NR And 
(BYG_ARL_SAML+TAGETAGE_ARL_UDNYT)-(BYG_BOLIG_ARL_SAML+ERHV_ARL_SAML+ANDET_ARL+GARAGE_INDB_ARL+CARPORT_INDB_ARL+UDHUS_INDB_ARL+UDESTUE_ARL) Not In (0) 
And BYG_ANVEND_KODE=120 And 

--XXX erstattes her med kommune_nr
dbo.CO10100T.KOMMUNE_NR=XXX 
--
And KAELDER_ARL_SAML=0
Order By (BYG_ARL_SAML+TAGETAGE_ARL_UDNYT)-(BYG_BOLIG_ARL_SAML+ERHV_ARL_SAML+ANDET_ARL+GARAGE_INDB_ARL+CARPORT_INDB_ARL+UDHUS_INDB_ARL+UDESTUE_ARL);