var tock3ts;
var userAccount;

$(function() {
    console.log("windowAddEventListener(Load... metamask... startAppa)");
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        // Use Mist/MetaMask's provider
        web3js = new Web3(web3.currentProvider);
    } else {
        // Handle the case where the user doesn't have Metamask installed
        // Probably show them a message prompting them to install Metamask
        alert("Use MetaMask");
    }
    // Now you can start your app & access web3 freely:
    startApp();
});

function startApp() {
    var tock3tsAddress = "0x8efCB0bE3E4bAB6FDc9A8885e55551DfbDA55A2e";
    tock3ts = new web3js.eth.Contract(tock3tsABI, tock3tsAddress);

    accounts = async () => { await web3.eth.getAccounts();}
    userAccount = accounts[0];

    // var accountInterval = setInterval(function() {
    //   // Check if account has changed
    //   if (web3.eth.accounts[0] !== userAccount) {
    //     userAccount = web3.eth.accounts[0];
    //   }
    // }, 100);
    //initialized=true;
    console.log("startApp... initialized=true");
}

function displayNextEventsCards(ids, target) {
    $(target).empty();
    for (id of ids) {
        // Look up zombie details from our contract. Returns a `zombie` object
        getEventDetails(id)
            //.then(console.log("yep!"));
            .then(function(event) {
                console.log("getEventDetails: " + JSON.stringify(event));
                $(target).append(displayEventCard(event));
                getEventTock3tsByEvent(event.id).then(function (eventTock3tsIds){
                    console.log("getEventTock3tsByEvent: " + JSON.stringify(eventTock3tsIds));
                    for(i=0;i<eventTock3tsIds.length;i++)
                    {
                        getEventTock3tsById(eventTock3tsIds[i]).then(function (eventTock3t) {
                            console.log("getEventTock3tsById: " + JSON.stringify(eventTock3t));
                            addBuyButtonToEventCard(event.id, eventTock3t);
                        });
                    }
                });
            });
    }
}

function displayEventCard(item){
    // <a href="event.html?id=${item.id}" className="btn btn-primary">Go to event</a>
    return `<div class="col-4 mt-3">
                <div class="card event-${item.id}">
                <img src="imgs/ayax22-368.jpeg" class="card-img-top" alt="..." style="max-height: ;">
                    <div class="card-body">
                        <h5 class="card-title">${item.name}</h5>
                        <p class="card-text">${item.description}</p>                        
<!--                        <button type="button" class="buyTicket btn-primary w-100 mt-1" tock3t-event-id="1">Buy Vip Tocket</button>-->
<!--                        <button type="button" class="buyTicket btn-primary w-100 mt-1" tock3t-event-id="1">Buy Regular Tocket</button>-->
                    </div>
                </div>
          </div>`;
}

function addBuyButtonToEventCard(eventId, eventTock3t){
    $(".event-" + eventId + ">.card-body" ).append(`<button type="button" class="buyTicket btn-primary w-100 mt-1" tock3t-event-id="${eventTock3t.id}" tock3t-price="${eventTock3t.tokenPrice}" onclick="buyTock3t(${eventTock3t.id},${eventTock3t.tokenPrice});"  >${eventTock3t.name}: ${web3js.utils.fromWei(eventTock3t.tokenPrice)} MATIC (${eventTock3t.maxSupply}/${eventTock3t.mintedSupply}) </button>`);
}

function getEventDetails(id){
    return tock3ts.methods.events(id).call()
    //return tock3ts.methods.getEventDetails(id).call()
}

function getEventTock3tsByEvent(eventId){
    return tock3ts.methods.getEventTock3tsByEvent(eventId).call()
}

function getEventTock3tsById(tock3tId){
    return tock3ts.methods.eventTock3ts(tock3tId).call()
}

function displayEventDetails(id, target){

    $(target).empty();

    getEventDetails(id)
        .then(function(item) {
            $(target).append(
                `<div className="row pt-5">
                    <div className="col-6">
                        <h1>${item.name}</h1>
                        <p>${item.description}</p>
                    </div>
                    <div className="col-6">
                        <img src="imgs/ayax22-368.jpeg" alt="ayax" className="h-100">
                    </div>
                </div>`
            )
        });
}

function getEventTock3tsByEventContract(id) {
    return tock3ts.methods.getEventTock3tsByEvent(id).call()
}

function getTock3tPrize(id){

}

async function buyTock3t(eventTock3tId, price) {
    let walletAddr = await getAccount();
    //return cryptoZombies.methods.levelUp(zombieId)
    return tock3ts.methods.buyTock3ts(eventTock3tId,1)
        //.send({ from: userAccount, value: web3.utils.toWei("0.001", "ether") })
        //.send({ from: userAccount, value: price })
        .send({ from: walletAddr, value: price });
}

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
    return false;
};


/******************************/

const ethereumButton = document.querySelector('.enableEthereumButton');

ethereumButton.addEventListener('click', () => {
    getAccount();
});

async function getAccount() {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    const account = accounts[0];
    return account;
}

/******************************/