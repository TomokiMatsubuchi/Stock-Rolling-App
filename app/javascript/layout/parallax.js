document.addEventListener('turbolinks:load', function() {
    $(function () {
        var parallaxContent = $("#parallax");
        var parallaxNum = parallaxContent.offset().top;
        var parallaxFactor = 1.0;
        var windowHeight = $(window).height();
        var scrollYStart = parallaxNum - windowHeight;
        $(window).on('scroll', function () {
            var scrollY = $(this).scrollTop();
            if (scrollY > scrollYStart) {
                parallaxContent.css('background-position-y', (scrollY - parallaxNum) * parallaxFactor + 'px');
            } 
    });
});
})