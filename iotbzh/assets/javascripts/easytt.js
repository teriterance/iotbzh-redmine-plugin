
function visible_show(){
  document.getElementById('formulaire').style.display = "block";
}

function created(date,remainHour) {
    var action = $("#new_time_entry").attr("action");
    $("#new_time_entry").attr("action", action.replace("easytt/edit/", "easytt/create/"));
    date = new Date(date.toString());
    console.log(date);
    document.getElementsByClassName('typeForm')[0].innerHTML = "Creation form";
    document.getElementById('time_entry_spent_on').valueAsDate = date;
    document.getElementById('time_entry_hours').value = remainHour;
    visible_show();
  }
function hidde(){
  document.getElementById('formulaire').style.display = "none";
}

function edit(entry) {
  var action = $("#new_time_entry").attr("action");
  $("#new_time_entry").attr("action", action.replace("easytt/create/", "easytt/edit/"));
  document.getElementsByClassName('typeForm')[0].innerHTML = "Edition form";
  document.getElementById('time_entry_project_id').value =entry.project_id; 
  document.getElementById('time_entry_issue_id').value = entry.issue_id;
  date = new Date(entry.spent_on.toString());
  document.getElementById('time_entry_spent_on').valueAsDate = date;
  document.getElementById('time_entry_hours').value = entry.hours;
  document.getElementById('time_entry_comments').value = entry.comments;
  document.getElementById('time_entry_activity_id').value =entry.activity_id;
  document.getElementById('id').value = entry.id;
  visible_show();
}
function showUserList(){
  document.getElementById('button_users').style.display = "none";
  document.getElementById('form_user').style.display = "block"
}