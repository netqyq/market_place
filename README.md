# Market Place API

market_place is an e-commerence JSON API service.
This is built by TDD.

## Ruby Version
```
ruby 2.4.0
rails 5.0.2
```


## Run Rspec Testing
### install puma-dev for domain
see https://www.driftingruby.com/episodes/puma-dev-replacement-for-pow-and-prax

### testing

```
rspec spec/controllers/api/v1/
rspec spec/controllers/api/v1/sessions_controller_spec.rb

```


## Testing Using cURL
### Add hosts
```
# cat /etc/hosts
127.0.0.1 api.market.dev

```

### Start server
```
rails s -p 3015
```

### Create Session

send post request with your email and password, for getting token.
```
curl  -H "Content-Type: application/json, Accept: application/vnd.marketplace.v1" -X POST -d '{"session": {"email": "example@marketplace.com", "password": "12345678"}}' http://api.market.dev:3015/sessions

```
the response, you will receive your token.
```
{"id":1,"email":"example@marketplace.com","created_at":"2017-03-31T03:57:20.013Z","updated_at":"2017-04-01T04:35:16.741Z","auth_token":"fEMvrXpF6KkFxYa5f2Js"}
```


## Resources
https://github.com/book-source/rspec_projects
http://apionrails.icalialabs.com/


## License
MIT