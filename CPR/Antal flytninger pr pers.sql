/*
Denne finder antal flytninger pr. CPR-nummer. 
*/
Select DTPERSBO.PNR, Count(DTPERSBO.PNR) 
From DTPERSBO 
Group By DTPERSBO.PNR 
Order By DTPERSBO.PNR
