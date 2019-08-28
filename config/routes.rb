# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'easytt', :to => 'easytt#index'
get 'easytt/index', :to => 'easytt#index'
get 'easytt/index/:userid', :to => 'easytt#index'
get 'easytt/index/:userid/:viewtype', :to => 'easytt#index'
get 'easytt/index/:userid/:viewtype/:refdate', :to => 'easytt#index'

get 'easytt/delete/:id', :to => 'easytt#delete'
get 'easytt/drop_drag/:userid/:viewtype/:refdate/:id/:rdate',    :to => 'easytt#drop_drag'
post 'easytt/edit/:userid/:viewtype/:refdate',  :to => 'easytt#edit'
post 'easytt/create/:userid/:viewtype/:refdate',    :to => 'easytt#create'
post 'easytt/multiple_create/:userid/:viewtype/:refdate',    :to => 'easytt#multiple_create'
post 'easytt/other_user/:viewtype/:refdate',    :to => 'easytt#other_user'
