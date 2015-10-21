//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$( document ).ready(function() {
    $('#correct_student').hide();
    $('#wrong_student').hide();
    $('#attempted_student').hide();

    $("#button_one").click(function(event){
        questionType = $('#selectQuestion').val()
        if (questionType == 1){
            window.location.href = "/multiple_choice_questions/new/?test_id="+$('#button_one').attr("test_id");
        }
        else{
            window.location.href = "/descriptive_questions/new/?test_id="+$('#button_one').attr("test_id");;
        }
        
    });

    $('#correct').click(function toggle_stuff() {
        $('#correct_student').toggle(); 
        $('#wrong_student').hide();
    });

    $('#wrong').click(function toggle_stuff() {
        $('#wrong_student').toggle(); 
        $('#correct_student').hide();
    });

    $('#short_answer').click(function toggle_stuff() {
        $('#attempted_student').toggle();
    });

    $('.correct_option').css({ 'color': 'green'});
    $('.incorrect_option').css({ 'color': 'red'});    
    
});
