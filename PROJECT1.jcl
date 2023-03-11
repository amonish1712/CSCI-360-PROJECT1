//KC03E9AA JOB ,'Nevada Perry',MSGCLASS=H
//JSTEP01  EXEC PGM=ASSIST
//STEPLIB  DD DSN=KC00NIU.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
******************************************************************
* CSCI 360-2                PROJECT 1                Spring 2023 *
*                                                                *
* NAMES: Monish Annadurai (Z1938781),                            *
*        Nevada Perry     (Z1976298)                             *
* DATE:  3/31/2023                                               *
*                                                                *
* Assesses customer credit and update APR and LOC.               *
*                                                                *
* REGISTER USAGE:                                                *
*   R1 - Scan pointer (read and written by XDECI)                *
******************************************************************
*
* Responsibilities for Monish and Nevada:
* 1. Build credit table                 - Nevada
* 2. Build transaction table            - Monish
* 3. Build/calculate APR change         - Nevada
* 4. Build/calculate LOC recommendation - Monish
* 5. Generate report                    - Pair
*
CREDIT   DSECT
$ID      DS    F
$NAME    DS    20C
$INCOME  DS    F
$LOC     DS    F
$APR     DS    F
$EQUIFAX DS    F
$TRANSU  DS    F
$EXPERIA DS    F
* Total 12 fullwords per row
*
TRANSACT DSECT
$ID      DS    F
$MONTH   DS    F
$DAY     DS    F
$TYPE    DS    12C            9C but align to fullword boundary
$AMOUNT  DS    F
* Total 7 fullwords per row
*
MAIN     CSECT
         USING MAIN,15
*
* Read in-stream values into customer credit table
*
         SR    2,2            Zero out R2 (number of rows)
         SR    6,6            Zero out R6 (index of array)
OUTER1   XREAD RECORD,80      Read input record into RECORD
         BM    HCOEF          Branch to HCOEF on EOF
         A     2,=F'1'        Increment R2 by 1
         LA    1,RECORD       Load address of RECORD into scan ptr
INNER1   XDECI 7,0(,1)        Convert input; store in R7
         BO    OUTER1         Branch to OUTER1 if exhausted
         ST    7,COEF(6)      Store converted in COEF/VAR
         A     6,=F'4'        Increment R6 by 1 fullword
         B     INNER1         Repeat INNER1
*
* Read in-stream values into customer transaction table
*

*
* Exit
*
DONE     BR    14             Return to caller
         LTORG                Allow for literals
*
* Storage
*
RECORD   DS    CL80           Input record buffer
CCREDITN DC    F'0'           Number of rows in credit table
CCREDIT  DS    36F            Customer credit table (max 3 rows)
* (^Each row is equivalent to 12 fullwords in width)
CTRANSN  DC    F'0'           Number of rows in transaction table
CTRANS   DS    140F           Customer tx. table (max 20 rows)
* (^Each row is equivalent to 7 fullwords in width)
*
         END   MAIN
/*
//*
//* IN-STREAM PROGRAM DATA
//FT05F001 DD *
53081599 Branden Mursell      04900000 400000 1364 805 811 789
46068220 Lena Copestake       10400000 300000 1446 595 587 599
58393056 Jeremy Mollett       11200000 100000 2103 640 649 627
*
53081599 11 16 TRANSFER  047500
46068220 05 09 LIVING    098400
46068220 03 08 TRANSFER  022600
46068220 11 25 TRANSFER  029700
53081599 03 18 MISC      069900
46068220 08 31 LIVING    057100
53081599 01 26 LIVING    079300
46068220 11 04 ENTERTAIN 036600
46068220 09 16 MISC      044200
58393056 06 06 TRANSFER  093900
58393056 07 18 TRANSFER  042500
53081599 05 25 ENTERTAIN 034300
46068220 09 07 ENTERTAIN 033100
53081599 07 18 PAYMENT   011500
53081599 09 14 ENTERTAIN 040500
53081599 12 07 MISC      084900
58393056 12 26 PAYMENT   027500
53081599 10 16 TRANSFER  015900
53081599 07 24 ENTERTAIN 098100
58393056 04 25 ENTERTAIN 057300
/*
//