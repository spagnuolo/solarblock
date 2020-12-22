## Adding OrgHaushaltA to the test network

You can use the `addOrgHaushaltA.sh` script to add another organization to the Fabric test network. The `addOrgHaushaltA.sh` script generates the OrgHaushaltA crypto material, creates an OrgHaushaltA organization definition, and adds OrgHaushaltA to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addOrgHaushaltA.sh` script.

```
./network.sh up createChannel
cd addOrgHaushaltA
./addOrgHaushaltA.sh up
```

If you used `network.sh` to create a channel other than the default `mychannel`, you need pass that name to the `addorgHaushaltA.sh` script.
```
./network.sh up createChannel -c channel1
cd addOrgHaushaltA
./addOrgHaushaltA.sh up -c channel1
```

You can also re-run the `addOrgHaushaltA.sh` script to add OrgHaushaltA to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addOrgHaushaltA
./addOrgHaushaltA.sh up -c channel2
```

For more information, use `./addOrgHaushaltA.sh -h` to see the `addOrgHaushaltA.sh` help text.
