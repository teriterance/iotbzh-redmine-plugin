$( "#user_id" ).change(function() {
  update_user();
});

function visible_show(){
  document.getElementById('formulaire').style.display = "block";
  document.getElementById('user_time_entry').style.display = "none";
}
function empty_form(){
  document.getElementById('time_entry_project_id').value =null; 
    document.getElementsByClassName('typeForm')[0].innerHTML = "Creation";
    document.getElementById('time_entry_activity_id').value =null;
    document.getElementById('button_duplicate').style.display ='none';
}

function created(date,remainHour) {
    var action = $("#new_time_entry").attr("action");
    $("#new_time_entry").attr("action", action.replace("easytt/edit/", "easytt/create/"));
    date = new Date(date.toString());
    document.getElementById('button-edit-create').display = 'block'
    document.getElementById('champ2').display = 'none'
    document.getElementById('time_entry_spent_on').valueAsDate = date;
    document.getElementById('time_entry_hours').value = remainHour;
    console.log(date);
    empty_form();
    visible_show();
  }
function hide(){
  document.getElementById('formulaire').style.display = "none";
  document.getElementById('champ2').display = "none"
  document.getElementById('user_time_entry').style.display = "block";
}

function duplicate()
{
  var action = $("#new_time_entry").attr("action");
  $("#new_time_entry").attr("action", action.replace("easytt/edit/", "easytt/create/"));
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
  document.getElementById('button-edit-create').display = "block"
  document.getElementById('champ2').display = "none"
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
  wishDay = document.getElementById("date").value.toString();
  a[7] = wishDay;
  if (a[7] !=""){
    window.location.href = a.join('/');
  }
  console.log(a)
}

function multiple_edit_activate(){
  visible_show();
  document.getElementById('button-edit-create').display = 'none'
  document.getElementById('champ2').display = 'block'
  empty_form();
}

function multiple_create(){
  document.getElementById('champ2').display = 'block'
  document.getElementById('button-edit-create').display = 'none'
  var xhr_object = null; 
  if(window.XMLHttpRequest) // Firefox 
    xhr_object = new XMLHttpRequest(); 
  else if(window.ActiveXObject) // Internet Explorer 
    xhr_object = new ActiveXObject("Microsoft.XMLHTTP"); 
  else { // XMLHttpRequest non supporté par le navigateur 
    alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest..."); 
    return;
  } 
  var project_id = document.getElementById('time_entry_project_id').value;
  var time_entry_activity_id = document.getElementById('time_entry_activity_id').value;
  var time_entry_spent_on = document.getElementById('time_entry_spent_on').value;
  time_entry_spent_on = new Date(time_entry_spent_on);
  console.log(time_entry_spent_on);
  var hours = document.getElementById('time_entry_hours').value;
  var date2 = document.getElementById('date2');
  date2 = new Date(date2);
  var time_entry_hours = document.getElementById('time_entry_hours').value;
  var time_entry_comments = document.getElementById('time_entry_comments').value;
  
  if(project_id != null && time_entry_activity_id!=null && time_entry_spent_on!=null && date2!= null && hours!=null){
  console.log(time_entry_spent_on);
  var data = {
              "commit": "Ok",
              "authenticity_token": arguments.token,                 
              "time_entry[project_id]": project_id,         
              "time_entry[issue_id]": "",         
              "time_entry[spent_on]": time_entry_spent_on,         
              "time_entry[hours]": hours,         
              "time_entry[comments]": "",         
              "time_entry[activity_id]": time_entry_activity_id,  
              "id":"",       
            }
  
  console.log(time_entry_spent_on+1);
  xhr_object.open('POST',  "easytt/create", true);
  xhr_object.send(JSON.stringify(data));
  }

}