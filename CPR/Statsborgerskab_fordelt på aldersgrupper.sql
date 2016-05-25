/*
Denne viser antal borgere med angivelse as statsborgerskab, opdelt i aldersgrupper
*/
SELECT DISTINCT
        cav.Statsborgerret ,
        (SELECT COUNT(*) FROM CPR_AktivView cav1 WHERE cav1.Statsborgerret = cav.Statsborgerret
                      AND cav1.Alder < 6) AS [0-5] ,
        (SELECT COUNT(*) FROM CPR_AktivView cav1 WHERE cav1.Statsborgerret = cav.Statsborgerret
                      AND cav1.Alder > 5 AND cav1.Alder < 18) AS [6-17] ,
        (SELECT COUNT(*) FROM CPR_AktivView cav1 WHERE cav1.Statsborgerret = cav.Statsborgerret
                      AND cav1.Alder > 17 AND cav1.Alder < 106) AS [18-105] ,
        (SELECT COUNT(*) FROM CPR_AktivView cav1 WHERE cav1.Statsborgerret = cav.Statsborgerret) AS Total

FROM    CPR_AktivView cav
ORDER BY cav.Statsborgerret;
