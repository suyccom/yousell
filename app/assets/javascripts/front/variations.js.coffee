$ ->
  variations_run_on_load()
$(window).bind 'page:change', ->
  variations_run_on_load()

variations_run_on_load = ->
  $('.name-tag').blur ->
    # Get the value and process it
    valor = this.value
    valor = valor.toUpperCase()
    if valor.length > 3
      valor = valor.substring(0,3)

    # Set it on Code input if necessary
    code_input = $(this).parents('div.span0').first().find('input.code-tag').first()
    if code_input.val() == ''
      code_input.val(valor)
