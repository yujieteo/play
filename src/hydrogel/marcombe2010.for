      SUBROUTINE UHYPER(BI1,BI2,AJ,U,UI1,UI2,UI3,TEMP,NOEL,
     1 CMNAME,INCMPFLAG,NUMSTATEV,STATEV,NUMFIELDV,FIELDV,
     2 FIELDVINC,NUMPROPS,PROPS)
C===============================================================
C     User defined hyperelastic material subroutine
C       for gel with Flory-Rehner free-energy function
C       to be used in Abaqus Standard
C     Fomulated and written by Wei Hong, April 20, 2008
C---------------------------------------------------------------
C     Material properties to be passed to the subroutine:
C       PROPS(1) - Nv
C       PROPS(2) - chi
C       PROPS(3) - lambda_0   initial swelling
C       PROPS(4) - vC0        ion concentration in external solution
C       PROPS(5) - pKa        dissociation constant
C       PROPS(6) - f          density of PH sensitive monomer
C       
C     State variable:
C       TEMP     - PH0  PH in the solvent outside the gel   
C       Set chemical potential of all kinds of ions at vc0 as 0.
C       
C       The initial value of PH0 and lambda_0 should match each other 
C===============================================================
C
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME
      DIMENSION U(2),UI1(3),UI2(6),UI3(6),STATEV(*),FIELDV(*),
     1 FIELDVINC(*),PROPS(*)
      REAL(8) Nv, chi, lambda0, detF0,vCcou, vCco,vCpro,Ka,f,vNa
      REAL(8) U UI1 UI2 UI3 aa bb cc dd PP QQ FORM11 DDDGDDDAJ
      REAL(8) FORM21 FORM31 FORM41 FORM12 FORM22 FORM32 FORM 
      REAL(8) FORM42 DCDAJ DDCDDAJ DDDCDDDAJ vCH DvCHDAJ DDvCHDDAJ 
      REAL(8) DDDvCHDDDAJ vCA DvCADAJ DDvCADDAJ DDDvCADDDAJ vCAH
      REAL(8) DvCAHDAJ DDvCAHDDAJ D3vCAHD3AJ GAJ DGDAJ DDGDDAJ 
      REAL(8) R theta FI SE TH FO
            
       Nv = PROPS(1)
       chi = PROPS(2)
       lambda0 = PROPS(3)
       detF0 = lambda0**3
       vCcou=PROPS(4)
       vNa=0.0602
       vCpro=vNa*10.0**(-TEMP)
       vCco=vCcou+vCpro
       Ka=10**(-PROPS(5))
       f=PROPS(6)

            
      	U(1) = Nv/2 * ( 1/lambda0*BI1*AJ**(2.0/3.0) - 3/detF0
     & - 2/detF0*(3*LOG(lambda0) + LOG(AJ)) ) - chi/detF0**2/AJ
     & - (AJ-1/detF0)*LOG(AJ/(AJ-1/detF0)) 
       

	U(2) = 0
	UI1(1) = Nv/2/lambda0*AJ**(2.0/3.0)
	UI1(2) = 0

        
        UI1(3) = Nv/3/lambda0*BI1*AJ**(-1.0/3.0)
     & + (1-Nv)/AJ/detF0 - LOG(AJ/(AJ-1/detF0))+chi/(detF0*AJ)**2
        
	UI2 = 0
	UI2(3) = -Nv/9/lambda0*BI1*AJ**(-4.0/3.0) -(1-Nv)/AJ**2/detF0
     & + 1/AJ/(AJ-1/detF0)/detF0 - 2*chi/detF0**2/AJ**3
        UI2(5) = Nv/3/lambda0 * AJ**(-1.0/3.0)
	UI3 = 0
	UI3(4) = -Nv/9/lambda0 * AJ**(-4.0/3.0)
	UI3(6) = 4*Nv/27/lambda0*BI1*AJ**(-7.0/3.0)
     & + 2*(1-Nv)/AJ**3/detF0
     & - (2*AJ-1/detF0)/(AJ*(AJ-1/detF0))**2/detF0
     & + 6*chi/detF0**2/AJ**4

       aa=1+vCcou/vCpro
       bb=Ka*(vNa)*aa
       cc=-(Ka*vNa*f/AJ/detF0+vCpro*vCco)
       dd=-Ka*vNa*vCpro*vCco

       PP=cc/aa-(bb**2)/3/(aa**2)
       QQ=dd/aa-bb*cc/3/aa**2+2*bb**3/27/aa**3
       
       FORM=(QQ/2)**2+(PP/3)**3
       
       IF(FORM.GE.0.0)THEN

       vCH=(-QQ/2+FORM**(1.0/2.0))**(1.0/3.0)+(-QQ/2
     & - FORM**(1.0/2.0))**(1.0/3.0)-bb/3/aa

       ELSE

       R=QQ**2/4-FORM

       theta=ATAN2(-2*(-FORM)**(0.5),QQ)

       IF(theta.LT.0.0)THEN
       theta=3.1415926+theta
       ENDIF

       vCH=2*R**(1.0/6.0)*cos(theta/3)-bb/3/aa
       ENDIF
      
       DCDAJ=Ka*vNa*f*(AJ*detF0)**(-2)
       DDCDDAJ=-2*Ka*vNa*f*(AJ*detF0)**(-3)
       DDDCDDDAJ=6*Ka*vNa*f*(AJ*detF0)**(-4)
    
       DvCHDAJ=-(vCH)*DCDAJ/(3*aa*vCH**2+2*bb*vCH+cc)

       DDvCHDDAJ=-(vCH*DDCDDAJ+2*DCDAJ*DvCHDAJ+2*bb*DvCHDAJ**2+6*aa
     & * vCH*DvCHDAJ**2)/(3*aa*vCH**2+2*bb*vCH+cc)

       DDDvCHDDDAJ=-(6*aa*DvCHDAJ**3+18*aa*vCH*DvCHDAJ*DDvCHDDAJ+6
     & * bb*DvCHDAJ*DDvCHDDAJ+3*DCDAJ*DDvCHDDAJ+3*DDCDDAJ*DvCHDAJ
     & + vCH*DDDCDDDAJ)/(3*aa*vCH**2+2*bb*vCH+cc)
       

       vCA=aa*vCH-vCpro*vCco/vCH

       DvCADAJ=(aa+vCpro*vCco/vCH**2)*DvCHDAJ

       DDvCADDAJ=(aa+vCpro*vCco/vCH**2)*DDvCHDDAJ-2*DvCHDAJ**2
     & * vCpro*vCco/vCH**3

       DDDvCADDDAJ=DDDvCHDDDAJ*(aa+vCpro*vCco/vCH**2)-6*DDvCHDDAJ 
     & * DvCHDAJ*vCpro*vCco/(vCH**3)+6*vCpro*vCco/(vCH**4)*(DvCHDAJ**3)
       

       vCAH=f/detF0/AJ-vCA

       DvCAHDAJ=-f/detF0**2/AJ**2-DvCADAJ
       DDvCAHDDAJ=2*f/detF0**3/AJ**3-DDvCADDAJ
       D3vCAHD3AJ=-6*f/detF0**4/AJ**4-DDDvCADDDAJ
       
 
       

       FORM11=log(vCH)+log(vCA)-log(vCAH)-log(vNa)-log(Ka)
      
 
       FORM12=aa*vCH+vCpro*vCco/vCH

       FORM21=DvCHDAJ/vCH+DvCADAJ/vCA-DvCAHDAJ/vCAH
       FORM22=(aa-vCpro*vCco/(vCH**2))*DvCHDAJ

       FORM31=DDvCHDDAJ/vCH-(DvCHDAJ/vCH)**2+DDvCADDAJ/vCA 
     & - (DvCADAJ/vCA)**2-DDvCAHDDAJ/vCAH+(DvCAHDAJ/vCAH)**2

       FORM32=(aa-vCpro*vCco/(vCH**2))*DDvCHDDAJ+2*vCpro 
     & * vCco/(vCH**3)*(DvCHDAJ**2)

       FORM41=DDDvCHDDDAJ/vCH-3*DDvCHDDAJ*DvCHDAJ/vCH**2
     & + 2*(DvCHDAJ/vCH)**3+DDDvCADDDAJ/vCA-3*DDvCADDAJ*DvCADAJ
     & / vCA**2+2*(DvCADAJ/vCA)**3-D3vCAHD3AJ/vCAH+3*DDvCAHDDAJ 
     & * DvCAHDAJ/vCAH**2-2*(DvCAHDAJ/vCAH)**3

       FORM42=(aa-vCpro*vCco/(vCH**2))*DDDvCHDDDAJ+6*vCpro 
     & * vCco/(vCH**3)*DDvCHDDAJ*DvCHDAJ-6*vCpro*vCco/(vCH**4)
     & * DvCHDAJ**3
               
      

       GAJ=detF0*AJ*vCA*FORM11+f*(log(detF0*AJ)-log(f)
     & + log(vCAH))+(detF0*AJ-1)*(vCpro+vCco+vCcou)
     & - detF0*AJ*FORM12
     


       
       FI=vCpro+vCco+vCcou
       SE=f*(1/(detF0*AJ)+DvCAHDAJ/vCAH)
       TH=(vCA+detF0*AJ*DvCADAJ)*FORM11
       FO=detF0*AJ*vCA*FORM21-FORM12-AJ*detF0*FORM22

       DGDAJ=FI+SE+TH+FO  
     

       DDGDDAJ=f*(-1/(detF0*AJ)**2+DDvCAHDDAJ/vCAH-(DvCAHDAJ/vCAH)**2) 
     & + 2*FORM21*(vCA+detF0*AJ*DvCADAJ)+FORM11*(2*DvCADAJ+detF0*AJ
     & * DDvCADDAJ)+detF0*vCA*AJ*FORM31-2*FORM22-AJ*detF0
     & * FORM32

       DDDGDDDAJ=f*(2/(detF0*AJ)**3+D3vCAHD3AJ/vCAH-3*DvCAHDAJ 
     & *DDvCAHDDAJ/vCAH**2+2*(DvCAHDAJ/vCAH)**3)+3*FORM21
     & *(2*DvCADAJ+detF0*AJ*DDvCADDAJ)+3*(vCA+detF0*AJ*DvCADAJ) 
     & *FORM31+FORM11*(3*DDvCADDAJ+detF0*AJ*DDDvCADDDAJ)+detF0 
     & *AJ*vCA*FORM41-3*FORM32-detF0*AJ*FORM42



       U(1)=U(1)+GAJ/detF0
       
       UI1(3)=UI1(3)+DGDAJ
       UI2(3)=UI2(3)+DDGDDAJ*detF0    
       UI3(6)=UI3(6)+DDDGDDDAJ*detF0**2 
       
      RETURN
      END