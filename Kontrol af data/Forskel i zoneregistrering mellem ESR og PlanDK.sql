/*
Sammenligner registrering af zonekode i ESR og på PlanDK på matrikelniveau

Vær opmærksom på, at der skal ændres kommunekode ned i WHERE-clausen
*/

Select Distinct Zone.ZONE_T As Zone_Plan, 
Zone.LANDSEJERLAV_KODE, 
Zone.MatrNR, 
ESRMatrikelView.ZONE_KODE_T As Zone_ESR 
FROM dbo.Plandk2ZoneMatView AS Zone Right Join ESRMatrikelView 
ON Zone.LANDSEJERLAV_KODE = ESRMatrikelView.LANDSEJERLAV_KODE 
AND Zone.MatrNR = ESRMatrikelView.MatrNr 
AND Zone.ZONE <> ESRMatrikelView.ZONE_KODE 
WHERE Zone.KOMMUNE_NR = 849 
ORDER By Zone.LANDSEJERLAV_KODE, Zone.MatrNR