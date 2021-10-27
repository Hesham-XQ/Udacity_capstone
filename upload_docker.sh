# Tag image
docker tag flask-app:latest heshamxq/flask-app:latest

# Login to docker-hub
docker login --username=heshamxq

# Push image
docker push heshamxq/flask-app:latest