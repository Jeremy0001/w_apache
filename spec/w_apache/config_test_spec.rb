require_relative '../spec_helper'

describe 'w_apache::config_test' do
  context 'with default setting' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        node.set['w_memcached']['ips'] = ['127.0.0.1']
        node.set['apache']['access_file_name'] = '.htaccess'
      end.converge(described_recipe)
    end

    it 'creates config_test.php' do
      expect(chef_run).to create_template('/websites/example.com/www/config_test.php')
      expect(chef_run).to create_template('/websites/example2.com/sub/config_test.php')
      expect(chef_run).to create_template('/websites/example3.com/sub/config_test.php')
      expect(chef_run).not_to create_template('/websites/multi-repo-vhost/config_test.php')
      expect(chef_run).not_to create_template('/websites/dov/config_test.php')
    end

    it 'creates info.php' do
      expect(chef_run).to create_file('/websites/example.com/www/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/example2.com/sub/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/example3.com/sub/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/dov/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/multi-repo-vhost/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/example.com/ssl/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/example.com/ssl_disabled/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/ssl-website-wic.com/info.php').with_content('<?php phpinfo(); ?>')
    end

    it 'prepares redirect test' do
      expect(chef_run).to create_directory('/websites/example.com/www/redirect_test')
      expect(chef_run).to create_directory('/websites/example2.com/sub/redirect_test')
      expect(chef_run).to create_directory('/websites/example3.com/sub/redirect_test')
      expect(chef_run).to create_directory('/websites/dov/redirect_test')
      expect(chef_run).to create_directory('/websites/multi-repo-vhost/redirect_test')
      expect(chef_run).to create_directory('/websites/example.com/ssl/redirect_test')
      expect(chef_run).to create_directory('/websites/example.com/ssl_disabled/redirect_test')
      expect(chef_run).to create_directory('/websites/ssl-website-wic.com/redirect_test')
    end

    %w[ old new ].each do |filename|
      it "creates /websites/example.com/www/redirect_test/#{filename}file.html" do
        expect(chef_run).to create_file("/websites/example.com/www/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/example2.com/sub/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/example3.com/sub/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/dov/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/multi-repo-vhost/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/example.com/ssl/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/example.com/ssl_disabled/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/ssl-website-wic.com/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
      end
    end

    access_file_content = <<-eos
    RewriteEngine ON\n    RewriteRule ^/redirect_test/oldfile.html$ /redirect_test/newfile.html [END,R=301]
  eos

    it 'creates file /websites/example.com/www/redirect_test/.htaccess' do
      expect(chef_run).to create_file('/websites/example.com/www/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/example2.com/sub/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/example3.com/sub/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/dov/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/multi-repo-vhost/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/example.com/ssl/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/example.com/ssl_disabled/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/ssl-website-wic.com/redirect_test/.htaccess').with_content(access_file_content)
    end
  end
end
