
sequence_definition_regexp = /(\d+)-(\d+)(:(\d+))?(%(\d+))?/;

class SequenceParser
  constructor: () ->
  
  # Parse une "expression" simple. Une expression est une seule séquence de type a-b(:c)?(%d)? où a, b, c et d sont des nombres. 
  # Renvoie un hash définissant la séquence
  compile : (sequence_as_a_string) -> 
    matchs = sequence_definition_regexp.exec(sequence_as_a_string)
    # [sequence, start, end, ignore1, step, ignore2, modulo] = matchs
    result = 
      # start   : parseInt(start)   
      # end     : parseInt(end)   
      # step    : parseInt(step)   
      # modulo  : parseInt(modulo) 
      start   : parseInt(matchs[1])   
      end     : parseInt(matchs[2])   
      step    : parseInt(matchs[4])   
      modulo  : parseInt(matchs[6])  
    # if step  
    #   result["step"]   = parseInt(step)  
    # if modulo
    #   result["modulo"] = parseInt(modulo)
    # fin des ifs
    result
    
  

window.SCModels.sequence_compile = (sequence_as_a_string) ->
  parser                = new SequenceParser()
  sequence_definition   = parser.compile(sequence_as_a_string)
