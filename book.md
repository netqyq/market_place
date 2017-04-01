# Errors and Failures During Coding.

### Upgrade
https://github.com/thoughtbot/shoulda-matchers/issues/951
require 'shoulda/matchers'


### keyword
change `constrains:` to `constrains`



### CSRF
change
```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
end
```
to
```
protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
```

### sign_in
change
```
post :create, { session: credentials }
```
to
```
post :create, params: { session: credentials }
```


### sign_out test
```
[yq@local market_place]$rspec spec/controllers/api/v1/sessions_controller_spec.rb
....F

Failures:

  1) Api::V1::SessionsController DELETE #destroy
     Failure/Error: sign_in @user, store: false

     ArgumentError:
       unknown keyword: store
```


