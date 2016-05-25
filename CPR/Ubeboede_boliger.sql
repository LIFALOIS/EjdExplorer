
Create VIEW [dbo].[Ubeboede_boliger]
as
--View til at fremfinde alle ubeboede beboelsesenheder og angive hvor lang tid de har været ubeboede
-- Hvis der på en adresse i BBR findes 2 eller flere beboelsesenheder vil de få samme status i forespørgslen.
-- Det vil sige, der kan være ubeboede enheder som ikke kan fanges, da der er en person tilmeldt adressen
WITH MaxFraflytDato
AS (
  -- Henter person data, konverterer dem så dataformat ligner BBR og gemmer det som en midlertidig tabel
  -- Finder alle adresser som er beboede (FRAFDTO er NULL) og sætter denne dato til 31/12-2400
  -- Vælger den maksimale fraflytningsdato og kalder denne maxFrafdto
  SELECT KOMKOD,
    VEJKOD,
    HUSNR,
    ETAGE,
    LTRIM(UPPER(substring(SIDEDOER, patindex('%[^0]%', SIDEDOER), 10))) AS SIDEDOER,
    Convert(DATETIME, Left(MAX(ISNULL(FRAFDTO, 2400012312359)), 8), 112) AS maxFrafdto
  FROM dbo.DTPERSBO
  GROUP BY KOMKOD,
    VEJKOD,
    HUSNR,
    ETAGE,
    SIDEDOER
  )
-- Kobler ovenstående tabel med alle aktive beboelsesenheder
-- Sorterer alle pt. beboede enheder fra (hvor maxFrafdto ikke er 31/12-2400), så der tilbage kun er ubeboede enheder
SELECT top 100 percent
  TomDage = datediff(day, maxFrafdto, getdate()),
  b.vej_navn,
  A.VEJKOD AS VEJ_KODE,
  A.HUSNR,
  A.ETAGE,
  A.SIDEDOER,
  maxFrafdto,
  B.ENH_ANVEND_KODE_T,
  B.BOLIGTYPE_KODE_T,
  B.Enhed_id,
  A.KOMKOD AS KOMMUNE_NR,
  B.ENH_UDLEJ2_KODE_T,
  B.ENH_ANVEND_KODE,

  GetDate() as Udtraek_dato
FROM MaxFraflytDato AS A
RIGHT JOIN NyBBR_EnhedView AS B ON KOMKOD = B.KOMMUNE_NR
  AND A.VEJKOD = B.VEJ_KODE
  AND A.HUSNR = B.HUS_NR
  AND ISNULL(A.ETAGE,0) = ISNULL(B.ETAGE,0)
AND ISNULL(A.SIDEDOER,0) = ISNULL(B.SIDE_DOERNR,0)
WHERE B.ObjStatus = 1
  AND B.ENH_ANVEND_KODE IN (110,120,130,140,150,190,510)
  AND b.nybyg = 0
  AND year(maxFrafdto) < 2300
ORDER BY TomDage DESC


