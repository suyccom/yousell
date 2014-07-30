$ ->
  add_products_run_only_once()
  add_products_run_always()
$(window).bind 'page:change', ->
  add_products_run_always()


add_products_run_only_once = ->
  $('a.add-product-button').on 'click', (e) ->
    e.preventDefault()
    if $('#barcode').val().length > 0
      $.ajax({
        url: '/product_types/new_from_barcode',
        data: 'barcode=' + $('#barcode').val(),
        dataType: 'script'
      })
    else
      clone = $('#products-table tr:last').clone()
      selects = $('#products-table tr:last').find("select");
      $(selects).each (i) ->
        select = this
        $(clone).find("select").eq(i).val($(select).val())
      $(clone).appendTo("#products-table")

  # We hook this callback like so as the dom is changing when you click on minus.
  $(document).on 'click', 'a.remove-product-button', (e) ->
    e.preventDefault()
    if $('#products-table tr').length > 2
      $(this).parent().parent().fadeOut 150, ->
        $(this).remove()

add_products_run_always = ->
  # This is related to the impediment of the use of ENTER key (see yousell.js.coffee). 
  # This way we workaround the use of ENTER key, just for barcode readers.
  $('#add-product-form input.barcode').keydown (e) ->
    if (e.keyCode == 13)
      e.preventDefault()
      $('#add-product-form button').click()
