Creating rolling sets of monthly tables

Not sure I fuly understand the problem.

Op says there are 3 base(demographic?) tables and six financial tables, but the macro uses
9 financial tables. I will follow the code.

github
https://github.com/rogerjdeangelis/utl-creating-rolling-sets-of-monthly-tables

SAS Forum
https://communities.sas.com/t5/New-SAS-User/Macro-for-mapping-balances/m-p/561598

This is not a typical rolling sum problem.

  Steps  (six-month rolling tables)

    1. Join September 'amb' values with six subsequent months(oct-mar) of demographic data by account number
       union October 'amb' values with six subsequent months of demographic data by account number
       union November
       ...
    2. Transpose sets of six months (desired output?)

       AGEWGT_
       ACCT_NO    _NAME_          MONTH1    MONTH2    MONTH3    MONTH4    MONTH5    MONTH6

          1       FINANCIAL       OCT18     NOV18     DEC18     JAN19     FEB19     MAR19
                                  2         24        76        32        86        26     * Revious Financial

          1       DEMOGRAPHICS    MAR19     MAR19     MAR19     MAR19     MAR19     MAR19

          1       AGE             18        18        18        18        18        18     * Demographics
          1       WGT             97        97        97        97        97        97

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;


Three Demographic tables

 Mar19
 Apr19
 MAY19

NINE Finacial tables tables

monthly_balance_Sep18
monthly_balance_Oct18
monthly_balance_Nov18
monthly_balance_Dec18
monthly_balance_Jan19
monthly_balance_Feb19
monthly_balance_Mar19
monthly_balance_Apr19
monthly_balance_May19


********************
DEMOGRAPHIC TABLES *
********************

data
   Mar19
   Apr19
   MAY19
  ;
  do acct_no=1 to 3;
    age=acct_no*22;
    wgt=acct_no*123;
    output;
  end;
run;quit;

THREE TABLES

WORK.MAR18 total obs=3
 ACCT_NO    AGE    WGT
    1        22    123
    2        44    246
    3        66    369

WORK.APR19 total obs=3
 ACCT_NO    AGE    WGT
    1        22    123
    2        44    246
    3        66    369

WORK.MAY19 total obs=3
 ACCT_NO    AGE    WGT
    1        22    123
    2        44    246
    3        66    369


data
   monthly_balance_Sep18
   monthly_balance_Oct18
   monthly_balance_Nov18
   monthly_balance_Dec18
   monthly_balance_Jan19
   monthly_balance_Feb19
   monthly_balance_Mar19
   monthly_balance_Apr19
   monthly_balance_May19
;
  do acct_no=1 to 3;
    amb=int(100*uniform(3647));
    output;
  end;
run;quit;

********************
FINANCIAL TABLES   *
********************

NINE TABLES

MONTHLY_BALANCE_SEP18 total obs=3

  ACCT_NO    AMB

     1        55
     2        91
     3        15

'' 7 more tables

MONTHLY_BALANCE_APR19 total obs=3

 ACCT_NO    AMB

    1        55
    2        91
    3        15

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

WORK.WANTX total obs=54

  AGEWGT_
  ACCT_NO    _NAME_          MONTH1    MONTH2    MONTH3    MONTH4    MONTH5    MONTH6

     1       MTHIDX          1         2         3         4         5         6
     1       AGEWGTMTHYER    MAR19     MAR19     MAR19     MAR19     MAR19     MAR19
     1       AMBFRO          OCT18     NOV18     DEC18     JAN19     FEB19     MAR19
     1       AMB             2         24        76        32        86        26
     1       AGE             18        18        18        18        18        18
     1       WGT             97        97        97        97        97        97


     2       MTHIDX          1         2         3         4         5         6
     2       AGEWGTMTHYER    MAR19     MAR19     MAR19     MAR19     MAR19     MAR19
     2       AMBFRO          OCT18     NOV18     DEC18     JAN19     FEB19     MAR19
     2       AMB             8         7         5         2         21        7
     2       AGE             39        39        39        39        39        39
     2       WGT             25        25        25        25        25        25
     3       MTHIDX          1         2         3         4         5         6

     3       AGEWGTMTHYER    MAR19     MAR19     MAR19     MAR19     MAR19     MAR19
     3       AMBFRO          OCT18     NOV18     DEC18     JAN19     FEB19     MAR19
     3       AMB             95        59        55        26        17        99
     3       AGE             92        92        92        92        92        92
     3       WGT             96        96        96        96        96        96

   ...

     1       MTHIDX          1         2         3         4         5         6
     1       AGEWGTMTHYER    APR19     APR19     APR19     APR19     APR19     APR19
     1       AMBFRO          NOV18     DEC18     JAN19     FEB19     MAR19     APR19
     1       AMB             24        76        32        86        26        34
     1       AGE             54        54        54        54        54        54
     1       WGT             53        53        53        53        53        53

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

* make data;

* a series;
data
   Mar19
   Apr19
   MAY19
  ;
  do acct_no=1 to 3;
    age=acct_no*22;
    wgt=acct_no*123;
    output;
  end;
run;quit;

*a series;
data havAgeWgt / view=havAgeWgt;
  retain sfx 0;
  set
   Mar19
   Apr19
   MAY19 indsname=nam;
   ;
   retain sfx;
   fro=scan(nam,2,".");
   mthYer=input(fro,monyy5.);
   if lag(nam) ne nam then sfx=sfx+1;
   age=int(100*uniform(1));
   wgt=int(100*uniform(2));

run;quit;


data
   monthly_balance_Sep18
   monthly_balance_Oct18
   monthly_balance_Nov18
   monthly_balance_Dec18
   monthly_balance_Jan19
   monthly_balance_Feb19
   monthly_balance_Mar19
   monthly_balance_Apr19
   monthly_balance_May19
;
  do acct_no=1 to 3;
    amb=int(100*uniform(3647));
    output;
  end;
run;quit;

data havAmb / view=havAmb;
 set
   monthly_balance_Sep18
   monthly_balance_Oct18
   monthly_balance_Nov18
   monthly_balance_Dec18
   monthly_balance_Jan19
   monthly_balance_Feb19
   monthly_balance_Mar19
   monthly_balance_Apr19
   monthly_balance_May19
      indsname=nam;;
  retain sfx 0;
    fro=scan(nam,3,"_");
    mthYer=input(fro,monyy5.);
    if lag(nam) ne nam then sfx=sfx+1;
    amb=int(100*uniform(3647));
run;quit;

/* LEFT TABLE

Up to 40 obs from HAVAGEWGT total obs=9

     Obs    SFX    ACCT_NO    AGE    WGT     FRO

       1     1        1        18     97    MAR19
       2     1        2        39     25    MAR19
       3     1        3        92     96    MAR19
       4     2        1        54     53    APR19
       5     2        2         4      6    APR19
       6     2        3        81     52    APR19
       7     3        1        85      6    MAY19
       8     3        2        95     29    MAY19
       9     3        3        27     68    MAY19

   RIGHT TABLE

Up to 40 obs WORK.HAVAMB total obs=27

     Obs    ACCT_NO    AMB    SFX     FRO

       1       1        55     1     SEP18
       2       2        91     1     SEP18
       3       3        15     1     SEP18
       4       1         2     2     OCT18
       5       2         8     2     OCT18
       6       3        95     2     OCT18
       7       1        24     3     NOV18
       8       2         7     3     NOV18
       9       3        59     3     NOV18
      10       1        76     4     DEC18
      11       2         5     4     DEC18
      12       3        55     4     DEC18
      13       1        32     5     JAN19

*/


proc sql;
  create
     table haveAmnAgeWgt  (where=(ambFro ne "")) as
  select
      r.sfx - l.sfx  as mthIdx
     ,l.acct_no  as   ageWgt_acct_no
     ,r.acct_no  as   amb_acct_no
     ,l.sfx      as   ageWgtSfx
     ,r.sfx      as   ambSfx
     ,l.MthYer   as   ageWgtMthYer
     ,r.MthYer   as   ambSMthYer
     ,l.fro      as   ageWgtFro
     ,r.fro      as   ambFro
     ,r.amb
     ,l.age      as   age
     ,l.wgt      as   wgt
  from
     havAgeWgt as l left join havAmb as r
  on
     l.acct_no   = r.acct_no  and
     r.Sfx > l.sfx  and
     0 < r.sfx - l.sfx  < 7
  order
     by  AGEWGTMTHYER , ageWgt_acct_no , AMBSFX
;quit;

/*
WORK.HAVEAMNAGEWGT total obs=54

            AGEWGT_      AMB_
  MTHIDX    ACCT_NO    ACCT_NO    AGEWGTSFX    AMBSFX    AGEWGTMTHYER    AMBSMTHYER    AGEWGTFRO    AMBFRO    AMB    AGE    WGT

     1         1          1           1           2          21609          21458        MAR19      OCT18       2     18     97
     2         1          1           1           3          21609          21489        MAR19      NOV18      24     18     97
     3         1          1           1           4          21609          21519        MAR19      DEC18      76     18     97
     4         1          1           1           5          21609          21550        MAR19      JAN19      32     18     97
     5         1          1           1           6          21609          21581        MAR19      FEB19      86     18     97
     6         1          1           1           7          21609          21609        MAR19      MAR19      26     18     97
     1         2          2           1           2          21609          21458        MAR19      OCT18       8     39     25
     2         2          2           1           3          21609          21489        MAR19      NOV18       7     39     25
...

*/

* transpose can be problematic because it assigns long lengths to the output variables;
* try arts tranpose macro;
proc transpose data=haveamnagewgt (keep=
      agewgt_acct_no
      agewgtmthyer
      mthidx
      mthidx
      ambfro
      amb
      age
      wgt )  out=want prefix=month;
format agewgtmthyer monyy5.;
var _all_;
by agewgtmthyer agewgt_acct_no;
id mthidx;
run;quit;

* left justify moonths;
data wantx;
 length month: $5;
 set want(drop=AGEWGTMTHYER where=(_name_ not in ('AGEWGT_ACCT_NO')));
 array month month:;
 do over month;
   month=strip(month);
 end;
run;quit;

/*
WORK.WANTX total obs=54

 AGEWGT_
 ACCT_NO    _NAME_          MONTH1    MONTH2    MONTH3    MONTH4    MONTH5    MONTH6

    1       MTHIDX          1         2         3         4         5         6
    1       AGEWGTMTHYER    MAR19     MAR19     MAR19     MAR19     MAR19     MAR19
    1       AMBFRO          OCT18     NOV18     DEC18     JAN19     FEB19     MAR19
    1       AMB             2         24        76        32        86        26
    1       AGE             18        18        18        18        18        18
    1       WGT             97        97        97        97        97        97
    2       MTHIDX          1         2         3         4         5         6
    2       AGEWGTMTHYER    MAR19     MAR19     MAR19     MAR19     MAR19     MAR19
    2       AMBFRO          OCT18     NOV18     DEC18     JAN19     FEB19     MAR19
    2       AMB             8         7         5         2         21        7
    2       AGE             39        39        39        39        39        39
    2       WGT             25        25        25        25        25        25
    3       MTHIDX          1         2         3         4         5         6
    3       AGEWGTMTHYER    MAR19     MAR19     MAR19     MAR19     MAR19     MAR19
    3       AMBFRO          OCT18     NOV18     DEC18     JAN19     FEB19     MAR19
    3       AMB             95        59        55        26        17        99
    3       AGE             92        92        92        92        92        92
    3       WGT             96        96        96        96        96        96
    1       MTHIDX          1         2         3         4         5         6
    1       AGEWGTMTHYER    APR19     APR19     APR19     APR19     APR19     APR19
    1       AMBFRO          NOV18     DEC18     JAN19     FEB19     MAR19     APR19
    1       AMB             24        76        32        86        26        34
    1       AGE             54        54        54        54        54        54
    1       WGT             53        53        53        53        53        53
    2       MTHIDX          1         2         3         4         5         6
    2       AGEWGTMTHYER    APR19     APR19     APR19     APR19     APR19     APR19
    2       AMBFRO          NOV18     DEC18     JAN19     FEB19     MAR19     APR19
    2       AMB             7         5         2         21        7         4
    2       AGE             4         4         4         4         4         4
    2       WGT             6         6         6         6         6         6
    3       MTHIDX          1         2         3         4         5         6
    3       AGEWGTMTHYER    APR19     APR19     APR19     APR19     APR19     APR19
    3       AMBFRO          NOV18     DEC18     JAN19     FEB19     MAR19     APR19
    3       AMB             59        55        26        17        99        51
    3       AGE             81        81        81        81        81        81
*.


