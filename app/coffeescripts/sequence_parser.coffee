
sequence_definition_regexp = /(\d+)-(\d+)(:(\d+))?(%(\d+))?/;

class SequenceParser
  constructor: () ->
  
  # Parse une "expression" simple. Une expression est une seule séquence de type a-b(:c)?(%d)? où a, b, c et d sont des nombres. 
  # Renvoie un hash définissant la séquence
  compile : (sequence_as_a_string) -> 
    matchs = sequence_definition_regexp.exec(sequence_as_a_string)
    [sequence, start, end, ignore1, step, ignore2, modulo] = matchs
    result = 
      start   : parseInt(start)   
      end     : parseInt(end)   
      step    : parseInt(step)   if step?
      modulo  : parseInt(modulo) if modulo?
    result
    
  

window.SCModels.sequence_compile = (sequence_as_a_string) ->
  parser                = new SequenceParser()
  @sequence_definition  = parser.compile(sequence_as_a_string)
