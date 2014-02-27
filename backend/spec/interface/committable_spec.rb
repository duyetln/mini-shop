require "spec_helper"

[Payment, Purchase].each do |model|

  describe model do

    let(:instance) { described_class.new }
    let(:klass) { described_class }

    it("responds to committed") { expect(klass).to respond_to(:committed) }
    it("responds to pending") { expect(klass).to respond_to(:pending) }

    it("responds to committed?") { expect(instance).to respond_to(:committed?) }
    it("responds to pending?") { expect(instance).to respond_to(:pending?) }
    it("responds to commit!") { expect(instance).to respond_to(:commit!) }
  end
end