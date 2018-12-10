# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'easytt', :to => 'easytt#index'
get 'easytt/:viewtype', :to => 'easytt#index'
get 'easytt/:viewtype/:refdate', :to => 'easytt#index'
