//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Ideas is ERC721 {
    // Total numbers of all Ideas
    uint256 public totalIdeas;

    string private baseURI;

    constructor(string memory _defaultURI) ERC721("Decedia", "DCD") {
        baseURI = _defaultURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function mint() public {
          totalIdeas++;
          _safeMint(msg.sender, totalIdeas);
      }

}