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
Bluepay.secret_key = "supersecret"
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

report = Bluepay::Report.generate!(
  query_by_settlement: true,
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

report = Bluepay::Report.generate!(
  transaction_id: '10008..',
  starts_on: Date.new
  ends_on: Date.new
)

report['100867577224']
# => #<OpenStruct id="100867577224", payment_type="CREDIT", trans_type="AUTH", amount="0.00", card_type="VISA", payment_account="xxxxxxxxxxxx1111", order_id="100867577224", invoice_id="100867577224", custom_id="", custom_id2="", master_id="", status="1", f_void="", message="INFORMATION STORED", origin="bp10emu", issue_date="2020-04-06 11:17:25", settle_date="", rebilling_id="", settlement_id="", card_expire="1225", bank_name="", addr1="123 Test St.", addr2="Apt #500", city="Testville", state="IL", zip="54321", phone="123-123-1234", email="test@bluepay.com", auth_code="", name1="Bob", name2="Tester", company_name="", memo="", backend_id="", doc_type="", f_captured="", avs_result="_", cvv_result="_", card_present="0", merchdata="", level_3_data="", remote_ip="75.139.119.161", connected_ip="75.139.119.161", level_2_data="">

card = Bluepay::Card.new(
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
).save!
#=> <BluePay::Card>
card.trans_id
#=> card.trans_id
card.auth
#=> <Bluepay::Auth>

Bluepay::BankAccount.new(
  ach_routing: '123123123',
  ach_account: '123456789',
  ach_account_type: 'C',
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
).save!
#=> <BluePay::BankAccount>
bank_account.trans_id
#=> bank_account.trans_id
bank_account.auth
#=> <Bluepay::Auth>


transaction = Bluepay::Transaction.retrieve!('10080152343')
transaction.amount
#=> "10.00"

```

### Parameters

When you pass parameters to this gem's methods, we convert them to the API's
style of parameters for you. This means you can pass `symbols` as keys and that
there is a 1:1 mapping to the paramters in the Bluepay provided API
documentation.

### Parameter Conversions

Some paramerters will be converted to the expected strings before passing to
the Bluepay API.

- `:amount` can take an `Integer` of the amount in cents, a `Float` in dollars,
  or a formatted string.
- dates/times can take a `Date` or `Datetime` instance or a formatted string.

### Timezones

Bluepay uses the Central Timezone (US). Some parameters will convert time/date
like objects to strings but will use the given objects hours. As such, you must
pass in approriate date or time objects in Central Timezone or offset.

## TODOS

- Response Parameter Conversion (i.e. "10.00" to 1000)


## Bluepay Documentation


- https://www.bluepay.com/sites/default/files/documentation/BluePay_bp10emu/BluePay%201-0%20Emulator.txt
- https://www.bluepay.com/sites/default/files/documentation/BluePay_stq/BluePay_Single_Transaction_Query.txt
- https://www.bluepay.com/sites/default/files/documentation/BluePay_bpdailyreport2/bpdailyreport2.pdf

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

The gem doesn't come with default credentials for BluePay. You will need to
provide those

## Testing

Add a `.env` to run tests.

```
BLUEPAY_ACCOUNT_ID=100....
BLUEPAY_SECRET_KEY=WCP0....
```

Run tests with:
```
rake test
```

## Releases
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bluepay-rb.

