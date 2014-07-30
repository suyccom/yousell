$ ->
  flashCallback = ->
    $(".alert").fadeOut()
  $(".alert").bind 'click', (ev) =>
    $(".alert").fadeOut()
  setTimeout flashCallback, 4000

  $(".search-query").keyup ->
    $("form.search-products").submit()

  $("#search-products").on "click", ->
    valor = $("#textarea-transfer").val()
    $("#clon-textarea").val(valor) 
    valor2 = $("#selected_products_ids").val()
    $("#clon-lines").val(valor2) 

  $(".modal").on "shown", -> 
    $("#payment_modal").focus()

  # Don't allow ENTER key press on whole app, in order to avoid double POSTing in some forms. Besides, the app is for touchscreens! (no ENTER key) :)
  $(document).on "keypress", (event) ->
    if event.keyCode is 13
      event.preventDefault()
      false

  $(document).on "focus", "#line_discount, #line_amount, #sale_total_discount", ->
    $(this).select()

@check_toggle = ->
  $("input[type='checkbox']").click()


