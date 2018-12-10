Redmine::Plugin.register :iotbzh do
  name 'Iot.Bzh plugin'
  author 'Loïc Collignon'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://iot.bzh'
  author_url 'https://iot.bzh/en/team/portfolio/collignon-loic'

  menu :top_menu, :easytt, { :controller => 'easytt', :action => 'index' }, :caption => 'EasyTT'
end
