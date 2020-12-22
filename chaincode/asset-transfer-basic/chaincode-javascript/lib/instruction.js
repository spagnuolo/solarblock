
//     1. Bring the network up: ./network.sh up
//     2. Create Channel and Join Peer of Organisation: ./network.sh createChannel
//     3. Deploy Chaincode to Channel: ./network.sh deployCC -ccl javascript 
//     4. Interact with the network   
//          4.1 export PATH=${PWD}/bin:$PATH
//          4.2 export FABRIC_CFG_PATH=$PWD/config/
//          4.3 check peer version : peer version
//     5. Set up Environment variables for Org1:OrgNetzbetreiberMSP oder entsprechend for Org2:OrgKundeMSP
//          5.1 export CORE_PEER_TLS_ENABLED=true
//          5.2 export CORE_PEER_LOCALMSPID="OrgNetzbetreiberMSP"
//          5.3 export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt
//          5.3 export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp
//          5.4 export CORE_PEER_ADDRESS=localhost:7051 
//          5.5 Port 7051 for OrgNetzbetreiberMSP , Port 9051 for OrgKundeMSP
//      6. Create InitLedger with Sample Data
//          6.1 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt -c '{"function":"InitLedger","Args":[]}'
//      7. Get AllAssets: peer chaincode query  peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}' 
//      8. ReadAsset: peer chaincode query  peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","assetID"]}'
//      9. UpdateAsset: peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt -c '{"function":"UpdateAsset","Args":["assetID","owner","electricity"]}'
//      10. CreateAsset:  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt -c '{"function":"CreateAsset","Args":["assetID","owner","electricity"]}'
//      11. DeleteAsset: peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt -c '{"function":"DeleteAsset","Args":["assetID"]}'
//      12. AssetExists: peer chaincode query  peer chaincode query -C mychannel -n basic -c '{"Args":["AssetExists","assetID"]}'
//      13. TransferAsset: peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt -c '{"function":"TransferAsset","Args":["assetID","newOwner"]}'
