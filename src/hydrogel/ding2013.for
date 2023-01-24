      SUBROUTINE UHYPER(BI1,BI2,AJ,U,UI1,UI2,UI3,TEMP,NOEL,
     1 CMNAME,INCMPFLAG,NUMSTATEV,STATEV,NUMFIELDV,FIELDV,
     2 FIELDVINC,NUMPROPS,PROPS)
C===============================================================
C     User defined hyperelastic material subroutine
C       for gel with Flory-Rehner free-energy function
C       to be used in Abaqus Standard
C     Fomulated and written by Ding Zhiwei June 15, 2012
C     Supervised by Prof Liu Zishun
C---------------------------------------------------------------
C     Material properties to be passed to the subroutine:
C       PROPS(1) - Nv
C       PROPS(2) - lambda_0   initial swelling
C     State variable:
C       TEMP     - mu/kT      current chemical potential
C       The initial value of chemical potential should agree
C           with the initial swelling, given as follows:
C       mu_0/kT = Nv*(1/lambda_0-1/detF0) + ln(1-1/detF0)
C                    + 1/detF0+ chi/detF0^2
C       where detF0 = lambda_0^3
C     Output
C       Free-energy function U(I, J) and its derivatives
C       All free-energy density and stress given by the
C           calculation are normalized by kT/v
C===============================================================
C
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME
      DIMENSION U(2),UI1(3),UI2(6),UI3(6),STATEV(*),FIELDV(*),
     1 FIELDVINC(*),PROPS(*)
      REAL(8) Nv, chi0,chi1,A0,B0,A1,B1, lambda0, detF0, mu_k
      Nv = PROPS(1)
      lambda0 = PROPS(2)
      detF0 = lambda0**3
      mu_k = 0
      A0=-12.947
      B0=0.04496
      A1=17.92
      B1=-0.0569
      chi0=A0+B0*TEMP
      chi1=A1+B1*TEMP

	U(1) = Nv/2*TEMP* ( lambda0**2*BI1*AJ**(2.0/3.0) - 3
     & - 2*(3*LOG(lambda0) + LOG(AJ))) 
     & + TEMP*((detF0*AJ-1)*LOG((detF0*AJ-1)/detF0/AJ)
     & + (chi0/AJ/detF0+chi1/AJ**2/detF0**2)) - mu_k*(detF0*AJ-1)
	U(2) = 0
	UI1(1) = Nv*TEMP/2 * lambda0**2*AJ**(2.0/3.0)
	UI1(2) = 0
	UI1(3) = Nv/3*TEMP*lambda0**2*BI1*AJ**(-1.0/3.0)-mu_k*detF0
     & + ((1-Nv)/AJ - ( LOG(AJ/(AJ-1/detF0)))*detF0)*TEMP
     & + (chi0-chi1)*TEMP*AJ**(-2)/detF0+2*chi1*TEMP*detF0**(-2)*AJ**(-3)
	UI2 = 0
	UI2(3) = -Nv/9*lambda0**2*BI1*AJ**(-4.0/3.0)*TEMP
     & - (1-Nv)/AJ**2*TEMP + 1/AJ/(AJ-1/detF0)*TEMP 
     & + 2*TEMP*(chi1-chi0)*AJ**(-3)/detF0
     & - 6*chi1*TEMP*detF0**(-2)*AJ**(-4) 
      UI2(5) = Nv/3*lambda0**2 * AJ**(-1.0/3.0)*TEMP
	UI3 = 0
	UI3(4) = -Nv/9*lambda0**2 * AJ**(-4.0/3.0)*TEMP
	UI3(6) = 4*Nv/27*lambda0**2*BI1*AJ**(-7.0/3.0)*TEMP
     & + 2*(1-Nv)/AJ**3*TEMP - TEMP*(2*AJ-1/detF0)/(AJ*(AJ-1/detF0))**2
     & + 24*chi1*TEMP*detF0**(-2)*AJ**(-5)
     & + 6*(chi0-chi1)*TEMP*AJ**(-4)/detF0

       STATEV(1)=TEMP       

      RETURN
      END