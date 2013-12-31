shared_examples "sku service" do |sku_class|

  class << self; attr_accessor :namespace; end
  
  namespace = sku_class.to_s.tableize

  let(:sku_class) { sku_class }

  def expect_status(code)
    expect(last_response.status).to eq(code)
  end

  def expect_empty_response
    expect(last_response.body).to be_empty
  end

  describe "get /#{namespace}/ping" do

    it "returns 200 status" do

      get "/#{namespace}/ping"
      expect_status(200)
    end
  end

  describe "get /#{namespace}" do

    before(:each) { 10.times { FactoryGirl.create(sym_sku_class) } }

    let(:offset) { 2 }
    let(:limit)  { 5 }

    context "pagination on" do

      it "returns paginated skus" do

        get "/#{namespace}", pagination: true, offset: offset, limit: limit
        expect_status(200)
        expect(parsed_result.count).to eq(limit)
        expect(parsed_result.first[:id]).to eq(offset + 1)
      end
    end

    context "pagination off" do

      it "returns all skus" do

        get "/#{namespace}"
        expect_status(200)
        expect(parsed_result.count).to eq(skus.count)
      end
    end
  end

  describe "get /#{namespace}/:id" do

    context "valid id" do

      context "non-deleted sku" do

        it "returns the sku" do

          get "/#{namespace}/#{created_sku.id}"
          expect_status(200)
          expect(parsed_result[:id]).to eq(created_sku.id)
        end
      end

      context "deleted sku" do

        it "returns 404 status" do

          created_sku.delete!
          get "/#{namespace}/#{created_sku.id}"
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

      it "creates the sku and returns it" do

        expect{ post "/#{namespace}", built_sku.attributes }.to change{sku_class.count}.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(sku_class.last.id)
      end
    end

    context "invalid parameters" do

      it "ignores invalid parameters and creates the sku" do

        expect{ post "/#{namespace}", built_sku.attributes.merge(foo: :baz) }.to change{sku_class.count}.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(sku_class.last.id)
      end
    end

    context "missing parameters" do

      it "returns 400 status" do

        expect{ post "/#{namespace}" }.to_not change{sku_class.count}
        expect_status(400)
        expect_empty_response
      end
    end

    context "removed flag included" do

      it "does not update the removed flag" do

        expect{post "/#{namespace}", built_sku.attributes.merge(removed: true) }.to change{sku_class.count}.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(sku_class.last.id)
        expect(parsed_result[:removed]).to be_false
        expect(sku_class.last.removed?).to be_false
      end
    end

    context "active flag included" do

      it "does not update the active flag" do

        expect{ post "/#{namespace}", built_sku.attributes.merge(active: false) }.to change{sku_class.count}.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(sku_class.last.id)
        expect(parsed_result[:active]).to be_true
        expect(sku_class.last.active?).to be_true
      end
    end
  end

  describe "put /#{namespace}/:id" do

    context "valid id" do

      context "non-deleted sku" do

        context "valid parameters" do

          it "updates the sku and returns it" do

            new_title = "New Title"
            put "/#{namespace}/#{created_sku.id}", title: new_title
            expect_status(200)
            expect(parsed_result[:title]).to eq(new_title)
            created_sku.reload
            expect(created_sku.title).to eq(new_title)
          end
        end

        context "invalid parameters" do

          it "ignores invalid parameters and updates the sku" do

            new_title = "New Title"
            put "/#{namespace}/#{created_sku.id}", title: new_title, foo: :baz
            expect_status(200)
            expect(parsed_result[:title]).to eq(new_title)
            created_sku.reload
            expect(created_sku.title).to eq(new_title)
          end
        end

        context "removed flag included" do

          it "does not update the removed flag" do

            put "/#{namespace}/#{created_sku.id}", removed: true
            expect_status(200)
            expect(parsed_result[:removed]).to be_false
            created_sku.reload
            expect(created_sku.removed?).to be_false
          end
        end

        context "active flag included" do

          it "does not update the active flag" do

            put "/#{namespace}/#{created_sku.id}", active: false
            expect_status(200)
            expect(parsed_result[:active]).to be_true
            created_sku.reload
            expect(created_sku.active?).to be_true
          end
        end
      end

      context "deleted sku" do

        it "returns 404 status" do

          created_sku.delete!
          put "/#{namespace}/#{created_sku.id}"
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

      context "non-deleted sku" do

        it "deletes the sku and returns it" do

          delete "/#{namespace}/#{created_sku.id}"
          expect_status(200)
          expect(parsed_result[:removed]).to be_true
          created_sku.reload
          expect(created_sku.removed?).to be_true
        end
      end

      context "deleted sku" do

        it "returns 404 status" do

          created_sku.delete!
          delete "/#{namespace}/#{created_sku.id}"
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

      context "non-deleted sku" do

        it "activates the sku and returns it" do

          created_sku.deactivate!
          put "/#{namespace}/#{created_sku.id}/activate"
          expect_status(200)
          expect(parsed_result[:active]).to be_true
          created_sku.reload
          expect(created_sku.active?).to be_true
        end
      end

      context "deleted sku" do

        it "returns 404 status" do

          created_sku.delete!
          put "/#{namespace}/#{created_sku.id}/activate"
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

      context "non-deleted sku" do

        it "deactivates the sku and returns it" do

          put "/#{namespace}/#{created_sku.id}/deactivate"
          expect_status(200)
          expect(parsed_result[:active]).to be_false
          created_sku.reload
          expect(created_sku.active?).to be_false
        end
      end

      context "deleted sku" do

        it "returns 404 status" do

          created_sku.delete!
          put "/#{namespace}/#{created_sku.id}/deactivate"
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