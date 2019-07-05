# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'easytt', :to => 'easytt#index'
get 'easytt/index', :to => 'easytt#index'
get 'easytt/index/:userid', :to => 'easytt#index'
get 'easytt/index/:userid/:viewtype', :to => 'easytt#index'
get 'easytt/index/:userid/:viewtype/:refdate', :to => 'easytt#index'

get 'easytt/delete/:id', :to => 'easytt#delete'
post 'easytt/edit/:userid/:viewtype/:refdate',  :to => 'easytt#edit'
post 'easytt/create/:userid/:viewtype/:refdate',    :to => 'easytt#create'
post 'easytt/other_user/:viewtype/:refdate',    :to => 'easytt#other_user'
post 'easytt/:date_begin/:date_end',    :to => 'easytt#create_multiple'