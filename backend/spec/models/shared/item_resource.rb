require "spec/models/shared/activable"
require "spec/models/shared/deletable"
require "spec/models/shared/displayable"

shared_examples "item resource" do

  it_behaves_like "activable object"
  it_behaves_like "deletable object"
  it_behaves_like "displayable object"

  describe "factory model" do

    it("is valid") { expect(new_model).to be_valid }
    it("saves successfully") { expect(saved_model).to be_present}
  end

  describe "#available?" do

    context("deleted")  { it("is false") { saved_model.delete!;     expect(saved_model).to_not be_available } }
    context("inactive") { it("is false") { saved_model.deactivate!; expect(saved_model).to_not be_available } }
  end

end