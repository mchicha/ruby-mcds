namespace :rubber do

  namespace :wkhtmltopdf do

    rubber.allow_optional_tasks(self)

    after "rubber:install_packages", "rubber:wkhtmltopdf:install"

    desc "install wkhtmltopdf see http://wkhtmltopdf.org/downloads.html"
    task :install, :roles => :unicorn do
      rubber.sudo_script 'install_wkhtmltopdf', <<-ENDSCRIPT
        if ! which wkhtmltopdf &> /dev/null; then
          apt-get install -y wkhtmltopdf
          apt-get remove -y wkhtmltopdf --purge
          cd /usr/local/bin
          chown ubuntu:ubuntu /usr/local/bin
          wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-precise-amd64.deb
          dpkg -x wkhtmltox-0.12.2.1_linux-precise-amd64.deb foo
          mv foo/usr/local/bin/* /usr/local/bin
          rm -rf foo
          rm wkhtmltox-0.12.2.1_linux-precise-amd64.deb
        fi
      ENDSCRIPT
    end

  end
end

# apt-get autoremove

# dpkg wkhtmltox-0.12.2.1_linux-precise-amd64.deb tmp
# mv tmp/usr/local/bin/* /usr/local/bin
# rm -rf tmp
# rm wkhtmltox-0.12.2.1_linux-precise-amd64.deb


# apt-get install -y wkhtmltopdf
# apt-get remove -y wkhtmltopdf --purge
# cd /usr/local/bin
# wget http://downloads.sourceforge.net/project/wkhtmltopdf/0.12.2.1/wkhtmltox-0.12.2.1.tar.bz2
# tar -xvjf wkhtmltox-0.12.2.1.tar.bz2
# rm -rf wkhtmltox-0.12.2.1.tar.bz2
# sudo wkhtmltox-0.12.2.1/scripts/build.py setup-schroot-precise
# sudo python wkhtmltox-0.12.2.1/scripts/build.py precise-amd64
