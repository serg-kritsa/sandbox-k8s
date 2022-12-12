# # V0 - mongo-express FAILS
# docker run --name some-mongo -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example -p 27017:27017 mongo
# docker run --name some-mongo-express -e ME_CONFIG_MONGODB_SERVER=localhost -e ME_CONFIG_MONGODB_ADMINUSERNAME=root -e ME_CONFIG_MONGODB_ADMINPASSWORD=example -p 8081:8081 mongo-express # mongo-express:0.54

# # V1 - mongo-express FAILS
# docker run -d --name some-mongo -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example -p 27017:27017 mongo
# sleep 5 # starting mongodb server
# docker run --name some-mongo-express -e ME_CONFIG_MONGODB_SERVER=localhost -e ME_CONFIG_MONGODB_ADMINUSERNAME=root -e ME_CONFIG_MONGODB_ADMINPASSWORD=example -p 8081:8081 mongo-express # mongo-express:0.54

# # V2 - inside network FAILS
# docker network create app-net
# docker run -d --network app-net --name app-mongo -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example -p 27017:27017 mongo
# docker run --network app-net --name app-mongo-express -e ME_CONFIG_MONGODB_SERVER=app-mongo -e ME_CONFIG_MONGODB_ADMINUSERNAME=root -e ME_CONFIG_MONGODB_ADMINPASSWORD=example -p 8081:8081 mongo-express # mongo-express:0.54
# curl localhost:8081
# # docker network rm app-net   # created net is needed to remove 

# # V3 - inside network w/ not specified port FAILED
# docker network create app-net
# docker run -d --network app-net --name app-mongo -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example mongo
# sleep 5 # waiting mongodb server
# docker run -d --network app-net --name app-mongo-express -e ME_CONFIG_MONGODB_SERVER=app-mongo -e ME_CONFIG_MONGODB_ADMINUSERNAME=root -e ME_CONFIG_MONGODB_ADMINPASSWORD=example mongo-express # mongo-express:0.54
# curl localhost:8081
# docker stop app-mongo-express
# docker stop app-mongo
# docker network rm app-net   # created net is needed to remove 
# docker rm app-mongo-express
# docker rm app-mongo

# V4 - inside network OK
docker network create app-net
docker run -d --network app-net --name app-mongo -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example -p 27017:27017 mongo
sleep 5 # waiting mongodb server
docker run -d --network app-net --name app-mongo-express -e ME_CONFIG_MONGODB_SERVER=app-mongo -e ME_CONFIG_MONGODB_ADMINUSERNAME=root -e ME_CONFIG_MONGODB_ADMINPASSWORD=example -p 8081:8081 mongo-express # mongo-express:0.54
curl localhost:8081
docker stop app-mongo-express
docker stop app-mongo
docker network rm app-net   # created net is needed to remove 
docker rm app-mongo-express
docker rm app-mongo