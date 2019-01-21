$( "#user_id" ).change(function() {
  update_user();
});

function visible_show(){
  document.getElementById('formulaire').style.display = "block";
  document.getElementById('user_time_entry').style.display = "none";
}

function created(date,remainHour) {
    var action = $("#new_time_entry").attr("action");
    $("#new_time_entry").attr("action", action.replace("easytt/edit/", "easytt/create/"));
    date = new Date(date.toString());
    console.log(date);
    document.getElementById('time_entry_project_id').value =null; 
    document.getElementsByClassName('typeForm')[0].innerHTML = "Creation";
    document.getElementById('time_entry_spent_on').valueAsDate = date;
    document.getElementById('time_entry_hours').value = remainHour;
    document.getElementById('time_entry_activity_id').value =null;
    document.getElementById('button_duplicate').style.display ='none';
    visible_show();
  }
function hide(){
  document.getElementById('formulaire').style.display = "none";
  document.getElementById('user_time_entry').style.display = "block";
}

function duplicate()
{
  var action = $("#new_time_entry").attr("action");
  $("#new_time_entry").attr("action", action.replace("easytt/edit/", "easytt/create/"));
  getElementById("new_time_entry").submit();
}

function edit(entry) {
  var action = $("#new_time_entry").attr("action");
  $("#new_time_entry").attr("action", action.replace("easytt/create/", "easytt/edit/"));
  document.getElementsByClassName('typeForm')[0].innerHTML = "Edition";
  document.getElementById('time_entry_project_id').value =entry.project_id; 
  document.getElementById('time_entry_issue_id').value = entry.issue_id;
  date = new Date(entry.spent_on.toString());
  document.getElementById('time_entry_spent_on').valueAsDate = date;
  document.getElementById('time_entry_hours').value = entry.hours;
  document.getElementById('time_entry_comments').value = entry.comments;
  document.getElementById('time_entry_activity_id').value =entry.activity_id;
  document.getElementById('id').value = entry.id;
  document.getElementById('button_duplicate').style.display ='block';
  visible_show();
}
function showUserList(){
  document.getElementById('button_users').style.display = "none";
  document.getElementById('form_user').style.display = "block"
}
function update_user(){
  var t = document.getElementById('user_id').value;
  var url = window.location.href;
  var a = url.split('/');
  url = url.replace('/index/'+a[5]+'/','/index/'+t+'/');
  window.location.href = url;
}
function update_view(){
  var t = document.getElementById('select_view').value;
  var url = window.location.href;
  var a = url.split('/');
  url = url.replace('/'+a[6]+'/','/'+t+'/');
  console.log(url);
  window.location.href = url;
  
}