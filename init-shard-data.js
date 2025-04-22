use demo

sh.enableSharding("demo")
db.users.createIndex({ user_id: 1 })
sh.shardCollection("demo.users", { user_id: 1 })

let bulk = []
for (let i = 0; i < 200000; i++) {
  bulk.push({ user_id: i, name: "User " + i })
  if (bulk.length === 1000) {
    db.users.insertMany(bulk)
    bulk = []
  }
}
if (bulk.length > 0) db.users.insertMany(bulk)

sh.startBalancer()
