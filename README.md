# Wynum

Wynum client for ruby. Put your Ruby code in the file `lib/wynum`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wynum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wynum

## Usage

### Getting started
Very easy to use. Create a ```Client``` and you're ready to go.
### API Credentials
The ```Client``` needs Wynum credentials.You can either pass these directly to the constructor.
```ruby
require "wynum"

secret = "your_secret_key"
token = "project_token"
client = Wynum::Client.new secret, token
```


### Get schema
call ```get_schema``` on ```Client``` to get the keys and types for the data. This will return a ```Array``` of ```Schema``` objects.  ```Schema.key``` will return the key and ```Schema.type``` will return the Wynum type. Following is the mapping from Wynum type to ruby type.

| Wynum type            | Ruby type                   |
| --------------------- | --------------------------- |
| Text                  | ```String```                |
| Date                  | ```String``` (dd/mm/yyyy)   |
| Number                | ```Fixnum``` or ```Float``` |
| Choice (Or)           | ```Fixnum``` or ```Float``` |
| Multiple Choice (And) | ```Array``` of ```String``` | 
| Time                  | ```String``` (hh:mm)        |

```ruby
schemas = client.get_schema
schemas.each { |schema| puts "key: #{schema.key}, value: #{schema.type}" }
```

### Post data
the ```post_data``` method accepts a single parameter data which is ```Hash``` containing the post key:value. Every data ```Hash``` should contain the 'identifier'. You can get identifier key if you have called ```get_schema```. You can retrieve it using ```client.identifier```.

```ruby
client.get_schema
identifer_key = client.identifier
data = {'key1'=>val1, 'key2'=>val2, identifer_key=>'id_string'}
res = client.post_data data
```
If the call is successful it returns the ```Hash``` containing the created data instance. If there is some error the ```Hash``` will contain ```_error``` and ```_message``` keys.  You should check this to check for errors.

### Get data
Call ```get_data``` to get the data. This will return ```Array``` of ```Hash```
```ruby
data = client.get_data
```

### Updating data
The ```update``` method is same as that of ```post_data``` method.
```python
client.get_schema
identifer_key = client.identifier
data = {'key1'=>val1, 'key2'=>val2, identifer_key=>'id_string'}
res = client.update data
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patil-suraj/wynum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
