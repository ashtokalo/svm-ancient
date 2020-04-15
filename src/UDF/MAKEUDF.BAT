@echo off
if exist %1.asm goto Run
 @echo usage: MakeUDF.BAT sourcename  [drivername]
 @echo        sourcename - source in assembler code 
 @echo        drivername - name of creating driver
 @echo WARNING! Use filename of source driver without extension.
 goto EndBAT
:Run
 cls
 @echo Assembling file ...
 tasm %1.asm /m2
 if errorlevel == 1 goto EndBAT
 @echo Linking file ...
 tlink %1.obj /x
 exe2udf %1.exe %2
 erase %1.obj
 erase %1.exe
 echo Ok
:EndBAT
