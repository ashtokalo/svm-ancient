 ;---------------------------------------------------------------------------
 ;                The command file for ShAG Installer v1.0
 ;                     Copyright (c) 2000 ShAG Studio
 ;---------------------------------------------------------------------------
 ;    This  command file use ShAG Installer script lenguage to make installer
 ; for  SVM  version  1.0.  If you want to more info about ShAG Installer and
 ; this     script    you   mast   visit   ShAG   home   page   by   address:
 ; http://www.shag.itgo.com.  When  you  load  this  page  you  mast  jump to
 ; ~Programs~  item  and  find on it anchor to ShAG Installer someone version
 ; and load archiv of it. After that you mast install it on you hard disk and
 ; read  help  file and ShAG Installer Script Book. In this document you find
 ; all information about ShAG Installer.
 ;---------------------------------------------------------------------------
 ; P.S. Send me letter if you find some mistakas in this installer.
 ; E-mail: shag@qnx.com
 ; Home page: http://www.shag.itgo.com
 ; Author: Shtokalo Alexey Gennadievich
 ;---------------------------------------------------------------------------
 
 ; Creat variables
 NewVar(Persent);
 NewVar(DiskName);
 NewVar(TempStr);
 NewVar(DiskSize);
 NewVar(Dest);
 NewVar(TempINIFile);
 NewVar(TempFile);

 ; Set counter for files, that we edit, copy or execute during installation
 SetPersent(71);

 ; Show logotype of SVM
 ClearImage();
 AddStringToImage(旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커);
 AddStringToImage(� 栢栢栢栢    栢      栢   栢        栢 TM    );
 AddStringToImage(�栢      栢   栢      栢   栢�      栢�       );
 AddStringToImage(�栢  같같같같 栢같    栢 같栢栢�   栢栢 같 같 );
 AddStringToImage(�栢 같      같栢같    栢 같栢 栢� 栢 栢같�    );
 AddStringToImage(� 栢栢栢栢     栢�   栢  같栢 겡栢�  栢같�    );
 AddStringToImage(�   같   栢    栢�   栢  같栢 같栢�  栢 같    );
 AddStringToImage(�    같같栢같   栢� 栢  같 栢 같  같겡� 같    );
 AddStringToImage(�栢      栢 같   栢栢   같 栢 같   같栢 같    );
 AddStringToImage(� 栢栢栢栢  같    栢�  같  栢 같     栢 같    );
 AddStringToImage(�   같      같      같같      같        같    );
 AddStringToImage(�    같같같같        같       같        같    );
 AddStringToImage(읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸);
 ShowImage(0,1,45,10);

 ; Show copyright for this program
 ClearImage();
 AddStringToImage(旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�);
 AddStringToImage(�      SVM Development Kit       );
 AddStringToImage(�          Version 1.0           );
 AddStringToImage(�Copyright (c) 2000  ShAG Studio );
 AddStringToImage(읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�);
 ShowImage(47,1,80,3);

 ;Main program

 GetComputerType(tempstr);
 if (tempstr, <, 1);
 then 
  ShowMessage(60,꽞� �젩�瞬 �昔｀젹� �� 將�． 캙ぅ�� 궇� �拾�� ぎН溢收� �� �Ĳ� Intel80x286,~�~音��);
  Exit(꽞� �젩�瞬 �昔｀젹� �� 將�． 캙ぅ�� 궇� �拾�� ぎН溢收� �� �Ĳ� Intel80x286);
 endthen

 ShowText(2,16,74,Left,룼М雩, 앪� �昔｀젹쵟 信�젺�˘� � 췅飡昔ⓥ ㄻ� 궇� SVM ´褻Ŀ 1.0. 끷エ 귣 若殊收 信�젺�˘筍 SVM, 獸 췅━ⓥ� ~ENTER~ Þ좂� 췅━ⓥ� ~ESC~. 끷エ 귣 쭬若殊收 �誓舒졻� 信�젺�˚� 췅━ⓥ� ~ESC~.);
 WaitKey(13);

 ShowText(2,16,74,Left,룼М雩, 꽞� 信�젺�˚� 귣 ㄾウ�� 丞젳졻� ㄸ稅 췅 ぎ獸贍� �� 貰〃�젰收刷 飡젪ⓥ� SVM. 룼 僧�ョ젺⑧ - 將� ㄸ稅 췅 ぎ獸昔� 췅若ㄸ恂� 將�� ㄸ飡黍▲殊�. �� ��);
 Let(DiskName,MainDisk);
 Let(TempStr,~ESC~ 롟�젪ⓥ� ㄸ稅 ~);
 Concat(TempStr,DiskName);
 Concat(TempStr,~ �� 僧�ョ젺⑧.);
 WriteToStatusLine(TempStr);
 ; Get disk char
 GetString(8,9,1,볚�젺�˚�,� 將�� 飡昔ぅ 귣 ㄾウ�� ⇔α殊 ▲あ� ㄸ稅� ㄻ� 信�젺�˚�:,DiskName);
 UpString(DiskName);
 ; and test it. if disk char lowly that C disk
 if string(DiskName,<,C);
 then
  ; than show warning
  ShowMessage(60,궘º젺��!,룧ぅ� М┃� 信�젺젪エ쥯筍 獸レぎ 췅 ┘飡え� ㄸ稅.,~�~硫殊);
  ; and finish installation
  Exit(롨Æ첓 �黍 信�젺�˚�: 캙ぅ� М┃� 信�젺젪エ쥯筍 獸レぎ 췅 ┘飡え� ㄸ稅, � �濡�젺 〓� ㄸ稅�¡�.);
 endthen

 ; Get disk size
 GetDiskSize(DiskName,DiskSize);
 ; and test it. if available size lowly that 1000000
 if(DiskSize, <, 1000000);
 then
  ; then show warning and
  Let(TempStr,뜝 ㄸ稅��);
  Concat(TempStr,DiskName);
  Concat(TempStr,�㏇ⅲ��);
  Concat(TempStr,DiskSize);
  Concat(TempStr,�聲�‘ㄽ音 줎⒱. � ㄻ� 信�젺�˚� ���▼�ㄸМ �� Д�ⅴ 1 Д짛줎⒱�.);
  WriteToStatusLine(볚�젺�˚� �ⅱ�㎚�┃�, 췅━ⓥ� ~ENTER~ ㄻ� �音�쩆 �� 信�젺�˚�.);
  ShowMessage(60,궘º젺��!,TempStr,~�~硫殊);
  ; finish installation
  Exit(롨Æ첓 �黍 信�젺�˚�: 췅 �濡�젺��� ㄸ稅� �ⅳ�飡졻�嶺� Д飡�.);
 endthen

 ShowText(2,16,74,Left,룼М雩, 뮙��閃, αエ 귣 췅━β� ~ENTER~ 췅嶺β碎 �昔璵遜 信�젺�˚� SVM ´褻Ŀ 1.0. 끷エ 귣 ��誓ㅳ쵟エ, 獸 췅━ⓥ� ~ESC~ ㄻ� �音�쩆. �� ��);
 WriteToStatusLine(~ESC~ 귣若�   ~ENTER~ 뤲�ㄾウⓥ� 信�젺�˚�);
 WaitKey(13);

 ; Redraw screen
 DrawFon();
 ShowImage(47,1,80,3);
 ClearImage();
 AddStringToImage(旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커);
 AddStringToImage(� 栢栢栢栢    栢      栢   栢        栢 TM    );
 AddStringToImage(�栢      栢   栢      栢   栢�      栢�       );
 AddStringToImage(�栢  같같같같 栢같    栢 같栢栢�   栢栢 같 같 );
 AddStringToImage(�栢 같      같栢같    栢 같栢 栢� 栢 栢같�    );
 AddStringToImage(� 栢栢栢栢     栢�   栢  같栢 겡栢�  栢같�    );
 AddStringToImage(�   같   栢    栢�   栢  같栢 같栢�  栢 같    );
 AddStringToImage(�    같같栢같   栢� 栢  같 栢 같  같겡� 같    );
 AddStringToImage(�栢      栢 같   栢栢   같 栢 같   같栢 같    );
 AddStringToImage(� 栢栢栢栢  같    栢�  같  栢 같     栢 같    );
 AddStringToImage(�   같      같      같같      같        같    );
 AddStringToImage(�    같같같같        같       같        같    );
 AddStringToImage(읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸);
 ShowImage(0,1,45,10);

 WriteToStatusLine(~ESC~ 뤲�舒졻� 信�젺�˚�);

 ClearImage();
 AddStringToImage(�                                                                             );
 AddStringToImage(�                                                                             );
 ShowImage(1,21,78,22);

 ; creat all directories and subdirectories
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 ▲ㅳ� 貰ℓ젺�� ㏇� 첓�젷�（, ぎ獸贍� ���▼�ㄸщ ㄻ� �젩�瞬 SVM.);
 MakeDir(DiskName,:\SVM);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MakeDir(DiskName,:\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MakeDir(DiskName,:\SVM\DOCS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MakeDir(DiskName,:\SVM\FONTS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MakeDir(DiskName,:\SVM\EXAMPLES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MakeDir(DiskName,:\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MakeDir(DiskName,:\SVM\MAPS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract all document file
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶좐恂� ㄾゃД�瞬. � �º �狩�碎筍碎 �젵ル 貰ㄵ逝좈�� Þ兒席졿⑧ �� ㏇�� �昔｀젹쵟� �� 將�． 캙ぅ��, � �젶┘ 晨ⅰ�Ø �� SVM 졹醒Аゥ說.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰� ㄾゃД��졿⑧ �� ぎНŒ汀�說...      �);
 Exec(sfp.exe,/ep,space,svmac_d.sfp, space, DiskName, :\SVM\DOCS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� ㄾゃД��졿⑧ �� �漱젮葉ゃ...        �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,svmd_d.sfp, space, DiskName, :\SVM\DOCS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� 晨ⅰ�Ø �� 졹醒Аゥ說...            �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,svmasm_d.sfp, space, DiskName, :\SVM\DOCS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� ㄾゃД��졿⑧ �� ㅰ젵´說 щ鼇...    �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,skmouse_d.sfp, space, DiskName, :\SVM\DOCS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� ㄾゃД��졿⑧ �� 젺殊˘說說�с 룑... �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,vcheck_d.sfp, space, DiskName, :\SVM\DOCS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract all fonts. All fonts - is CHR font what's why you may use it in
 ; your programm if you have functions and procedures for use it.
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶좐恂� 說遜え� 歲飡�Л瑜 ´も�惜瑜 歪ⓧ瞬. 귗� ��� �手η좐 飡젺쩆設� CHR, ��將�с Мｃ� 〓筍 ⓤ��レ㎜쥯��� � ㄻ� ㅰ膝ⓨ 璵ゥ�.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰� Arial Cyrillic...                   �);
 Exec(sfp.exe,/ep,space,arial.sfp, space, DiskName, :\SVM\FONTS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� Courier New Cyrillic...             �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,courier.sfp, space, DiskName, :\SVM\FONTS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� BIOS Cyrillic...                    �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,bios.sfp, space, DiskName, :\SVM\FONTS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� Triplex Cyrillic...                 �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,triplex.sfp, space, DiskName, :\SVM\FONTS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰� Times New Roman Cyrillic...         �);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space,times.sfp, space, DiskName, :\SVM\FONTS);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract all libraries. Libraries the files that contains assembler
 ; procedures and functions and you may use it when you wrote you program
 ; by assemler for SVM v1.0
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶좐恂� 飡젺쩆循�瑜 〃∥Ŧ收え. 끷エ 귣 ▲ㄵ收 ⓤ��レ㎜쥯筍 將� 〃∥Ŧ收え - 귣 ��ャ葉收 М邀硫 � 蝨�∼硫 Þ飡說Д�� ㄾ飡承� ぎ ㏇�� 誓率褻젹 SVM.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 � ｀졽Ø��...  �);
 Exec(sfp.exe,/ep,space, graph.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 � か젪쯄栒昔�...);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, keyboard.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 � 쵟收쵟殊ぎ�...);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, math.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 � ��獸첓Ж...  �);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, stream.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 � �젵쳽Ж...    );
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, files.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 貰 飡昔첓Ж... �);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, strings.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 � 收席Þ젷��... );
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, terminal.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 貰 №�Д���... �);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, time.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� 〃∥Ŧ收첓 ㄻ� �젩�瞬 � щ夭�...     �);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, mouse.sfp, space, DiskName, :\SVM\INCLUDES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; Main files! Extract sample programs for SVM assembler.
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶좐恂� �黍Д贍 췅 筌紐� 졹醒Аゥ誓. 묂ⅳ� �黍Д昔� 귣 췅ħβ� �黍Д� �젩�瞬 � ｀졽Ø�� � �昔｀젹с, ぎ獸說� �②呻 �젹�� ��舒�� �黍 �㎯曄�Ŀ ヮ‘． 筌紐�.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� �黍Д� �젩�瞬 � ｀졽Ø��...                                 �);
 Exec(sfp.exe,/ep,space, gr_demo.sfp, space, DiskName, :\SVM\EXAMPLES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� �昔｀젹쵟 ぎ獸�좑 �猶�ㄸ� 췅 咨�젺 飡昔ゃ ~"Hello world!"~...);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, hello.sfp, space, DiskName, :\SVM\EXAMPLES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 WriteString(3,22,맆召젶��猶젰恂� М� 兒獸｀졽⑨, ���▼�ㄸ쵟� ㄻ� �黍Д�� �젩�瞬 � ｀졽Ø��...�);
 MoveCursor(1,23);
 Exec(sfp.exe, /ep, space, shag_fto.sfp, space, DiskName, :\SVM\EXAMPLES);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract compiller and it ini file
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶젰恂� ぎНŒ汀�� � ⅲ� ぎ�十ｃ�졿Ŧ��硫 �젵�. 닱Д�程 췅飡昔ø� � ぎ�十ｃ�졿Ŧ���� �젵ゥ, 귣 М┘收 ㄾ〃筍碎 循ⅰ濕М� 궇� �젩�瞬.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� ぎНŒ汀�� 졹醒Аゥ��...                                    �);
 Exec(sfp.exe,/ep,space, svmac.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� ぎ�十ｃ�졿Ŧ��硫 �젵� ぎНŒ汀���...                        �);
 Exec(sfp.exe,/ep,space, svmac_i.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract loader and it ini file
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶젰恂� 姿乘汀�� � ⅲ� ぎ�十ｃ�졿Ŧ��硫 �젵�. 닱Д�程 췅飡昔ø� � ぎ�十ｃ�졿Ŧ���� �젵ゥ, 귣 М┘收 ㄾ〃筍碎 �� 姿乘汀��� 循ⅰ濕М� 궇� �젩�瞬.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� 姿乘汀�� SVM...                                    �);
 Exec(sfp.exe,/ep,space, svml.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� ぎ�十ｃ�졿Ŧ��硫 �젵� 姿乘汀���...                 �);
 Exec(sfp.exe,/ep,space, svml_i.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract debugger and it ini file
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶젰恂� �漱젮葉� � ⅲ� ぎ�十ｃ�졿Ŧ��硫 �젵�. 닱Д�程 췅飡昔ø� � ぎ�十ｃ�졿Ŧ���� �젵ゥ, 귣 М┘收 ㄾ〃筍碎 �� �漱젮葉첓 循ⅰ濕М� 궇� �젩�瞬.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� �漱젮葉� SVM...                                    �);
 Exec(sfp.exe,/ep,space, svmd.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� ぎ�十ｃ�졿Ŧ��硫 �젵� �漱젮葉첓...                 �);
 Exec(sfp.exe,/ep,space, svmd_i.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract IDE and it ini file
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶젰恂� IDE - Þ收｀ⓣ�쥯�췅� 蓀ⅳ� �젳�젩�洙� �昔｀젹� � ρ Þ兒席졿Ŧ�췅� 歲飡�쵟. 댾��レ㎯� ρ 귣 ��ャ葉收 ㏇� 蝨�■手� Þ收雪ⅸ�� Turbo Vision.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� Þ收｀ⓣ�쥯�췅� 蓀ⅳ� �젳�젩�洙�...                �);
 Exec(sfp.exe,/ep,space, svmasm.sfp, space, DiskName, :\SVM\BIN);
 MoveCursor(1,23);
 Exec(sfp.exe,/ep,space, svmasm_m.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� ぎ�十ｃ�졿Ŧ��硫 �젵� IDE...                       �);
 Exec(sfp.exe,/ep,space, svmasm_i.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 댾��レ㎯� ㏇循����莘 Þ兒席졿Ŧ��莘 歲飡�с, 귣 ��ャ葉收 ㄾ飡承 ぎ ㏇ⅸ �拾��� Þ兒席졿Ŀ, � Þ收�젶殊˛硫 晨ⅰ�Ø �� 졹醒Аゥ說, ��㎖�エ� 궇� �㎯�졻� 筌紐, �� ��え쩆� IDE.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� Þ兒席졿Ŧ�췅� 歲飡�쵟...                          �);
 Exec(sfp.exe,/ep,space, svmasm_h.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract mouse driver. More information about this driver you find
 ; in skmouse.doc
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶젰恂� ㅰ젵´� щ鼇. 댾��レ㎯� 將�� ㅰ젵´�, 귣 細�┘收 ⓤ��レ㎜쥯筍 щ夭, 쩆┘ �黍 ρ �恂呻飡˘�. 앪� ㄾ飡ª젰恂� �呻�� ⓤ��レ㎜쥯�⑨ か젪쯄栒贍.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� ㅰ젵´� щ鼇...                                    �);
 Exec(sfp.exe,/ep,space, skmouse.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract virus checker. More information about this program you find
 ; in vcheck.doc
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 �졹캙ぎ�猶젰恂� �昔｀젹쵟, ぎ獸�좑 ��М┘� 궇� � ‘閃‥ � ˘說�젹�. � ��М雩� 將�� �昔｀젹щ 〓쳽 信�젺�˙�췅 젺殊˘說說좑 쭬蟯�� 췅 ㏇� ⓤ��キ畑щ� �젵ル 將�． 캙ぅ��.);
 MoveCursor(1,23);
 WriteString(3,22,맆召젶��猶젰恂� 젺殊˘說說�� 룑...                                 �);
 Exec(sfp.exe,/ep,space, vcheck.sfp, space, DiskName, :\SVM\BIN);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; correct all ini files for new information as disk, path, fonts, etc.
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 췅飡�젴쥯荻碎 ぎ�十ｃ�졿Ŧ��瑜 �젵ル ㏇ε 信�젺�˙���音 �昔｀젹�. 닱Д�禎恂� 첓�젷�（, ㄸ稅� � ㅰ膝좑 Þ兒席與� � 將ⓨ �젵쳽�. 앪�� �昔璵遜 М┘� 쭬舜�呻藺�.);
 ShowImage(1,21,78,22);

 Let(TempFile,DiskName);
 Concat(TempFile,:\SVM\BIN);

 WriteString(3,22,뜝飡�젴´� ぎ�十ｃ�졿Ŧ��硫 �젵� ぎНŒ汀���...                             �);
 Let(TempINIFile,TempFile);
 Concat(TempINIFile,\svmac.ini);
 PutItem(TempINIFile,OPTIONS,RESULT_DIR,DiskName,:\SVM\BIN);
 PutItem(TempINIFile,OPTIONS,MAP_DIR,DiskName,:\SVM\MAPS);
 PutItem(TempINIFile,OPTIONS,INCLUDES_DIR,DiskName,:\SVM\INCLUDES);
 PutItem(TempINIFile,OPTIONS,SWAP_DISK,DiskName);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 WriteString(3,22,뜝飡�젴´� ぎ�十ｃ�졿Ŧ��硫 �젵� Þ收｀�쥯���� 蓀ⅳ� �젳�젩�洙�...          �);
 Let(TempINIFile,TempFile);
 Concat(TempINIFile,\svmasm.ini);
 PutItem(TempINIFile,DIRECTORIES,RESULT_DIR,DiskName,:\SVM\BIN);
 PutItem(TempINIFile,DIRECTORIES,SVML_DIR,DiskName,:\SVM\BIN);
 PutItem(TempINIFile,DIRECTORIES,SVMD_DIR,DiskName,:\SVM\BIN);
 PutItem(TempINIFile,DIRECTORIES,SVMAC_DIR,DiskName,:\SVM\BIN);
 PutItem(TempINIFile,DIRECTORIES,SWAP_DISK,DiskName);
 PutItem(TempINIFile,DIRECTORIES,MAP_DIR,DiskName,:\SVM\MAPS);
 PutItem(TempINIFile,DIRECTORIES,INCLUDE_DIR,DiskName,:\SVM\INCLUDES);
 PutItem(TempINIFile,COMPILE,PRIMARY_FILE,*.ASM);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 WriteString(3,22,뜝飡�젴´� ぎ�十ｃ�졿Ŧ��硫 �젵� 姿乘汀���...                               �);
 Let(TempINIFile,TempFile);
 Concat(TempINIFile,\svml.ini);
 PutItem(TempINIFile,OPTIONS,SWAP_DISK,DiskName);
 PutItem(TempINIFile,OPTIONS,TOTAL_FONTS,5);
 PutItem(TempINIFile,FONTS,Arial Cyrillic,DiskName,:\SVM\FONTS\arial.chr);
 PutItem(TempINIFile,FONTS,Courier Cyrillic,DiskName,:\SVM\FONTS\courier.chr);
 PutItem(TempINIFile,FONTS,BIOS Cyrillic,DiskName,:\SVM\FONTS\bios.chr);
 PutItem(TempINIFile,FONTS,Triplex Cyrillic,DiskName,:\SVM\FONTS\triplex.chr);
 PutItem(TempINIFile,FONTS,Times New Roman Cyrillic,DiskName,:\SVM\FONTS\times.chr);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 WriteString(3,22,뜝飡�젴´� ぎ�十ｃ�졿Ŧ��硫 �젵� �漱젮葉첓...                               �);
 Let(TempINIFile,TempFile);
 Concat(TempINIFile,\svmd.ini);
 PutItem(TempINIFile,OPTIONS,SWAP_DISK,DiskName);
 PutItem(TempINIFile,OPTIONS,TOTAL_FONTS,5);
 PutItem(TempINIFile,FONTS,Arial Cyrillic,DiskName,:\SVM\FONTS\arial.chr);
 PutItem(TempINIFile,FONTS,Courier Cyrillic,DiskName,:\SVM\FONTS\courier.chr);
 PutItem(TempINIFile,FONTS,BIOS Cyrillic,DiskName,:\SVM\FONTS\bios.chr);
 PutItem(TempINIFile,FONTS,Triplex Cyrillic,DiskName,:\SVM\FONTS\triplex.chr);
 PutItem(TempINIFile,FONTS,Times New Roman Cyrillic,DiskName,:\SVM\FONTS\times.chr);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; copy archiver, text viewer and readme.txt to directories with SVM
 ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 ぎ�ⓣ莘恂� ㄾ��キⓥ�レ�瑜 �젵ル. � �º �狩�碎恂�: �昔細�循蟯� 收め獸�音 �젵ギ�, 졷夜쥯獸�, 收め獸�硫 �젵�, ぎ獸贍� 귣 ㄾウ�� 〓エ �昔葉�졻� ��誓� 信�젺�˚��, � 誓（飡�젵Ŧ�췅� 첓設�囹�.);
 Let(Dest,DiskName);
 Concat(Dest,:\SVM\readme.txt);
 WriteString(3,22,뒶�ⓣ濕� 收め獸�硫 �젵� ~README.TXT~...                                �);
 CopyFile(SourcePath\readme.txt,Dest);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 Let(Dest,DiskName);
 Concat(Dest,:\SVM\BIN\sfp.exe);
 WriteString(3,22,뒶�ⓣ濕� 졷夜쥯獸�...                                                  �);
 CopyFile(SourcePath\sfp.exe,Dest);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);
 Let(Dest,DiskName);
 Concat(Dest,:\SVM\BIN\tfr.exe);
 WriteString(3,22,뒶�ⓣ濕� �昔細�循蟯� 收め獸�音 �젵ギ�...                               �);
 CopyFile(SourcePath\tfr.exe,Dest);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 ; extract registration card
 WriteString(3,22,맆召젶��猶젰� 誓（飡�졿Ŧ��莘 첓設�囹�...                              �);
 Exec(sfp.exe,/ep,space, rcard.sfp, space, DiskName, :\SVM);
 GetPersent(Persent);
 WriteString(2,17,귣��キ����   �% �� �↓ⅲ� ぎエ曄飡쥯 �젩�瞬.);
 WriteString(12,17,Persent);

 Qestion(맓（飡�졿⑨, 뒶＄� 귣 쭬��キⓥ� 誓（飡�졿Ŧ��莘 첓設�囹�?, ~�~ⅸ�졹, ~�~�獸�);
 then
  ; if user want we fill registration card after installation, but
  ; before user left installer
  Let(TempINIFile,DiskName);
  Concat(TempINIFile,:\SVM\rcard.ini);
  ShowText(48,8,29,Left,댂飡젷ワ與� 췅�젷졹�, 뫁⑴졹 ▲ㅳ� ��琠ワ筍碎 ¡�昔頌. 귣 ㄾウ�� 췅 �ⓨ �手βⓥ�. 롡´瞬 ▲ㅳ� 貰魚젺��� � �젵� rcard.ini. 앪�� �젵� 귣 ㄾウ�� �琇�젪ⓥ� �� 젮誓率 ~shag@qnx.com~ Œ� ��醒殊收 飡�젺①ゃ ~http://www.shag.itgo.com~.);  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� �젹Œ⑧ º� � �洵α手� 曄誓� �昔‥�:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD01,TempStr);
  Let(TempStr, );
  GetString(8,9,2,맓（飡�졿⑨,궋ⅳⓥ� 쥯� ¡㏅졹�:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD02,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� 쥯嵬 췅與�췅レ��飡�:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD03,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� 쥯� 젮誓� (М┃� 獸レぎ 誓（��):,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD04,TempStr);
  Let(TempStr, );
  GetString(8,9,20,맓（飡�졿⑨,궋ⅳⓥ� 쥯� 收ゥ兒� (‥� �젳ㄵエ收ゥ�):,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD05,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� 젮誓� 쥯蜈� �ゥも昔���� ��譽�:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD06,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� 젮誓� 쥯蜈� ㄾ쵟鈺ⅸ 飡�젺①え:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD07,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� 췅㎖젺�� 쥯蜈� �昔狎αĿ:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD08,TempStr);
  Let(TempStr, );
  GetString(8,9,2,맓（飡�졿⑨,궋ⅳⓥ� ぎエ曄飡¡ ゥ� ぎ獸昔� 귣 쭬�º젰收刷 �昔｀젹Ж昔쥯����:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD09,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� 筌紐� �昔｀젹Ж昔쥯�⑨ ぎ獸贍� 귣 ⓤ��レ㎯β�:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD10,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� ぎ�十ｃ�졿⑧ 궇蜈． ぎН溢收��:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD11,TempStr);
  Let(TempStr, );
  GetString(8,9,255,맓（飡�졿⑨,궋ⅳⓥ� 췅㎖젺�� ⓤ獸嶺Ø� �洙蝨� � 궇� ��캙� 將�� 캙ぅ�:,TempStr);
  PutItem(TempINIFile,REGISTRATION_CARD,FILD12,TempStr);
  ShowMessage(60,맓（飡�졿⑨,렞昔▲⒱� 將�� 캙ぅ�, � ��笹� 將�． � �勝も ~FILD13~ �� �젵쳽 ~rcard.ini~ ¿②ⓥ� 궇蜈 Л���� �狩�歲收レ�� SVM � 將�． 캙ぅ��.,~�~�昔溫);
 endthen
 else
  ; else we show message
  ShowMessage(60,맓（飡�졿⑨, 룼쬊ャ⒰�� 쭬��キⓥ� 誓（飡�졿Ŧ��莘 첓設�囹� (~rcard.ini~). 렚� �� ¡㎙젫젰� 췅 궇� �� 첓ゃ� �手β飡´���飡� � ▲ㄵ� ⓤ��レ㎜쥯췅 獸レぎ ㄻ� 飡졻ⓤ殊え.,~�~�昔溫);
 endelse

 Qestion(맓（飡�졿⑨, 빇殊收 �昔葉�졻� ~readme.txt~ (將�� �젵� 貰ㄵ逝ⓥ Þ兒席졿⑧ � 信�젺�˚� � � ρ 誓㎯レ�졻졾)?, ~�~�, ~�~β);
 then
  ; if user want we view readme.txt
  SaveScreen();
  Exec(tfr.exe,readme.txt);
  RestoreScreen();
 endthen

 ShowMessage(60,볚�젺�˚�, 룼ℓ�젪ワ� 귣 信�젺�˘エ 醒‥ SVM ´褻Ŀ 1.0 ‥� �昔∥��!,~O~K);

 ; free memory from all variables that we use during this program
 FreeVar(Persent);
 FreeVar(DiskName);
 FreeVar(TempStr);
 FreeVar(DiskSize);
 FreeVar(Dest);

 ;---------------------------------------------------------------------------
 ;                The command file for ShAG Installer v1.0
 ;                     Copyright (c) 2000 ShAG Studio
 ;---------------------------------------------------------------------------