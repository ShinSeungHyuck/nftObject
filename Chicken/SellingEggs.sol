// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Chicken.sol";

contract SellingEgg{
    newNFT public Token;

    constructor(address _tokenAddress){
        Token = newNFT(_tokenAddress);
    }

    //tokenId=>price
    mapping (uint => uint) public tokenPrices;


    //�Ǹ� �����Է¹ޱ� 
    function SaleEgg(uint _tokenId, uint _price) public {
        address owner = Token.ownerOf(_tokenId);

        //�Ǹ��ڰ� ������ ������ �³�?
         require(owner == msg.sender);

        //������ ����� �ԷµǾ���?
         require(_price > 0);

        //��ū ������ ��Ʈ��Ʈ���� �Ǹű����� �����߳�?
         require(Token.isApprovedForAll(msg.sender,address(this)));

        //id�� �Է��ϸ� �ø� ���� ����
        tokenPrices[_tokenId]=_price;
    }

    //�Ǹ� ����� ���
    function CancleSelling(uint _tokenId) public{
        address owner = Token.ownerOf(_tokenId);
        require(owner == msg.sender);
        require(tokenPrices[_tokenId] > 0);

        tokenPrices[_tokenId]=0;
    }

    //NFT ���� �Լ�
    function BuyEgg(uint _tokenId) public payable{
        address owner = Token.ownerOf(_tokenId);

        //�ڱⰡ �ڱⲬ ��ٸ� â������
        require(owner != msg.sender);
    
        //�ǸŰ����� �÷��� ��� �Ǹ����̶�� �Ǵ�
        require(tokenPrices[_tokenId] > 0);

        //������ balance�� Price���� ū�� Ȯ��
        require(tokenPrices[_tokenId]<=msg.value);

        //�̴��� ����
        payable(owner).transfer(msg.value);

        //NFT ���� ����
        Token.transferFrom(owner,msg.sender,_tokenId);

        //�Ǹ� ���� ����
        tokenPrices[_tokenId]=0;
    }
}

rmfjs TLtm 