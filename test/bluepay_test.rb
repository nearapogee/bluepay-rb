require "test_helper"

class BluepayTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Bluepay::VERSION
  end

  def test_run_auth
    auth = Bluepay::Auth.new(
      amount: "0.00",
      rrno: nil,

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

    assert auth.trans_id,
      "should return a trans_id"
    assert_equal 302, auth.response.code
    assert_equal 'INFORMATION STORED', auth.message
  end

  def test_run_sale
    sale = Bluepay::Sale.new(
      amount: "55.00",
      rrno: nil,

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

    assert sale.trans_id, sale.response.bluepay_params.inspect
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

  def approved_test_amount
    v = rand(1..10000)
    (v.even? ? v+1 : v) * 100
  end

  def denied_test_amount
    approved_test_amount + 100
  end
end
