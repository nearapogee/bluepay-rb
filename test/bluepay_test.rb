require "test_helper"

class BluepayTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Bluepay::VERSION
  end

  def test_run_auth
    auth = Bluepay::Auth.new(
      amount: "0.00",
      rrno: nil,
      source: card
    ).create!

    assert auth.trans_id,
      "should return a trans_id"
    assert_equal 302, auth.response.code
    assert_equal 'INFORMATION STORED', auth.message
  end

  def test_run_sale_with_trans_id
    auth = Bluepay::Auth.new(
      amount: "0.00",
      source: card
    ).create!
    assert auth.trans_id,
      "should return a trans_id"

    sale = Bluepay::Sale.new(
      amount: "55.00",
      rrno: auth.trans_id
    ).create!

    assert sale.trans_id, sale.response.data.inspect
    assert_equal 302, sale.response.code
    assert_equal 'Approved Sale', sale.message
  end

  def test_run_sale
    sale = Bluepay::Sale.new(
      amount: "55.00",
      rrno: nil,
      source: card
    ).create!

    assert sale.trans_id, sale.response.data.inspect
    assert_equal 302, sale.response.code
    assert_equal 'Approved Sale', sale.message
    assert sale.to_h
  end

  def test_run_sale_converted
    sale = Bluepay::Sale.new(
      amount: 5500,
      rrno: nil,
      source: card
    ).create!

    assert sale.trans_id, sale.response.data.inspect
    assert_equal "55.00", sale.amount
    assert_equal 302, sale.response.code
    assert_equal 'Approved Sale', sale.message
  end

  def test_run_transaction_report
    report = Bluepay::Report.generate!(
      report_start_date: '2020-04-01',
      report_end_date: '2020-04-30'
    )
    assert report.rows.any?,
      'should have some data'
    assert report.rows.first.id,
      'should should have an id'
  end

  def test_run_transaction_report_converted
    report = Bluepay::Report.generate!(
      query_by_settlement: true,
      report_start_date: Date.new(2020,04,01),
      report_end_date: Date.new(2020,04,30)
    )
    assert report.rows.any?,
      'should have some data'
    assert report.rows.first.id,
      'should should have an id'
  end

  def test_run_settled_transaction_report
    report = Bluepay::Report.generate!(
      query_by_settlement: '1',
      report_start_date: '2020-04-01',
      report_end_date: '2020-04-30'
    )
    assert report.rows.any?,
      'should have some data'
    assert report.rows.first.settlement_id,
      'should have a settlement id'
  end

  def test_index_transaction_report_by_id
    report = Bluepay::Report.generate!(
      report_start_date: '2020-04-01',
      report_end_date: '2020-04-30'
    )

    id = report.rows.first.id
    refute report[id].nil?,
      'transaction id should index report'
    refute report[id].amount.nil?,
      'transaction details should be available'
  end

  def test_single_transaction_report_by_id
    trans = Bluepay::Transaction.retrieve!('100873698090')

    assert trans.id,
      'should have returned result'
  end

  def test_single_transaction_report
    trans = Bluepay::Transaction.query!(
      report_start_date: '2020-04-22',
      report_end_date: '2020-04-23',
      limit_one: true
    )
    assert trans.id,
      'should have returned result'
  end

  def test_card_save
    _card = card
    assert _card.save!
    assert _card.trans_id
    assert _card.rrno

    id = _card.trans_id
    assert _card.save!
    assert_equal id, _card.trans_id
  end

  def test_bank_account_save
    _bank_account = bank_account
    assert _bank_account.save!
    assert _bank_account.trans_id
    assert _bank_account.rrno

    id = _bank_account.trans_id
    assert _bank_account.save!
    assert_equal id, _bank_account.trans_id
  end

  def card
    Bluepay::Card.new(
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
  end

  def bank_account
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
    )
  end


  def approved_test_amount
    v = rand(1..10000)
    (v.even? ? v+1 : v) * 100
  end

  def denied_test_amount
    approved_test_amount + 100
  end
end
