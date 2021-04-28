# init variables

username=testuser
displayName=TestUser01
password=123456
adminname=admin
port=8091


# create user

create_user_result=`curl -s -X POST -H "Content-Type: application/json" http://127.0.0.1:$port/identity \
--data-binary @- << EOT
{
  "schemaId": "default",
  "traits": {
    "username": "$username",
    "displayName": "$displayName"
  }
}
EOT`

user_id=`jq -r '.id' <<< $create_user_result`

if [ -z "$user_id" ]
then
  echo "create failed, please retry later"
  exit 1
fi

# set password

set_password_result=`curl -s -X PUT -H "Content-Type: application/json" http://127.0.0.1:$port/identity/$user_id/password \
--data-binary @- << EOT
{
  "password": "$password"
}
EOT`

# create administrator

create_admin_result=`curl -s -X POST -H "Content-Type: application/json" http://127.0.0.1:$port/identity \
--data-binary @- << EOT
{
  "schemaId": "administrator",
  "traits": {
    "username": "$adminname",
    "displayName": "$adminname"
  }
}
EOT`

admin_id=`jq -r '.id' <<< $create_admin_result`
set_password_result=`curl -s -X PUT -H "Content-Type: application/json" http://127.0.0.1:$port/identity/$admin_id/password \
--data-binary @- << EOT
{
  "password": "$password"
}
EOT`

echo "create user successfully, you can login as $username $password"
echo "create admin successfully, you can login as $adminname $password"