// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

  $('div.arrow-up').click(function(){
    var gadgetId = $(this).attr('gadget-id');

    $.post('/gadgets/' + gadgetId + '/upvote', function ( resp ){
      $('td[gadget-id="' + gadgetId + '"].vote-numbers').text( resp['newVotes'] );
      $('span#user-vote-' + gadgetId).text( resp['yourVote']);
    });

  });

  $('div.arrow-down').click(function(){
    var gadgetId = $(this).attr('gadget-id');

    $.post('/gadgets/' + gadgetId + '/downvote', function ( resp ){
      $('td[gadget-id="' + gadgetId + '"].vote-numbers').text( resp['newVotes'] );
      $('span#user-vote-' + gadgetId).text( resp['yourVote'])
    })
  })
});
