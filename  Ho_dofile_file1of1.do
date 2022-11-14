**************
*Set working directory 
****************
*version 17
clear
cd "C/Users/naomiho/Documents/Thesis /Data/Questionnaire LadyAgri - final.xlsx", sheet("Sheet0") cellrange(A1:BB216) firstrow clear
capture log close
set more off

//import excel "/Users/naomiho/Documents/Thesis /Data/Questionnaire LadyAgri - final.xlsx", sheet("Sheet0") cellrange(A1:BB216) firstrow clear
// (54 vars, 215 obs)

******************
*1. Data Cleaning 
******************

log using "obtained excel data from LadyAgri"

*observations 114, 3, 110, 21, 72 were dropped as they were duplicates
*original survey data variables are uppercase
*variables used in analysis are lowercase

gen id=_n
order id

//Business ID Info
rename a Last_Name 
label var Last_Name "Last name of respondent" 

rename b First_Name
label var First_Name "First name of respondent" 

tab c 
rename c Gender 
label var Gender "Gender of respondent" 
tab Gender

tab d
rename d Country 
label var Country "Country of respondent" 

//Winsorization 
sort Turnover 
replace Turnover=48000 in 203

*************************************************
//independent variables
*Age
tab e 
rename e Age
label var Age "Age of business owner"
encode Age, gen (Age_Category_temp)
gen age_cat=.
label var age_cat "Age of business owner"
replace age_cat=0 if Age_Category_temp==2
replace age_cat=1 if Age_Category_temp==3
replace age_cat=2 if Age_Category_temp==4
replace age_cat=3 if Age_Category_temp==1
drop Age_Category_temp
label define age_cat 0 "18-25 years" 1 "25-40 years" 2 "40-60 years" 3 "60+ years", replace
label values age_cat age_cat
tab age_cat

*Education Status
tab h
encode h, gen (education_status)
label var education "Education status"
tab education

 
*Number of Employees
tab M
rename M Number_Employees
label var Number_Employees "Number of employees"
gen nbr_emp = Number_Employees
recode nbr_emp (1/4=1) (5/19=2) (20/60=3) 
label define nbr_emp 1"1-4" 2 "5-19" 3 "20+", replace
label values nbr_emp nbr_emp
label var nbr_emp "Number of employees"
tab nbr_emp


*Number of Suppliers
tab N
rename N Number_Suppliers
label var Number_Suppliers "Number of suppliers"
gen nbr_sup= Number_Suppliers
recode nbr_sup (1/5=1) (6/10=2) (11/max=3) 
label define nbr_sup 1"1-5" 2 "6-10" 3 "11+", replace
label value nbr_sup nbr_sup
label var nbr_sup "Number of Suppliers"
tab nbr_sup
asdoc tab nbr_sup, replace 


*Turnover of Business
tab aa
rename aa Turnover
label var Turnover "Annual turnover of business"
gen turnover_cat=Turnover
recode turnover_cat(0/9000=1) (10000/50000=2) (50001/80000=3) (80001/max=4)
label define turnover_cat 1 "<10,000" 2 "10,000-50,000" 3 "50,001-80,000" 4 "80,000+", replace  
label var turnover_cat "Turnover (Year) (US$)"
label values turnover_cat turnover_cat 
tab turnover_cat
asdoc tab turnover_cat, replace 


*Sale of Other Crops or Products/ Diversification
tab X
rename X Other_Crops
label var Other_Crops "Sale of other crops or products"
encode Other_Crops, gen(other_crops_temp)
gen other_crops=.
replace other_crops=0 if other_crops_temp==1
replace other_crops=1 if other_crops_temp==2
drop other_crops_temp
label var other_crops "Sale of other crops or products"
label define YesNo 0 "No" 1 "Yes"
label values other_crops YesNo
tab other_crops

*Market Location
tab P
rename P Location
label var Location "Market location"
encode Location, gen (location_temp)
gen location=.
replace location=1 if location_temp==3| location_temp==4| location_temp==5| location_temp==6 
replace location=0 if location_temp==1| location_temp==7| location_temp==2  
drop location_temp
label define location 1"Kinshasa" 0 "Other markets"
label value location location
label var location "In which urban markets are you selling?"
tab location

*Participation in Women's Savings Group
tab j
rename j Womens_Savings_Group
label var Womens_Savings_Group "Participation in women's savings group"
encode Womens_Savings_Group, gen (women_savings_temp)
gen women_savings_group=.
replace women_savings_group=0 if women_savings_temp==1
replace women_savings_group=1 if women_savings_temp==2
label values women_savings_group YesNo
drop women_savings_temp
label var women_savings_group "Participation in women's savings group"
tab women_savings_group

*Main Crop or Product
tab W
rename W Main_Crop
label var Main_Crop "Main crop or product"
encode Main_Crop, gen (main_crop_temp)
gen main_crop=.
codebook Main_Crop
tab Main_Crop


*Percentage of women employees
tab AD
rename AD Women_Employees
label var Women_Employees "Percentage of women employees"
encode Women_Employees, gen (women_employees_temp)
gen women_employees=.
replace women_employees=0 if women_employees_temp==1|women_employees_temp==4
replace women_employees=1 if women_employees_temp==2
replace women_employees=2 if women_employees_temp==3| women_employees_temp==5
drop women_employees_temp
label define women_employees 0 "0-50%" 1 "51-70%" 2 "71-100%", replace
label var women_employees "Percentage of women employees"
label values women_employees women_employees
tab women_employees
asdoc tab women_employees, replace
 

*Percentage of women supervisors
tab AB
rename AB Women_Supervisors
label var Women_Supervisors "Percentage of women supervisors"
encode Women_Supervisors, gen (women_supervisors_temp)
gen women_supervisors=.
replace women_supervisors=0 if women_supervisors_temp==1|women_supervisors_temp==5
replace women_supervisors=1 if women_supervisors_temp==2|women_supervisors_temp==3
replace women_supervisors=2 if women_supervisors_temp==4| women_supervisors_temp==6
drop women_supervisors_temp
label define women_supervisors 0 "0-30%" 1 "31-70%" 2 "71-100%", replace
label var women_supervisors "Percentage of women supervisors"
label values women_supervisors women_supervisors
tab women_supervisors
asdoc tab women_supervisors, replace 

*************************************************
// dependent variables
*Do Women Employees Recieve Contracts?
tab e_1
rename e_1 Contracts_Social
encode Contracts_Social, gen (contracts_social_temp)
label var Contracts_Social "Do women employees have/receive contracts?"
gen contracts_social=.
replace contracts_social=0 if contracts_social_temp==1
replace contracts_social=1 if contracts_social_temp==2
drop contracts_social_temp
label var contracts_social "Do women employees have/receive contracts?"
label values contracts_social YesNo
tab contracts_social

*Do Women Employees Recieve Health Benefits?
tab e_3
rename e_3 Health_Benefits
encode Health_Benefits, gen (health_benefits_temp)
label var Health_Benefits "Do women employees have/receive health benefits (paid maternity leave/ pharmacy coupons/ vaccines/…)?"
gen health_benefits=.
replace health_benefits=0 if health_benefits_temp==1
replace health_benefits=1 if health_benefits_temp==2
drop health_benefits_temp
label var health_benefits "Do women employees have/receive health benefits (paid maternity leave/ pharmacy coupons/ vaccines/…)?"
label values health_benefits YesNo
tab health_benefits

save "/Users/naomiho/Documents/Thesis /Data/Final Data.dta", replace
file /Users/naomiho/Documents/Thesis /Data/Final Data.dta saved

clear 
***********************************************************************
* 2. Data Analysis

cd "/Users/naomiho/Documents/Thesis /Data/
use Final Data.dta, replace 

*descriptive statistics 

outreg2 using myreg.doc, replace sum(log) keep(Number_Employees Number_Suppliers Turnover age_cat other_crops women_savings_group education_status)


*Pearsons correlation matrix

Pearson 
asdoc pwcorr turnover_cat nbr_emp other_crops women_savings_group age_cat education_status, star (.5)

*multicollinearity  

collin turnover_cat nbr_emp women_savings_group age_cat education_status other_crops

asdoc collin turnover_cat nbr_emp women_savings_group age_cat education_status other_crops


//Logistic Analysis

//Contracts 

logistic contracts_social turnover_cat nbr_emp age_cat women_savings_group education_status other_crops,r 

*Table
outreg2 using myreg.doc, replace ctitle(Logit coeff)
outreg2 using myreg.doc, append ctitle(Odds ratio) eform

*output for Appendex 
asdoc logistic contracts_social turnover_cat nbr_emp age_cat women_savings_group education_status other_crops,r  


//Health Benefits 

logistic health_benefits turnover_cat nbr_emp age_cat women_savings_group education_status other_crops,r 

*Table
outreg2 using myreg.doc, replace ctitle(Logit coeff)
outreg2 using myreg.doc, append ctitle(Odds ratio) eform


*output for Appendex 
asdoc logistic health_benefits turnover_cat nbr_emp age_cat women_savings_group education_status other_crops,r 

*Robustness check and model fit 

//Probit 
probit health_benefits turnover_cat nbr_emp age_cat women_savings_group education_status other_crops,r 

//Hosmer and Lemeshow 
asdoc estat gof, group(9) 

asdoc linktest

//Wald test 
quietly: logistic contracts_social turnover_cat nbr_emp age_cat women_savings_group education_status other_crops,r 

asdoc test turnover_cat nbr_emp age_cat women_savings_group education_status other_crops

quietly: logistic health_benefits turnover_cat nbr_emp age_cat women_savings_group education_status other_crops,r 

asdoc test turnover_cat nbr_emp age_cat women_savings_group education_status other_crops

//Receiver Operating Characteristic Curves
asdoclroc
















 



