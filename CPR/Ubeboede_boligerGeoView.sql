
Create VIEW [dbo].[Ubeboede_boligerGeoView]
AS
SELECT
	dbo.Ubeboede_boliger.TomDage
	,dbo.Ubeboede_boliger.VEJ_NAVN
	,dbo.Ubeboede_boliger.HUSNR
	,dbo.Ubeboede_boliger.ETAGE
	,dbo.Ubeboede_boliger.SIDEDOER
	,dbo.Ubeboede_boliger.ENH_ANVEND_KODE
	,dbo.Ubeboede_boliger.VEJ_KODE
	,dbo.Ubeboede_boliger.BOLIGTYPE_KODE_T
	,dbo.Ubeboede_boliger.ENH_UDLEJ2_KODE_T
	,dbo.Ubeboede_boliger.maxFrafdto
	,dbo.NyBBR_AdgAdrGEOView.ObjStatus
	,dbo.NyBBR_AdgAdrGEOView.Geometri
	,dbo.NyBBR_AdgAdrGEOView.KOMMUNE_NR AS Expr1
FROM dbo.Ubeboede_boliger
INNER JOIN dbo.NyBBR_AdgAdrGEOView
	ON dbo.Ubeboede_boliger.VEJ_KODE = dbo.NyBBR_AdgAdrGEOView.VEJ_KODE
	AND dbo.Ubeboede_boliger.HUSNR = dbo.NyBBR_AdgAdrGEOView.HUS_NR


