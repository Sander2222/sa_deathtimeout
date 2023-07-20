    $(function() {
        function display(bool) {
            if (bool) {
                $("body").fadeIn();

            } else {
                $("body").hide();
            }
        }

        display(false)

        window.addEventListener('message', function(event) {
            var item = event.data;
            if (item.type === "ui") {
                if (item.status == true) {
                    display(true);

                    //Vars für Daten
                    var today = new Date();
                    var dd = String(today.getDate()).padStart(2, '0');
                    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                    var yyyy = today.getFullYear();
                    var time = today.getHours() + ":" + today.getMinutes();
                    today = dd + '.' + mm + '.' + yyyy;

                    //Felder fühlen
                    $(".MoneySpan").html(item.money);
                    $(".NameSpan").html(item.UserName);
                    $(".IDSpan").html(item.UserID);
                    $(".DateSpan").html(today);
                    $(".TimeSpan").html(time);
                } else {
                    display(false)
                }
            }
        })

        document.onkeyup = function(data) {
            if (data.which == 27) {
                $.post('https://sa_banking/exit', JSON.stringify({}));
                return
            }
        };
    });

    function closeWindow() {
        $.post('https://sa_banking/exit', JSON.stringify({}));
    }

    function Withdraw() {
        $.post('https://sa_banking/Withdraw', JSON.stringify({
            WithdrawAmount: $(".WithdrawInput").val()
        }));
    }

    function Deposit() {
        $.post('https://sa_banking/Deposit', JSON.stringify({
            WithdrawAmount: $(".DepositInput").val()
        }));
    }

    function transfer() {
        $.post('https://sa_banking/transfer', JSON.stringify({
            transferAmount: $(".TransferInput").val(),
            PayerID: $(".PlayerIDInput").val()
        }));
    }