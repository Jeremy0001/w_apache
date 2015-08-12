include_recipe 'git'

directory "/var/www/.ssh" do
  owner 'www-data'
  group 'www-data'
  mode '0700'
  action :create
end

private_key = data_bag_item('w_apache', 'deploykey')['private_key']

file '/var/www/.ssh/id_rsa' do
  content private_key
  owner 'www-data'
  group 'www-data'
  mode '600'
end

jenkins_pub = data_bag_item('w_apache', 'jenkinskey')['public_key']

file '/root/.ssh/jenkins_pub' do
  content jenkins_pub
  owner 'root'
  group 'root'
end

execute 'add and delete jenkins_pub' do
  command 'cat /root/.ssh/jenkins_pub >> /root/.ssh/authorized_keys && rm /root/.ssh/jenkins_pub'
  not_if "cat /root/.ssh/authorized_keys | grep \"#{jenkins_pub}\""
end

gitlab_pub = data_bag_item('w_apache', 'gitlabkey')['public_key']

file '/var/www/.ssh/gitlab_pub' do
  content gitlab_pub
  owner 'www-data'
  group 'www-data'
end

execute 'add and delete gitlab_pub' do
  command 'cat /var/www/.ssh/gitlab_pub >> /var/www/.ssh/known_hosts && rm /var/www/.ssh/gitlab_pub && chown www-data.www-data /var/www/.ssh/known_hosts'
  not_if "cat /var/www/.ssh/known_hosts | grep \"#{gitlab_pub}\""
end

node['w_common']['web_apps'].each do |web_app|

	if web_app['deploy'].has_key? 'repo_ip' then
	
		repo_ip = web_app['deploy']['repo_ip']
		repo_domain = web_app['deploy']['repo_domain']
	
		hostsfile_entry repo_ip do
		  hostname repo_domain
		  action :append
		  unique true
		end
	end

  vhost = web_app['vhost']
  dir = vhost['docroot'] ? vhost['docroot'] : vhost['main_domain']
  dir = '/websites/' + dir
	url = web_app['deploy']['repo_url']
	
	execute "git init for #{url}" do
	  cwd dir
	  command 'git init'
	  user 'www-data'
	  group 'www-data'
	  creates "#{dir}/.git/HEAD"
	end
	
	execute "git remote add origin #{url}" do
	  cwd dir
	  user 'www-data'
	  group 'www-data'
	  not_if "cat #{dir}/.git/config | grep #{url}"
	end

end