
sequence_definition = /(\d+)-(\d+)(:(\d+))?(%(\d+))?/;

class SequenceParser
  constructor: (@sequence_as_a_string) ->
  
  # Parse une "expression" simple. Une expression est une seule séquence de type a-b(:c)?(%d)? où a, b, c et d sont des nombres. 
  # Renvoie un hash définissant la séquence
  compile : (expr) -> 
    matchs = sequence_definition.exec(expr)
    [sequence, start, end, _, step, _, modulo] = matchs
    result = 
      start  : start 
      end    : end
      step   : step
      modulo : modulo
    
    
  

window.SCModels.sequence_compile = (sequence_as_a_string) ->
  parser                = new SequenceParser(sequence_as_a_string)
  sequence_definition   = parser.compile
