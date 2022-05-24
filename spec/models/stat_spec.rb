require 'rails_helper'

describe Stat do
  before do
    Stat.delete_all
  end

  describe '#create!' do
    it 'must create stats if not existing' do
      name  = 'foo'
      today = Date.today
      data = { 'bar' => 'baz' }
      expect { Stat.create! name, data }
        .to change { Stat.count }.from(0).to(1)
      stat = Stat.first
      expect(stat.name).to eq name
      expect(stat.date).to eq today
      expect(stat.data).to eq data
    end

    it 'must delete existing date if exist' do
      name  = 'foo'
      today = Date.today
      data = { 'bar' => 'baz' }
      expect { Stat.create! name, data }
        .to change { Stat.count }.from(0).to(1)

      data = { 'bar' => 'qux' }
      expect { Stat.create! name, data }
        .to_not change { Stat.count }

      stat = Stat.first
      expect(stat.name).to eq name
      expect(stat.date).to eq today
      expect(stat.data).to eq data
    end
  end

  describe '#[]' do
    it 'must retrieve the youngest data' do
      name = 'foo'

      stat = Stat[name]
      expect(stat).to be_nil

      data = { 'bar' => 'baz' }
      date = Date.new 1970, 1, 1
      Stat.create! name, data, date

      stat = Stat[name]
      expect(stat).to_not be_nil
      expect(stat.date).to eq date
      expect(stat.data).to eq data

      data = { 'bar' => 'qux' }
      date = Date.new 1970, 1, 2
      Stat.create! name, data, date

      stat = Stat[name]
      expect(stat).to_not be_nil
      expect(stat.date).to eq date
      expect(stat.data).to eq data
    end
  end
end
