document.addEventListener('turbolinks:load', function() {
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

    function FixedAnime() {
        var headerH = $('#header').outerHeight(true);
        var scroll = $(window).scrollTop();
        if (scroll >= headerH){
                $('#header').addClass('md:fixed');
            }else{
                $('#header').removeClass('md:fixed');
            }
    }
    $(window).scroll(function () {
        FixedAnime();
    });
    $(window).on('load', function () {
        FixedAnime();
    });
})