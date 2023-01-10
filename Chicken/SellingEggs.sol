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


    //판매 정보입력받기 
    function SaleEgg(uint _tokenId, uint _price) public {
        address owner = Token.ownerOf(_tokenId);

        //판매자가 코인의 주인이 맞나?
         require(owner == msg.sender);

        //가격이 제대로 입력되었나?
         require(_price > 0);

        //토큰 주인이 컨트랙트에게 판매권한을 위임했나?
         require(Token.isApprovedForAll(msg.sender,address(this)));

        //id를 입력하면 올린 가격 매핑
        tokenPrices[_tokenId]=_price;
    }

    //판매 취소할 경우
    function CancleSelling(uint _tokenId) public{
        address owner = Token.ownerOf(_tokenId);
        require(owner == msg.sender);
        require(tokenPrices[_tokenId] > 0);

        tokenPrices[_tokenId]=0;
    }

    //NFT 구매 함수
    function BuyEgg(uint _tokenId) public payable{
        address owner = Token.ownerOf(_tokenId);

        //자기가 자기껄 산다면 창조손해
        require(owner != msg.sender);
    
        //판매가격을 올렸을 경우 판매중이라고 판단
        require(tokenPrices[_tokenId] > 0);

        //지갑의 balance가 Price보다 큰지 확인
        require(tokenPrices[_tokenId]<=msg.value);

        //이더를 전송
        payable(owner).transfer(msg.value);

        //NFT 주인 변경
        Token.transferFrom(owner,msg.sender,_tokenId);

        //판매 가격 삭제
        tokenPrices[_tokenId]=0;
    }
}

rmfjs TLtm 