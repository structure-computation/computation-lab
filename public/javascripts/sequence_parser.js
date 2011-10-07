/* DO NOT MODIFY. This file was compiled Fri, 07 Oct 2011 12:25:28 GMT from
 * /Users/raphael/Documents/StructComp/SC_Interface/app/coffeescripts/sequence_parser.coffee
 */

(function() {
  var SequenceParser, sequence_definition;
  sequence_definition = /(\d+)-(\d+)(:(\d+))?(%(\d+))?/;
  SequenceParser = (function() {
    function SequenceParser(sequence_as_a_string) {
      this.sequence_as_a_string = sequence_as_a_string;
    }
    SequenceParser.prototype.compile = function(expr) {
      var end, matchs, modulo, result, sequence, start, step, _;
      matchs = sequence_definition.exec(expr);
      sequence = matchs[0], start = matchs[1], end = matchs[2], _ = matchs[3], step = matchs[4], _ = matchs[5], modulo = matchs[6];
      return result = {
        start: start,
        end: end,
        step: step,
        modulo: modulo
      };
    };
    return SequenceParser;
  })();
  window.SCModels.sequence_compile = function(sequence_as_a_string) {
    var parser;
    parser = new SequenceParser(sequence_as_a_string);
    return sequence_definition = parser.compile;
  };
}).call(this);
