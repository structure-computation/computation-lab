/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:18 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/mobile.coffee
 */

(function() {
  $(function() {
    $('#main_menu li')[0].onGesture("tap", function(event) {
      return $(this).find('ul').css('display', 'block');
    });
    if ($('.action_on_table')[0] != null) {
      $('.action_on_table')[0].onGesture("tap", function() {
        var ul;
        ul = $(this).find('> ul');
        if (ul.css('display') === 'none') {
          $('.action_on_table ul').css('display', 'none');
          return ul.css('display', 'block');
        } else {
          return ul.css('display', 'none');
        }
      });
    }
    return $('body')[0].onGesture("tap", function(eventObj) {
      if (!$(eventObj.target.target).hasClass('action_on_table')) {
        return $('.action_on_table ul').css('display', 'none');
      }
    });
  });
}).call(this);
