# Overvie
Bytlyn is a semester long project where users can put their name on a restaurant waitlist. The purpose of this project is to help less time waiting at the restaurant.

Please visit www.bytlyn.com or see instruction below to run bytlyn on localhost. 


# Instructions

### Run Server
After downloading the files, open terminal and change the directory to bytlyn. Then, follow this command below
```
$ rails server
```

### Run Bytlyn
Next, go to your browser. Then, type in the URL:
```
localhost:3000
```

### Tests
This project uses Test Driven Development. Some of the method of testing including: unit test, integration test, functional test, automation UI test, and regression test.

To do all testing:
```
$ rake test
```
or
```
$ bundle exec rake test
```


To run a specific test, use: bundle exec rake test test/... (the directory). For example, to run waitlist_routes_test.rb inside integration test, use: bundle exec rake test test/integration/waitlist_routes_test.rb

```
$ bundle exec rake test test/integration/waitlist_routes_test.rb
```

### Some Tools
* Ruby on Rails           : MVC
* PostgreSQL              : database
* Amazon Web Service SDK  : image database container
* Papperclip              : image upload
* Braintree               : payment system
* Selenium                : automation UI testing
* Factory Girl            : testing devise
* Device                  : user login and sign up
* Bcript                  : password
* Jbuilder                : JSON API
* SimpleCov               : code covarage