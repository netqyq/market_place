# Improvement of The Book

## Upgrade
https://github.com/thoughtbot/shoulda-matchers/issues/951
require 'shoulda/matchers'


- Mistakes
change `constrains:` to `constrains`



## Do not Understand

app/controllers/application_controller.rb
```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
end
```


## CSRF
change
```
protect_from_forgery with: :null_session
```
to
```
protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
```


change
```
post :create, { session: credentials }
```
to
```
post :create, params: { session: credentials }
```
