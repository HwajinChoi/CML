C *****************************************************************************
C
C       PROGRAM NAME : bpass.f
C       PROGRAMMER : Dr. Kwang Y. Kim & Kyong-Hwan Seo
C       CODE IDENTIFICATION NUMBER : BPASS/VERSION 1.0
C       CODE CLASSIFICATION : Scientific Computer Code
C       CREATION DATE : February 22, 1993
C       REVISION DATE : not revised
C       REVISION INFORMATION : not applicable
C
C *****************************************************************************
C       This program generates and applies a digital band pass filter.
C  SEO You need to change from (1) through (4) only 

C********************* (1)
      PARAMETER (NT=365*13, NVOID=0)
      PARAMETER (N=NT+15000,NX=144,NY=73)
C*********************

      DIMENSION BETA(0:N), TRNS(0:N), TSER(N), FSER(N), TTTT(NX,NY,NT)
      DIMENSION TEMP(NX,NY), VOID(NX,NY)
      CHARACTER*70 FILENM, FORMAT
      CHARACTER*3 ANS
C      CHARACTER*3 VOID

        PI = 4.0*ATAN(1.0)
        TPI = 2.0*PI
C      PRINT *,'Type center freq(0.5(1/T1+1/T2)) & bandwidth(F_cen-1/T2)'
C      READ *, CF, BW
C      PRINT *, '  Type # of terms (Lags) for approximating a filter.'
C      READ *, LAG
C      PRINT *, '  Define the type of weighting function.'
C      PRINT *, '    0 : no weight'
C      PRINT *, '    1 : Bartlett weight'
C      PRINT *, '    2 : Tukey weight'
C      PRINT *, '    3 : Parzen weight'
C      PRINT *, '    4 : Bohman weight'
C      PRINT *, '    5 : Lanczos weight'
C      READ *, IWT

C       CF=0.0238095 ![30-70]
C       BW=0.00952379

C********************* (2)
       DAY1=2
       DAY2=128

C*********************

       CF=(1.0/DAY1+1.0/DAY2)*0.5
       BW=CF-(1.0/DAY2)

C       CF=0.03  ![20-100]
C       BW=0.02 ;half bandwidth

       NSKP=0 !NOW VOID IS NOT LINE BUT FIELD
       LAG=100  !han
c       LAG=70
       IWT=5  !Lanczos filter

C       { DIGITAL FILTER DESIGN }

C ------- Filter Coefficients
        BETA(0) = 4.*BW
      DO 10 K=1,LAG
        UK = FLOAT(K)*CF
        VK = FLOAT(K)*BW
        BETA(K) = 2./(PI*FLOAT(K)) * COS(TPI*UK) * SIN(TPI*VK)
10    CONTINUE

C ------- Weighted Filter Coefficients
Cseo        IF (IWT.EQ.0)  GO TO 30
      DO 20 K=0,LAG
        U = FLOAT(K)/FLOAT(LAG)
C ---------- Bartlett window
        IF (IWT.EQ.1) THEN
          BETA(K) = BETA(K) * (1. - U)
C ---------- Tukey window
        ELSE IF (IWT.EQ.2) THEN
          BETA(K) = BETA(K) * (0.54 + 0.46*COS(PI*U))
C ---------- Parzen window
        ELSE IF (IWT.EQ.3) THEN
          IF (U.LT.0.5) THEN
            BETA(K) = BETA(K) * (1. - 6.*U*U + 6.*U*U*U)
          ELSE
            BETA(K) = BETA(K) * (2.*(1.-U)**3)
          END IF
C ---------- Bohman window
        ELSE IF (IWT.EQ.4) THEN
          BETA(K) = BETA(K) * ((1.-U)*COS(PI*U) + SIN(PI*U)/PI)
C ---------- Lanczos window (Duchon 1979) sigma factor=sinX/X
C ---------- ADD this on 01/27/03 by Seo
        ELSE IF (IWT.EQ.5) THEN
          IF (U.EQ.0) THEN
          print *,'*** Lanczos Filter with ', LAG*2+1, ' weights***'
          print *,'*n>=1.3/(fc2-fc1)',1.3/(2.0*BW),' 2*n+1 weights*'

          ENDIF
          IF (U.EQ.0) THEN
            BETA(K) = BETA(K) * 1.0
          ELSE
            BETA(K) = BETA(K) * (SIN(PI*U)/(PI*U))
          END IF
        END IF
20    CONTINUE

C ------- Print the Filter Coefficients
40    FORMAT(A60)
C ------- Band-pass Filter Transfer Function
C50    PRINT *, '  Do you want the bandpass filter transfer function?'
C      READ 35, ANS
C      IF (ANS.NE.'Y' .AND. ANS.NE.'YES' .AND.
C     &    ANS.NE.'y' .AND. ANS.NE.'yes')  GO TO 70
C      PRINT *, '  Type the ftf filename and the format.'
C      READ 40, FILENM, FORMAT
C      PRINT *, '  How many points along the frequency axis?'
C      READ *, NPTS

C      NPTS=101  !seo
      NPTS=LAG+1

      DF = .5/FLOAT(NPTS)

      DO 60 I=0,NPTS
        FRQ = FLOAT(I)*DF
        SUM = BETA(0)
      DO 55 K=1,LAG
        SUM = SUM + 2.*BETA(K)*COS(TPI*FLOAT(K)*FRQ)
55    CONTINUE
        TRNS(I) = SUM
60    CONTINUE

      OPEN(UNIT=7, FILE='transf.d', STATUS='UNKNOWN')
      WRITE(7,'(6E13.5)')  (TRNS(I), I=0,NPTS)
      CLOSE(UNIT=7)

C ------- Band-pass Filter a Time Series
C70    PRINT *, '  Do you want to bandpass filter a time series?'
C      READ 35, ANS
C      IF (ANS.NE.'Y' .AND. ANS.NE.'YES' .AND.
C     &    ANS.NE.'y' .AND. ANS.NE.'yes')  GO TO 90
C      PRINT *, '  Type the filename and the format of the input file.'
C      READ 40, FILENM
Cseo      READ 40, FILENM, FORMAT
C      PRINT *, '  How many lines to skip?'
C      READ *, NSKP
C      PRINT *, '  How many data points?'
C      READ *, NPTS

       NPTS=NT !211    !seo
C org-routine = '/3t/hc/choi7/master/ccsm/extract20.data/data/anom/FPS_20.anom'
C******************************** (3)
       OPEN(UNIT=4, 
     & FILE='/das_b/hkkim/data/ccsm4/anom/FPS1000.anom',
     &     STATUS='OLD',FORM='UNFORMATTED',
     &     ACCESS='DIRECT', RECL=NX*NY*4) 
C********************************

C      DO K=1,NSKP
C        READ(4)  VOID
C      END DO
     
 
       DO KK=1,NT
       PRINT *, 'SEO', KK
          READ(4,REC=KK)  TEMP
          DO JJ=1,NY
          DO II=1,NX
          TTTT(II,JJ,KK)=TEMP(II,JJ)
          ENDDO
          ENDDO
       END DO

          print *,'*** Lanczos Filter with ', LAG*2+1, ' weights***'
          print *,'*n>=1.3/(fc2-fc1)',1.3/(2.0*BW),' 2*n+1 weights*'
C ------- end of reading
      DO 99 JJ=1,NY
      DO 99 II=1,NX
       DO KK=1,NT
         TSER(KK)=TTTT(II,JJ,KK)
       ENDDO

      CLOSE(UNIT=4)

      DO 80 I=1,NPTS
C      DO 80 I=1+LAG,NPTS-LAG
        SUM = BETA(0)*TSER(I)
      DO 75 K=1,LAG
        K1 = MOD(NPTS+I-K-1,NPTS) + 1
        K2 = MOD(I+K-1,NPTS) + 1
        SUM = SUM + BETA(K)*(TSER(K1) + TSER(K2))
C        SUM = SUM + BETA(K)*(TSER(I-K) + TSER(I+K))
75    CONTINUE
        FSER(I) = SUM
80    CONTINUE

C      PRINT *, '  Type the filename and the format of the output file.'
C      READ *, FILENM
C      READ 40, FILENM, FORMAT
Cseo      PRINT 85, NPTS-2*LAG
85    FORMAT(2X,'There are',I6,' filtered data points.')
      
       DO KK=1,NT
         TTTT(II,JJ,KK)=FSER(KK)
       ENDDO

99    CONTINUE

C************************************ (4) OUTPUT FILE
      OPEN(UNIT=91, 
     &  FILE='/das_b/hkkim/data/ccsm4/bpass/FPS.anom_bpass', 
     &       STATUS='UNKNOWN',FORM='UNFORMATTED',
     &       ACCESS='DIRECT', RECL=NX*NY*4) 
C************************************ 
      
      DO KK=1,NT
      WRITE(91, REC=KK) ((TTTT(II,JJ,KK),II=1,NX), JJ=1,NY)
      ENDDO

      CLOSE(UNIT=9)

90    STOP
      END
