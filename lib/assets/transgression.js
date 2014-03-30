$(unencodeTransgressions);

function unencodeTransgressions(){
  var transgressions = ['trans']
    , $body = jQuery('body')[0];

  jQuery(':not(:has(*))', $body).text(function(i, v) {
    return v.replace(/~\*(\d*)\*~/g, function(match, value){
      return transgressions[parseInt(value)];
    });
  });
}
