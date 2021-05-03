# curl -s -X PUT http://127.0.0.1:4455/api/access/relation-tuples -H 'Content-Type: application/json' -H 'Accept: application/json' \
# --data-binary @contrib/permission/init-data/create_identity.json

# curl -s -X PUT http://127.0.0.1:4455/api/access/relation-tuples -H 'Content-Type: application/json' -H 'Accept: application/json' \
# --data-binary @contrib/permission/init-data/filter_identity.json

# curl http://127.0.0.1:4455/api/access/relation-tuples?namespace=identity -H 'Accept: application/json' | jq .

port=8091

id_list=`curl -s -H "Content-Type: application/json" http://127.0.0.1:$port/identity`

for row in $(echo "${id_list}" | jq -c '.[]'); do

    _jq() {
      echo ${row} | jq -r '.id'
    }

    _jq_roleType() {
      echo ${row} | jq -r '.traits.roleType'
    }

    id=$(_jq)
    roleType=$(_jq_roleType)
    # echo "$id $schemaId $roleType"

    if [ $roleType != 'administrator' ]; then
      continue
    fi
    echo "init permission for $id as role $roleType"

    add_create_permission_result=`curl -s -X PUT -H "Content-Type: application/json" http://127.0.0.1:4455/inner/api/access/relation-tuples \
    --data-binary @- << EOT
    {
      "namespace": "identity",
      "object": "/identity",
      "relation": "mock",
      "subject": "administrator"
    }
    EOT`
    echo $add_create_permission_result

    add_create_permission_result=`curl -s -X PUT -H "Content-Type: application/json" http://127.0.0.1:4455/inner/api/access/relation-tuples \
    --data-binary @- << EOT
    {
      "namespace": "identity",
      "object": "/identity/filter",
      "relation": "mock",
      "subject": "administrator"
    }
    EOT`
    echo $add_create_permission_result

    add_create_permission_result=`curl -s -X PUT -H "Content-Type: application/json" http://127.0.0.1:4455/inner/api/access/relation-tuples \
    --data-binary @- << EOT
    {
      "namespace": "access",
      "object": "/access/query",
      "relation": "mock",
      "subject": "administrator"
    }
    EOT`
    echo $add_create_permission_result
done