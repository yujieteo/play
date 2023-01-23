      SUBROUTINE UHYPER(BI1,BI2,AJ,U,UI1,UI2,UI3,TEMP,NOEL,
     1 CMNAME,INCMPFLAG,NUMSTATEV,STATEV,NUMFIELDV,FIELDV,
     2 FIELDVINC,NUMPROPS,PROPS)
      
      INCLUDE 'ABA_PARAM.INC'

C     Recreation of hong2009 code.
C     Original code by Hong et. al. Comments and annotations by Teo Yu Jie.
C     Subroutine
C     Material properties:
C     --------------------
C     PROPS(1) - Nv (Range: 10E-4 - 10E-1, number of molecules per unit volume)
C     PROPS(2) - chi (Range: 0 - 1.2, enthalpy of mixing)
C     PROPS(3) - lambda_0 (Range: 1.5, pre-swelling isotropic stretch)
C
C     State variables:
C     ----------------
C     TEMP     - mu/kT    (Range: ???, chemical potential of the solvent, independent variable)
C
C     Initial conditions
C     -------------------
C
C     Note that detF_0 = lambda_0 ** 3
C     See equation 20 for isotropic stretches of free swelling in hong2009
C
C     mu_0/kT = Nv * (1/lambda_0 - 1/detF_0) + ln(1 - 1/detF_0) + 1/detF_0 + chi/(detF0**2)
C
C
C     Output result
C     -------------
C     Free energy function, or the Helmholtz work. We designate this as W
C     W(I,J) and its derivatives.
C     J is the determinant of F
C     J = det F = lambda_1 lambda_2 lambda_3
C     In the subroutine, AJ is the J. This is not keyed in.
C     I_1 is the first invariant (trace)
C     I_1 = lambda_1 ** 2 + lambda_2 ** 2 + lambda_3 ** 2
C     Ibar_1 = J ** (-2/3) I_1 is the first invariant of the isochoric part of
C     the right Cauchy-Green deformation tensor.
C     I = F_ik F_ik      

C     Must it really be 80? Experiment with other numbers.

      CHARACTER*80 CMNAME
      
C     Setting parameters for dimensions
C     In dimension, the parentheses represents the number of columns
C     When called i.e. U(2), this is the second entry.
     
C     U is the strain energy density vector, 1 x 2. So DIMENSION U(2)
C     U(1) is the strain energy density function. 
C     U(2) is the deviatoric part of the strain energy density. Needed for Mullins' effect.
C     U(2) models quasi-static loading based on incompressible isotropic elasticity.
C     Damage variable is defined. Only the deviatoric part is associated with damange.
C     Models the damage of the hydrogel.
C     BI1 = bar I_1 ; BI2 = bar I_2 ; AJ = J
      DIMENSION U(2)
      
C     UI are the first derivatives of U, 1 x 3. So DIMENSION UI(3)

C     UI(1) refers to the derivative with respect to the first invariant of isochoric part.
C     Latex: $\partial U/\partial \bar I_1$
C     I_1bar = J ** -2/3 I_1
C     I_1 is the first invariant (trace) of the deformation gradient
C     I_1 = lambda_1 ** 2 + lambda_2 ** 2 + lambda_3 ** 2

C     UI(2) refers to the derivative with respect to the second invariant of isochoric part.
C     Latex: $\partial U/\partial \bar I_2$
C     I_2bar = ???
C     I_2 is an undesignated invariant?
C     I_2 = ???
C     In our example, it is zero. Why?

C     UI(3) refers to the derivative with respect to the determinant of the deformation
C     gradient J.
C     Latex: $\partial U/\partial \bar J$
C     J = det F = lambda_1 lambda_2 lambda_3
C     J is the second invariant of the deformation gradient.      
      
      DIMENSION UI1(3)
      
C     UI2, recycle from UI1 the same documentation, but second derivatives
C     NOTATION: U'''(Ibar_1'' J') means third derivative of U with respect to Ibar_1 twice
C     and J once.
C     UI2(4) = $\partial^2 U/\partial \bar I_1 \partial \bar I_2$, U''(Ibar_1' Ibar_2')
C     UI2(5) = $\partial^2 U/\partial \bar I_1 \partial \bar J$, U''(Ibar_1' J')
C     UI2(6) = $\partial^2 U/\partial \bar I_2 \partial \bar J$, U''(Ibar_2' J')
      DIMENSION UI2(6)
      
C     UI3, third derivatives
C     NOTATION: U'''(Ibar_1'' J') means third derivative of U with respect to Ibar_1 twice
C     and J once
C     UI3(1) = U'''(Ibar_1'' J')
C     UI3(2) = U'''(Ibar_2'' J')
C     UI3(3) = U'''(Ibar_1' Ibar_2' J')
C     UI3(4) = U'''(Ibar_1' J'')
C     UI3(5) = U'''(Ibar_2' J'')
C     UI3(6) = U'''(J''')
      
      DIMENSION UI3(6)
      
C     Soluion dependent at state variables that are user defined.
C     Supply at the start or as values updated by other subroutine.
C     Return as values at the end of the increment.      
      DIMENSION STATEV(*)
      
C     Interpolated value array of field variables at the end
C     of the increment based on values read in at nodes.
C     Analysis start: initial values
C     Analysis process: current values      
      DIMENSION FIELDV(*)
      
C     Array of increments of predefined field variables at this increment.      
      DIMENSION FIELDVINC(*)
      
C     Material properties of user defined variables.
      DIMENSION PROPS(*)

C     Must it really be 8 bits? Real valued numbers.
C     PROPS(1) - Nv (Range: 10E-4 - 10E-1, number of molecules per unit volume)

      REAL(8) Nv
      
C     PROPS(2) - chi (Range: 0 - 1.2, enthalpy of mixing)

      REAL(8) chi
      
C     PROPS(3) - lambda0 (initial stretch factor)
      REAL(8) lambda0
      
C     For initial conditions detF_0 = lambda_0 ** 3
C     This is given as the derivation for the paper.
      REAL(8) detF0
      
C     TEMP = mu/kT    (Range: -10E-5 to -10E-1, chemical potential of the solvent, independent variable)
C     For convention, underscore means fraction.
      REAL(8) mu_kT
      
C     Strain energy density function.
C     Important! This is normalised by kT/v so
C     U(1) = W'/(kT/v) = v/kT W'
C     Consult formula 23 and then use the logarithm rule to get out the rest.
C     AJ = J'
C     I' = BI1 * AJ**(2.0/3.0)
C     Note that in the paper, there is a typo with the second logarithm.
C     LOG(AJ / (AJ - 1/detF0)) = LOG((AJ * detF0)/(AJ * detF0 - 1))
C     Is the correct version. See iMechanica for more details.

      Nv = PROPS(1)
      chi = PROPS(2)
      lambda0 = PROPS(3)
      detF0 = lambda0 ** 3
      mu_kT = TEMP   
      
      U(1) = Nv/2 * ( BI1 * 1/lambda0 * AJ**(2.0/3.0) - 3/detF0
     & - 2/detF0 *(3 * LOG(lambda0) + LOG(AJ)) ) - chi / detF0**2 / AJ
     & - (AJ - 1/detF0) * LOG(AJ/(AJ - 1/detF0))
     & - mu_kT * (AJ - 1/detF0)

C     There is no deviatoric component.     
      U(2) = 0
      
C     Differentiate the following with BI1 and get:
      UI1(1) = Nv / 2 / lambda0 * AJ**(2.0/3.0)
      UI1(2) = 0
      UI1(3) = Nv / 3 / lambda0 * BI1 * AJ**(-1.0/3.0)
     & + (1 - Nv)/AJ/detF0
     & - LOG(AJ/(AJ - 1/detF0))
     & + chi/(detF0 * AJ)**2
     & - mu_kT

C     Set the rest to be zero first.
      UI2 = 0

C     UI2, recycle from UI1 the same documentation, but second derivatives
C     NOTATION: U'''(Ibar_1'' J') means third derivative of U with respect to Ibar_1 twice
C     and J once.
C     Note: only AJ = J' needs to be differentiated.
C     UI2(3) = U''(J'')
C     UI2(5) = U''(Ibar_1' J')

C     Recycle expression of UI1(3) differentiate again      
      UI2(3) = - Nv / 9 /lambda0 * BI1 * AJ**(-4.0/3.0)
     & - (1 - Nv) / AJ**2 / detF0
     & + 1 / AJ / (AJ-1/detF0) / detF0
     & - 2 * chi/detF0 ** 2/ AJ**3

      UI2(5) = Nv/3/lambda0 * AJ ** (-1.0/3.0)
      
C     Set the rest to be zero first.
      UI3 = 0
      
C     UI3(4) = U'''(Ibar_1' J'')
C     UI3(6) = U'''(J''')
      UI3(4) = - Nv / 9 / lambda0 * AJ ** (-4.0/3.0)
      UI3(6) = 4 * Nv * BI1 * AJ**(-7.0/3.0) / 27 / lambda0
     & + 2 * (1 - Nv)/AJ**3/detF0
     & - (2*AJ - 1/detF0) / (AJ*(AJ-1/detF0)) ** 2 / detF0 ! Diff. to verify!
     & + 6 * chi/detF0 ** 2/ AJ**4

C     In FORTRAN, the RETURN statement ends a subrorutine.
C     END is equivalent to the execution of a return statement.
      RETURN
      END