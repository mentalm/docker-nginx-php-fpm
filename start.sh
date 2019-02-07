
#!/bin/bash
#set -eo pipefail

for i in 7.3
 do
        C=nginx-php$i-fpm
        I=nginx-php-fpm:$i

        docker build -t $I -f Dockerfile.php$i .
        docker run --rm -d -p 80:80 --name $C $I
        docker ps
        sleep 4
        docker logs $C
        docker exec $C pgrep nginx
        docker exec $C pgrep php-fpm
        IP=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $C`
        #curl -s --connect-timeout 2 http://$IP/index.php | grep -q "phpinfo()"
        curl -v --connect-timeout 2 http://$IP/index.php | grep "phpinfo()"
done
