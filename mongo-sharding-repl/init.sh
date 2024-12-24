mongosh --host host.docker.internal --port 27017 <<EOF
rs.initiate(
    {
        _id : "config_server",
        configsvr: true,
        members: [
            { _id : 0, host : "configSrv:27017" }
        ]
    }
)
EOF

mongosh --host host.docker.internal --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard1-1:27118" },
        { _id : 2, host : "shard1-2:27218" }
      ]
    }
);
EOF

mongosh --host host.docker.internal --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2:27019" },
        { _id : 1, host : "shard2-1:27119" },
        { _id : 2, host : "shard2-2:27219" }
      ]
    }
)
EOF

mongosh --host host.docker.internal --port 27020 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");

 sh.enableSharding("somedb");
 sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

 use somedb

 for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
 db.helloDoc.countDocuments()
EOF