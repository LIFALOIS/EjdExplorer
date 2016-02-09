/*
Denne finder “dårlige boliger” ud fra de kriterier vi har valgt. Brug den evt. som skabelon og skift selv ud på kriterierne.
*/
Select NyBBR_GrundView_Aktuel.KOMMUNE_NR, NyBBR_GrundView_Aktuel.EJD_NR, NyBBR_GrundView_Aktuel.VEJ_KODE, NyBBR_GrundView_Aktuel.VEJ_NAVN, NyBBR_GrundView_Aktuel.HUS_NR, NyBBR_GrundView_Aktuel.GRU_Afloeb_Kode, NyBBR_GrundView_Aktuel.GRU_Afloeb_Kode_T, NyBBR_GrundView_Aktuel.GRU_VandForsy_Kode, NyBBR_GrundView_Aktuel.GRU_VandForsy_Kode_T, NyBBR_BygningView_Aktuel.OPFOERELSE_AAR, NyBBR_BygningView_Aktuel.OPVARMNING_KODE, NyBBR_BygningView_Aktuel.OPVARMNING_KODE_T, NyBBR_BygningView_Aktuel.VARME_SUPPL_KODE, NyBBR_BygningView_Aktuel.VARME_SUPPL_KODE_T, NyBBR_BygningView_Aktuel.YDERVAEG_KODE, NyBBR_BygningView_Aktuel.YDERVAEG_KODE_T, NyBBR_BygningView_Aktuel.TAG_KODE, NyBBR_BygningView_Aktuel.TAG_KODE_T, NyBBR_BygningView_Aktuel.BYG_ANVEND_KODE, NyBBR_BygningView_Aktuel.BYG_ANVEND_KODE_T, NyBBR_EnhedView_Aktuel.TOILET_KODE, NyBBR_EnhedView_Aktuel.TOILET_KODE_T, NyBBR_EnhedView_Aktuel.BAD_KODE, NyBBR_EnhedView_Aktuel.BAD_KODE_T, NyBBR_EnhedView_Aktuel.KOEKKEN_KODE, NyBBR_EnhedView_Aktuel.KOEKKEN_KODE_T From NyBBR_BygningView_Aktuel Inner Join NyBBR_GrundView_Aktuel On NyBBR_BygningView_Aktuel.KOMMUNE_NR = NyBBR_GrundView_Aktuel.KOMMUNE_NR And NyBBR_BygningView_Aktuel.EJD_NR = NyBBR_GrundView_Aktuel.EJD_NR Inner Join NyBBR_EnhedView_Aktuel On NyBBR_EnhedView_Aktuel.KOMMUNE_NR = NyBBR_GrundView_Aktuel.KOMMUNE_NR And NyBBR_EnhedView_Aktuel.VEJ_KODE = NyBBR_GrundView_Aktuel.VEJ_KODE And NyBBR_EnhedView_Aktuel.HUS_NR = NyBBR_GrundView_Aktuel.HUS_NR 
Where NyBBR_BygningView_Aktuel.BYG_ANVEND_KODE In (110, 120, 130, 140, 150, 160, 190, 420) And NyBBR_EnhedView_Aktuel.TOILET_KODE = 'A' And NyBBR_EnhedView_Aktuel.BAD_KODE In ('C', 'D') 
And NyBBR_EnhedView_Aktuel.KOEKKEN_KODE In ('F', 'G', 'H') 
Order By NyBBR_GrundView_Aktuel.VEJ_NAVN, NyBBR_GrundView_Aktuel.HUS_NR