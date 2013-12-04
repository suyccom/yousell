$ ->
  flashCallback = ->
    $(".alert").fadeOut()
  $(".alert").bind 'click', (ev) =>
    $(".alert").fadeOut()
  setTimeout flashCallback, 4000


  $(".search-query").on "keypress", ->
    $("form.search-products").submit()
    $("div.search-products").submit()

  $("#search-products").on "click", ->
    valor = $("#textarea-transfer").val()
    $("#clon-textarea").val(valor) 


@check_toggle = ->
  $("input[type='checkbox']").click()


