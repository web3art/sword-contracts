// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import { IMetadata } from './Web3SwordMetadata.sol';

// [
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
// [0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
// [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
// [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
// [0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
// [0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
// [0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
// [0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
// [0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
// [0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
// [0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
// [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0]]
contract Web3Sword is
    Initializable,
    ERC1155Upgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIdCounter;

    struct SwordBlock {
        uint256 tokenId;
        address ownerAddress;
        string imgURL;
        uint256 number;
    }

    mapping(uint256 => SwordBlock) public blockById;
    mapping(uint8 => uint256) public latestClaimTokenByType;

    // mint = 1
    // marketing = 2
    // lucky = 3
    // thirdparty = 4
    // airdrop = 5
    // twitter = 6
    uint8 constant private mint = 1;
    uint8 constant private marketing = 2;
    uint8 constant private lucky = 3;
    uint8 constant private thirdparty = 4;
    uint8 constant private airdrop = 5;
    uint8 constant private twitter = 6;

    bool fullyMint;

    uint256 public currentPrice;

    uint8[][] public swordMatrix;

    IMetadata private metadataGenerator;

    event BuySuccess(address indexed buyer, uint256 tokenId, uint256 value);
    event SocialClaimSuccess(address indexed claimer, uint256 tokenId, uint8 t);
    event Withdrawal(address indexed, uint256 value);
    event ResetPrice(uint256 newPrice);

    function initialize(IMetadata _metadataGenertaor) public initializer {
        __ERC1155_init("");
        __Ownable_init();
        __UUPSUpgradeable_init();
        fullyMint = false;
        metadataGenerator = _metadataGenertaor;
        currentPrice = 15 * 10 ** 16;
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
        swordMatrix.push([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
        swordMatrix.push([0, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 1, 1, 1, 1, 0]);
        swordMatrix.push([0, 0, 0, 1, 1, 4, 4, 4, 4, 4, 4, 1, 1, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 6, 6, 1, 1, 6, 6, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 1, 1, 1, 3, 1, 1, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 4, 4, 4, 4, 6, 6, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 4, 4, 4, 4, 6, 6, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 6, 6, 5, 5, 5, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 6, 6, 5, 5, 5, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 4, 4, 5, 5, 5, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 4, 4, 5, 5, 5, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 5, 5, 5, 6, 6, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 5, 5, 6, 6, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 5, 5, 4, 4, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 5, 5, 4, 4, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 6, 6, 4, 4, 4, 4, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 6, 6, 4, 4, 4, 4, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 1, 1, 6, 6, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 1, 1, 6, 6, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 6, 6, 2, 1, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 6, 6, 2, 1, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 1, 4, 4, 1, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 1, 1, 1, 4, 6, 1, 1, 1, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 1, 1, 6, 6, 1, 1, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
        swordMatrix.push([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]);
    }

    function buy(uint256 tokenId) public payable {
        require(msg.value >= currentPrice, "You don't have enough money");
        _mint(_msgSender(), tokenId, mint);
        currentPrice = currentPrice * 2 / 100;
        emit BuySuccess(_msgSender(), tokenId, msg.value);
    }

    // reset current price
    function resetCurrentPrice(uint256 price) public onlyOwner {
        currentPrice = price;
        emit ResetPrice(currentPrice);
    }

    function _getNextSocialTokenId(uint8 t) internal view returns(uint256) {
        uint256 latestTokenId = latestClaimTokenByType[t];
        if (latestTokenId == 0) {
            for (uint256 i = 0; i < swordMatrix.length; i++) {
                uint8[] memory row = swordMatrix[i];
                for (uint256 j = 0; j < row.length; j++) {
                    if (swordMatrix[i][j] == t) {
                        return _computeTokenId(j + 1, i + 1);
                    }
                }
            }
        }

        (uint256 x, uint256 y) = _getXYPointFromTokenId(latestTokenId);
        for (uint256 i = 0; i < swordMatrix.length; i++) {
                uint8[] memory row = swordMatrix[i];
                for (uint256 j = 0; j < row.length; j++) {
                    if (
                        i + 1 > y &&
                        j + 1 > x &&
                        swordMatrix[i][j] == t
                    ) {
                        return _computeTokenId(j + 1, i + 1);
                    }
                }
        }

        return 0;
    }

    // claim
    function socialClaim(address to, uint8 t) public onlyOwner {
        uint256 nextTokenId = _getNextSocialTokenId(t);
        require(nextTokenId != 0, "No more token to claim");
        _mint(to, nextTokenId, t);
        latestClaimTokenByType[t] = nextTokenId;
        emit SocialClaimSuccess(to, 1, t);
    }

    function _checktokenId(uint256 tokenId, uint8 t) internal view returns(bool) {
        (uint256 x, uint256 y) = _getXYPointFromTokenId(tokenId);
        return swordMatrix[y - 1][x - 1] == t;
    }

    function _getXYPointFromTokenId(uint256 tokenId) internal pure returns(uint256, uint256) {
        uint256 y = tokenId % 10000;
        uint256 x = (tokenId - y) / 10000;
        return (
            x,
            y
        );
    }

    function _computeTokenId(uint256 x, uint256 y) internal pure returns(uint256) {
        return x * 10000 + y;
    }

    function _mint(address to, uint256 id, uint8 t) internal {
        require(blockById[id].ownerAddress == address(0), "This block is already owned");
        require(_checktokenId(id, t), "This block is not of this type");
        _tokenIdCounter.increment();
        SwordBlock memory b = SwordBlock(
            id,
            to,
            "",
            _tokenIdCounter.current()
        );
        blockById[id] = b;
        ERC1155Upgradeable._mint(to, id, 1, abi.encodePacked(t));
    }

    // Upload new imguri
    function upload(uint256 tokenId, string memory uri) public {
        SwordBlock memory b = blockById[tokenId];
        require(b.ownerAddress == _msgSender(), "You are not the owner of this block");
        b.imgURL = uri;
        blockById[tokenId] = b;
        string memory metadataURI = generateMetadataURI(tokenId);
        emit URI(metadataURI, tokenId);
    }

    // Extract eth and send events so that everyone can know
    function withdraw(uint256 value) public onlyOwner {
        require(value > 0);
        require(value <= address(this).balance);
        payable(msg.sender).transfer(value);
        emit Withdrawal(msg.sender, value);
    }

    function name(uint256) public view returns (string memory) {
        return metadataGenerator.name();
    }

    function generateMetadataURI(uint256 id) internal view returns (string memory) {
        SwordBlock memory b = blockById[id];
        require(b.tokenId > 0, "This block is not owned");
        return metadataGenerator.tokenMetadata(b.tokenId, b.number, b.imgURL);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {
        
    }
}
