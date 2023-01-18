// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract newChicken is ERC721Enumerable, Ownable{
  string public metadataURI;
  
  constructor(string memory _name, string memory _symbol, string memory _metadataURI)ERC721(_name,_symbol){ 
    metadataURI = _metadataURI;
  }

  function layEgg(uint _eggId) public payable{
    payable(Ownable.owner()).transfer(msg.value);
    _mint(msg.sender,_eggId);
  }
}
