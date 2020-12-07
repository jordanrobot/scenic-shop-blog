echo off

SET /p user="Enter User Name:"
SET host=scenic-shop.com
SET publicDest=~/public_html/blog/

hugo

SET publicSource=public/
if not exist %publicSource% goto :end

rsync -azvu --delete %publicSource% %user%@%host%:%publicDest% --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r

:end
echo on