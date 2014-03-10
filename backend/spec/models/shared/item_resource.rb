require "spec/models/shared/activable"
require "spec/models/shared/deletable"
require "spec/models/shared/displayable"

shared_examples "item resource" do

  let(:new_object) { new_item }
  let(:created_object) { created_item }

  it_behaves_like "activable object"
  it_behaves_like "deletable object"
  it_behaves_like "displayable object"

  describe "factory model" do

    it("is valid") { expect(new_item).to be_valid }
    it("saves successfully") { expect(created_item).to be_present}
  end

  describe "#available?" do

    context("deleted")  { it("is false") { created_item.delete!;     expect(created_item).to_not be_available } }
    context("inactive") { it("is false") { created_item.deactivate!; expect(created_item).to_not be_available } }
  end

end