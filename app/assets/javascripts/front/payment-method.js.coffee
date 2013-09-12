$ ->
  payment_modal()
$(window).bind 'page:change', ->
  payment_modal()

payment_modal = ->
  # We register click event like this in order to make it work after modal-submit-button-ajax-call :)
  $(document).on 'click', '.payment-method', ->
    $('.modal-header h3').html(this.id)
    $("input[name='payment_amount']").val('')
    $("input[name='payment_method_id']").val( $(this).data('method-id') )
