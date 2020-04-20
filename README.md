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

```ruby
Bluepay.account_id = "blah"
Bluepay.account_secret = "supersecret"
Bluepay.mode = :live


auth = Bluepay::Auth.new(
  amount: '0.00',
  source: Bluepay::Card.new(
    cc_num: '4111111111111111',
    cc_expires: '1227',
    cvcvv2: "723",
    name1: 'Bobby',
    name2: 'Tester',
    addr1: '123 Test St.',
    addr2: 'Apt #500',
    city: 'Testville',
    state: 'IL',
    zipcode: '94321',
    country: 'USA',
    phone: '123-123-1234',
    email: 'test@bluepay.com',
    company_name: ''
  )
).create!

auth.trans_id
#=> "10080152343"

# 
report = Bluepay::Report.generate!(
  query_by_settlement: '1',
  report_start_date: '2020-04-01',
  report_end_date: '2020-04-30'
)
report.rows.first.id
#=> "10080152343"

report.rows.first
# => #<OpenStruct id="100867577224", payment_type="CREDIT", trans_type="AUTH", amount="0.00", card_type="VISA", payment_account="xxxxxxxxxxxx1111", order_id="100867577224", invoice_id="100867577224", custom_id="", custom_id2="", master_id="", status="1", f_void="", message="INFORMATION STORED", origin="bp10emu", issue_date="2020-04-06 11:17:25", settle_date="", rebilling_id="", settlement_id="", card_expire="1225", bank_name="", addr1="123 Test St.", addr2="Apt #500", city="Testville", state="IL", zip="54321", phone="123-123-1234", email="test@bluepay.com", auth_code="", name1="Bob", name2="Tester", company_name="", memo="", backend_id="", doc_type="", f_captured="", avs_result="_", cvv_result="_", card_present="0", merchdata="", level_3_data="", remote_ip="75.139.119.161", connected_ip="75.139.119.161", level_2_data="">

report = Bluepay::Report.generate!(
  transaction_id: '100867577224',
  report_start_date: '2020-04-01',
  report_end_date: '2020-04-30'
)
report.rows.first.id
#=> "10080152343"

report.rows.first
# => #<OpenStruct id="100867577224", payment_type="CREDIT", trans_type="AUTH", amount="0.00", card_type="VISA", payment_account="xxxxxxxxxxxx1111", order_id="100867577224", invoice_id="100867577224", custom_id="", custom_id2="", master_id="", status="1", f_void="", message="INFORMATION STORED", origin="bp10emu", issue_date="2020-04-06 11:17:25", settle_date="", rebilling_id="", settlement_id="", card_expire="1225", bank_name="", addr1="123 Test St.", addr2="Apt #500", city="Testville", state="IL", zip="54321", phone="123-123-1234", email="test@bluepay.com", auth_code="", name1="Bob", name2="Tester", company_name="", memo="", backend_id="", doc_type="", f_captured="", avs_result="_", cvv_result="_", card_present="0", merchdata="", level_3_data="", remote_ip="75.139.119.161", connected_ip="75.139.119.161", level_2_data="">

# TODO
report = Bluepay::Report.generate!(
  transaction_id: '10008..',
  starts_on: Date.new
  ends_on: Date.new
)

# TODO
report['100867577224']
# => #<OpenStruct id="100867577224", payment_type="CREDIT", trans_type="AUTH", amount="0.00", card_type="VISA", payment_account="xxxxxxxxxxxx1111", order_id="100867577224", invoice_id="100867577224", custom_id="", custom_id2="", master_id="", status="1", f_void="", message="INFORMATION STORED", origin="bp10emu", issue_date="2020-04-06 11:17:25", settle_date="", rebilling_id="", settlement_id="", card_expire="1225", bank_name="", addr1="123 Test St.", addr2="Apt #500", city="Testville", state="IL", zip="54321", phone="123-123-1234", email="test@bluepay.com", auth_code="", name1="Bob", name2="Tester", company_name="", memo="", backend_id="", doc_type="", f_captured="", avs_result="_", cvv_result="_", card_present="0", merchdata="", level_3_data="", remote_ip="75.139.119.161", connected_ip="75.139.119.161", level_2_data="">

# TODO
Bluepay::Card.new(
  # card num
).save!

# TODO
Bluepay::BankAccount.new(
  # routing, account etc
).save!
#=> card with trans_id (call auth)

# TODO
Bluepay::Transaction.retrieve('10080152343') # trans_id - via stq
# => Transaction

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Tests

Add a `.env` to run tests.

```
BLUEPAY_ACCOUNT_ID=100....
BLUEPAY_ACCOUNT_SECRET=WCP0....
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bluepay-rb.

