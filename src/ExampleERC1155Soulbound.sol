// SPDX-License-Identifier: MIT License
pragma solidity ^0.8.19;

import {ImmutableERC1155} from "@imtbl/contracts/contracts/token/erc1155/preset/ImmutableERC1155.sol";


contract ExampleERC1155Soulbound is ImmutableERC1155 {
    error TokenSoulbound();

    constructor(
        address owner,
        string memory name,
        string memory symbol,
        string memory baseURI,
        string memory contractURI,
        address operatorAllowlist,
        address royaltyReceiver,
        uint96 feeNumerator
    ) ImmutableERC1155(owner, name, baseURI, contractURI, operatorAllowlist, royaltyReceiver, feeNumerator) {}

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override {
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            revert TokenSoulbound();
        }
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
