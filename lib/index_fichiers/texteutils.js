function remplacerTexte(el, texte) {
  if (el != null) {
    effacerTexte(el);
    var nouveauNoeud = document.createTextNode(texte);
    el.appendChild(nouveauNoeud);
  }
}

function effacerTexte(el) {
  if (el != null) {
    if (el.childNodes) {
      for (var i = 0; i < el.childNodes.length; i++) {
        var noeudFils = el.childNodes[i];
        el.removeChild(noeudFils);
      }
    }
  }
}

function getTexte(el) {
  var texte = "";
  if (el != null) {
    if (el.childNodes) {
      for (var i = 0; i < el.childNodes.length; i++) {
        var noeudFils = el.childNodes[i];
        if (noeudFils.nodeValue != null) {
          texte = texte + noeudFils.nodeValue;
        }
      }
    }
  }
  return texte;
}
