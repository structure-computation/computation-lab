<!--

//------------------------------------------------------------------------------------------------------
// fonctions génériques
//------------------------------------------------------------------------------------------------------

function clone(myArray){
    var newArray = new Array();
    for (var property in myArray){
        newArray[property] = typeof (myArray[property]) == 'object' ? clone(myArray[property]) : myArray[property]
    } 
    return newArray
}


function pair(nombre)
{
   return ((nombre-1)%2);
}

// convertir une array en json string
function array2json(arr) {
    var parts = [];
    var is_list = (Object.prototype.toString.apply(arr) === '[object Array]');
    var virgule ='on';

    for(var key in arr) {
    	//if(key!='clone'){
	    	var value = arr[key];
	        if(typeof value == "object") { //Custom handling for arrays
		    var str = "";
		    //if(!is_list) 
		    str =  key ;
		    parts.push(str);
		    virgule ='off';
	            if(is_list) parts.push(array2json(value)); /* :RECURSION: */
	            else parts[key] = array2json(value); /* :RECURSION: */
	            //else parts.push('"' + key + '":' + returnedVal);
	        } else {
	        	if(typeof value != "function"){
		            var str = "";
		            //if(!is_list) 
		             str =  '\''+key + '\':';
		
		            //Custom handling for multiple data types
		            if(typeof value == "number") str += value; //Numbers
		            else if(value === false) str += 'false'; //The booleans
		            else if(value === true) str += 'true';
		            else str +=  '\''+value+'\'' ; //All other things
		            // :TODO: Is there any more datatype we should be in the lookout for? (Functions?)
	            	parts.push(str);
	        	}
	        }
    	//}
    }
    if(virgule =='on'){
      var json = parts.join(", ");
      return '[' + json + ']';//Return numerical JSON
    }
    else if(virgule =='off'){
      var json = parts.join("");
      return '[' + json + ']';//Return associative JSON
    }
    
    //if(is_list) return '{' + json + '}';//Return numerical JSON
    //return '{' + json + '}';//Return associative JSON
}
function array2object(array){
    var object = new Object();
    for(var key in array) {
	var value = array[key];
	if(typeof value == "Array") { //Custom handling for arrays
            object[key] = array2object(value);
        } else {
            object[key] = value;
        }
    }
    return object;
}



//----------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des cache noir et des wizard
//----------------------------------------------------------------------------------------------------------

function displayBlack(interupteur) {
    var arrLinkId    = new Array('bl_1','bl_2','bl_3','bl_4','bl_5','black_footer_top','black_footer');
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
    document.getElementById('New_wiz_layer').className = interupteur;
    NMcurrent_stape = 'page_information';
    if(interupteur=='on'){
	new_model_info_affiche_value();
    }
    affiche_NM_page();
}

-->