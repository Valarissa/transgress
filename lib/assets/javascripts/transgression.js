jQuery(unencodeTransgressions);

function unencodeTransgressions(){
  var transgressions
    , $body = jQuery('body')[0];

  jQuery.getJSON("/assets/string_list.json", function(data){
    transgressions = data;
    nodes = getTextNodesIn(document.getElementsByTagName('body')[0], false);
    var node_length = nodes.length;
    for(var i = 0; i < node_length; i++){
      nodes[i].nodeValue = alterText(nodes[i].nodeValue, transgressions);
    }
  });
}

function alterText(v, transgressions) {
  console.log(typeof(v));
  return v.replace(/~\*(\d*)\*~/g, function(match, value){
    console.log(value);
    console.log(transgressions[parseInt(value)])
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
