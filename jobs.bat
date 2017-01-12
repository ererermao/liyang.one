@echo off

echo running sync hexo

d:

cd \hexo\

(hexo clean && hexo g && gulp && hexo d && echo %date:~0,4%%date:~5,2%%date:~8,2% %time%) >> logs\%date:~0,4%%date:~5,2%%date:~8,2%.txt

::( hexo clean && hexo g && gulp && hexo d && echo ok ) || echo error

exit