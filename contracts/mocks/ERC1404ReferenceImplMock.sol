pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../token/ERC1404/ERC1404ReferenceImpl.sol";

contract ERC1404ReferenceImplMock is BasicTokenMock, ERC1404ReferenceImpl {
    constructor (address initialAccount, uint256 initialBalance)
      BasicTokenMock(initialAccount, initialBalance)
      public
    {

    }
}