require 'spec_helper'

describe RailsCacheMigrator::Migrator do
  let(:old_spec) { :null_store }
  let(:new_spec) { :null_store }

  subject { RailsCacheMigrator::Migrator.new old_spec, new_spec }

  context 'when provided with a symbol for a cache store' do
    let(:old_spec) { :null_store }

    it 'looks up and instantiates it' do
      expect(subject.instance_variable_get(:@old_store)).to be_a ActiveSupport::Cache::NullStore
    end
  end

  context 'when provided with a symbol and options for a cache store' do
    let(:path) { File.dirname(File.expand_path(__FILE__)) }
    let(:new_spec) { [:file_store, path] }

    it 'looks up and instantiates it with the given options' do
      expect(subject.instance_variable_get(:@new_store)).to be_a ActiveSupport::Cache::FileStore
      expect(subject.instance_variable_get(:@new_store).cache_path).to eq path
    end
  end

  context '#migrate' do
    let(:old_spec) { double 'old store' }
    let(:new_spec) { double 'new store' }
    let(:stored_datum) { Marshal.dump(datum) }
    let(:datum) { {datum: 'penguin'} }

    it 'writes the Marshaled data to the new store' do
      allow(old_spec).to receive(:read).and_return stored_datum
      expect(new_spec).to receive(:write).with('key', datum)
      subject.migrate('key')
    end
  end

end
