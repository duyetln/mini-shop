shared_examples "item service" do |item_class|

  class << self; attr_accessor :namespace; end
  
  namespace = item_class.to_s.tableize

  let(:item_class) { item_class }

  describe "get /#{namespace}/ping" do

    it "returns 200 status" do

      get "/#{namespace}/ping"
      expect_status(200)
    end
  end

  describe "get /#{namespace}" do

    before(:each) { 10.times { FactoryGirl.create(sym_item_class) } }

    let(:offset) { 2 }
    let(:limit)  { 5 }

    context "pagination on" do

      it "returns paginated items" do

        get "/#{namespace}", pagination: true, offset: offset, limit: limit
        expect_status(200)
        expect(parsed_result.count).to eq(limit)
        expect(parsed_result.first[:id]).to eq(offset + 1)
      end
    end

    context "pagination off" do

      it "returns all items" do

        get "/#{namespace}"
        expect_status(200)
        expect(parsed_result.count).to eq(items.count)
      end
    end
  end

  describe "get /#{namespace}/:id" do

    context "valid id" do

      context "non-deleted item" do

        it "returns the item" do

          get "/#{namespace}/#{created_item.id}"
          expect_status(200)
          expect(parsed_result[:id]).to eq(created_item.id)
        end
      end

      context "deleted item" do

        it "returns 404 status" do

          created_item.delete!
          get "/#{namespace}/#{created_item.id}"
          expect_status(404)
          expect_empty_response
        end
      end
    end

    context "invalid id" do

      it "returns 404 status" do

        get "/#{namespace}/foo"
        expect_status(404)
        expect_empty_response
      end
    end

  end

  describe "post /#{namespace}" do

    context "valid parameters" do

      it "creates the item and returns it" do

        expect{ post "/#{namespace}", built_item.attributes }.to change{ item_class.count }.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(item_class.last.id)
      end
    end

    context "invalid parameters" do

      it "ignores invalid parameters and creates the item" do

        expect{ post "/#{namespace}", built_item.attributes.merge(foo: :baz) }.to change{ item_class.count }.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(item_class.last.id)
      end
    end

    context "missing parameters" do

      it "returns 400 status" do

        expect{ post "/#{namespace}" }.to_not change{ item_class.count }
        expect_status(400)
        expect_empty_response
      end
    end

    context "deleted flag included" do

      it "does not update the deleted flag" do

        expect{ post "/#{namespace}", built_item.attributes.merge(deleted: true) }.to change{ item_class.count }.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(item_class.last.id)
        expect(parsed_result[:deleted]).to be_false
        expect(item_class.last).to_not be_deleted
      end
    end

    context "active flag included" do

      it "does not update the active flag" do

        expect{ post "/#{namespace}", built_item.attributes.merge(active: false) }.to change{ item_class.count }.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(item_class.last.id)
        expect(parsed_result[:active]).to be_true
        expect(item_class.last).to be_active
      end
    end
  end

  describe "put /#{namespace}/:id" do

    context "valid id" do

      context "non-deleted item" do

        let(:new_title) { "New title" }

        context "valid parameters" do

          it "updates the item and returns it" do

            put "/#{namespace}/#{created_item.id}", title: new_title
            expect_status(200)
            expect(parsed_result[:title]).to eq(new_title)
            created_item.reload
            expect(created_item.title).to eq(new_title)
          end
        end

        context "invalid parameters" do

          it "ignores invalid parameters and updates the item" do

            put "/#{namespace}/#{created_item.id}", title: new_title, foo: :baz
            expect_status(200)
            expect(parsed_result[:title]).to eq(new_title)
            created_item.reload
            expect(created_item.title).to eq(new_title)
          end
        end

        context "deleted flag included" do

          it "does not update the deleted flag" do

            put "/#{namespace}/#{created_item.id}", deleted: true
            expect_status(200)
            expect(parsed_result[:deleted]).to be_false
            created_item.reload
            expect(created_item).to_not be_deleted
          end
        end

        context "active flag included" do

          it "does not update the active flag" do

            put "/#{namespace}/#{created_item.id}", active: false
            expect_status(200)
            expect(parsed_result[:active]).to be_true
            created_item.reload
            expect(created_item).to be_active
          end
        end
      end

      context "deleted item" do

        it "returns 404 status" do

          created_item.delete!
          put "/#{namespace}/#{created_item.id}"
          expect_status(404)
          expect_empty_response
        end
      end
    end

    context "invalid id" do

      it "returns 404 status" do

        put "/#{namespace}/foo"
        expect_status(404)
        expect_empty_response
      end
    end
  end

  describe "delete /#{namespace}/:id" do

    context "valid id" do

      context "non-deleted item" do

        it "deletes the item and returns it" do

          delete "/#{namespace}/#{created_item.id}"
          expect_status(200)
          expect(parsed_result[:deleted]).to be_true
          created_item.reload
          expect(created_item).to be_deleted
        end
      end

      context "deleted item" do

        it "returns 404 status" do

          created_item.delete!
          delete "/#{namespace}/#{created_item.id}"
          expect_status(404)
          expect_empty_response
        end
      end
    end

    context "invalid id" do

      it "returns 404 status" do

        delete "/#{namespace}/foo"
        expect_status(404)
        expect_empty_response
      end
    end
  end

  describe "put /#{namespace}/:id/activate" do

    context "valid id" do

      context "non-deleted item" do

        it "activates the item and returns it" do

          created_item.deactivate!
          put "/#{namespace}/#{created_item.id}/activate"
          expect_status(200)
          expect(parsed_result[:active]).to be_true
          created_item.reload
          expect(created_item).to be_active
        end
      end

      context "deleted item" do

        it "returns 404 status" do

          created_item.delete!
          put "/#{namespace}/#{created_item.id}/activate"
          expect_status(404)
          expect_empty_response
        end
      end
    end

    context "invalid id" do

      it "returns 404 status" do

        put "/#{namespace}/foo/activate"
        expect_status(404)
        expect_empty_response
      end
    end
  end

  describe "put /#{namespace}/:id/deactivate" do

    context "valid id" do

      context "non-deleted item" do

        it "deactivates the item and returns it" do

          put "/#{namespace}/#{created_item.id}/deactivate"
          expect_status(200)
          expect(parsed_result[:active]).to be_false
          created_item.reload
          expect(created_item).to_not be_active
        end
      end

      context "deleted item" do

        it "returns 404 status" do

          created_item.delete!
          put "/#{namespace}/#{created_item.id}/deactivate"
          expect_status(404)
          expect_empty_response
        end
      end
    end

    context "invalid id" do

      it "returns 404 status" do

        put "/#{namespace}/foo/deactivate"
        expect_status(404)
        expect_empty_response
      end
    end
  end

end