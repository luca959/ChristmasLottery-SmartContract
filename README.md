# ChristmasLottery-SmartContract
Annually, students organize a Christmas Party, typically seeking funds through a lottery. Unfortunately, the use of cryptocurrencies for financing the Christmas party is not feasible. Nevertheless, it is possible to develop a smart contract with the following functionalities:

Sell one or more tickets (unique numbers) to students before the party, with payment in euros (face-to-face)
On the day of the party, randomly select a specified number of tickets/numbers, depending on the available prizes (a parameter that cannot be configured at deployment time).
For each selected ticket/number, provide information about the student who owns that ticket. It is important to note that only the contract owner or a predefined set of addresses has the authority to access this information stored on the blockchain.

compiler:  0.8.18
