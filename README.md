This repo includes 3 wallets and one payput wallet.
The multi-sign wallet is hugo, svend and bendt.

The pin-code and password of the multi-sign wallets are.

Name pincode password
- hugo 0001 hugo
- svend 0002 hugo
- bendt 0003 hugo

The multi-sign wallet is called wallet1

To make payout from a csv file:
```
mkdir wallet1/payout
cp <from-some-where>/payout_file_14-12-2023.csv wallet1/payout
auszahlung wallet1.json hugo.json svend.json bendt.json payout_14-12-2023.csv
```
This will produces two files.

A contract file:
*wallet1/contracts/payout_file_14-12-2023.hibon*

And an update file.
*wallet1/contracts/payout_file_14-12-2023_update.hibon*

To do the payout the contract file should be send to the network.

When the transaction has been processed by the network the update should be send.

The wallet should be update from the response received back from the network.

```
auszahlung wallet1.json hugo.json svend.json bendt.json --response payout_file_14-12-2023_update_response.hibon
```

The accounting in the multi-sign wallet can be shown by.
```
auszahlung wallet1.json --list
```



