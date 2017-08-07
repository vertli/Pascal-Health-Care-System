program SBA;
uses crt;
type
 ACPWType=record  {帳號及密碼}
           ACCT:string[30]; {Account}
		   PSWD:string[30]; {Password}
		   CLSS:string[30]; {帳號類別}
		  end;

 HTtype=record  {健康提示資料}
        topic:string; {主題}
		body:string {內容}
	   end;

 MItype=record   {醫療機構資料}
         name:string; 
		 add:string; 
		 tel:string[8];
		 fax:string[8];
		 email:string;
		 web_add:string
		end;
	
 CFsNolist=record {病歷記錄號碼資料}
            CFsNo:string; 
			name:string;
 		   end;

 CFsPPType=record {病歷記錄個人資料 Personal Profile}
            CFsNo:string; 
			surname:string; {姓}
            givenname:string; {名}
			sex:string[1]; {性別}
			HKID:string[8]; {香港身份証}
			dy:integer; {出生年期}
			dm:integer; {出生月分}
			dd:integer; {出生日期}
		   end;
		   
 CFsCIType=record {病歷記錄個人聯絡資料 Communication Information}
			CFsNo:string;
			hp:string[8]; {固網電話}
		    mp:string[8]; {手機號碼}
			add:string; 
		    add_area:string; 
		   end;
		   
 CFsFIType=record  {病歷記錄家屬資料 Family Information}
		    surname:string; {姓}
            givenname:string; {名}
			sex:string[1]; {性別}
			relationship:string;
			hp:string[8]; {固網電話}
		    mp:string[8]; {手機號碼}
			add:string; 
		    add_area:string; 
		   end;
		   
 CFsSIType=record  {病歷記錄個人疾病資料 Sick Information}
			SIdate:string;
			SickI:string;
			mdi:string; {medicine}
			slp:string[1]; {sick leave paper}
		   end;

const
 MITnum=2;
 HTTnum=13;
 
var
 AC_PW:array of ACPWType;
 HT_file:array[1..HTTnum] of HTtype;
 MI_file:array[1..MITnum] of MItype;
 CFsNL_file:array of CFsNolist;
 CFsPP_file:array of CFsPPType;
 CFsCI_file:array of CFsCIType;
 CFsFI_file:array of CFsFIType;
 CFsSI_file:array of CFsSIType;
 position:integer;
 ch_no:integer;
 chse:integer;
 
procedure login_function(var index:integer); {登入系統}
var
 ACPWfile:text;
 AC_count:integer;
 ACtarget:string;
 PWtarget:string;
 found:boolean;
 ACcount:integer;
 IDnum:integer;
begin
 IDnum:=0;
 AC_count:=0;
 assign(ACPWfile,'ACPW.txt');
 reset(ACPWfile);
 while not eof(ACPWfile) do
  begin
  readln(ACPWfile);
  AC_count:=AC_count+1;
  end;
 AC_count:=AC_count div 3;
 setlength(AC_PW,AC_count); 
 close(ACPWfile);
 assign(ACPWfile,'ACPW.txt');
 reset(ACPWfile);
 while not eof(ACPWfile) do
 begin
  IDnum:=IDnum+1;
  with AC_PW[IDnum] do
  begin
   readln(ACPWfile,ACCT);
   readln(ACPWfile,PSWD);
   readln(ACPWfile,CLSS);
   end
 end;
 close(ACPWfile); 
 write('Account:');
 readln(ACtarget);
 write('Password:');
 readln(PWtarget); 
 found:=false;
 ACcount:=0;
 index:=0;
 repeat
  ACcount:=ACcount+1;
  with AC_PW[ACcount] do
   if ACCT = ACtarget
    then begin
	      index:=ACcount;
	      found:=true
	     end
 until found or (ACcount = IDnum);
 if found=false
  then begin
   writeln('Wrong Account or Password.');
   writeln('Press any key to continue...');
   ch_no:=7;	
   readln();
  end
  else begin
   with AC_PW[index] do  
    if PWtarget = PSWD
	 then begin
	  writeln('Login Successful.');
      writeln('Press any key to continue...');
	  ch_no:=0;
	  readln();				
	 end
	 else begin
	  writeln('Wrong Account or Password.');
      writeln('Press any key to continue...');
      ch_no:=7;	
      readln();
     end;
	end; 
end; {end of login_function}

procedure goto_XY; {gotoXY系統}
var
 i:integer;
begin
 gotoXY(1,1);
 for i:=1 to 50 do
   begin
   writeln(' ');
   end;
   gotoXY(1,1);
end;
 
procedure CFsListDataInput;  {CFs List Data Iuput}
var
 NLfile:text;
 NLnum:integer;
 NLcount:integer;
 begin
  NLcount:=0;
  NLnum:=0;
  assign(NLFile,'CFsNolist.txt');
  reset(NLFile);
  while not eof(NLFile) do
   begin
    readln(NLFile);
    NLcount:=NLcount+1;
   end;
  NLcount:=NLcount div 2;
  setlength(CFsNL_file,NLcount);
  close(NLfile);
  assign(NLFile,'CFsNolist.txt');
  reset(NLFile); 
  while not eof(NLFile) do
   begin
    NLnum:=NLnum+1;
    with CFsNL_file[NLnum] do
     begin
      readln(NLFile,CFsNo);
      readln(NLFile,name);
     end
  end;
  close(NLfile);
  end;
 
procedure CFsDataInput(case_no:string;var FIcount,SIcount:integer);  {CFs Data Iuput}
var
 PPfile:text;
 CIfile:text;
 FIfile:text;
 SIfile:text;
 FItemp:string;
 SItemp:string;
 PPnum:integer;
 CInum:integer;
 FInum:integer;
 SInum:integer;
 PPcount:integer;
 CIcount:integer; 
begin
 PPcount:=0;
 PPnum:=0;
 assign(PPFile,'CFPP.txt');
 reset(PPFile);
 while not eof(PPFile) do
  begin
   readln(PPFile);
   PPcount:=PPcount+1;
  end;
 PPcount:=PPcount div 8;
 setlength(CFsPP_file,PPcount);
 close(PPfile);
 assign(PPFile,'CFPP.txt');
 reset(PPFile); 
 while not eof(PPFile) do
  begin
   PPnum:=PPnum+1;
   with CFsPP_file[PPnum] do
    begin
     readln(PPFile,CFsNo);
     readln(PPFile,surname);
     readln(PPFile,givenname);
	 readln(PPFile,sex);
	 readln(PPFile,HKID);
	 readln(PPFile,dy);
	 readln(PPFile,dm);
	 readln(PPFile,dd);
    end
  end;
  close(PPfile);
  CIcount:=0;
  CInum:=0;
  assign(CIfile,'CFCI.txt');
  reset(CIFile);
  while not eof(CIFile) do
   begin
    readln(CIFile);
    CIcount:=CIcount+1;
   end;
  CIcount:=CIcount div 5;
  setlength(CFsCI_file,CIcount);
  close(CIfile);
  assign(CIFile,'CFCI.txt');
  reset(CIFile); 
  while not eof(CIFile) do
  begin
   CInum:=CInum+1;
   with CFsCI_file[CInum] do
    begin
     readln(CIFile,CFsNo);
     readln(CIFile,hp);
     readln(CIFile,mp);
	 readln(CIFile,add);
	 readln(CIFile,add_area);
    end
  end;
  close(CIFile);
  FIcount:=0;
  FInum:=0;
  FItemp:=case_no+'CFsFI.txt'; 
  assign(FIFile,FItemp);
  reset(FIFile);
  while not eof(FIFile) do
   begin
    readln(FIFile);
    FIcount:=FIcount+1;
   end;
  FIcount:=FIcount div 8;
  setlength(CFsFI_file,FIcount);
  close(FIfile);
  assign(FIFile,FItemp);
  reset(FIFile); 
  while not eof(FIFile) do
  begin
   FInum:=FInum+1;
   with CFsFI_file[FInum] do
    begin
     readln(FIFile,surname);
     readln(FIFile,givenname);
	 readln(FIFile,sex);
     readln(FIFile,relationship);
	 readln(FIFile,hp);
	 readln(FIFile,mp);
	 readln(FIFile,add);
	 readln(FIFile,add_area);
    end
  end;
  close(FIFile);  
  SIcount:=0;
  SInum:=0;
  SItemp:=case_no+'CFsSI.txt';
  assign(SIFile,SItemp);
  reset(SIFile);
  while not eof(SIFile) do
   begin
    readln(SIFile);
    SIcount:=SIcount+1;
   end;
  SIcount:=SIcount div 4;
  setlength(CFsSI_file,SIcount);
  close(SIfile);
  assign(SIFile,SItemp);
  reset(SIFile); 
  while not eof(SIFile) do
  begin
   SInum:=SInum+1;
   with CFsSI_file[SInum] do
    begin
     readln(SIFile,sIdate);
     readln(SIFile,SickI);
	 readln(SIFile,mdi);
	 readln(SIFile,slp);
    end
  end;
  close(SIFile);
end;

procedure CFsPP(num:integer); {CFs Personal Profile}
begin
 goto_XY;
 writeln('------Personal Profile------');
 with CFsPP_file[num] do
  begin
   writeln('Case File no. :',CFsNo);
   writeln('Name :',surname,' ',givenname);
   writeln('Sex: ',sex);
   writeln('HKID :',HKID);
   writeln('Day of birthday :',dd,'/',dm,'/',dy);
   writeln();
   writeln('Press any key to continue...');
   readln();
   goto_XY;
  end;
end;

procedure CFsCI(num:integer); {CFs Communication Information}
begin
 goto_XY;
 writeln('------PCommunication Information------');
 with CFsPP_file[num] do
  begin
   writeln('Case File no. :',CFsNo);
   writeln('Name :',surname,' ',givenname);
  end;
 with CFsCI_file[num] do
  begin
   writeln('Home Phone No. : ',hp);
   writeln('Personal Mobile Phone No. :',mp);
   writeln('Address :',add,' ,',add_area);
   writeln();
   writeln('Press any key to continue...');
   readln();
   goto_XY;
  end;
end;

procedure CFsFI(num,total_no:integer); {CFs Family Information}
var
 FIfile:text;
 i:integer;
begin
 goto_XY;
 writeln('------Family Information------');
 with CFsPP_file[num] do
  begin
   writeln('Case File no. :',CFsNo);
   writeln('Name :',surname,' ',givenname);
   writeln();
  end;
  num:=0;
  for i:=1 to total_no do
   begin
	num:=num+1;
    with CFsFI_file[num] do
     begin
      writeln('Name :',surname,' ',givenname);
      writeln('Sex :',sex);
      writeln('Relationship:',relationship);
      writeln('Home Phone No. : ',hp);
      writeln('Personal Mobile Phone No. :',mp);
      writeln('Address :',add,' ,',add_area);
      writeln();
     end;
  end;
 writeln('Press any key to continue...');
 readln();
 goto_XY;
end;

procedure CFsSI(num,total_no:integer); {CFs Sick Information}
var
 FIfile:text;
 i:integer;
 CFs_No:string;
 nothinguse:integer;
begin
 goto_XY;
 writeln('------Family Information------');
 with CFsPP_file[num] do
  begin
   writeln('Case File no. :',CFsNo);
   writeln('Name :',surname,' ',givenname);
   writeln();
  end;
  str(num,CFs_No);
  CFsDataInput(CFs_No,total_no,nothinguse);
  num:=0;
  for i:=1 to total_no do
   begin
	num:=num+1;
    with CFsFI_file[num] do
     begin
      writeln('Name : ',surname,' ',givenname);
      writeln('Sex : ',sex);
      writeln('Relationship: ',relationship);
      writeln('Home Phone No. : ',hp);
      writeln('Personal Mobile Phone No. : ',mp);
      writeln('Address : ',add,' ,',add_area);
      writeln();
     end;
  end;
 writeln('Press any key to continue...');
 readln();
 goto_XY;
end;

procedure CFsChse; {CFs Choose List}
var
CF_no:integer;
ch_no:integer;
C_no:string;
FI_num:integer;
SI_num:integer;
begin
 goto_XY;
 CF_no:=0;
 CFsListDataInput;
 writeln('------Look at the case file------');
 write('Please enter the Case File no. :');
 readln(CF_no);
 goto_XY;
 str(CF_no,C_no);
 CFsDataInput(C_no,FI_num,SI_num);
 repeat
  with CFsNL_file[CF_no] do 
   begin
    writeln('Case File no. :',CFsNo);
	writeln('Name :',name);
	writeln(' ');
	writeln('1.Personal Profile');
	writeln('2.Communication Information');
	writeln('3.Family Information');
	writeln('4.Sick Information');
	writeln('5.Exit.');
	write('Please choose the function: ');
	readln(ch_no);
	goto_XY;
	case ch_no of
	 1:CFsPP(CF_no);
	 2:CFsCI(CF_no);
	 3:CFsFI(CF_no,FI_num);
	 4:CFsSI(CF_no,SI_num);
	 5:writeln('OK.');
	 else writeln('ERROR!Please enter again.');
	end;
   end;
 until ch_no=5;
 end;

procedure CFs; {CFs Main Program}
var
 CFsnum:real;
 ch_no:integer;
begin  
repeat 
 goto_XY;
 writeln('------Case Files------');
 writeln('1.Look at the case file.');
 writeln('2.Exit');
 write('Please choose the function: ');
 readln(ch_no);
 case ch_no of
  1:CFsChse;
  2:writeln('Okay.');
  else begin
        writeln('ERROR!Please enter again.');
		writeln('Press any key to continue...');
	    readln();
       end;
 end;
 until ch_no=2;
end;   

procedure checkBMI; {BMI計算系統}
var
 height,weight,bmi:real;
begin
 goto_XY;
 writeln('------Check BMI function------');
 write('Enter you height(m):');
 readln(height);
 write('Enter you weight(kg):');
 readln(weight);
 bmi:= weight/(sqr(height));
 writeln('Your BMI is: ',bmi:1:2);
 if BMI<18.5 then
  writeln('Your weight status is underweight!')
  else 
   if (BMI>24.00) and (BMI<28.00) then
    writeln('Your weight status is overweight!')
   else
    if BMI>28.00 then
	 writeln('Your weight status is obese!')
   else 
    writeln('Your weight status is pass!');
 writeln(' ');
 writeln('Press any key to continue...');
 readln();	 
 goto_XY;
 end;
 

procedure HTread(ch_no:integer);  {健康提示系統}
var
 DiskFile:text;
 ch_num:integer;
 exit_no:integer;
 count:integer;
begin 
 goto_XY;
 case ch_no of
  1:assign(DiskFile,'Hair_loss.txt');
  2:assign(DiskFile,'Male_diet.txt');
  3:assign(DiskFile,'Male_sports.txt');
  4:assign(DiskFile,'Mens_Health.txt');
  5:assign(DiskFile,'Womens_Health.txt');
 end;
 reset(DiskFile);
 count:=0;
 while not eof(DiskFile) do
  begin
   count:=count+1;
   with HT_file[count] do
   begin
    readln(DiskFile,topic);
	readln(DiskFile,body);
   end;
  end;
  repeat
   count:=0;
   repeat
    count:=count+1;
     with HT_file[count] do
     begin
      writeln(count,'.',topic);
	 end;
  until count=HTTnum;
  exit_no:=count+1;
  writeln(exit_no,'.Exit.');
  ch_num:=0;
  write('Your choose is: ');
  readln(ch_num);
  goto_XY;
  if ch_num<>exit_no then
  begin
  with HT_file[ch_num] do
   begin
    writeln('Topic: ',topic);
    writeln('Body: ',body);
    writeln(' ');
	writeln('Press any key to continue...');
	readln();	
    goto_XY;	
   end;
  end;
 until ch_num=exit_no;
 goto_XY;
end; {HTread}

procedure HTinput(ch_no:integer);  {健康提示系統}
begin
 goto_XY;
 HTread(ch_no);
 goto_XY;
end;

procedure HTs; {健康提示選擇目錄系統}
var
 HT_ch:integer; 
begin
 goto_XY;
 repeat 
  HT_ch:=0;
  writeln('------Health Tips------');
  writeln('1.Hair Loss'); 		
  writeln('2.Male Diet');
  writeln('3.Male Sports');
  writeln('4.Men''s Health');
  writeln('5.Women''s Health');
  writeln('6.Check BMI'); 
  writeln('7.Exit.');
  write('Your choose is: ');
  readln(HT_ch);
  goto_XY;
  case HT_ch of
    1:HTinput(HT_ch);
    2:HTinput(HT_ch);
    3:HTinput(HT_ch);
    4:HTinput(HT_ch);
    5:HTinput(HT_ch);
	6:checkBMI;
  end;
 until HT_ch=7;
 goto_XY;
end;

procedure MIread(ch_no:integer); {醫療機構系統}
var
 DiskFile:text;
 ch_num:integer;
 exit_no:integer;
 count:integer;
begin
 goto_XY; 
case ch_no of
  1:assign(DiskFile,'PHI.txt');
  2:assign(DiskFile,'PH.txt');
 end;
 reset(DiskFile);
 count:=0;
 while not eof(DiskFile) do
  begin
   count:=count+1;
   with MI_file[count] do
   begin
    readln(DiskFile,name);
	readln(DiskFile,add);
	readln(DiskFile,tel);
	readln(DiskFile,fax);
	readln(DiskFile,email);
	readln(DiskFile,web_add);
   end;
  end;
  repeat
   count:=0;
   repeat
    count:=count+1;
     with MI_file[count] do
     begin
      writeln(count,'.',name);
	 end;
  until count=MITnum;
  exit_no:=count+1;
  writeln(exit_no,'.Exit.');
  ch_num:=0;
  write('Your choose is: ');
  readln(ch_num);
  if ch_num<>exit_no then
  begin
  with MI_file[ch_num] do
   begin
    goto_XY;
    writeln('Name: ',name);
    writeln('Add.: ',add);
	writeln('Tel.: ',tel);
	writeln('Fax.: ',fax);
	writeln('E-Mail: ',email);
	writeln('Web Add.: ',web_add);
	writeln(' ');
	writeln('Press any key to continue...');
	readln();		
   end;
   end;
  goto_XY;
 until ch_num=exit_no;
 goto_XY;
end; {MIread}

procedure MIinput(ch_no:integer); {醫療機構系統}
begin
 goto_XY;
 MIread(ch_no);
 goto_XY;
end;

procedure MIs; {醫療機構系統}
var
 MI_ch:integer;
 begin
  goto_XY;
  repeat 
  MI_ch:=0;
  writeln('------Medical Institutions------');
  writeln('1.Public Hospitals And Institutions');		
  writeln('2.Private Hospitals');
  writeln('3.Exit.');
  write('Your choose is: ');
  readln(MI_ch);
  writeln(' ');
  case MI_ch of
   1:MIinput(MI_ch);
   2:MIinput(MI_ch);
   else if (MI_ch<1) or (MI_ch>3) 
         then writeln('Error!');
  end;
  until MI_ch=3;
  goto_XY;
end;

procedure ch_funtn(index:integer); {主目錄系統}
begin
 goto_XY;
 ch_no:=0;
 with AC_PW[index] do
   if CLSS = 'doctor'
    then begin
		  writeln('------Main List------');
	      writeln('1.Case Files.');
		  writeln('2.Medical Institutions.');
		  writeln('3.Health Tips.');
		  writeln('4.Exit.');
		  write('Please choose the function: ');
		  readln(ch_no);
		  case ch_no of
		   1:CFs;
		   2:MIs;
		   3:HTs;
		   4:ch_no:=10;
		   else writeln('error!');
	      end;
		  goto_XY;
		 end
	else begin
		  writeln('------Main List------');
		  writeln('1.Medical Institutions.');
		  writeln('2.Health Tips.');
		  writeln('3.Exit.');
		  write('Please choose the function: ');
		  readln(ch_no);
		  case ch_no of
		   1:MIs;
		   2:HTs;
		   3:ch_no:=10;
		   else writeln('error!');
		  end;
		  goto_XY;
         end;
end;

begin {main program}
 ch_no:=0;
 repeat
  login_function(position);
  goto_XY;
 until ch_no=0;
  repeat
   goto_XY;
   ch_funtn(position);
  until ch_no=10;
 end. 