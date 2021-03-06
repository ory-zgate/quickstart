action=$1
profile=$2
container=$3

if [ -z "$action" ]
then
  echo "action not set, default to stat"
  action="stat"
fi

if [ -z "$profile" ]
then
  echo "profile not set, default to all"
  profile="all"
fi

compose="-f docker-compose.yml"
case $profile in
  "all")
    compose="-f docker-compose.yml -f docker-compose-ui.yml -f docker-compose-gateway.yml -f docker-compose-permission.yml"
  ;;
  "backend")
    compose="-f docker-compose.yml"
esac

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
  "restart-one")
    docker-compose $compose stop $container && docker-compose $compose start $container
  ;;
  "usage")
    echo "usage: ./run.sh action profile"
    echo "action can be list of [stat, log, start, stop, restart-one]"
    echo "profile can be list of [all, backend]"
  ;;
esac