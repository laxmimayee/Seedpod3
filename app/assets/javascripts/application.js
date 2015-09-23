//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$( document ).ready(funcetion() {
    $("#create").click(function(){
        var e = document.getElementById("selectQuestion");
        var strUser = e.options[e.selectedIndex].value;
        var e = document.getElementById("selectQuestion");
        var strUser1 = e.options[e.selectedIndex].text;

        if (strUser == 1){
            window.location.href = "/multiple_choice_questions/new";
        }
        else{
            window.location.href = "/descriptive_questions/new";
        }
    });



});
