require 'integration/spec_setup'

describe 'inventory administration' do
  before :all do
    @pitem = FactoryGirl.create :physical_item
    @ditem = FactoryGirl.create :digital_item
    @bundle = FactoryGirl.create :bundle
  end

  def pitem; @pitem; end
  def ditem; @ditem; end
  def bundle; @bundle; end

  before :each do
    pitem.reload
    ditem.reload
    bundle.reload
  end

  describe 'physical item' do
    it 'is not deleted' do
      expect(pitem).to be_kept
    end

    it 'is not active' do
      expect(pitem).to be_inactive
    end

    it 'has positive qty' do
      expect(pitem.qty > 0).to be_true
    end

    it 'is available' do
      expect(pitem).to be_available
    end

    it 'is activable' do
      expect(pitem).to be_activable
    end

    it 'is deletable' do
      expect(pitem).to be_deletable
    end
  end

  describe 'digital item' do
    it 'is not deleted' do
      expect(ditem).to be_kept
    end

    it 'is not active' do
      expect(ditem).to be_inactive
    end

    it 'is available' do
      expect(ditem).to be_available
    end

    it 'is activable' do
      expect(ditem).to be_activable
    end

    it 'is deletable' do
      expect(ditem).to be_deletable
    end
  end

  describe 'bundle' do
    it 'is not deleted' do
      expect(bundle).to be_kept
    end

    it 'is not active' do
      expect(bundle).to be_inactive
    end

    it 'has no bundleds' do
      expect(bundle.items).to be_empty
    end

    it 'is not available' do
      expect(bundle).to_not be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is deletable' do
      expect(bundle).to be_deletable
    end
  end

  describe 'physical item' do
    it 'is deleted' do
      expect { pitem.delete! }.to change { pitem.deleted? }.from(false).to(true)
    end

    it 'is not available' do
      expect(pitem).to_not be_available
    end

    it 'is not activable' do
      expect(pitem).to_not be_activable
    end

    it 'is not deletable' do
      expect(pitem).to_not be_deletable
    end

    it 'is undeleted' do
      expect do
        pitem.deleted = false
        pitem.save!
      end.to change { pitem.deleted? }.from(true).to(false)
    end

    it 'is available' do
      expect(pitem).to be_available
    end

    it 'is activable' do
      expect(pitem).to be_activable
    end

    it 'is deletable' do
      expect(pitem).to be_deletable
    end
  end

  describe 'digital item' do
    it 'is deleted' do
      expect { ditem.delete! }.to change { ditem.deleted? }.from(false).to(true)
    end

    it 'is not available' do
      expect(ditem).to_not be_available
    end

    it 'is not activable' do
      expect(ditem).to_not be_activable
    end

    it 'is not deletable' do
      expect(ditem).to_not be_deletable
    end

    it 'is undeleted' do
      expect do
        ditem.deleted = false
        ditem.save!
      end.to change { ditem.deleted? }.from(true).to(false)
    end

    it 'is available' do
      expect(ditem).to be_available
    end

    it 'is activable' do
      expect(ditem).to be_activable
    end

    it 'is deletable' do
      expect(ditem).to be_deletable
    end
  end

  describe 'bundle' do
    it 'is deleted' do
      expect { bundle.delete! }.to change { bundle.deleted? }.from(false).to(true)
    end

    it 'is not available' do
      expect(bundle).to_not be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is not deletable' do
      expect(bundle).to_not be_deletable
    end

    it 'is undeleted' do
      expect do
        bundle.deleted = false
        bundle.save!
      end.to change { bundle.deleted? }.from(true).to(false)
    end

    it 'is not available' do
      expect(bundle).to_not be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is deletable' do
      expect(bundle).to be_deletable
    end
  end

  describe 'bundle' do
    it 'adds physical item' do
      expect { bundle.add_or_update(pitem) }.to change { bundle.items.count }.by(1)
    end

    it 'adds digital item' do
      expect { bundle.add_or_update(ditem) }.to change { bundle.items.count }.by(1)
    end

    it 'is available' do
      expect(bundle).to be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is deletable' do
      expect(bundle).to be_deletable
    end
  end

  describe 'physical item' do
    it 'has zero qty' do
      expect do
        pitem.qty = 0
        pitem.save!
      end.to change { pitem.qty }.to(0)
    end

    it 'is not available' do
      expect(pitem).to_not be_available
    end

    it 'is not activable' do
      expect(pitem).to_not be_activable
    end

    it 'is deletable' do
      expect(pitem).to be_deletable
    end
  end

  describe 'bundle' do
    it 'is not available' do
      expect(bundle).to_not be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is deletable' do
      expect(bundle).to be_deletable
    end
  end

  describe 'physical item' do
    it 'has positive qty' do
      expect do
        pitem.qty = qty
        pitem.save!
      end.to change { pitem.qty }.to(qty)
    end

    it 'is available' do
      expect(pitem).to be_available
    end

    it 'is activable' do
      expect(pitem).to be_activable
    end

    it 'is deletable' do
      expect(pitem).to be_deletable
    end
  end

  describe 'bundle' do
    it 'is available' do
      expect(bundle).to be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is deletable' do
      expect(bundle).to be_deletable
    end
  end

  describe 'physical item' do
    it 'is activated' do
      expect { pitem.activate! }.to change { pitem.active? }.from(false).to(true)
    end

    it 'is available' do
      expect(pitem).to be_available
    end

    it 'is not activable' do
      expect(pitem).to_not be_activable
    end

    it 'is not deletable' do
      expect(pitem).to_not be_deletable
    end 
  end

  describe 'bundle' do
    it 'is available' do
      expect(bundle).to be_available
    end

    it 'is avalaible' do
      expect(bundle).to be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is deletable' do
      expect(bundle).to be_deletable
    end
  end

  describe 'digital item' do
    it 'is activated' do
      expect { ditem.activate! }.to change { ditem.active? }.from(false).to(true)
    end

    it 'is available' do
      expect(ditem).to be_available
    end

    it 'is not activable' do
      expect(ditem).to_not be_activable
    end

    it 'is not deletable' do
      expect(ditem).to_not be_deletable
    end 
  end

  describe 'bundle' do
    it 'is available' do
      expect(bundle).to be_available
    end

    it 'is available' do
      expect(bundle).to be_available
    end

    it 'is activable' do
      expect(bundle).to be_activable
    end

    it 'is deletable' do
      expect(bundle).to be_deletable
    end
  end

  describe 'bundle' do
    it 'is activated' do
      expect { bundle.activate! }.to change { bundle.active? }.from(false).to(true)
    end

    it 'is available' do
      expect(bundle).to be_available
    end

    it 'is not activable' do
      expect(bundle).to_not be_activable
    end

    it 'is not deletable' do
      expect(bundle).to_not be_deletable
    end
  end

  describe 'physical item' do
    it 'cannot be deleted' do
      expect { pitem.delete! }.to_not change { pitem.deleted? }
    end
  end

  describe 'digital item' do
    it 'cannot be deleted' do
      expect { ditem.delete! }.to_not change { ditem.deleted? }
    end
  end

  describe 'bundle' do
    it 'cannot be deleted' do
      expect { bundle.delete! }.to_not change { bundle.deleted? }
    end
  end
end
