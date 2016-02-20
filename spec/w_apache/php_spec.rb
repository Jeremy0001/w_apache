require_relative '../spec_helper'

describe 'w_apache::php' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['w_apache']['xdebug_enabled'] = true
      node.set['w_common']['web_apps'] = web_apps
      node.set['w_memcached']['ips'] = ['127.0.0.1']
      node.set['php']['ini_settings']['max_execution_time'] = 30
      node.set['php']['fpm_log_dir'] = '/var/log/php-fpm'
    end.converge(described_recipe)
  end

  %w( php-pear php5-dev ).each do |package|
    it "installs #{package} package" do
      expect(chef_run).to install_package(package)
    end
  end

  it 'runs recipe php::fpm' do
    expect(chef_run).to include_recipe('php::fpm')
  end

  it 'runs resource php-fpm' do
    expect(chef_run).to add_php_fpm('php-fpm').with(user: 'www-data', group: 'www-data', socket: true, socket_path: '/var/run/php5-fpm.sock', terminate_timeout: 50, valid_extensions: %w( .php .htm .php3 .html .inc .tpl .cfg ), value_overrides: {
    :error_log => "/var/log/php-fpm/php-fpm.log"
  })
  end

  %w( mysql memcached gd pspell curl ).each do |package|
    it "installs php5-#{package} package" do
      expect(chef_run).to install_package("php5-#{package}")
    end
  end

  it 'enables firewall and run resource firewall_rule to allow port 9000' do
    expect(chef_run).to install_firewall('default')
    expect(chef_run).to create_firewall_rule('xdebug').with(port: 9000, protocol: :tcp)
  end
end
