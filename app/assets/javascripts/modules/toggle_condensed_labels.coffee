$ ->
  button = $('#toggle-condensed-labels')
  checkbox = button.find('input[type="checkbox"]')
  param = 'condense='

  button.click (event) ->
    event.stopPropagation()
    checkbox.toggle

  checkbox.change ->
    checked = !!this.checked
    $(this).parents('.dropdown-menu').find('a.export-label-format').each ->
      $(this).attr('href', $(this).attr('href').replace(param + !checked, param + checked))
