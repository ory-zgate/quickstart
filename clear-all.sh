port=8091

id_list=`curl -s -H "Content-Type: application/json" http://127.0.0.1:$port/identity`

for row in $(echo "${id_list}" | jq -c '.[]'); do
    _jq() {
      echo ${row} | jq -r '.id'
    }

   id=$(_jq '.id')
   echo "delete $id"
   `curl -s -X DELETE http://127.0.0.1:$port/identity/$id`
done
