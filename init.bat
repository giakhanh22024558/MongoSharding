@echo off
echo =====================================
echo 🚀 Starting MongoDB Shard Initialization...
echo =====================================

echo 🟡 Initiating Config Server...
docker exec configsvr mongosh --port 27017 --eval "rs.initiate({_id: 'rs-config', configsvr: true, members: [{ _id: 0, host: 'configsvr:27017' }]})"

echo 🟡 Initiating Shard 1...
docker exec shard1 mongosh --port 27018 --eval "rs.initiate({_id: 'rs-shard-1', members: [{ _id: 0, host: 'shard1:27018' }]})"

echo 🟡 Initiating Shard 2...
docker exec shard2 mongosh --port 27019 --eval "rs.initiate({_id: 'rs-shard-2', members: [{ _id: 0, host: 'shard2:27019' }]})"

echo ⏳ Waiting for initialization...
timeout /t 5 >nul

echo 🟢 Adding Shards to Router (mongos)...
docker exec mongos mongosh --port 27017 --eval "sh.addShard('rs-shard-1/shard1:27018'); sh.addShard('rs-shard-2/shard2:27019'); sh.status();"

echo ✅ MongoDB Sharded Cluster is Ready!
pause
