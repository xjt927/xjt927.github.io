git add -A
git commit -m "updated %date:~0,10% %time%"
git push orgin hexo
hexo clean && hexo g && hexo d
pause