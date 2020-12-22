## Adding OrgHaushaltB to the test network

You can use the `addOrgHaushaltB.sh` script to add another organization to the Fabric test network. The `addOrgHaushaltB.sh` script generates the OrgHaushaltB crypto material, creates an OrgHaushaltB organization definition, and adds OrgHaushaltB to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addOrgHaushaltB.sh` script.

```
./network.sh up createChannel
cd addOrgHaushaltB
./addOrgHaushaltB.sh up
```

If you used `network.sh` to create a channel other than the default `mychannel`, you need pass that name to the `addorgHaushaltB.sh` script.
```
./network.sh up createChannel -c channel1
cd addOrgHaushaltB
./addOrgHaushaltB.sh up -c channel1
```

You can also re-run the `addOrgHaushaltB.sh` script to add OrgHaushaltB to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addOrgHaushaltB
./addOrgHaushaltB.sh up -c channel2
```

For more information, use `./addOrgHaushaltB.sh -h` to see the `addOrgHaushaltB.sh` help text.
