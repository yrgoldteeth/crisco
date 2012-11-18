linkRow = (original_url, short_url) ->
  slug = short_url.split('/').pop()
  row = "<tr class='success' id='#{slug}'>"
  row += cellForUrl(original_url)
  row += cellForUrl(short_url)
  row += "<td>Just Now</td>"
  row += "<td><a href='javascript:void(0)' id='#{slug}' class='btn delete btn-danger btn-small'><i class='icon-remove'></i></a></td></tr>"
  row

cellForUrl = (url) ->
  "<td><a href='#{url}'>#{url}</a></td>"

$(document).ready ->

  $('body').timeago()

  $('a#tweetbot_link').live 'click', ->
    if $(this).text() == 'Show Tweetbot Link'
      $(this).text('Hide Tweetbot Link')
      $('.tweetbot-share').removeClass('hidden')
    else
      $(this).text('Show Tweetbot Link')
      $('.tweetbot-share').addClass('hidden')

  $('a.delete').live 'click', ->
    if confirm("Click OK to delete this link, or Cancel.")
      slug = $(this).attr('id')
      $.ajax
        type: "DELETE"
        url: "/links/#{slug}"
        success: (data) ->
          selector = "tr##{slug}"
          if data.success == true
            $(selector).remove()
          else
            $(selector).addClass('error')
    false

  $('#shorten_link').live 'click', ->
    original_url = $('#original_url').val()
    unless original_url == ''
      $.ajax
        type: "POST"
        url: "/links"
        data:
          original_url: original_url
        success: (data) ->
          $('table#links').append linkRow(original_url, data.shorturl)
        complete: () ->
          $('#original_url').val('')
    false
