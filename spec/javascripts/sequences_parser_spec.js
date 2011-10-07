
// Création de la variable globale utilisée partout pour acceder aux sources compilées par CS :
window.SCModels = {};

sequence_compile = SCModels.sequence_compile




// Une séquence est une chaine de caractère qui nous fourni une suite d'index en sortie. 
// Elle suit (à vérifier) une syntaxte déjà vue dans matlab. Exemple : simple : "1-5", deux simples : "1-5,7-12"
// avec step "1-10:3", renvoie "1,4,7,10", des séquences avec "modulo" qu'il reste à définir correctement.
// 
// describe("Sequences parser", function() {  
//   it("Handle simple correct sequences", function() {  
//     expect(sequence_parse("4-5")).toEqual([4, 5]);
//     expect(sequence_parse("1-1")).toEqual([1]);
//     expect(sequence_parse("12-21")).toEqual([12,13,14,15,16,17,18,19,20,21]);
//   });  
// 
//   it("Handle simple sequences with steps", function() {  
//     expect( sequence_parse("1-1:1")  ).toEqual([1]);
//     expect( sequence_parse("1-1:2")  ).toEqual([1]);
//     expect( sequence_parse("1-1:5")  ).toEqual([1]);
//     expect( sequence_parse("1-2:2")  ).toEqual([1]);
//     expect( sequence_parse("1-3:2")  ).toEqual([1,3]);    
//     expect( sequence_parse("12-21:3")).toEqual([12,15,18,21]);
//   });  
// });

describe("Sequences parser, compilation step", function() { 
  var sequence_build_result = function (start, stop, step, modulo){
    return {"start"  : start ,
            "end"    : end   ,
            "step"   : step  ,
            "modulo" : modulo
          }
  }; 

  it("Handle simple sequences", function() {  
    expect(sequence_parse("4-5"))   .toEqual( sequence_build_result(4, 5) );
    expect(sequence_parse("1-1"))   .toEqual( sequence_build_result(1, 1) );
    expect(sequence_parse("12-21")) .toEqual( sequence_build_result(1, 1) );
  });  
  
  it("Handle sequences with steps only", function() {  
    expect(sequence_parse("4-5:6"))   .toEqual( sequence_build_result(4,  5,    6   ) );
  });  
  it("Handle sequences with modulo only", function() {  
    expect(sequence_parse("4-5%6"))   .toEqual( sequence_build_result(4,  5, null, 6) );
  });
  it("Handle sequences with step and modulo", function() {  
    expect(sequence_parse("1-20:2%6")).toEqual( sequence_build_result(4, 20,    2, 6) );
  });  

});