$ ->
  add_products_run_only_once()
  add_products_run_always()
$(window).bind 'page:change', ->
  add_products_run_always()


add_products_run_only_once = ->
  $(document).on 'click', 'a.add-product-button', (e) ->
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
      $(clone).hide().appendTo("#products-table").fadeIn(250)

  $(document).on 'click', 'a.remove-product-button', (e) ->
    if $('#products-table tr').length > 2
      $(this).parent().parent().fadeOut 250, ->
        $(this).remove();
    e.preventDefault()
  
add_products_run_always = ->
  $('#barcode').keydown (e) ->
    if (e.keyCode == 13)
      e.preventDefault()
      $('.add-product-button').click()
