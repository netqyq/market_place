# Market Place API

market_place is an E-commerence JSON API service.


## Ruby Version
```
ruby 2.4.0
rails 5.0.2
```

## Main Models
```
User
Product
Order
```

## Start Server

You can start the server use puma-dev, or start it using the traditional way `rails s`.

### Clone and init

```
git clone https://github.com/netqyq/market_place
cd market_place
bundle install
rake db:migrate

```

### start server use puma-dev. 
If you installed this tools, it will generate a local domain called `market_place.dev` for you and 
start the server as a daemon automatically for you. 

create file: `/usr/local/bin/pumad`
```
#!/bin/bash

if [ ! -f Gemfile ]; then
  echo "Are you sure you're in a Ruby on Rails app?"
else
  ln -s "$(pwd)" ~/.puma-dev/"$(basename `pwd`)"
  puma-dev -install
  echo "Your app should be available at http://$(basename `pwd`).dev and https://$(basename `pwd`).dev now!"
fi

```

create file: /usr/local/bin/unpumad
```
rm ~/.puma-dev/"$(basename `pwd`)"
```
makes it executable
```
chmod +x /usr/local/bin/pumad
chmod +x /usr/local/bin/unpumad
```

install puma-dev
```
brew install puma/puma/puma-dev
sudo puma-dev -setup
puma-dev -install
```

stop puma-dev
```
pkill -USR1 puma-dev
```

the daemon will be look like this
```
$ps -ef | grep puma
  501  3334     1   0  8:30AM ??         0:11.63 /usr/local/Cellar/puma-dev/0.10/bin/puma-dev -launchd -dir ~/.puma-dev -d dev -timeout 15m0s

```


more about puma-dev, see
```
https://github.com/puma/puma-dev
https://www.driftingruby.com/episodes/puma-dev-replacement-for-pow-and-prax

start it
```
cd market_place
pumad
```
after run `pumad`, You can access via broswer `https://api.market_place.dev/` for test.


### Start server standalone
Add hosts
```
# cat /etc/hosts
127.0.0.1 api.market.dev

```

start server 
```
rails s -p 3015
```

## Authentication

1. The client request for sessions resource with the corresponding credentials, usually email and password.
2. The server returns the user resource along with its corresponding authentication token
3. Every page that requires authentication, the client has to send that authentication token


### 1. Create session. User send its credentials to server.

sending post request with your email and password, for getting token.
```
curl  -H "Content-Type: application/json, Accept: application/vnd.marketplace.v1" -X POST -d '{"session": {"email": "example@marketplace.com", "password": "12345678"}}' http://api.market.dev:3015/sessions

```
the response, you will receive your token.
```
{"id":1,"email":"example@marketplace.com","created_at":"2017-03-31T03:57:20.013Z","updated_at":"2017-04-01T04:35:16.741Z","auth_token":"fEMvrXpF6KkFxYa5f2Js"}
```
### 2. Send other requests. for instance `Get` a user
```
curl  -H "Content-Type: application/json, Accept: application/vnd.marketplace.v1" http://api.market.dev:3015/users/1
```

## Run RSpec

all tests are green passing now.

```
rspec spec/controllers/api/v1/
rspec spec/controllers/api/v1/sessions_controller_spec.rb

```


## Resources
http://apionrails.icalialabs.com/


## License
MIT