Scripts for setting up .Net web server on Ubuntu. The script will setup mono
from source. Install nginx webserver, setup and run fastcgi-mono-server4 
for .net 4.0 web apps.

To run script: 
chmod -x install_mono.sh
sudo ./install_mono.sh

fastcgi-mono-server4 will be running at: 127.0.0.1:9000

Summary:

	Web app files: /var/www/
	Site config: /etc/nginx/sites-available 
	Enabled sites: /etc/nginx/sites-enabled
	fastcgi enable: /etc/mono/fastcgi

After successful install follow the procedures to get asp.net/mvc/nancy app
deployed.

Configuration for the virtual directories go in:
/etc/nginx/sites-available

Create a file called: your.domain.xyz, and paste the sample configuration into
the file. Replacing your.domain.xyz with your domain name.

	server{
		listen 80;
		server_name your.domain.xyz;
		access_log /var/log/nginx/your.domain.xyz;
	
		location /{
			root /var/www/your.domain.xyz/;
			fastcgi_pass 127.0.0.1:9000;
			include /etc/nginx/fastcgi_params;
		}
	}

The fastcgi start script tells fastcgi-mono-server4 where to find that apps 
to serve. The config files are located at "/etc/mono/fastcgi". cd to this 
directory and create a file called your.domain.xyz.webapp and copy:

	<apps>
		<web-application>
			<name>name_of_app</name>
			<vhost>your.domain.xyz</vhost>
			<vport>80</vport>
			<vpath>/</vpath>
			<path>/var/www/your.domain.xyz</path>
		</web-application>
	</apps>

copy your web app files to: 
/var/www/your.domain.xyz <--- create the directory
All web app files get deployed to /var/www/

Now enable the site: 
sudo ln -s /etc/nginx/sites-available/your.domain.xyz /etc/nginx/sites-enabled/your.domain.xyz

restart nginx:

service nginx restart
