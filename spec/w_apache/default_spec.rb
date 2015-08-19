require_relative '../spec_helper'

describe 'w_apache::default' do

  before do
    stub_command("/usr/sbin/apache2 -t").and_return(true)
	  stub_command("cat /websites/examplewebsite.com/.git/config | grep https://git.examplewebsite.com/www.git").and_return(false)
	  stub_command("cat /websites/www/.git/config | grep https://git.examplewebsite.com/www.git").and_return(false)
	  stub_command("cat /websites/examplewebsite.com/admin/.git/config | grep https://git.examplewebsite.com/admin.git").and_return(false)
    stub_command("lsof -u phpmyadmin | grep phpmyadmin").and_return(true)
    stub_data_bag('w_apache').and_return(['deploykey'])
    stub_data_bag_item("w_apache", "deploykey").and_return('id' => 'deploykey', 'private_key' => '-----BEGIN RSA PRIVATE KEY-----CVIOpAIBAAKCAQEA4tcgfvo5E7HG3u+Bl1zDHmW+L4vbCE31PlCzPnUA+1iLfb6Sv1x/ibzhVsFXALP0LON5lL2/3wf6B+qH7t6JpsmYo8qsWpmKy2J7pygQYrmHsxhxxaVU2NEhZT/uhWLKzF40yJ74/of5yBxwutoESYEl1YIilPiGJaWMmQtFUlCiHa7iZQ0Rx7w+A/waxnslA1cajwb3T4PdmLK5zPd8c+089BiCXzJgrKsGSJQ0Ea/EemoU2LIwvs75P3e6necmMSpjqaZGr9s87orbKq1pNyh3/QWzn4C3OKj8QX1m/g51YkUvzTSJzLeJMZygrhSCEU4KoqmwMWW8yUmLMs2xLQIBIwKCAQEAlREGudeh2b33txJrGlLmnvJnCU1GyvFmpUr5ci+hjzovx6kemwJFLqCxVkSJoWBQAD22S80mULwZVai/ujp3tr795/o2vzGy+q5ug8ne4cpgfQFvVf7unRu23CKyr2zOaQq0+N1/DanQByih2d+5rKVTYGt1z5wAYeHRa+LVyF+ixRjZh8kl0y74V32MpWoLddDjK4t5Kcqp/YRJ+cZrj0sqZhIKotbowhbzPZm4a9s7tqbsgLzTbKZPDLqibA1sxtC0DjfavaVEG79QWw+ReNJpxXLCK6LuoiOlJTheOkkX9OT0Hmt4UKILtQsNxASzwD6omQT1L1zqj/d1G/dutwKBgQD2UbMPrhxyjQktLCM7EUCcQvs7siyPGzdCxCsYy8fLEYnHD+8BIaqbfdmzpcca5US0UluTUHBG89qshKN8GlhGqGoghxrvT9QOMvL4vz/bx5Bc3CWyAaqR0rLoPMIRyJdhxMP2oDNKw6j3dF1s6KyBlH16zGoVyhse8AJTjXhGYwKBgQDrwXHVmmV77jPv+aqEHa9sLncKu/sI3nE/Gxdc9GXsUK5LoeGHUNyPgeYNAkdZk2tcPqEv5b5lRwJaAICVQ03sF2xoyiAVo5xi6mmfypik72MK3iY+UE2Cm7/V7XvQ8wfY5g6OCdgjxgG3k3xLWFW3TSNMfhaq3G9PKrhkC3i3LwKBgQDvSA0H6vcQMTwdQNHEWeb+MnBl4EiLBH7TJPaqX47ihhDQANmMEhNyekEyLAM+stUG8Os+pelpfywyj3o+CvarCgCx4lSt9cautSaLPXE75m77HwAMAZ5hxV1WoWwRRoRtmpJ6jP6gZkxeGUTQMnuxE+eb3IRPrmN9I6p9DRXAtwKBgQCa7NXG4c2pNiIhWuxlcpfZYFzbKxKuDoTu9IuyHPKFWZcbwiZ9fkfMBOeiJhGhQ55Sj45+j6kAuaJ1qI8DAFfHCBQKWPCDP6FIUOZTEBsqjq7MoJzJ3P+8Ona/x/JHeyJp9kQUMlrVrgEg3UMM8Ofe2utPhg7lTwdRR/WDkoKHAQKBgQDeqRjEqLVs8sHu49PeVY2v/JbDhWHLmyCTP7v8tn9UA/E0JATz8/7lEr5nqGoWx7MK4AYv4QUIRH9eamkMA8TZy7gAPCCb13wllU0ntbD7Dtm0RioxGwnD4GeQEBwIQ4BdMl4wbDmPt9rhBEGkD9vGDkmbU4iHoWK8rC0EHrgCsQ+=-----END RSA PRIVATE KEY-----')
    stub_command("/usr/sbin/apache2 -t").and_return(true)
    stub_data_bag_item("w_apache", "phpmyadmin").and_return('id' => 'phpmyadmin', 'user' => 'user', 'passwd' => 'passwd')
    stub_command("ls /websites").and_return(false)
    stub_data_bag_item("w_apache", "jenkinskey").and_return('id' => 'jenkinskey', 'public_key' => 'ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com')
	  stub_data_bag_item("w_apache", "gitlabkey").and_return('id' => 'gitlabkey', 'public_key' => 'git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK')
	  stub_command("cat /root/.ssh/authorized_keys | grep \"ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com\"").and_return(false)
	  stub_command("cat /var/www/.ssh/known_hosts | grep \"git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK\"").and_return(false)
  end
  
  context 'with Ubintu 12.04 precise' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
      	node.set['w_memcached']['ips'] = ['127.0.0.1']
      	node.automatic["lsb"]["codename"] = 'precise'
        node.automatic['memory']['total'] = '4049656kB'
        node.automatic['memory']['swap']['total'] = '1024kB'
      	varnish = {
           "purge_target" => true
            }
  
  			node.set['w_common']['web_apps'] = [
          {"vhost" => {
                  "main_domain" => "example.com",
                  "aliases" => ['www.example.com', 'ex.com'],
                  "docroot" => "www"
                  },
           "deploy" => {
                  "repo_ip" => "9.9.9.9",
                  "repo_domain" => "git.examplewebsite.com",
                  "repo_url" => "https://git.examplewebsite.com/www.git"
           },
           "connection_domain" => {
                   "db_domain" => "db.example.com",
                   "webapp_domain" => "webapp.example.com",
                   "varnish_domain" => "varnish.example.com"
                  },
           "mysql" =>  [
                   {"db" => "dbname", "user" => "username", "password" => "password"},
                   {"db" => "dbname2", "user" => "username2", "password" => "password2"}
                   ],
           "varnish" => varnish
          }
  			]
  			node.set['w_varnish']['node_ipaddress_list'] = ["7.7.7.7", "8.8.8.8"]
  			node.set['apache']['access_file_name'] = '.htaccess'
  			node.set['apache']['listen_ports'] = [80]
        node.set['w_apache']['config_test_enabled'] = true
        node.set['w_apache']['monit_enabled'] = true
        node.set['w_apache']['varnish_enabled'] = true
        node.set['w_apache']['deploy']['enabled'] = true
        node.set['w_apache']['phpmyadmin']['enabled'] = true
        node.set['w_apache']['deploy']['repo_url'] = 'https://git.example.com/repo.git'
      end.converge(described_recipe)
    end

  	it 'adds apt repository multiverse, updates-multiverse, security-multiverse-src, php55 and apache2' do
  		expect(chef_run).to add_apt_repository('multiverse').with(uri: 'http://archive.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'precise', deb_src: true)
  		expect(chef_run).to add_apt_repository('updates-multiverse').with(uri: 'http://archive.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'precise-updates', deb_src: true)
  		expect(chef_run).to add_apt_repository('security-multiverse-src').with(uri: 'http://security.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'precise-security', deb_src: true)
  	end
  
    it 'runs recipe apache2' do
      expect(chef_run).to include_recipe('apache2')
    end
  
    it 'runs recipe w_apache::php, and w_apache::vhosts' do
      expect(chef_run).to include_recipe('w_apache::php')
      expect(chef_run).to include_recipe('w_apache::vhosts')
    end
  
    it 'enables firewall' do
    	expect(chef_run).to enable_firewall('ufw')
    end
  
    [80].each do |listen_port|
    	it "runs resoruce firewall_rule to open port #{listen_port}" do
      	expect(chef_run).to allow_firewall_rule('http').with(port: listen_port, protocol: :tcp)
      end
    end
  
  #	%w( config_test monit varnish_integration deploy phpmyadmin).each do |recipe|
  #		it "runs recipe w_apache::#{recipe}" do
  #			expect(chef_run).to include_recipe("w_apache::#{recipe}")
  #		end
  #	end
    end
    
  context 'with Ubintu 14.04 trusty' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_memcached']['ips'] = ['127.0.0.1']
        node.automatic["lsb"]["codename"] = 'trusty'
      	varnish = {
           "purge_target" => true
            }  
  			node.set['w_common']['web_apps'] = [
          {"vhost" => {
                  "main_domain" => "example.com",
                  "aliases" => ['www.example.com', 'ex.com'],
                  "docroot" => "www"
                  },
           "deploy" => {
                  "repo_ip" => "9.9.9.9",
                  "repo_domain" => "git.examplewebsite.com",
                  "repo_url" => "https://git.examplewebsite.com/www.git"
           },
           "connection_domain" => {
                   "db_domain" => "db.example.com",
                   "webapp_domain" => "webapp.example.com",
                   "varnish_domain" => "varnish.example.com"
                  },
           "mysql" =>  [
                   {"db" => "dbname", "user" => "username", "password" => "password"},
                   {"db" => "dbname2", "user" => "username2", "password" => "password2"}
                   ],
           "varnish" => varnish
          }
  			]
        node.set['w_varnish']['node_ipaddress_list'] = ["7.7.7.7", "8.8.8.8"] 
      end.converge(described_recipe)
    end
    
  	it 'adds apt repository multiverse, updates-multiverse, security-multiverse-src, php55 and apache2' do
  		expect(chef_run).to add_apt_repository('multiverse').with(uri: 'http://archive.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'trusty', deb_src: true)
  		expect(chef_run).to add_apt_repository('updates-multiverse').with(uri: 'http://archive.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'trusty-updates', deb_src: true)
  		expect(chef_run).to add_apt_repository('security-multiverse-src').with(uri: 'http://security.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'trusty-security', deb_src: true)
  	end
    
  end

end
