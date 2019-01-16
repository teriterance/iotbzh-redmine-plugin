# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'easytt', :to => 'easytt#index'
get 'easytt/index', :to => 'easytt#index'
get 'easytt/index/:viewtype', :to => 'easytt#index'
get 'easytt/index/:viewtype/:refdate', :to => 'easytt#index'

get 'easytt/delete/:id', :to => 'easytt#delete'
post 'easytt/edit/:viewtype/:refdate',  :to => 'easytt#edit'
post 'easytt/create/:viewtype/:refdate',    :to => 'easytt#create'
post 'easytt/other_user/:viewtype/:refdate',    :to => 'easytt#other_user'