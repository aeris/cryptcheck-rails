require 'rails_helper'

describe Analysis do
  describe '::find_refresh_delay' do
    it 'must return host value' do
      expect(Analysis::RESOLVER).to receive(:getresources)
                                     .with('www.example.org', ::Resolv::DNS::Resource::IN::TXT)
                                     .and_return([::Resolv::DNS::Resource::IN::TXT.new('cryptcheck=PT1M')])
      allow(Analysis::RESOLVER).to receive(:getresources)
                                     .with('example.org', ::Resolv::DNS::Resource::IN::TXT)
                                     .and_raise(Exception, :must_not_be_called)
      host = Analysis.new host: 'www.example.org'
      expect(host.find_refresh_delay).to eq 1.minute
    end

    it 'must recurse domain value' do
      expect(Analysis::RESOLVER).to receive(:getresources)
                                     .with('www.example.org', ::Resolv::DNS::Resource::IN::TXT)
                                     .and_return([])
      expect(Analysis::RESOLVER).to receive(:getresources)
                                     .with('example.org', ::Resolv::DNS::Resource::IN::TXT)
                                     .and_return([::Resolv::DNS::Resource::IN::TXT.new('cryptcheck=PT1M')])
      allow(Analysis::RESOLVER).to receive(:getresources)
                                     .with('org', ::Resolv::DNS::Resource::IN::TXT)
                                     .and_raise(Exception, :must_not_be_called)
      host = Analysis.new host: 'www.example.org'
      expect(host.find_refresh_delay).to eq 1.minute
    end

    it 'must not test TLD' do
      expect(Analysis::RESOLVER).to receive(:getresources)
                                      .with('www.example.org', ::Resolv::DNS::Resource::IN::TXT)
                                      .and_return([])
      expect(Analysis::RESOLVER).to receive(:getresources)
                                      .with('example.org', ::Resolv::DNS::Resource::IN::TXT)
                                      .and_return([])
      allow(Analysis::RESOLVER).to receive(:getresources)
                                      .with('org', ::Resolv::DNS::Resource::IN::TXT)
                                      .and_raise(Exception, :must_not_be_called)
      host = Analysis.new host: 'www.example.org'
      expect(host.find_refresh_delay).to eq 1.hour
    end

    it 'must support debug mode' do
      expect(Analysis::RESOLVER).to receive(:getresources)
                                      .with('www.example.org', ::Resolv::DNS::Resource::IN::TXT)
                                      .and_return([::Resolv::DNS::Resource::IN::TXT.new('cryptcheck=debug')])
      allow(Analysis::RESOLVER).to receive(:getresources)
                                     .with('example.org', ::Resolv::DNS::Resource::IN::TXT)
                                     .and_raise(Exception, :must_not_be_called)
      host = Analysis.new host: 'www.example.org'
      expect(host.find_refresh_delay).to be_nil
    end
  end
end
