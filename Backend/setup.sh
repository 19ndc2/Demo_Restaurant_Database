
echo "Running setup.sh"

#create docker environment
docker run --name restaurant-mysql \
  -e MYSQL_ROOT_PASSWORD=database1840 \
  -e MYSQL_DATABASE=restaurantDB \
  -p 3307:3306 \
  -d mysql:8 #install mysql to docker

# Wait for MySQL to initialize
echo "Waiting 10 seconds for MySQL to start..."
sleep 10

# Step 3: Import SQL script
docker exec -i restaurant-mysql mysql -u root -pdatabase1840 restaurantDB < restaurant.sql

# Verify that the database loaded correctly (non-interactive)
echo "Verifying database..."
docker exec restaurant-mysql mysql -u root -pdatabase1840 -e "SHOW DATABASES; USE restaurantDB; SHOW TABLES;"
