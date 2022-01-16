$(function(){
    let id = false;
    let currG = "Male"
    $("#identity").hide();
    window.addEventListener("message",function(event) {
        var item = event.data;
        switch (item.action) {
            case "Open":
                $("#identity").fadeIn()
                id = true;
                break;
            case "Close":
                $("#identity").fadeOut()
                id = false; break;
        }
    })

    $(".selec").click(function(){
        if (id) {
            if ($("#img").attr("src") == "https://cdn.discordapp.com/attachments/846097816912396308/932007952666230804/test3.png") {
                $("#img").attr("src","https://cdn.discordapp.com/attachments/846097816912396308/931998646126379088/test1.png")
                currG = "Female"
            } else {
                $("#img").attr("src","https://cdn.discordapp.com/attachments/846097816912396308/932007952666230804/test3.png")
                currG = "Male"
            }
        }
    })

    $("#create").click(function(){
        if (id) {
            let age = $("#sage").val();
            let nume = $("#ffname").val();
            let prenume = $("#ssname").val()
            if (parseInt(age) < 99 && parseInt(age) > 0 && nume != (null || undefined) && prenume != (null || undefined)) {
                $.post("https://vrp_identity/receiveExt", JSON.stringify({
                    type: 1,
                    varsta : parseInt(age),
                    nume : nume,
                    prenume:prenume,
                    sexul :currG
                }));
            }
            else {
                $.post("https://vrp_identity/receiveExt", JSON.stringify({ type: 2 }));
            }
        }
    })
})