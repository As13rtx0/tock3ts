var tock3ts;
var userAccount;
// var initialized=false;
//
// if(!initialized)
// {
//     window.addEventListener('load', function() {
//
//         console.log("windowAddEventListener(Load... metamask... startAppa)");
//
//         // Checking if Web3 has been injected by the browser (Mist/MetaMask)
//         if (typeof web3 !== 'undefined') {
//             // Use Mist/MetaMask's provider
//             web3js = new Web3(web3.currentProvider);
//         } else {
//             // Handle the case where the user doesn't have Metamask installed
//             // Probably show them a message prompting them to install Metamask
//             alert("Use MetaMask");
//         }
//         // Now you can start your app & access web3 freely:
//         startApp();
//     });
// }

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
    // var accountInterval = setInterval(function() {
    //   // Check if account has changed
    //   if (web3.eth.accounts[0] !== userAccount) {
    //     userAccount = web3.eth.accounts[0];
    //     // Call a function to update the UI with the new account
    //     getZombiesByOwner(userAccount)
    //             .then(displayZombies);
    //   }
    // }, 100);
    initialized=true;
    console.log("startApp... initialized=true");
}

function displayNextEventsCards(ids, target) {
    $(target).empty();
    for (id of ids) {
        // Look up zombie details from our contract. Returns a `zombie` object
        getEventDetails(id)
            .then(function(event) {

                getEventTock3tsByEventContract(id).then(function(eventTock3ts){
                    console.log(JSON.stringify(eventTock3ts));
                    //function getEventTock3tsByEventContract(id) {
                    for(et in eventTock3ts){

                    }
                });

                $(target).append(displayEventCard(event));
            });
    }
}

function displayEventCard(item){
    // <a href="event.html?id=${item.id}" className="btn btn-primary">Go to event</a>
    return `<div class="col-4 mt-3">
                <div class="card">
                <img src="imgs/ayax22-368.jpeg" class="card-img-top" alt="..." style="max-height: ;">
                    <div class="card-body">
                        <h5 class="card-title">${item.name}</h5>
                        <p class="card-text">${item.description}</p>                        
                        <button type="button" class="buyTicket btn-primary w-100 mt-1" tock3t-event-id="1">Buy Vip Tocket</button>
                        <button type="button" class="buyTicket btn-primary w-100 mt-1" tock3t-event-id="1">Buy Regular Tocket</button>
                    </div>
                </div>
          </div>`;
}

function getEventDetails(id){
    return tock3ts.methods.events(id).call()
}

function getEventTock3tsByEvent(eventId){
    return tock3ts.methods.getEventTock3tsByEvent(id).call()
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

function buyEventTock3t(id){
    alert("are u sure to buy?");
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