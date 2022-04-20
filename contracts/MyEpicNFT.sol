// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public nftCount;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Sketchy", "Legendary", "Epic", "Loser", "Sad", "Snitchy", "Cute", "Pretty", "Beautiful", "Nerdy","Charming", "Handsome", "Chubby", "Sweet", "Spicy"];
    string[] secondWords = ["Little", "Big", "Small", "Large", "Medium", "Blue", "Red", "Green", "Yellow", "Purple", "Grey", "Orange", "Kind", "Short", "Tall"];
    string[] thirdWords = ["Prince", "Lord", "Queen", "King", "Duke", "Peasant", "Jester", "Baller", "President", "Dictator", "Teacher", "Poet", "Writer", "Joker", "Hoarder"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoa!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        console.log("First Word rand variable: ", rand);
        rand = rand % firstWords.length;
        console.log("First word remainder rand: ", rand);
        return firstWords[rand];
    }
    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256){
        return nftCount;

    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();
        nftCount = newItemId+1;
        uint256 maxNftCount = 50;
        console.log("Current ID: ", newItemId);
        console.log("Max NFT is: ", maxNftCount);

        require(newItemId < maxNftCount, "No NFTs left to mint :(");
        
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
        
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        
        
        // console.log("\n--------------------");
        // console.log(string(abi.encodePacked("https://nftpreview.0xdev.codes/?code=",finalTokenUri)));
        // console.log("--------------------\n");
        
        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    

    
    
 
    

    
}