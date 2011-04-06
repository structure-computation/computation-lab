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
    var is_list2 = (Object.prototype.toString.apply(arr) === '[object Object]');
    var virgule ='on';

    for(var key in arr) {
	var value = arr[key];
	if(typeof value == "object") { //Custom handling for arrays
		var str = "";
		var str2 = "";
		//alert('object_' + key);
		if(is_list2){ 
			str =  '\"'+key + '\":';
			virgule ='on';
			str2 = array2json(value); /* :RECURSION: */
			str += str2;
			//str = '{' + str + '}'
			parts.push(str);
 		} else if(is_list) {
 			if(isNaN(key)){
				str =  '\"'+key + '\":';
				virgule ='on';
				str2 = array2json(value); /* :RECURSION: */
				str += str2;
				//str = '{' + str + '}'
				parts.push(str);
			}else{
				virgule ='off'
				parts.push(array2json(value)); /* :RECURSION: */
			}
		}else {
			parts[key] = array2json(value); /* :RECURSION: */
		}
		//else parts.push('"' + key + '":' + returnedVal);
	} else {
		if(typeof value != "function"){
			//virgule ='on';
			var str = "";
			//if(!is_list) 
			str =  '\"'+key + '\":';
	    
			//Custom handling for multiple data types
			if(typeof value == "number") str += value; //Numbers
			else if(value === false) str += 'false'; //The booleans
			else if(value === true) str += 'true';
			else str +=  '\"'+value+'\"' ; //All other things
			// :TODO: Is there any more datatype we should be in the lookout for? (Functions?)
			parts.push(str);
		}
	}
    }
    if(virgule =='on'){
      var json = parts.join(", ");
      return '{' + json + '}';//Return numerical JSON
    }
    else if(virgule =='off'){
      var json = parts.join(", ");
      return '[' + json + ']';//Return associative JSON
    }
    
    //if(is_list) return '{' + json + '}';//Return numerical JSON
    //return '{' + json + '}';//Return associative JSON
}
function array2object(array){
    var object = new Object();
    for(var key in array) {
	var value = array[key];
	if(typeof value == "Array" || typeof value == "object") { //Custom handling for arrays
            object[key] = array2object(value);
        } else {
            object[key] = value;
        }
    }
    return object;
}
function object2array(object){
    var array = new Array();
    for(var key in object) {
	var value = object[key];
	if(typeof value == "Array" || typeof value == "object") { //Custom handling for arrays
            array[key] = object2array(value);
        } else {
            array[key] = value;
        }
    }
    return array;
}


//----------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des cache noir et des wizard
//----------------------------------------------------------------------------------------------------------

function displayBlack(interupteur) {
    var arrLinkId    = new Array('bl_1','bl_4','bl_5','black_footer_top','black_footer');
    var intNbLinkElt = new Number(arrLinkId.length);
    var strContent   = new String();

    for (i=0; i<intNbLinkElt; i++) {
        strContent = arrLinkId[i];
        if ( interupteur == "on" ) {
            id_black = document.getElementById(strContent);
	    if(id_black != null){
		    id_black.className = "black on";
	    }
        }
        if ( interupteur == "off" ) {
	    id_black = document.getElementById(strContent);
	    if(id_black != null){
		    id_black.className = "black off";
	    }
        }
    }   
}

-->