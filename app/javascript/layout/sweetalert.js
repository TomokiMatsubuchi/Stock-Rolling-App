document.addEventListener('turbolinks:load', function() {
  if ($('div').hasClass('alert-notice')){
    Swal.fire({
      title: $('.alert-notice').text(),
      icon: 'success',
      timer: "2000" ,
      showConfirmButton: false
  })
  }else if ($('div').hasClass('alert-warn')){
    Swal.fire({
      title: $('.alert-warn').text(),
      icon: 'warning',
      timer: "2000" ,
      showConfirmButton: false
  })
  }else if ($('div').hasClass('alert-error')){
    Swal.fire({
      title: $('.alert-error').text(),
      icon: 'error',
      timer: "2000" ,
      showConfirmButton: false
  })
  }else if ($('div').hasClass('alert-alert')){
    Swal.fire({
      title: $('.alert-alert').text(),
      icon: 'info',
      timer: "2000" ,
      showConfirmButton: false
  })}
});