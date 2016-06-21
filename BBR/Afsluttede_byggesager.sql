/*
Forespørgsel som viser alle bygninger, hvorpå der er afsluttede byggesager
Kan anvendes i forbindelse med ændringsudpegning
*/

SELECT
	byg.KomKode
	,byg.ESREjdNr
	,byg.Bygning_id
	,byg.Bygningsnr
	, AdgAdr.VejKode, AdgAdr.VEJ_NAVN, AdgAdr.HUS_NR, AdgAdr.SupBynavn, AdgAdr.PostNr, AdgAdr.PostByNavn, AdrPkt.KoorOest, AdrPkt.KoorNord
	,byg.BYG_ANVEND_KODE
	,Afsluttetsagdato =
						CASE Bygsag.BYGGESAG_KODE
							WHEN 1 THEN Bygsag.FULDFOERT_DATO
							WHEN 2 THEN CASE
									WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
									ELSE Bygsag.FULDFOERT_DATO
								END
							WHEN 3 THEN CASE
									WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN CASE
											WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
											ELSE Bygsag.FULDFOERT_DATO
										END
									ELSE CASE
											WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
											ELSE Bygsag.IBRUG_TILLAD_DATO
										END
								END
							WHEN 4 THEN CASE
									WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
									ELSE Bygsag.FULDFOERT_DATO
								END
							WHEN 5 THEN CASE
									WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
									ELSE Bygsag.FULDFOERT_DATO
								END
						END
	,AfslutType =
					CASE Bygsag.BYGGESAG_KODE
						WHEN 1 THEN 'Fuldført'
						WHEN 2 THEN CASE
								WHEN Bygsag.FULDFOERT_DATO IS NULL THEN 'Nedrivning'
								ELSE 'Fuldført'
							END
						WHEN 3 THEN CASE
								WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN CASE
										WHEN Bygsag.FULDFOERT_DATO IS NULL THEN 'Nedrivning'
										ELSE 'Fuldført'
									END
								ELSE CASE
										WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN 'Nedrivning'
										ELSE 'Ibrugtagning'
									END
							END
						WHEN 4 THEN CASE
								WHEN Bygsag.FULDFOERT_DATO IS NULL THEN 'Nedrivning'
								ELSE 'Fuldført'
							END
						WHEN 5 THEN CASE
								WHEN Bygsag.FULDFOERT_DATO IS NULL THEN 'Nedrivning'
								ELSE 'Fuldført'
							END
					END
	,Bygsag.BYGGESAG_KODE
	, BYGGESAG_KODE_T = CASE Bygsag.BYGGESAG_KODE WHEN 1	THEN 'BR - Tilladelsessag uden ibrugtagningstilladelse'
WHEN 2	THEN 'BR - Anmeldelsessag (garager, carporte, udhuse og nedrivning)'
WHEN 3	THEN 'BR - Tilladelsessag med ibrugtagningstilladelse'
WHEN 4	THEN 'BR - Tilladelsessag landbrugsbygning'
WHEN 5	THEN 'BR - Anmeldelsessag (øvrige)'
END 

FROM CO40100T byg
INNER JOIN CO40900T Bygsag
	ON byg.Byggesag_id = Bygsag.Byggesag_id
INNER JOIN CO42000T AdgAdr ON byg.AdgAdr_id = AdgAdr.AdgAdr_id
LEFT JOIN CO43200T AdrPkt ON AdgAdr.Adressepunkt_id = AdrPkt.Adressepunkt_id
LEFT JOIN CO42400T ct
	ON byg.Bygning_id = ct.Parent_id
WHERE byg.ObjStatus = 4
AND Bygsag.Henlaeggelse IS NULL
AND CASE Bygsag.BYGGESAG_KODE
	WHEN 1 THEN Bygsag.FULDFOERT_DATO
	WHEN 2 THEN CASE
			WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
			ELSE Bygsag.FULDFOERT_DATO
		END
	WHEN 3 THEN CASE
			WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN CASE
					WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
					ELSE Bygsag.FULDFOERT_DATO
				END
			ELSE CASE
					WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
					ELSE Bygsag.IBRUG_TILLAD_DATO
				END
		END
	WHEN 4 THEN CASE
			WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
			ELSE Bygsag.FULDFOERT_DATO
		END
	WHEN 5 THEN CASE
			WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
			ELSE Bygsag.FULDFOERT_DATO
		END
END IS NOT NULL

ORDER BY CASE Bygsag.BYGGESAG_KODE
	WHEN 1 THEN Bygsag.FULDFOERT_DATO
	WHEN 2 THEN CASE
			WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
			ELSE Bygsag.FULDFOERT_DATO
		END
	WHEN 3 THEN CASE
			WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN CASE
					WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
					ELSE Bygsag.FULDFOERT_DATO
				END
			ELSE CASE
					WHEN Bygsag.IBRUG_TILLAD_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
					ELSE Bygsag.IBRUG_TILLAD_DATO
				END
		END
	WHEN 4 THEN CASE
			WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
			ELSE Bygsag.FULDFOERT_DATO
		END
	WHEN 5 THEN CASE
			WHEN Bygsag.FULDFOERT_DATO IS NULL THEN Bygsag.NEDRIVNING_DATO
			ELSE Bygsag.FULDFOERT_DATO
		END
END