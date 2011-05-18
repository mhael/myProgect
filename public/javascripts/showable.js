/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function() {
    $("a.iframe").fancybox({
        'width' : '75%',
        'height' : '75%',
        'autoScale' : false,
        'transitionIn' : 'none',
        'transitionOut' : 'none',
        'type' : 'iframe'
    });
    $(function() {
        $("a.iframe").live("click", function() {
            $.getScript(this.href);
            return false;
        });
    });
});


