# init variables

username=testuser
password=123456


# create user

create_user_result=`curl -s -X POST -H "Content-Type: application/json" http://127.0.0.1:8091/identity \
--data-binary @- << EOT
{
  "schema_id": "default",
  "traits": {
    "username": "$username"
  }
}
EOT`

user_id=`jq -r '.id' <<< $create_user_result`

# set password

set_password_result=`curl -s -X PUT -H "Content-Type: application/json" http://127.0.0.1:8091/identity/$user_id/password \
--data-binary @- << EOT
{
  "password": "$password"
}
EOT`

echo "create user successfully, you can login as $username $password"