require 'models/emails/slim_helpers'

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
    email_body = Slim::Template.new("lib/models/emails/#{self.class.name.underscore}.slim").render(self)
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
