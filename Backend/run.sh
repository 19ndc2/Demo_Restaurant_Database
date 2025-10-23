echo "starting Restaurant Database project..."

if [ "$(docker ps -q -f name=restaurant-mysql)" ]; then
  echo " MySQL container is already running." 
elif [ "$(docker ps -aq -f status=exited -f name=restaurant-mysql)" ]; then
  echo " Restarting existing MySQL container..."
  docker start restaurant-mysql
else
  echo " No container found. Running setup..."
  ./setup.sh
fi

echo "Waiting 5 seconds for MySQL to be ready..."
sleep 5

echo "Starting Flask backend..."
source venv/bin/activate  
python app.py