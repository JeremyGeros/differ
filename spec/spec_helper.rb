require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'rubygems'
#require 'byebug'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'differ'

class String
  def +@
    Differ::Change.new(insert: self)
  end

  def -@
    Differ::Change.new(delete: self)
  end

  def >>(to)
    Differ::Change.new(delete: self, insert: to)
  end
end
