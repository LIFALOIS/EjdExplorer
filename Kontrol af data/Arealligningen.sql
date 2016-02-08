/*
Den beskriver det som man i BBR betegner som arealligningen. 
En kontrol som man kan bruge til at vurdere hvorvidt ens BBR er af nogenlunde kvalitet. 
Er der sammenhæng mellem de indtastninger som beskriver totalerne og de enkelte udspecificerede arealtyper. 

Kontrollen udføres på enfamilieshuse
*/

SELECT  bygn.KOMMUNE_NR ,
        bygn.EJD_NR ,
        bygn.BYG_ANVEND_KODE ,
        bygn.BYG_ARL_SAML + Tagetager.TAGETAGE_ARL_UDNYT AS Total_arealer ,
        bygn.BYG_BOLIG_ARL_SAML + bygn.ERHV_ARL_SAML + bygn.ANDET_ARL
        + bygn.GARAGE_INDB_ARL + bygn.CARPORT_INDB_ARL + bygn.UDHUS_INDB_ARL
        + bygn.UDESTUE_ARL AS Specifik_arealer ,
        ( bygn.BYG_ARL_SAML + Tagetager.TAGETAGE_ARL_UDNYT )
        - ( bygn.BYG_BOLIG_ARL_SAML + bygn.ERHV_ARL_SAML + bygn.ANDET_ARL
            + bygn.GARAGE_INDB_ARL + bygn.CARPORT_INDB_ARL
            + bygn.UDHUS_INDB_ARL + bygn.UDESTUE_ARL ) AS Tot_Spec_Diff ,
        bygn.VEJ_NAVN ,
        bygn.HUS_NR ,
        bygn.PostNr ,
        bygn.PostByNavn
FROM    NyBBR_BygningView_Aktuel bygn
        LEFT JOIN ( SELECT  NyBBR_EtageView_Aktuel.KOMMUNE_NR ,
                            NyBBR_EtageView_Aktuel.EJD_NR ,
                            NyBBR_EtageView_Aktuel.BYG_NR ,
                            NyBBR_EtageView_Aktuel.TAGETAGE_ARL_UDNYT ,
                            NyBBR_EtageView_Aktuel.KAELDER_ARL_U_125M ,
                            NyBBR_EtageView_Aktuel.KaeldArlLovigBebo
                    FROM    NyBBR_EtageView_Aktuel
                  ) Tagetager ON bygn.KOMMUNE_NR = Tagetager.KOMMUNE_NR
                                 AND bygn.EJD_NR = Tagetager.EJD_NR
                                 AND bygn.BYG_NR = Tagetager.BYG_NR
WHERE   bygn.KOMMUNE_NR = 479
        AND bygn.BYG_ANVEND_KODE in(110,120)
