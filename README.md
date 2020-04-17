# Bluepay::Rb

Simple Bluepay API Wrapper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bluepay-rb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bluepay-rb

## Usage

```
Bluepay.account_id = "blah"
Bluepay.account_secret = "supersecret"
Bluepay.mode = :live


Bluepay::Transaction.new(
  amount: 1000,
  source: Bluepay::Card.new(
    # trans_id / card numbers
    name: '',
    address: ''
  )
).create!

Bluepay::Card.new(
  # card num
).save!
Bluepay::BankAccount.new(
  # routing, account etc
).save!
# => card with trans_id (call auth)
Bluepay::Transaction.retrieve('10080152343') # trans_id - via stq
# => Transaction
Bluepay::Report.retrieve(
  id: '10008..',
  starts_on: Date.new
  ends_on: Date.new
) # trans_id
#=> <instnace of Report>.lines
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bluepay-rb.

