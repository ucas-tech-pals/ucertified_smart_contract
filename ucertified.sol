 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Certificate {

    address[] public issuers;
    mapping(address => bool) public isIssuer;
    struct EducationCertificate 
    {
        string certificationName;
        string issueDate;
        string issuingAuthority;
        string ipfsHash;
        string studentName;
    }
    mapping(address => EducationCertificate) private certificates;

    modifier onlyIssuer() {
        require(isIssuer[msg.sender], "Caller is not an issuer");
        _;
    }
// _______________________________________________________________________________________________

    function addIssuer(address issuer) public 
    {
    issuers.push(issuer);
    isIssuer[issuer] = true;
    }
// _______________________________________________________________________________________________


    function removeIssuer(address issuer) public 
    {
    isIssuer[issuer] = false;
    }
// _______________________________________________________________________________________________

    function issueCertificate(
        address student,
        string calldata studentName,
        string calldata certificationName,
        string calldata issueDate,
        string calldata issuingAuthority,
        string calldata ipfsHash
    )external onlyIssuer {
        certificates[student] = EducationCertificate(
            certificationName,
            issueDate,
            issuingAuthority,
            ipfsHash,
            studentName
        );
    }
    // ) external {
    //     // require(isIssuer[msg.sender], "Caller is not an issuer");
    //     certificates[student] = EducationCertificate(
    //         studentName,
    //         certificationName,
    //         issueDate,
    //         issuingAuthority,
    //         ipfsHash
    //     );
    // }
// _______________________________________________________________________________________________

    function getCertificate(address student) external view returns (EducationCertificate memory) 
    {
        return certificates[student];
    }
// _______________________________________________________________________________________________

    event CertificateIssued(address student, string studentName, string certificationName, string issueDate, string issuingAuthority, string ipfsHash);
// _______________________________________________________________________________________________

    function logCertificate
    (
        address student,
        string memory studentName,
        string memory certificationName,
        string memory issueDate,
        string memory issuingAuthority,
        string memory ipfsHash
    ) public {
        emit CertificateIssued(student, studentName, certificationName, issueDate, issuingAuthority, ipfsHash);
    }
// _______________________________________________________________________________________________

    function verifyCertificate(
    address student,
    string calldata studentName,
    string calldata certificationName,
    string calldata issueDate,
    string calldata issuingAuthority,
    string calldata ipfsHash
    ) external view returns (bool) {
    EducationCertificate memory certificate = certificates[student];


    if ( keccak256(abi.encodePacked(studentName)) == keccak256(abi.encodePacked(certificate.studentName)) &&
         keccak256(abi.encodePacked(certificationName)) == keccak256(abi.encodePacked(certificate.certificationName)) &&
         keccak256(abi.encodePacked(issueDate)) == keccak256(abi.encodePacked(certificate.issueDate)) &&
         keccak256(abi.encodePacked(issuingAuthority)) == keccak256(abi.encodePacked(certificate.issuingAuthority)) &&
         keccak256(abi.encodePacked(ipfsHash)) == keccak256(abi.encodePacked(certificate.ipfsHash))
           ) {
               return true;
           }
    return false;
        }
// _______________________________________________________________________________________________
}
    


