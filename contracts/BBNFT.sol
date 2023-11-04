// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BBNFT is ERC721, Ownable {
    uint256 public mintPrice; // mint 价格
    uint256 public totalSupply; // 已 mint 数量
    uint256 public maxSupply; // 总数
    uint256 public maxPerWallet; // 还是每个钱包可 mint 的数量
    bool public isPublicMintEnabled; // 是否启动了 public mint
    string internal baseTokenUri; // 图片 uri，可供 opensea 使用
    address payable public withdrawWallet; // 提款方式，用一个特定的钱包来收款
    mapping(address => uint256) public walletMints;

    constructor() payable ERC721("BBNFT", "BB") {
        mintPrice = 0.01 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }

    function setIsPublicMintEnabled(
        bool isPublicMintEnabTed_
    ) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabTed_;
    }

    function setBaseTokenUri(
        string calldata baseTolkenUri_
    ) external onlyOwner {
        baseTokenUri = baseTolkenUri_;
    }

    function tokenURI(
        uint256 tokenId_
    ) public view override returns (string memory) {
        require(_exists(tokenId_), "Token does not exist!");
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(tokenId_),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{value: address(this).balance}(
            ""
        );
        require(success, "withdraw failed");
    }

    // quantity_ 用户 mint 的数量
    function mint(uint256 quantity_) public payable {
        // 验证已经开售
        require(isPublicMintEnabled, "minting not enabled");
        // 验证金额正确
        require(msg.value == quantity_ * mintPrice, "wrong mint value");
        // 验证剩余可 mint 数正确
        require(totalSupply + quantity_ <= maxSupply, "soldout");
        // 验证单钱包最大可 mint 数的正确
        require(
            walletMints[msg.sender] + quantity_ <= maxPeerWallet,
            "exceed max wallet"
        );

        for (uint256i = 0; i < quantity_; i++) {
            uint256 newTokenid = totalSupply + 1;
            // 先增加数量后mint，减少重入攻击，宁可减少可 mint 数量，也不要过多的 mint
            totalSupply++;
            safeMint(msg.sender, newTokenId);
        }
    }
}
