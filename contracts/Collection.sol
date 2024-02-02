// Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Collection is ERC721URIStorage, Ownable {

    uint256 private _tokenIds = 0;
    uint256 private _totalMinted = 0;
    mapping(address => uint8) private mintedAddress;
    mapping(string => uint8) private URIMapping;
    uint256 public PRICE_PER_TOKEN = 0.01 ether;
    uint256 public LIMIT_PER_ADDRESS = 2;
    uint256 public MAX_SUPPLY  = 5;
    
    constructor() ERC721("Collection", "NFT") Ownable(msg.sender) {}

    function setPrice(uint256 price) external onlyOwner{
        PRICE_PER_TOKEN = price;
    }

    function setLimit(uint256 limit) external onlyOwner{
        LIMIT_PER_ADDRESS = limit;
    }

    function setMaxSupply(uint256 max_supply) external onlyOwner{
        MAX_SUPPLY = max_supply;
    }

    function mintNFT(string memory tokenURI)
        payable
        external
        returns (uint256)
    {
        require(PRICE_PER_TOKEN <= msg.value, "Ether paid is incorrect");
        require(mintedAddress[msg.sender] < LIMIT_PER_ADDRESS, "You have exceeded minting limit");
        require(_totalMinted + 1 <= MAX_SUPPLY, "You have exceeded Max Supply");
        require(URIMapping[tokenURI] == 0, "This NFT has already been minted");
        URIMapping[tokenURI] += 1;
        mintedAddress[msg.sender] += 1;

        uint256 newItemId = _tokenIds;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds++;
        _totalMinted++;
        return newItemId;
    }

    function withdrawMoney() external onlyOwner{
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
    }
}
