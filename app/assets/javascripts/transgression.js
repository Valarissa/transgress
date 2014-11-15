jQuery(unencodeTransgressions);

function unencodeTransgressions(){
  jQuery.getJSON("/assets/string_list.json", null, function(data){
    var transgressions;

    transgressions = data["safe"].concat(data["flagged"]);
    unencodeTextIn('body', transgressions);
    unencodeTextIn('head', transgressions);
  }).done(function(){ console.log("idiocy"); });
}

function unencodeTextIn(tag, transgressions){
  nodes = getTextNodesIn(document.getElementsByTagName(tag)[0], false);
  var node_length = nodes.length;
  for(var i = 0; i < node_length; i++){
    nodes[i].nodeValue = alterText(nodes[i].nodeValue, transgressions);
  }
}

function alterText(v, transgressions) {
  return v.replace(/~\*(\d*)\*~/g, function(match, value){
    return transgressions[parseInt(value)];
  });
}

function getTextNodesIn(node, includeWhitespaceNodes) {
  var textNodes = [], nonWhitespaceMatcher = /\S/;

  function getTextNodes(node) {
    if (node.nodeType == 3) {
      if (includeWhitespaceNodes || nonWhitespaceMatcher.test(node.nodeValue)) {
        textNodes.push(node);
      }
    } else {
      for (var i = 0, len = node.childNodes.length; i < len; ++i) {
        getTextNodes(node.childNodes[i]);
      }
    }
  }

  getTextNodes(node);
  return textNodes;
}
