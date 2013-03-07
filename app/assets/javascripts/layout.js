jQuery(function ($) {
    //for checkbox
    $('input[type=checkbox]').each(function(){
        var t = jQuery(this);
        if (t.attr('checked') != null && t.attr('checked') == 'checked')
            t.wrap('<span class="checkbox checked"></span>');
        else
            t.wrap('<span class="checkbox"></span>');
        t.parent().append('<div/>')
    });
    $(document).on('click', 'input[type=checkbox]', function(e){
        if(jQuery(this).is(':checked')) {
            jQuery(this).attr('checked',true);
            jQuery(this).parent().addClass('checked');
        } else {
            jQuery(this).attr('checked',false);
            jQuery(this).parent().removeClass('checked');
        }
        e.stopPropagation()
    })
    jQuery('.stdtablecb .checkall').click(function(){
        var parentTable = jQuery(this).parents('table');
        var ch = parentTable.find('tbody input[type=checkbox]');
        if(jQuery(this).is(':checked')) {

            //check all rows in table
            ch.each(function(){
                jQuery(this).attr('checked',true);
                jQuery(this).parent().addClass('checked');	//used for the custom checkbox style
                jQuery(this).parents('tr').addClass('selected');
            });

            //check both table header and footer
            parentTable.find('.checkall').each(function(){ jQuery(this).attr('checked',true); });

        } else {

            //uncheck all rows in table
            ch.each(function(){
                jQuery(this).attr('checked',false);
                jQuery(this).parent().removeClass('checked');	//used for the custom checkbox style
                jQuery(this).parents('tr').removeClass('selected');
            });

            //uncheck both table header and footer
            parentTable.find('.checkall').each(function(){ jQuery(this).attr('checked',false); });
        }
    });
});