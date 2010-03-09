<!--

//--------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des cache noir et des wizard
//--------------------------------------------------------------------------------------------

function displayBlack(interupteur) {
    var arrLinkId    = new Array('bl_1','bl_2','bl_3','bl_5','black_footer_top','black_footer');
    var intNbLinkElt = new Number(arrLinkId.length);
    var strContent   = new String();

    for (i=0; i<intNbLinkElt; i++) {
        strContent = arrLinkId[i];
        if ( interupteur == "on" ) {
            document.getElementById(strContent).className = "black on";
        }
        if ( interupteur == "off" ) {
            document.getElementById(strContent).className = "black off";
        }
    }   
}

function displayNewModel(interupteur) {
    displayBlack(interupteur);
    document.getElementById('NM_wiz_layer').className = interupteur;
    NMcurrent_stape = 'page_information';
    affiche_NM_page();
}

-->