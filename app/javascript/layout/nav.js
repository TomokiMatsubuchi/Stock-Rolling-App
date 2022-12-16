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
        if (scroll >= headerH){//headerの高さ以上になったら
                $('#header').addClass('md:fixed');//fixedというクラス名を付与
            }else{//それ以外は
                $('#header').removeClass('md:fixed');//fixedというクラス名を除去
            }
    }
    
    // 画面をスクロールをしたら動かしたい場合の記述
    $(window).scroll(function () {
        FixedAnime();/* スクロール途中からヘッダーを出現させる関数を呼ぶ*/
    });
    
    // ページが読み込まれたらすぐに動かしたい場合の記述
    $(window).on('load', function () {
        FixedAnime();/* スクロール途中からヘッダーを出現させる関数を呼ぶ*/
    });
})