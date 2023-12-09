// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Upload{
    struct Access{
        address user;
        bool access;
    }

    // Mapping to store an array of URLs for each user
    mapping(address => string[]) value;

    // Mapping to track ownership status between two addresses
    mapping(address => mapping(address => bool)) ownership;

    // Mapping to store access control list for each user
    mapping(address => Access[]) accessList;

    // Mapping to track previous data status. previousData == false  
    mapping(address => mapping(address => bool)) previousData;   
  

    function add(address _user, string calldata url) external{
        value[_user].push(url);
    }

    function whiteList(address user) external {
        ownership[msg.sender][user] = true;       
        if(previousData[msg.sender][user] == true){
            for(uint i = 0; i < accessList[msg.sender].length; i++){
                if(accessList[msg.sender][i].user == user){
                    accessList[msg.sender][i].access = true;
                }
            }
        }
        else {
            accessList[msg.sender].push(Access(user,true));
            previousData[msg.sender][user] = true;
        }
    }

    function blackList(address user) external {
        ownership[msg.sender][user] = false;
        for(uint i = 0; i < accessList[msg.sender].length; i++){
            if(accessList[msg.sender][i].user == user){
                accessList[msg.sender][i].access = false;
            }
        }
    }
    
    function display(address _user) external view returns (string[] memory){
        require(_user == msg.sender || ownership[_user][msg.sender], "No premission");
        return value[_user];
    }

    function shareAccess() public view returns(Access[] memory){
        return accessList[msg.sender];
    }

}
// contractaddr = 0x5fbdb2315678afecb367f032d93f642f64180aa3
