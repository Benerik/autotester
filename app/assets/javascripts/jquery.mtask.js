(function($){
    $.fn.paginate = function(options) {
        var defaults = {
            dbclick: false,
            callback: function() {}
        }

        var opts = $.extend(defaults, options);
        $(document).on('click', this.selector, function() {
            var tag_pag_body = $(this).closest('#dyntable_paginate')
            var tag_page_inner = tag_pag_body.find('.paginate-body-inner')
            var pag_width = tag_page_inner.outerWidth(true) - parseInt(tag_page_inner.css('margin-left').substr(0, tag_page_inner.css('margin-left').length - 2))
            if ($(this).closest('.paginate-body').length != 0) {
                opts.callback.call($(this), $(this).text())
                movement_pagination($(this), pag_width)
            }
            else {
                var type = ''
                type = $(this).attr('class');
                if (type.indexOf('first') != -1) {
                    if (opts.dbclick == false)
                        opts.callback.call($(this), 1);
                    movement_pagination($('.paginate-body > .paginate-body-inner > span:first'), pag_width)
                }
                else if (type.indexOf('last') != -1) {
                    if (opts.dbclick == false)
                        opts.callback.call($(this), $('.paginate-body > .paginate-body-inner > span:last').text())
                    movement_pagination($('.paginate-body > .paginate-body-inner > span:last'), pag_width)
                }
                else if (type.indexOf('previous') != -1) {
                    var number = parseInt($('.paginate-body > .paginate-body-inner > .paginate_active').text());
                    if (number > 1) {
                        if (opts.dbclick == false)
                            opts.callback.call($(this), number - 1)
                        movement_pagination($('.paginate-body > .paginate-body-inner > .paginate_active').prev(), pag_width)
                    }
                }
                else if (type.indexOf('next') != -1) {
                    var number = parseInt($('.paginate-body > .paginate-body-inner > .paginate_active').text());
                    var last = parseInt($('.paginate-body > .paginate-body-inner > span:last').text());
                    if (number < last) {
                        if (opts.dbclick == false)
                            opts.callback.call($(this), number + 1)
                        movement_pagination($('.paginate-body > .paginate-body-inner > .paginate_active').next(), pag_width)
                    }
                }
            }
        })

        $(document).on('dblclick', this.selector, function() {
            if (opts.dbclick == true) {
                var parent = $(this).parent('.paginate-body-inner')
                if (parent.length != 0) {
                    parent.children('.paginate_active').removeClass('paginate_active').addClass('paginate_button')
                    $(this).addClass('paginate_active').removeClass('paginate_button')
                }
            }
        })

        var movement_pagination = function(obj, pag_width) {
            var parent_width = obj.closest('.paginate-body').outerWidth(true)
            if (pag_width >= parent_width) {
                var left = obj.position().left
                var margin_left = obj.parent().css('margin-left')
                margin_left = parseInt(margin_left.substr(0, margin_left.length - 2))
                margin_left -= left - parent_width / 2
                if (left > 3 * parent_width / 4) {
                    if ((parent_width - pag_width) > margin_left)
                        margin_left = parent_width - pag_width
                    obj.parent().animate({"margin-left": margin_left + "px"})
                }
                else if (left < parent_width / 4) {
                    if (margin_left > 0)
                        margin_left = 0
                    obj.parent().animate({"margin-left": margin_left + "px"})
                }
            }
        }
        $.fn.paginate.remove_lastpage = function(page) {
            var inner = $('.dataTables_wrapper #dyntable_paginate .paginate-body-inner')
            if (page < inner.children('span').length)
                if (inner.children('span').length > 1)
                    inner.children('span:last').remove()
        }
    }
})(jQuery);