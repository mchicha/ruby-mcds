Welcome to the McDonald's Program Dashboard!
======================

## Getting Started

##### Clone repositories:

    - McSource: https://github.com/Tukaiz/mcds-program-dashboard
    - CAS: https://github.com/Tukaiz/backstage-2-cas
    - DAM: https://github.com/Tukaiz/digital_asset_manager

ruby-2.1.2 may not be installed.
To install do:

```
rvm install ruby-2.1.2’
```

#### Retrieve Dump Files:

You will need a dump file for McSource and CAS

**Note that if you have access to the application.yml file, you will be able to use a rake task to pull CAS database from production.**

#### Do the following for both McSource and CAS

- Using the config/database.yml.example file as reference, create config/database.yml
- For CAS, change socket to OSX setting (if you are on OSX)
- Make sure you have MySql running as both of these apps use MySql

```
bundle
bundle exec rake db:create

```

If you don't have application.yml file...

Import the dump file with something like the following, modifying the database name and path to the sql file as needed:

```
mysql --user=root mcds-program-dasboard_development < ~/Downloads/mcdonalds_staging_2015-08-31.
sql
```

If you do have application.yml file...

For CAS:

  1. cd into CAS directory
  2. run `rake s3:db:download`
  3. run `rake s3:db:import`

Run:

```
rake db:migrate
rake db:seed
rake db:seed_fu
```

Run your server:

```
rails s
```

#### Setup User for Authentication

1. Run rails console in mcds-program-dashboard
2. Create a new user: User.create(email: "your@email.com", password: "password", password_confirmation: "password", by_invite: false, role: 0)
3. Create the McSource site on CAS via rails console: ```Site.create(name: "McSource Online", uuid: "06545a95-88a6-4f65-99a0-2c78325b3004")```
4. Navigate to localhost:3008 and sign in with the newly created user details


## Server
http://ec2-54-190-232-236.us-west-2.compute.amazonaws.com


## Deploying
The deploy server is setup to deploy this app.  It can be found in `/vol/repos/mcds-program-dashboard/`

This repo deploys via tags.  Please read the following article to get up to speed. [http://nathanhoad.net/deploy-from-a-git-tag-with-capistrano]( http://nathanhoad.net/deploy-from-a-git-tag-with-capistrano)

To deploy run the following command.
`cap ENVIRONMENT deploy:migrations`

Example: `cap staging deploy:migrations`

## ENV Variables
Environmental variables are setup on the server in `/etc/environment`

For an example see `config/secrets.yml`
