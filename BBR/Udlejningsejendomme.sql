/*
Denne finder udlejningsejendomme:
*/

Select NyBBR_EnhedView_Aktuel.EJD_NR, NyBBR_EnhedView_Aktuel.VEJ_NAVN, NyBBR_EnhedView_Aktuel.HUS_NR, NyBBR_EnhedView_Aktuel.PostNr, NyBBR_EnhedView_Aktuel.ENH_ANVEND_KODE, NyBBR_EnhedView_Aktuel.ENH_ANVEND_KODE_T, NyBBR_EnhedView_Aktuel.BOLIGTYPE_KODE, NyBBR_EnhedView_Aktuel.BOLIGTYPE_KODE_T, NyBBR_EnhedView_Aktuel.ENH_UDLEJ2_KODE, NyBBR_EnhedView_Aktuel.ENH_UDLEJ2_KODE_T, ESREjerView.EJERFORHOLD_KODE, ESREjerView.EJERFORHOLD_KODE_T, NyBBR_EnhedView_Aktuel.ETAGE, NyBBR_EnhedView_Aktuel.SIDE_DOERNR 
From NyBBR_EnhedView_Aktuel Inner Join ESREjerView 
On NyBBR_EnhedView_Aktuel.KOMMUNE_NR = ESREjerView.KOMMUNE_NR And NyBBR_EnhedView_Aktuel.EJD_NR = ESREjerView.EJD_NR 
Where NyBBR_EnhedView_Aktuel.BOLIGTYPE_KODE In ('1', '3') And ESREjerView.EJERFORHOLD_KODE = '20' 
Order By NyBBR_EnhedView_Aktuel.VEJ_NAVN, NyBBR_EnhedView_Aktuel.HUS_NR

