// ==UserScript==
// @name         AOJ save latest language
// @namespace    http://orisano.github.io/scripts/
// @version      1.0
// @description  直近の提出言語を記憶してくれる
// @author       @orisano
// @match        http://judge.u-aizu.ac.jp/onlinejudge/status.jsp
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    function main() {
        var $submit_button = document.getElementById("submitButton");
        var $submit_language = document.getElementById("submit_language");
        var latest_language = localStorage.getItem("latest_language");
        if (latest_language) $submit_language.value = latest_language;
        $submit_button.addEventListener("click", function() {
            localStorage.setItem("latest_language", $submit_language.value);
        }, false);
    }
    if (["complete", "loaded", "interactive"].indexOf(document.readyState) != -1) {
        main();
    } else {
        document.addEventListener("DOMContentLoaded", main, false);
    }
})();
