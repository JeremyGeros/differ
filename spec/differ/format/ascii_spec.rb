require 'spec_helper'

describe Differ::Format::Ascii do
  it 'should format inserts well' do
    @expected = '{+"SAMPLE"}'
    expect(Differ::Format::Ascii.call(+'SAMPLE')).to(eq(@expected))
  end

  it 'should format deletes well' do
    @expected = '{-"SAMPLE"}'
    expect(Differ::Format::Ascii.call(-'SAMPLE')).to(eq(@expected))
  end

  it 'should format changes well' do
    expect(Differ::Format::Ascii.call(
      Differ::Change.new({delete: 'THEN', insert: 'NOW'})
    )).to eq('{"THEN" >> "NOW"}')
  end
end
