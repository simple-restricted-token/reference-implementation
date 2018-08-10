pragma solidity ^0.4.24;
import "./BasicTokenMock.sol";
import "../token/SRS20/SRS20ReferenceImpl.sol";

contract SRS20ReferenceImplMock is BasicTokenMock, SRS20ReferenceImpl {
    constructor (address initialAccount, uint256 initialBalance)
      BasicTokenMock(initialAccount, initialBalance)
      public
    {

    }
}