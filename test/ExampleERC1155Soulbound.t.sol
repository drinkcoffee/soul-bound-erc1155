// Copyright Immutable Pty Ltd 2018 - 2025
// SPDX-License-Identifier: Apache 2.0
// solhint-disable not-rely-on-time

pragma solidity >=0.8.19 <0.8.29;

// solhint-disable-next-line no-global-import
import "forge-std/Test.sol";
import {ExampleERC1155Soulbound} from "../src/ExampleERC1155Soulbound.sol";
import {OperatorAllowlistUpgradeable} from "@imtbl/contracts/contracts/allowlist/OperatorAllowlistUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract ExampleERC1155SoulboundTest is Test {

    ExampleERC1155Soulbound public erc1155Soulbound;
    address public owner;
    address public minter;
    address public player1;
    address public player2;

    function setUp() public virtual {
        owner = makeAddr("owner");
        minter = makeAddr("minter");
        player1 = makeAddr("player1");
        player2 = makeAddr("player2");
        address oalAdmin = makeAddr("oalAdmin");

        // These two are configured, but will never be used because the NFTs can not be transferred.
        address royaltyReceiver = address(1);
        uint96 feeNumerator = 0;

        string memory baseURI = "https://drinkcoffee.github.io/projects/erc1155nfts/{id}.json";
        string memory contractURI = "https://drinkcoffee.github.io/projects/erc1155nfts/sample-collection.json";
        address operatorAllowlist = _deployOperatorAllowlist(oalAdmin, oalAdmin, oalAdmin);

        erc1155Soulbound = new ExampleERC1155Soulbound(owner, "Soulbound", "SOUL", 
            baseURI, contractURI, operatorAllowlist, 
            royaltyReceiver, feeNumerator);

        bytes32 MINTER_ROLE = erc1155Soulbound.MINTER_ROLE();
        vm.prank(owner);
        erc1155Soulbound.grantRole(MINTER_ROLE, minter);

        // Fake accounts made in forge look like contracts. As such, they need to be added to the 
        // Operator Allowlist.
        address[] memory addresses = new address[](1);
        addresses[0] = player1;
        vm.prank(oalAdmin);
        OperatorAllowlistUpgradeable(operatorAllowlist).addAddressesToAllowlist(addresses);
    }


    function testCheckTransferFails() public {
        uint256 tokenId = 100;
        uint256 quantity = 1;
        vm.prank(minter);
        erc1155Soulbound.safeMint(player1, tokenId, quantity, bytes(""));

        vm.expectRevert(abi.encodeWithSelector(ExampleERC1155Soulbound.TokenSoulbound.selector));
        vm.prank(player1);
        erc1155Soulbound.safeTransferFrom(player1, player2, tokenId, quantity, bytes(""));
    }

    function testCheckBatchTransferFails() public {
        uint256 tokenId = 100;
        uint256 quantity = 1;
        vm.prank(minter);
        erc1155Soulbound.safeMint(player1, tokenId, quantity, bytes(""));

        uint256[] memory ids = new uint256[](1);
        ids[0] = tokenId;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = quantity;

        vm.expectRevert(abi.encodeWithSelector(ExampleERC1155Soulbound.TokenSoulbound.selector));
        vm.prank(player1);
        erc1155Soulbound.safeBatchTransferFrom(player1, player2, ids, amounts, bytes(""));
    }

    function testCheckBurnFails() public {
        uint256 tokenId = 100;
        uint256 quantity = 1;
        vm.prank(minter);
        erc1155Soulbound.safeMint(player1, tokenId, quantity, bytes(""));

        vm.expectRevert(abi.encodeWithSelector(ExampleERC1155Soulbound.TokenSoulbound.selector));
        vm.prank(player1);
        erc1155Soulbound.burn(player1, tokenId, quantity);
    }

    function testCheckBatchBurnFails() public {
        uint256 tokenId = 100;
        uint256 quantity = 1;
        vm.prank(minter);
        erc1155Soulbound.safeMint(player1, tokenId, quantity, bytes(""));

        uint256[] memory ids = new uint256[](1);
        ids[0] = tokenId;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = quantity;

        vm.expectRevert(abi.encodeWithSelector(ExampleERC1155Soulbound.TokenSoulbound.selector));
        vm.prank(player1);
        erc1155Soulbound.burnBatch(player1, ids, amounts);
    }

    function _deployOperatorAllowlist(address admin, address upgradeAdmin, address registerarAdmin) private returns (address) {
        OperatorAllowlistUpgradeable impl = new OperatorAllowlistUpgradeable();
        bytes memory initData = abi.encodeWithSelector(
            OperatorAllowlistUpgradeable.initialize.selector, admin, upgradeAdmin, registerarAdmin
        );
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), initData);
        return address(proxy);
    }}
