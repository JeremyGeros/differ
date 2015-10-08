require 'spec_helper'
require 'differ/string'

describe Differ::StringDiffer do
  it 'should be automatically mixed into String' do
    String.included_modules.should include(Differ::StringDiffer)
  end

  before(:each) do
    Differ.separator = nil
  end

  describe '#diff' do
    it 'should call Differ#diff' do
      Differ.should_receive(:diff).with('TO', 'FROM', "\n").once
      'TO'.diff('FROM')
    end

    it 'should call Differ#diff with Differ.separator' do
      Differ.separator = 'x'
      Differ.should_receive(:diff).with('TO', 'FROM', Differ.separator).once
      'TO'.diff('FROM')
    end
  end

  describe '#-' do
    it 'should call Differ#diff' do
      Differ.should_receive(:diff).with('TO', 'FROM', "\n").once
      'TO' - 'FROM'
    end

    it 'should call Differ#diff with Differ.separator' do
      Differ.separator = 'x'
      Differ.should_receive(:diff).with('TO', 'FROM', Differ.separator).once
      'TO' - 'FROM'
    end
  end
end
