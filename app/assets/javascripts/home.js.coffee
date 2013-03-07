$(document).ready ->
  fetch_item = (page, per) ->
    content = $('#dyntable_filter').children('input').val();
    type = $('#dyntable_filter').find('select').val();
    data = {page: page, per: per};
    if (content != '')
      data['type'] = type;
      data['content'] = content;
    $.ajax({
           type: 'POST',
           url: '/home/item_per_page',
           async: true,
           jsonpCallback: 'jsonCallback',
           dataType: 'json',
           data: data,
           beforeSend: () ->
             $('.stdtable > tbody').css('opacity', '0.25');
             width = $('.stdtable').parent().width()
             height = $('.stdtable').parent().height()
             $('.stdtable').prepend('<img src="/assets/loading_128.gif" style="position: absolute; left: '+(width/2-64)+'px; top: 128px" class="img-loading"/>');
           success: (response) ->
             $('.stdtable .img-loading').remove();
             $('.stdtable > tbody').empty();
             $('.stdtable > tbody').css('opacity', '1');
             showResults(response, page, per)
           });

  showResults = (response, page, per) ->
    if (per != undefined)
      $('#dyntable_paginate').empty();
      num = response.page;
      if (num > 1)
        $('#dyntable_paginate').append('<span class="first paginate_button" id="dyntable_first">'+I18n.t("common.first")+'</span><span class="previous paginate_button" id="dyntable_previous">'+I18n.t("common.previous")+'</span>')
        $('#dyntable_paginate').append('<span class="paginate-body" style="max-width: 256px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; vertical-align: middle;"><span class="paginate-body-inner"></span></span>')
        for i in [1..num]
          if (i == page)
            $('#dyntable_paginate > .paginate-body > .paginate-body-inner').append('<span class="paginate_active">'+i+'</span>');
          else
            $('#dyntable_paginate > .paginate-body > .paginate-body-inner').append('<span class="paginate_button">'+i+'</span>');
        $('#dyntable_paginate').append('<span class="next paginate_button" id="dyntable_next">'+I18n.t("common.next")+'</span><span class="last paginate_button" id="dyntable_last">'+I18n.t("common.last")+'</span>');
    else
      $('#dyntable_paginate > .paginate-body').children('.paginate-body-inner').children('.paginate_active').removeClass('paginate_active').addClass('paginate_button');
      $('#dyntable_paginate > .paginate-body').children('.paginate-body-inner').children('span:nth-child('+page+')').removeClass('paginate_button').addClass('paginate_active');
    if (response.data.length > 0)
      showInTable(response.data)
    else
      $('.stdtable > tbody').append('<tr><td colspan="5" style="text-align: center">Not Found Results</td></tr>');

  showInTable = (data) ->
    if (data == undefined || data == null || data.length == 0)
      return
    $.each(data, (index, value) ->
      $('.stdtable > tbody').append('<tr id="proid-'+value['id']+'"><td class="center"><span class="checkbox"><input type="checkbox"></span></td><td class="center">'+value['id']+'</td><td class="center">'+value['name']+'</td><td class="center">'+value['description']+'</td><td class="center">'+value['server_id']+'</td></tr>')
    )
  searchPress = (content, type) ->
    if (type == undefined)
      type = $('select.search-content').val()
    $.ajax({
           type: 'POST',
           url: '/home/item_per_page',
           async: true,
           jsonpCallback: 'jsonCallback',
           dataType: 'json',
           data: {type: type, content: content},
           beforeSend: () ->
             $('.stdtable > tbody').css('opacity', '0.25');
             width = $('.stdtable').parent().width()
             height = $('.stdtable').parent().height()
             $('.stdtable').prepend('<img src="/assets/loading_128.gif" style="position: absolute; left: '+(width/2-64)+'px; top: 128px" class="img-loading"/>');
           success: (response) ->
             $('.stdtable .img-loading').remove();
             $('.stdtable > tbody').empty();
             $('.stdtable > tbody').css('opacity', '1');
             if (response.data.length == 0)
               if (type == 'promotion_id')
                 $('#dyntable_paginate').empty();
                 $('.stdtable > tbody').empty();
                 $('.stdtable > tbody').css('opacity', '1');
                 $('.stdtable > tbody').append('<tr><td colspan="6" style="text-align: center">Not Found Results <a href="/product_promotions/new?promotion_id='+content+'">Want to Create?</a></td></tr>');
               else
                 showResults(response, 1, response.per)
             else
               showResults(response, 1, response.per);
           });

  $('#lists-item .btn-search').click(() ->
    value = $(this).parent().find('.search-content').children('option[selected="selected"]').attr('value')
    searchPress($(this).parent().children('input').val())
  )

  $('#lists-item #promotions-per-page').change(() ->
    per = $(this).val();
    fetch_item(1, per);
  )

  $('#lists-item #btn-delete button').click(() ->
    list = []
    $.each($('.stdtable > tbody').find('span.checkbox input[type=checkbox][checked=checked]'), (index, value) ->
      tr = $(value).closest('tr');
      list.push(tr.attr('id').substr(6));
    );
    if (list.length > 0)
      jConfirm(I18n.t('common.dialog.confirm.content'), I18n.t('common.dialog.confirm.title'), (r) ->
        if (r == true)
          $.each($('.stdtable > tbody').find('span.checkbox input[type=checkbox][checked=checked]'), (index, value) ->
            tr = $(value).closest('tr');
            tr.remove();
          );
          page_active = $('.dataTables_wrapper #dyntable_paginate .paginate-body-inner > .paginate_active').text()
          $.ajax({
                 type: 'POST',
                 url: '/home/remove_item',
                 async: true,
                 jsonpCallback: 'jsonCallback',
                 dataType: 'json',
                 data: {list: list, page: page_active, content: $('#dyntable_filter > input').val(), type: $('#dyntable_filter .search-content').val()},
                 success: (response) ->
                   $.fn.paginate.remove_lastpage(response.page)
                   showInTable(response.data)
                 });
      )
  )

  $('#lists-item #promo-search').keyup((e) ->
    content = $(this).val()
    if (e.which == 13)
      searchPress(content)
    else
      return;
      $.each($('.stdtable > tbody > tr'), (index, value) ->
        if ($(value).children('td:nth-child(3)').text().indexOf(content) == -1)
          $(value).hide()
        else
          $(value).show()
      );
  )
  $('#lists-item .paginate_button').paginate({callback: fetch_item})

  $('#dyntable_filter .search-content').change(() ->
    value = $(this).children('option[selected="selected"]').text()
    $('.search-select > div').text(value);
    value = $(this).children('option[selected="selected"]').attr('value')
    if (value == 'user_entered' || value == 'imported_only')
      $(this).closest('.dataTables_filter').children('input').css('display', 'none')
      $(this).closest('.dataTables_filter').children('.search-select').css({'position': 'static', 'margin-right': '28px'})
    else
      $(this).closest('.dataTables_filter').children('input').css('display', 'block')
      $(this).closest('.dataTables_filter').children('.search-select').css({'position': 'absolute', 'margin-right': '0'})
    $('#dyntable_filter > input').css('padding-left', ($('.search-select').outerWidth(true) + 4)+ 'px');
  )

  $('#dyntable_length button').click(() ->
    type = $(this).attr('type')
    if (type == 'new')
      $('body > .popup').removeClass('hide')
    else if (type == 'get')
      obj = $(this)
      $.ajax({
        type: 'POST',
        url: '/home/get_infor',
        async: true,
        jsonpCallback: 'jsonCallback',
        dataType: 'json',
        beforeSend: () ->
          obj.parent().append('<img src="/assets/starlight/loaders/loader1.gif" style="vertical-align: middle; margin: 0px 48px"/>')
          obj.remove()

        success: (response) ->
          window.location.reload()
        });
    return false;
  )

  $('body > .popup .footer button').click(() ->
    type = $(this).attr('type')
    if (type == 'cancel')
      $(this).closest('.popup').addClass('hide')
    else
      obj = $(this)
      tag_popup = $(this).closest('.popup')
      name = tag_popup.find('input:first').val()
      description = tag_popup.find('input:last').val()
      if (name == '')
        tag_popup.find('label:first').css('color', 'red')
      if (description == '')
        tag_popup.find('label:last').css('color', 'red')
      if (name == '' || description == '')
        return
      $.ajax({
        type: 'POST',
        url: '/home/add_item',
        async: true,
        jsonpCallback: 'jsonCallback',
        dataType: 'json',
        data: {name: name, description: description},
        beforeSend: () ->
          tag_popup.find('label:first').css('color', 'black')
          tag_popup.find('label:last').css('color', 'black')
          obj.remove()
        success: (response) ->
          window.location.reload()
      });
  )