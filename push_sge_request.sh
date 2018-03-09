find /mnt/users -maxdepth 1 -mindepth 1 -type d \
| awk '{print "cp -rvf", "/mnt/users/skel/.sge_request" , $1 "/priv" }' \
| egrep -v "skight1|ktindal2|msherid3|jdicke15|skel"
