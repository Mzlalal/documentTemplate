echo off
set second=60
echo 您想多少分钟后进行关机？请输入...
set /p delayMinute=请输入时长(分钟):
set /a finalTime=%delayMinute%*%second%
echo 你输入的时间为(%finalTime%)
shutdown -s -t %finalTime%
echo 请按任意键关闭
pause