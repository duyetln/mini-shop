require 'models/mailing/slim_helpers'

class Email < SimpleDelegator
  include SlimHelpers

  def initialize(payload = {})
    __setobj__(generate_email(payload))
  end

  def generate_email(payload = {})
    fail 'Must be implemented in derived class'
  end

  protected

  def email
    email_body = Slim::Template.new("lib/models/mailing/templates/#{self.class.name.underscore}.slim").render(self)
    @email ||= Mail.new do
      content_type 'text/html; charset=UTF-8'
      from 'noreply@mini.shop'
      header['Content-Transfer-Encoding'] = 'quoted-printable'
      body email_body
    end
    @email
  end
end

class PurchaseReceiptEmail < Email
  def generate_email(payload = {})
    @purchase = Purchase.committed.find(payload[:purchase_id])
    email.to @purchase.user.email
    email.subject 'Purchase Receipt'
    email
  end
end

class AccountActivationEmail < Email
  def generate_email(payload = {})
    @user = User.unconfirmed.find(payload[:user_id])
    @actv_url = payload[:actv_url]
    email.to @user.email
    email.subject 'Account Activation'
    email
  end
end

class PurchaseStatusEmail < Email
  def generate_email(payload = {})
    @purchase = Purchase.committed.find(payload[:purchase_id])
    email.to @purchase.user.email
    email.subject 'Purchase Status'
    email
  end
end
