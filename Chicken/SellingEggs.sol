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


    //�Ǹ� �����Է¹ޱ� 
    function SaleEgg(uint _tokenId, uint _price, bool _userAgree) public{
         address eggOwner = Egg.ownerOf(_tokenId);

        //NFT ������ SellingEgg ��Ʈ��Ʈ���� �ŷ� ���� ����
         Egg.setApprovalForAll(address(this), _userAgree);

        //��ū ������ ��Ʈ��Ʈ���� �Ǹű����� �����߳�?
         require(Egg.isApprovedForAll(msg.sender,address(this)),"Agree Error");

        //�Ǹ��ڰ� ������ ������ �³�?
         require(eggOwner == msg.sender,"You are not Owner");

        //������ ����� �ԷµǾ���?
         require(_price > 0, "Price Error");

        //id�� �Է��ϸ� �ø� ���� ����
         tokenPrices[_tokenId]=_price;
         isSelling[_tokenId] = true;
    }

    //�Ǹ� ����� ���
    function CancleSelling(uint _tokenId) public{
        address owner = Egg.ownerOf(_tokenId);
        require(owner == msg.sender);
        require(tokenPrices[_tokenId] > 0);

        tokenPrices[_tokenId]=0;
        isSelling[_tokenId] = false;
    }

    //NFT ���� �Լ�
    function BuyEgg(uint _tokenId, bool _userAgree) public payable{
        address eggOwner = Egg.ownerOf(_tokenId);

        //�����ڰ� ���� ���Ǹ� �ߴ��� Ȯ��
         require(_userAgree == true,"Agree Error");

        //NFT�� �Ǹ������� Ȯ��
         require(isSelling[_tokenId] == true, "NFT IS Not On Sale");

        //�ڱⰡ �ڱⲬ ��ٸ� â������
         require(eggOwner != msg.sender ,"You Can Not Buy Your NFT");

        //������ balance�� Price���� ū�� Ȯ��
         require(tokenPrices[_tokenId]<=msg.value , "You Have Not Enough Ether");

        //�̴��� ����
         payable(eggOwner).transfer(tokenPrices[_tokenId]*unit);

        //NFT ���� ����
         Egg.transferFrom(eggOwner,msg.sender,_tokenId);

        //�Ǹ� ���� ����
         tokenPrices[_tokenId]= 0;
         isSelling[_tokenId] = false;

        //�ŷ� ��. ������ �Ҵ��� �ŷ� ���� ��Ż
         Egg.setApprovalForAll(address(this), !_userAgree);
    }
}