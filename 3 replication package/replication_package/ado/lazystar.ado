#delimit

** anf(1/4/11) this ado file is similar to cleanup but adds labels and solves the troublesome
'rowscomma' it requires a 'varnames' and a 'varlabs' var that contain the variable names and 
labels, coefs specifies the number of coefficients per column and rowgap specifies the number
of rows between each coefficient estimate ; 

** anf(9/11/14) update changes format to 3 decimal places and a fixed width of 9 characters, 
inserts square brackets and appends the asterisks instead of putting them in a separate column
also, in general lazystar thinks that any three vertically consecutive numbers are NOT 
regression coefficients, so it will not give them parentheses or calculate asterisks. This
can be used to make lazystar treat summary statistics differently ;

cap program define lazystar;
syntax, table(string) columns(numlist) coefs(numlist) rowgap(numlist) outsheet(string);
mat zzz=`table';
cap drop zzz; 
svmat zzz;
cap drop coefline;
gen coefline=0;
local start = 1; 

** note, this specifies display format, can adjust to specify decimal points and width;
*width.decimalpoints ;
format zzz* %9.3f;

foreach Z of numlist 1/`coefs'{;

replace coefline = 1 in `start'; 
local start = `start' + `rowgap'; 
};


foreach X of numlist `columns'  {;


  local next=`X'+1;
  disp "dropping zzz`next'";
qui    drop zzz`next';
qui    gen str4 zzz`next'="";

qui    replace zzz`next'="*" if abs(zzz`X'/zzz`X'[_n+1]) > 1.646&coefline&zzz`X'[_n+1]!=. &zzz`X'!=. &zzz`X'[_n+2] == .;
qui    replace zzz`next'="**" if abs(zzz`X'/zzz`X'[_n+1]) > 1.96&coefline&zzz`X'[_n+1]!=. &zzz`X'!=. &zzz`X'[_n+2] == .;
qui    replace zzz`next'="***" if abs(zzz`X'/zzz`X'[_n+1]) > 2.57&coefline&zzz`X'[_n+1]!=. &zzz`X'!=. &zzz`X'[_n+2] == .;

local colmax=`next';
  };
aorder zzz*;

local rowmax= `coefs'*`rowgap'+5;

** solve star issue; 

tostring zzz*, force replace usedisplayformat ;

foreach X of numlist `columns'  {;

local next=`X'+1;

replace zzz`X' = zzz`X'+zzz`next' if zzz`X'[_n+2] == ""; 
replace zzz`next' = "";
replace zzz`X' = "" if zzz`X' == "." ; 

local colmax=`next';


  };
    
  
  

aorder zzz*;

** parentheses for SE's;

foreach X of numlist `columns'  {;
foreach Y of numlist 2(`rowgap')`rowmax'{;
local se = zzz`X' in `Y';
replace zzz`X' = "(`se')" in `Y' if zzz`X'[_n+1] == "" ;
replace zzz`X' = "" if zzz`X' == "()";
  };
  
  };
  

aorder zzz*;


local cwd="`c(pwd)'";
quietly capture cd "..\out";
local confirmdir=_rc ;
quietly cd "`cwd'";

*disp " confirmdir is `confirmdir'";

if `confirmdir'==0 {;
  export excel varnames varlabs zzz1-zzz`colmax' if _n<=`rowmax' using ..\out\\`outsheet'.xls,  replace;
  };
 else if `confirmdir'!=0 {;
  export excel varnames varlabs zzz1-zzz`colmax' if _n<=`rowmax' using `outsheet'.xls,  replace;
  };
 disp "Table `outsheet' written";

drop zzz* coefline;



end;