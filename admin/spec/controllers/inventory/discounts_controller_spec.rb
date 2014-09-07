require 'controllers/spec_setup'

describe Inventory::DiscountsController do
  let(:resource_class) { BackendClient::Discount }
  let(:resource) { discount }

  render_views

  describe '#index' do
    let(:method) { :get }
    let(:action) { :index }

    before :each do
      expect_all
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#create' do
    let(:name) { rand_str }
    let(:rate) { rand_num.to_f / 100 }
    let(:start_at) { 1.week.ago.strftime('%m/%d/%Y %H:%M') }
    let(:end_at) { 1.week.from_now.strftime('%m/%d/%Y %H:%M') }
    let(:method) { :post }
    let(:action) { :create }
    let :params do
      {
        discount: {
          name: name,
          rate: rate,
          start_at: start_at,
          end_at: end_at
        }
      }
    end
    let :create_params do
      {
        name: name,
        rate: rate.to_s,
        start_at: DateTime.strptime(start_at, '%m/%d/%Y %H:%M'),
        end_at: DateTime.strptime(end_at, '%m/%d/%Y %H:%M')
      }
    end

    context 'valid date parameters' do
      before :each do
        expect_create
      end

      include_examples 'redirect response'
      include_examples 'success flash set'
    end

    context 'invalid date parameters' do
      let(:start_at) { rand_str }

      include_examples 'redirect response'
      include_examples 'error flash set'
    end
  end

  describe '#update' do
    let(:name) { rand_str }
    let(:rate) { rand_num.to_f / 100 }
    let(:start_at) { 1.week.ago.strftime('%m/%d/%Y %H:%M') }
    let(:end_at) { 1.week.from_now.strftime('%m/%d/%Y %H:%M') }
    let(:method) { :put }
    let(:action) { :update }
    let :params do
      {
        id: id,
        discount: {
          name: name,
          rate: rate,
          start_at: start_at,
          end_at: end_at
        }
      }
    end
    let(:update_keys) { [ :name, :rate, :start_at, :end_at ] }

    context 'valid date parameters' do
      before :each do
        expect_find
        expect_update
      end

      include_examples 'resource changed'
      include_examples 'redirect response'
      include_examples 'success flash set'
    end

    context 'invalid date parameters' do
      let(:start_at) { rand_str }

      include_examples 'redirect response'
      include_examples 'error flash set'
    end
  end
end
