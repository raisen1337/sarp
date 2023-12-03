const bankingOperations = document.querySelector('.banking-operations')
const withdrawOperation = document.querySelector('.withdraw')
const depositOperation = document.querySelector('.deposit')
const transferOperation = document.querySelector('.transfer')

const bankingContainer = document.querySelector('.banking-container')

const transactionAmount1 = document.querySelector('#transactionAmount1')
const transactionAmount2 = document.querySelector('#transactionAmount2')
const transactionAmount3 = document.querySelector('#transactionAmount3')
const transactionId = document.querySelector('#transactionId')

bankingContainer.style.display = 'none';

const playerName = document.querySelector('#playerName')
const playerTotalMoney = document.querySelector('#playerTotalMoney')
const playerBankBalance = document.querySelector('#playerBankBalance')
const playerCashBalance = document.querySelector('#playerCashBalance')

const totalTransferred = document.querySelector('#totalTransferred')
const totalWithdrawn = document.querySelector('#totalWithdrawn')
const totalDeposited = document.querySelector('#totalDeposited')

let currentOperation = false

let operationData = {}

withdraw = function(){
    bankingOperations.style.display = 'flex'
    depositOperation.style.display = 'none'
    transferOperation.style.display = 'none'
    withdrawOperation.style.display = 'flex'

    bankingOperations.classList.add('fadeIn')

    currentOperation = 'withdraw'
    setTimeout(() => {
        bankingOperations.classList.remove('fadeIn')
    }, 1000); 
    
}

deposit = function(){
    
    bankingOperations.style.display = 'flex'
    depositOperation.style.display = 'flex'

    withdrawOperation.style.display = 'none'
    transferOperation.style.display = 'none'

    bankingOperations.classList.add('fadeIn')

    currentOperation = 'deposit'
    setTimeout(() => {
        bankingOperations.classList.remove('fadeIn')
    }, 1000);

    
}

transfer = function(){
    
    bankingOperations.style.display = 'flex'
    transferOperation.style.display = 'flex'

    withdrawOperation.style.display = 'none'
    depositOperation.style.display = 'none'

    bankingOperations.classList.add('fadeIn')

    currentOperation = 'transfer'
    setTimeout(() => {
        bankingOperations.classList.remove('fadeIn')
    }, 1000);
    
}

confirmTransaction = function(){
    
    if(currentOperation == 'withdraw') {
        $.post('http://rpbase/tryTransaction', JSON.stringify({
            type: currentOperation,
            amount: transactionAmount1.value,
        }));
        hideOperation()
    }else if(currentOperation == 'deposit'){
        $.post('http://rpbase/tryTransaction', JSON.stringify({
            type: currentOperation,
            amount: transactionAmount2.value,
        }));
        hideOperation()
    }else if(currentOperation == 'transfer') {
        $.post('http://rpbase/tryTransaction', JSON.stringify({
            type: currentOperation,
            amount: transactionAmount3.value,
            recipient: transactionId.value,
        }));
        hideOperation()
    }
    
}

document.addEventListener('keydown', function(event) {
  if (event.key === 'Escape' || event.key === 'Esc' || event.keyCode === 27) {
    if(!currentOperation) {
        hideBanking()
    }else{
        hideOperation()
        $.post('http://rpbase/keepFocus', JSON.stringify({
       
        }));
    }
  }
});

hideBanking = function(){
    bankingContainer.classList.remove('fadeIn')
    bankingContainer.classList.add('fadeOut')
    
    setTimeout(() => {
        bankingContainer.style.display = 'none';
    }, 800);

    $.post('http://rpbase/closeBank', JSON.stringify({
       
    }));

}

hideOperation = function(){
    currentOperation = false
    bankingOperations.classList.remove('fadeIn')
    bankingOperations.classList.add('fadeOut')
    setTimeout(() => {
        bankingOperations.classList.remove('fadeIn')
        bankingOperations.classList.remove('fadeOut')
        bankingOperations.style.display = 'none'
    }, 800);
}

function createAndAppendTransaction(data) {
  // Create a new transaction element
  const transactionElement = document.createElement('div');
  transactionElement.classList.add('banking-transaction', data.type);

  // Create the transaction top section
  const transactionTop = document.createElement('div');
  transactionTop.classList.add('banking-transaction-top');

  // Create the icon element
  const iconElement = document.createElement('i');
  iconElement.classList.add('fa-solid', 'fa-inbox-in');

  // Create the recipient element
  const recipientElement = document.createElement('span');
  recipientElement.classList.add('banking-transaction-recipient');
  recipientElement.textContent = data.recipient;

  // Append icon and recipient to transaction top
  transactionTop.appendChild(iconElement);
  transactionTop.appendChild(recipientElement);

  // Create the transaction details section
  const transactionDetails = document.createElement('div');
  transactionDetails.classList.add('banking-transaction-details');

  // Determine the transaction type based on data.type
  const transactionType = document.createElement('span');
  transactionType.classList.add('banking-transaction-type');
  if (data.type === 'sent') {
    transactionType.textContent = 'Trimis';
  } else if (data.type === 'received') {
    transactionType.textContent = 'Primit';
  }

  // Create the amount element
  const amountElement = document.createElement('span');
  amountElement.classList.add('banking-transaction-amount');
  amountElement.textContent = data.amount;

  // Append type and amount to transaction details
  transactionDetails.appendChild(transactionType);
  transactionDetails.appendChild(amountElement);

  // Append transaction top and details to the transaction element
  transactionElement.appendChild(transactionTop);
  transactionElement.appendChild(transactionDetails);

  // Append the transaction element to the .banking-transactions-item1 container
  const containerElement = document.querySelector('.banking-transactions-item1');
  containerElement.appendChild(transactionElement);
}

function formatMoney(number) {
  // Use toLocaleString to add commas for thousands separators
  return '$' + number.toLocaleString('en-US');
}

function deleteTransactions() {
    const container = document.querySelector('.banking-transactions-item1');
    
    // Remove all child elements one by one until there are no more children
    while (container.firstChild) {
      container.removeChild(container.firstChild);
    }
}

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "openBanking") {
        deleteTransactions()
        bankingContainer.classList.add('fadeIn')
        bankingContainer.classList.remove('fadeOut')

        setTimeout(() => {
            bankingContainer.style.display = 'flex';
        }, 200);

        playerTotalMoney.textContent = formatMoney(event.data.playerCash + event.data.playerBank)
        playerName.textContent = event.data.playerName

        playerBankBalance.textContent = formatMoney(event.data.playerBank)
        playerCashBalance.textContent = formatMoney(event.data.playerCash)


        for (const key in event.data.transactions) {
            if (event.data.transactions.hasOwnProperty(key)) {
                const transaction = event.data.transactions[key]; // Get the transaction object
        
                if (transaction.recipientId !== event.data.playerBankId) {
                    createAndAppendTransaction({
                        type: 'sent',
                        recipient: transaction.recipient,
                        amount: formatMoney(transaction.amount)
                    });
                } else {
                    createAndAppendTransaction({
                        type: 'received',
                        recipient: transaction.recipient,
                        amount: formatMoney(transaction.amount)
                    });
                }
            }
        }
        

        totalTransferred.textContent = formatMoney(event.data.totalTransferred)
        totalDeposited.textContent = formatMoney(event.data.totalDeposited)
        totalWithdrawn.textContent = formatMoney(event.data.totalWithdrawn)
        return
    }
    if (event.action == "updateBanking") {
        deleteTransactions()
        playerTotalMoney.textContent = formatMoney(event.data.playerCash + event.data.playerBank)
        playerName.textContent = event.data.playerName

        playerBankBalance.textContent = formatMoney(event.data.playerBank)
        playerCashBalance.textContent = formatMoney(event.data.playerCash)

    
        setTimeout(() => {
            for (const key in event.data.transactions) {
                if (event.data.transactions.hasOwnProperty(key)) {
                    const transaction = event.data.transactions[key]; // Get the transaction object
            
                    if (transaction.recipientId !== event.data.playerBankId) {
                        createAndAppendTransaction({
                            type: 'sent',
                            recipient: transaction.recipient,
                            amount: formatMoney(transaction.amount)
                        });
                    } else {
                        createAndAppendTransaction({
                            type: 'received',
                            recipient: transaction.recipient,
                            amount: formatMoney(transaction.amount)
                        });
                    }
                }
            }
        }, 500);

        totalTransferred.textContent = formatMoney(event.data.totalTransferred)
        totalDeposited.textContent = formatMoney(event.data.totalDeposited)
        totalWithdrawn.textContent = formatMoney(event.data.totalWithdrawn)
        return
    }
});
  

// const dataReceived = {
//   type: 'received',
//   recipient: 'RAISEN DEVELOPER',
//   amount: '$450.000',
// };

// const dataSent = {
//   type: 'sent',
//   recipient: 'RAISEN DEVELOPER',
//   amount: '$450.000',
// };

// const transactionReceivedElement = createAndAppendTransaction(dataReceived);
// const transactionSentElement = createAndAppendTransaction(dataSent);