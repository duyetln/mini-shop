require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Mailing::Emails do
  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

    shared_examples 'invalid email type' do
      context 'invalid email type' do
        let(:params) { { type: rand_str } }

        include_examples 'bad request'
      end
    end

    context 'purchase receipt email' do
      let(:purchase) { FactoryGirl.create :purchase, :orders }

      include_examples 'invalid email type'

      context 'valid email type' do
        let :params do
          {
            type: 'PurchaseReceiptEmail',
            payload: {
              purchase_id: purchase.id
            }
          }
        end

        context 'pending purchase' do
          before :each do
            expect(purchase).to be_pending
          end

          include_examples 'not found'
        end

        context 'committed purchase' do
          before :each do
            expect { purchase.commit! }.to change { purchase.committed? }.to(true)
            expect { send_request }.to change { Mail::TestMailer.deliveries.count }.by(1)
            expect_status(200)
          end

          it { should have_sent_email.to(purchase.user.email) }
        end
      end
    end

    context 'account activation email' do
      let(:user) { FactoryGirl.create :user }

      include_examples 'invalid email type'

      context 'valid email type' do
        let :params do
          {
            type: 'AccountActivationEmail',
            payload: {
              user_id: user.id
            }
          }
        end

        context 'confirmed user' do
          before :each do
            expect { user.confirm! }.to change { user.confirmed? }.to(true)
          end

          include_examples 'not found'
        end

        context 'unconfirmed user' do
          before :each do
            expect(user).to_not be_confirmed
            expect { send_request }.to change { Mail::TestMailer.deliveries.count }.by(1)
            expect_status(200)
          end

          it { should have_sent_email.to(user.email) }
        end
      end
    end

    context 'purchase status email' do
      let!(:purchase) { FactoryGirl.create :purchase, :orders }

      include_examples 'invalid email type'

      context 'valid email type' do
        let :params do
          {
            type: 'PurchaseStatusEmail',
            payload: {
              purchase_id: purchase.id
            }
          }
        end

        context 'pending purchase' do
          before :each do
            expect(purchase).to be_pending
          end

          include_examples 'not found'
        end

        context 'fulfilled purchase' do
          before :each do
            activate_inventory!
            expect do
              purchase.commit!
              purchase.pay!
              purchase.fulfill!
            end.to change { purchase.orders.all?(&:unmarked?) }.to(false)
            expect { send_request }.to change { Mail::TestMailer.deliveries.count }.by(1)
            expect_status(200)
          end

          it { should have_sent_email.to(purchase.user.email) }
        end
      end
    end
  end
end
