// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./Chicken.sol";

contract SellingEgg{
     uint unit = 1 ether;
     newChicken public Egg;
     constructor(address _contractAddress){
       Egg = newChicken(_contractAddress);
     }
    //tokenId=>price
     mapping (uint => uint) public tokenPrices;
    //tokenId=>bool
     mapping (uint => bool) public isSelling;


    //판매 정보입력받기 
    function SaleEgg(uint _tokenId, uint _price, bool _userAgree) public{
         address eggOwner = Egg.ownerOf(_tokenId);

        //NFT 주인이 SellingEgg 컨트랙트에게 거래 권한 위임
         Egg.setApprovalForAll(address(this), _userAgree);

        //토큰 주인이 컨트랙트에게 판매권한을 위임했나?
         require(Egg.isApprovedForAll(msg.sender,address(this)),"Agree Error");

        //판매자가 코인의 주인이 맞나?
         require(eggOwner == msg.sender,"You are not Owner");

        //가격이 제대로 입력되었나?
         require(_price > 0, "Price Error");

        //id를 입력하면 올린 가격 매핑
         tokenPrices[_tokenId]=_price;
         isSelling[_tokenId] = true;
    }

    //판매 취소할 경우
    function CancleSelling(uint _tokenId) public{
        address owner = Egg.ownerOf(_tokenId);
        require(owner == msg.sender);
        require(tokenPrices[_tokenId] > 0);

        tokenPrices[_tokenId]=0;
        isSelling[_tokenId] = false;
    }

    //NFT 구매 함수
    function BuyEgg(uint _tokenId, bool _userAgree) public payable{
        address eggOwner = Egg.ownerOf(_tokenId);

        //구매자가 구매 동의를 했는지 확인
         require(_userAgree == true,"Agree Error");

        //NFT가 판매중인지 확인
         require(isSelling[_tokenId] == true, "NFT IS Not On Sale");

        //자기가 자기껄 산다면 창조손해
         require(eggOwner != msg.sender ,"You Can Not Buy Your NFT");

        //지갑의 balance가 Price보다 큰지 확인
         require(tokenPrices[_tokenId]<=msg.value , "You Have Not Enough Ether");

        //이더를 전송
         payable(eggOwner).transfer(tokenPrices[_tokenId]*unit);

        //NFT 주인 변경
         Egg.transferFrom(eggOwner,msg.sender,_tokenId);

        //판매 가격 삭제
         tokenPrices[_tokenId]= 0;
         isSelling[_tokenId] = false;

        //거래 끝. 유저가 할당한 거래 권한 박탈
         Egg.setApprovalForAll(address(this), !_userAgree);
    }
}