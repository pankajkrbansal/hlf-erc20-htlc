createcertificatesForOrg1() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/production.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/production.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:2052 --caname ca.production.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2052-ca-production-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2052-ca-production-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2052-ca-production-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2052-ca-production-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/production.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.production.com --id.name peertf1 --id.secret peertf1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.production.com --id.name peertf2 --id.secret peertf2pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.production.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.production.com --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/production.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer tf1
  mkdir -p ../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com

  echo
  echo "## Generate the peertf1 msp"
  echo
  fabric-ca-client enroll -u https://peertf1:peertf1pw@localhost:2052 --caname ca.production.com -M ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/msp --csr.hosts peertf1.production.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/production.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/msp/config.yaml

  echo
  echo "## Generate the peertf1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peertf1:peertf1pw@localhost:2052 --caname ca.production.com -M ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls --enrollment.profile tls --csr.hosts peertf1.production.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/tlsca/tlsca.production.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/msp/tlscacerts/tlsca.production.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf1.production.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/ca/ca.production.com-cert.pem

  # --------------------------------------------------------------------------------------------------
  # Peer tf2
  echo
  echo "## Generate the peertf2 msp"
  echo
  fabric-ca-client enroll -u https://peertf2:peertf2pw@localhost:2052 --caname ca.production.com -M ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/msp --csr.hosts peertf2.production.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/production.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/msp/config.yaml

  echo
  echo "## Generate the peertf2-tls certificates"
  echo
  fabric-ca-client enroll -u https://peertf2:peertf2pw@localhost:2052 --caname ca.production.com -M ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls --enrollment.profile tls --csr.hosts peertf2.production.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/server.key

  # mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/msp/tlscacerts/ca.crt

  # mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/tlsca/tlsca.production.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/msp/tlscacerts/tlsca.production.com-cert.pem

  # mkdir ${PWD}/../crypto-config/peerOrganizations/production.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/production.com/peers/peertf2.production.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/production.com/ca/ca.production.com-cert.pem
  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/production.com/users
  mkdir -p ../crypto-config/peerOrganizations/production.com/users/User1@production.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:2052 --caname ca.production.com -M ${PWD}/../crypto-config/peerOrganizations/production.com/users/User1@production.com/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/production.com/users/Admin@production.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:2052 --caname ca.production.com -M ${PWD}/../crypto-config/peerOrganizations/production.com/users/Admin@production.com/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/production.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/production.com/users/Admin@production.com/msp/config.yaml

  mv ${PWD}/../crypto-config/peerOrganizations/production.com/users/Admin@production.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/production.com/users/Admin@production.com/msp/keystore/priv_sk
}

# createcertificatesForOrg1

createCertificatesForOrg2() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/manufacturer.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/manufacturer.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:2051 --caname ca.manufacturer.com --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2051-ca-manufacturer-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2051-ca-manufacturer-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2051-ca-manufacturer-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2051-ca-manufacturer-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/config.yaml

  echo
  echo "Register peertm1"
  echo
   
  fabric-ca-client register --caname ca.manufacturer.com --id.name peertm1 --id.secret peertm1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem

  echo
  echo "Register peertm2"
  echo
   
  fabric-ca-client register --caname ca.manufacturer.com --id.name peertm2 --id.secret peertm2pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.manufacturer.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.manufacturer.com --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/peers
  mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com

  # --------------------------------------------------------------
  # Peer tm1
  echo
  echo "## Generate the peertm1 msp"
  echo
   
  fabric-ca-client enroll -u https://peertm1:peertm1pw@localhost:2051 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/msp --csr.hosts peertm1.manufacturer.com --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/msp/config.yaml

  echo
  echo "## Generate the peertm1-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peertm1:peertm1pw@localhost:2051 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls --enrollment.profile tls --csr.hosts peertm1.manufacturer.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/tlsca/tlsca.manufacturer.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/msp/tlscacerts/tlsca.manufacturer.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm1.manufacturer.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/ca/ca.manufacturer.com-cert.pem

  # --------------------------------------------------------------------------------
  # Peer tm2
  echo
  echo "## Generate the peertm2 msp"
  echo
   
  fabric-ca-client enroll -u https://peertm2:peertm2pw@localhost:2051 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/msp --csr.hosts peertm2.manufacturer.com --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/msp/config.yaml

  echo
  echo "## Generate the peertm2-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peertm2:peertm2pw@localhost:2051 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls --enrollment.profile tls --csr.hosts peertm2.manufacturer.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/server.key

  # mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts/ca.crt

  # mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/tlsca/tlsca.manufacturer.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/msp/tlscacerts/tlsca.manufacturer.com-cert.pem

  # mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peertm2.manufacturer.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/ca/ca.manufacturer.com-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users
  mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users/User1@manufacturer.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:2051 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/User1@manufacturer.com/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:2051 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp/config.yaml

  mv ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp/keystore/priv_sk
}

# createCertificateForOrg2



createCertificatesForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/gov.io

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/gov.io

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:2050 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2050-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2050-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2050-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2050-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer2"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer3"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  mkdir -p ../crypto-config/ordererOrganizations/gov.io/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/gov.io/orderers/gov.io

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:2050 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp --csr.hosts orderer1.gov.io --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:2050 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls --enrollment.profile tls --csr.hosts orderer1.gov.io --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer1.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:2050 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/msp --csr.hosts orderer2.gov.io --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:2050 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls --enrollment.profile tls --csr.hosts orderer2.gov.io --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer2.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:2050 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/msp --csr.hosts orderer3.gov.io --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:2050 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls --enrollment.profile tls --csr.hosts orderer3.gov.io --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/orderers/orderer3.gov.io/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/tlscacerts/tlsca.gov.io-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/gov.io/users
  mkdir -p ../crypto-config/ordererOrganizations/gov.io/users/Admin@gov.io

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:2050 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/gov.io/users/Admin@gov.io/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/gov.io/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/gov.io/users/Admin@gov.io/msp/config.yaml

}


sudo rm -r fabric-ca
sudo docker-compose -f docker-compose.yaml up -d
sleep 6
sudo rm -r ../crypto-config/*
createcertificatesForOrg1
createCertificatesForOrg2
createCertificatesForOrderer