$( document ).ready(function() {
    $('.nav-link-text').click(function(){
        var link = this.getAttribute('href');
        if (!!link){
            location.href = link;
        }
    });

    if (typeof web3 !== 'undefined') {
        web3 = new Web3(Web3.currentProvider);
    } else {
        // set the provider you want from Web3.providers
        //web3 = new Web3(new Web3.providers.HttpProvider("http://192.168.1.108:8545"));
        web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/BlfSPiwV3hQujoJVWnUX"));

    }

    web3.eth.getBlock(48, function(error, result){
        if(!error)
            console.log(result)
        else
            console.error(error);
    });

    //read the contract from JSON file
    var jqxhr = $.getJSON( "http://192.168.1.108/energyIslands/js/ElectroMarket.json", function(data) {
        console.log( "success" );
        var web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/BlfSPiwV3hQujoJVWnUX"));
        //var abi = JSON.parse(data);
        var contract = web3.eth.contract(data.abi);
        var contractInstance = contract.at('0xc57bb8eab5d508cdc57713b940e3271d8d58c3a40b0c8d9e7102e39d696f0515');
    })
    .fail(function() {
        console.log( "error" );
    })

    $.ajax({
        'url' : 'http://192.168.1.150:8080/api/history',
        'type' : 'GET',
        'success' : function(data) {
            var lines = data.split('\n');
            for(var i=1; i< lines.length; i++){
                $("#janeDev1DataTableBody").append("<tr>");
                var columns = lines[i].split(',');

                $("#janeDev1DataTableBody").append("<td>"+ columns[0] + "</td>");
                $("#janeDev1DataTableBody").append('<td><a href="https://rinkeby.etherscan.io/tx/' + columns[5] + '" target="_blank">' + columns[5] + '</a></td>');
                $("#janeDev1DataTableBody").append("<td>"+ columns[1] + "</td>");
                $("#janeDev1DataTableBody").append("<td>"+ columns[2] + "</td>");
                $("#janeDev1DataTableBody").append("<td>"+ columns[4] + "</td>");

                $("#janeDev1DataTableBody").append("</tr>");
            }
        }
    });

});

