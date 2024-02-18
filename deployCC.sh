#!/bin/sh
VERSION="1"

mfdPrdCC(){

    echo '********** installing and building typescript chaincode *************'
    cd ./chaincode/mfc-prdc
    npm install
    npm run build
    cd ../..

    echo "********** Packaging CC for Manufacture-Production-Channel ********************"
    # sudo docker exec -it cli-manufacturer-1 peer lifecycle chaincode package basic.tar.gz --path /opt/gopath/src/github.com/hyperledger/fabric/peer/chaincode/mfc-prdc --lang node --label basic_1.0
    sudo docker exec -it cli-manufacturer-1 peer lifecycle chaincode package pmcc.tar.gz --path /opt/gopath/src/github.com/hyperledger/fabric/peer/chaincode/mfc-prdc --lang node --label basic_${VERSION}

    sleep 6

    # sudo docker exec -it cli-production-1 peer lifecycle chaincode package basic.tar.gz --path /opt/gopath/src/github.com/hyperledger/fabric/peer/chaincode/mfc-prdc --lang node --label basic_1.0
    sudo docker exec -it cli-production-1 peer lifecycle chaincode package pmcc.tar.gz --path /opt/gopath/src/github.com/hyperledger/fabric/peer/chaincode/mfc-prdc --lang node --label basic_${VERSION}

    sleep 6

    echo "********** ChainCode Packaged for Manufacture-Production-Channel ********************"

    echo "********* Installing CC for Manufacture-Production-Channel ************ "
    sudo docker exec -it cli-manufacturer-1 peer lifecycle chaincode install /opt/gopath/src/github.com/hyperledger/fabric/peer/pmcc.tar.gz
    
    sleep 6
    
    sudo docker exec -it cli-production-1 peer lifecycle chaincode install /opt/gopath/src/github.com/hyperledger/fabric/peer/pmcc.tar.gz

    sleep 6
}


ApproveCCMfdPrd(){
    # echo -n "" > log.txt 2>&1
    # echo -n "" > mw.txt 2>&1
    
    # sed -i 'd' log.txt
    # sed -i 'd' mw.txt
    sudo docker exec -it cli-manufacturer-1 peer lifecycle chaincode queryinstalled > log.txt 2>&1
    cat log.txt
    # CC_PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    export CC_PACKAGE_ID=$(cat log.txt | grep "basic" | cut -d " " -f 3 | cut -d "," -f 1)
    #   export CC_PACKAGE_ID
    sudo docker exec -it cli-manufacturer-1 peer lifecycle chaincode approveformyorg -o orderer1.gov.io:7050 --channelID mfd-prd-channel --name pmcc --version ${VERSION} --package-id ${CC_PACKAGE_ID} --sequence ${VERSION} --tls true --cafile "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem"

    sleep 5

    sudo docker exec -it cli-production-1 peer lifecycle chaincode approveformyorg -o orderer1.gov.io:7050 --channelID mfd-prd-channel --name pmcc --version ${VERSION} --package-id ${CC_PACKAGE_ID} --sequence ${VERSION} --tls true --cafile "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem"

    sleep 5
}




CheckCommitMfdPrd(){
    echo "Checking Commit Readiness for Channel mfd-prd-channel"
    sudo docker exec -it cli-manufacturer-1 peer lifecycle chaincode checkcommitreadiness --channelID mfd-prd-channel --name pmcc --version 1 --sequence ${VERSION} --tls true --cafile "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem" --output json
    sleep 8
}




CommitCCMfdPrd(){
    echo "******************** Making commit **********************"
    sudo docker exec -it cli-manufacturer-1 peer lifecycle chaincode commit -o orderer1.gov.io:7050 --channelID mfd-prd-channel --name pmcc --version 1 --sequence ${VERSION} --tls true --cafile "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem" --peerAddresses peertf1.production.com:8051 --tlsRootCertFiles "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/production.com/peers/peertf1.production.com/tls/ca.crt" --peerAddresses peertm1.manufacturer.com:9051 --tlsRootCertFiles "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/ca.crt"

    sleep 8
}



InstantiateCCMfdPrd(){
    echo "Instantiating CC on Production peer-1"
    sudo docker exec -it cli-production-1 peer chaincode instantiate -o orderer1.gov.io:7050 --tls true --cafile "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem" -C mfd-prd-channel -n basic -v 1 -c '{"Args":["init"]}' -P "AND ('tataMSP.peer','teafarmMSP.peer')"

    sleep 8

    echo "Instantiating CC on Manufacture peer-1"
    sudo docker exec -it cli-manufacturer-1 peer chaincode instantiate -o orderer1.gov.io:7050 --tls true --cafile "/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem" -C mfd-prd-channel -n basic -v 1 -c '{"Args":["init"]}' -P "AND ('tataMSP.peer','teafarmMSP.peer')"

    sleep 8
}

mfdPrdCC
ApproveCCMfdPrd
CheckCommitMfdPrd
CommitCCMfdPrd
