document.addEventListener("DOMContentLoaded", function () {
    const menuToggle = document.getElementById("menu-toggle");
    const sidebarMenu = document.getElementById("sidebar-menu");
    const menuOverlay = document.getElementById("menu-overlay");

    // 768px以上の場合はメニューを開閉しない
    function handleResize() {
        if (window.innerWidth >= 768) {
            sidebarMenu.classList.remove("open");
            menuOverlay.classList.remove("open");
        }
    }

    if (menuToggle && sidebarMenu && menuOverlay) {
        menuToggle.addEventListener("click", function () {
            sidebarMenu.classList.toggle("open");
            menuOverlay.classList.toggle("open");
        });

        menuOverlay.addEventListener("click", function () {
            sidebarMenu.classList.remove("open");
            menuOverlay.classList.remove("open");
        });

        // 画面サイズが変更された際に開閉状態をリセット
        window.addEventListener("resize", handleResize);
    }
});