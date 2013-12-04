$ ->
  flashCallback = ->
    $(".alert").fadeOut()
  $(".alert").bind 'click', (ev) =>
    $(".alert").fadeOut()
  setTimeout flashCallback, 4000


  $(".search-query").on "keypress", ->
    $("form.search-products").submit()

@check_toggle = ->
  $("input[type='checkbox']").click()


