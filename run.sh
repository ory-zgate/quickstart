action=$1

if [ -z "$action" ]
then
  echo "action not set, default to stat"
  action="stat"
fi

compose="-f docker-compose.yml"

case $action in
  "stat")
    docker-compose $compose ps
  ;;
  "log")
    docker-compose $compose logs -f
  ;;
  "start")
    docker-compose $compose down --remove-orphans && docker-compose $compose up -d --remove-orphans && docker-compose $compose ps
  ;;
  "stop")
    docker-compose $compose down --remove-orphans
  ;;
  "usage")
    echo "usage: ./run.sh action"
  ;;
esac