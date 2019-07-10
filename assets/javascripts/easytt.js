$( "#user_id" ).change(function() {
  update_user();
});

function visible_show(){
  document.getElementById("formulaire").style.display = "block";
  document.getElementById("user_time_entry").style.display = "none";
}

function hide(){
  document.getElementById('formulaire').style.display = "none";
  document.getElementById('user_time_entry').style.display = "block";
}

function created(date,remainHour) {
  var t = document.getElementById("select_view").value;
  if (!((t == "month") || (t == "workmonth"))){
    document.getElementById("zone-flotante").style.position = "initial";
  }else{
    document.getElementById("zone-flotante").style.position = "fixed";
  }
  var action = $("#new_time_entry").attr("action");
  action = action.split('/')
  action[2] = "create";
  $("#new_time_entry").attr("action", action.join('/'));
  document.getElementById("time_entry_project_id").value =null; 
  document.getElementById("time_entry_activity_id").value =null;
  document.getElementById("time_entry_spent_on").valueAsDate = new Date(date.toString());;
  document.getElementById("time_entry_hours").value = remainHour;
  document.getElementsByClassName("typeForm")[0].innerHTML = "Creation";
  document.getElementById("multiple-specific").style.display ="none";
  document.getElementById("multiple").style.display = "block";
  document.getElementById("button_duplicate").style.display ='none';
  visible_show();
}

function multiple_create(){
  var action = $("#new_time_entry").attr("action");
  action = action.split('/')
  action[2] = "multiple_create";
  $("#new_time_entry").attr("action", action.join('/'));
  document.getElementsByClassName('typeForm')[0].innerHTML = "Multiple Creation";
  document.getElementById("date_end").valueAsDate = document.getElementById('time_entry_spent_on').valueAsDate;
  document.getElementById("multiple-specific").style.display = "block";
}

function calc()
{
  if (document.getElementById("choice").checked) 
  {
    multiple_create();
  } else {
    var action = $("#new_time_entry").attr("action");
    document.getElementById("multiple-specific").style.display ="none";
    document.getElementsByClassName("typeForm")[0].innerHTML = "Creation";
    $("#new_time_entry").attr("action", action.replace("easytt/multiple_create/", "easytt/create/"));
  }
}

function duplicate()
{
  var action = $("#new_time_entry").attr("action");
  $("#new_time_entry").attr("action", action.replace("easytt/edit/", "easytt/create/"));
  $("#new_time_entry").attr("action", action.replace("easytt/multiple_create/", "easytt/create/"));
  getElementById("new_time_entry").submit();
}

function edit(entry) {
  var t = document.getElementById('select_view').value;
  if (!((t == "month") || (t == "workmonth"))){
    document.getElementById("zone-flotante").style.position = 'initial';
  }else{
    document.getElementById("zone-flotante").style.position = 'fixed';
  }
  var action = $("#new_time_entry").attr("action");
  action = action.split('/')
  action[2] = "edit";
  $("#new_time_entry").attr("action", action.join('/'));
  document.getElementsByClassName("typeForm")[0].innerHTML = "Edition";
  document.getElementById("time_entry_project_id").value =entry.project_id; 
  document.getElementById("time_entry_issue_id").value = entry.issue_id;
  document.getElementById("time_entry_spent_on").valueAsDate = new Date(entry.spent_on.toString());
  document.getElementById("time_entry_hours").value = entry.hours
  document.getElementById("time_entry_comments").value = entry.comments;
  document.getElementById("time_entry_activity_id").value =entry.activity_id;
  document.getElementById("id").value = entry.id;
  document.getElementById("multiple").style.display = "none";
  document.getElementById("multiple-specific").style.display ="none";
  document.getElementById("button_duplicate").style.display ="block";
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
  window.location.href = url;
}

function go_toDate(){
  var url = window.location.href;
  var a = url.split('/');
  wishDay = document.getElementById("active-day").value.toString();
  a[7] = wishDay;
  if (a[7] !=""){
    window.location.href = a.join('/');
  }
}