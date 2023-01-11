const searchBtn = document.querySelector("#search_button");

searchBtn.addEventListener("click", mem);
/*
function search() {
    var info = document.getElementById("search_info").value;
    location.href = "/adm/search/" + info;
    var query = sanitize(url.parse(request.url, true).query.query);
    var searchType = "name"; //type 설정 받기
    if(searchType == "name") {
        SELECT * FROM user_table WHERE user_name '%${info}%';
    } else if(searchType == "id") {
        SELECT * FROM user_table WHERE user_id '%${info}%';
    }
}
*/
//엔터키로 검색
function searchEnter(e) {
    if (e.keyCode == 13) {
        search();
    }
}
//화면 이동
function manage(){
    location.href = "/admin/auth/manage";
}
function regiAll(){
    location.href = "/admin/auth/regiAll";
}
function signUp(){
    location.href = "/admin/auth/signUp";
}

function mem(){
    fetch("/mem",{
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(),
    })
    .then((res) => res.json())
}