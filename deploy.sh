export NODE_ENV=production
git reset --hard
git pull origin HEAD
npm install
gulp build
pm2 stop uphall -f
pm2 start ./dist/index.js -n uphall