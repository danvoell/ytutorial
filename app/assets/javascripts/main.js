// App-wid JS goes here
$(function(){
  $("button.close").on("click", function(){ $(this).parent().hide();})
  prettyPrint(document); // custom version of prettyprint
});
