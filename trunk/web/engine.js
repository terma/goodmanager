function firmLastContacts() {
    var parentNode = document.getElementById("showfirmlastcontacts").parentNode;
    $("#showfirmlastcontacts").remove();
    $(parentNode).append("Момент...");
    $("#firmlastcontacts").load("/security/firmlastcontacts.jsp");
}