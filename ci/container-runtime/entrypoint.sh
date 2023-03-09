#!/bin/sh
cd $APP_HOME

cp nginx.conf $APP_SCRATCH_SPACE/nginx.conf
# Optional: Possibility to manipulate configuration files by substitution.
# sed -i -e 's|#HOSTNAME#|'"${HOSTNAME}"'|g' $APP_SCRATCH_SPACE/nginx.conf

cp htpasswd $APP_SCRATCH_SPACE/htpasswd
# Optional: Possibility to manipulate password files by substitution.
# sed -i -e 's|#USER_1#|'"${USER_1}"'|g' $APP_SCRATCH_SPACE/htpasswd
# sed -i -e 's|#PW_1#|'"${PW_1}"'|g' $APP_SCRATCH_SPACE/htpasswd
# sed -i -e 's|#USER_2#|'"${USER_2}"'|g' $APP_SCRATCH_SPACE/htpasswd
# sed -i -e 's|#PW_2#|'"${PW_2}"'|g' $APP_SCRATCH_SPACE/htpasswd

# # When content change, also the conent needs to be copied to the scratch space. nginx.conf needs to updated to point to that new location.
# mkdir -p $APP_SCRATCH_SPACE/target
# cp -r $APP_HOME/target $APP_SCRATCH_SPACE
# # Optional: Possibility to manipulate target files by substitution.
# # sed -i -e 's|#HOSTNAME#|'"${HOSTNAME}"'|g' $APP_SCRATCH_SPACE/target

# Run nginx
echo "Nginx started....."
nginx -c $APP_SCRATCH_SPACE/nginx.conf
