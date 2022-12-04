
document.addEventListener('turbolinks:load', () => {
    $(function() {
        $('.hamburger').click(function() {
            $(this).toggleClass('active');
            if ($(this).hasClass('active')) {
                $('.globalMenuSp').addClass('active');
            } else {
                $('.globalMenuSp').removeClass('active');
            }
        });
    });
})