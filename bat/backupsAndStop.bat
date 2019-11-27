@echo off
rem 时间设置 确定复制目录路径
set nowdate=%date:~0,4%-%date:~5,2%-%date:~8,2%
rem 参数端口,参数tomcat路径
rem ${projectName}项目名
rem tomcatport例如  ${tomcatRemotePort} 8080
set tomcatport=${tomcatRemotePort}
rem tomcathome例如 ${tomcatRemoteDirectory} G:\test\apache-tomcat-8.0.28
set tomcathome=${tomcatRemoteDirectory}
rem 参数方式获取端口 参数方式获取tomcat部署路径
set tomcatportparam=%1%
set tomcathomeparam=%2%
if not "%tomcatportparam%" equ "" (set tomcatport=%tomcatportparam%)
if not "%tomcathomeparam%" equ "" (set tomcathome=%tomcathomeparam%)

call:closetomect %tomcatport%
rem call:backupfile %tomcathome%
rem call:backupfolder %tomcathome%
call:deletefile %tomcathome%
call:deletefolder %tomcathome%
goto:eof

rem 关闭tomcat
:closetomect
	echo "current Tomcat Handle port:%1"
	netstat -aon|findStr "%1">pid.tmp
	set /p msg=<pid.tmp
	del /q pid.tmp
	set pid=%msg:~-5%
	if "%msg%"=="" (echo "port : %1 tomcat not run") else (taskkill /f /pid %pid%)
goto:eof
rem 备份文件war包
rem 复制文件夹只复制本项目的文件 例如 G:\test\apache-tomcat-8.0.28\webapps\pp.war
rem 复制文件只复制本项目的文件
:backupfile
	set needcopyfilepath=%1\webapps\${projectName}.war
	set backdir=%1\back\%nowdate%
	set backfilepath=%1\back\%nowdate%\${projectName}
	echo Start copying file: %needcopyfilepath% to %backfilepath%
	IF NOT EXIST "%backfilepath%" MD "%backfilepath%"
	rem 如果存在此文件
	if exist "%needcopyfilepath%" (
	    rem	复制文件
        COPY %needcopyfilepath% %backfilepath%
	) else (
		echo %needcopyfilepath% file does not exist!
	)
goto:eof
rem 备份文件夹
rem 复制文件夹只复制本项目的文件夹 例如 G:\test\apache-tomcat-8.0.28\webapps\pp
rem 需要备份的文件路径
:backupfolder
	set needcopyfolder=%1\webapps\${projectName}
	rem 备份的文件路径
	set backfolder=%1\back\%nowdate%\${projectName}\${projectName}
	rem 如果存在此文件夹
	echo Start copying folder: %needcopyfolder% to %backfolder%
	if exist "%needcopyfolder%" (
        xcopy /s /e /i /y %needcopyfolder% %backfolder%
	) else (
		echo %needcopyfolder% folder does not exist!
	)
goto:eof
rem 删除文件夹
rem 删除文件只删除本项目的文件
:deletefile
	set needdeletefilepath=%1\webapps\${projectName}.war
    echo Start delete file: %needdeletefilepath%
	if exist "%needdeletefilepath%" (
	    del %needdeletefilepath%
	) else (
		echo %needdeletefilepath% file does not exist!
	)
goto:eof	
rem 删除文件夹
rem 删除文件夹只删除本项目的文件夹
:deletefolder
	 set needdeletefolder=%1\webapps\${projectName}
	 echo Start delete folder: %needdeletefolder%
	 if exist "%needdeletefolder%" (
	    rem	删除文件夹
		rmdir /s/q %needdeletefolder%
	) else (
		echo %needdeletefolder% folder does not exist!
	)
goto:eof	
