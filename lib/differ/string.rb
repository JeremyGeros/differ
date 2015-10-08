module Differ
  module StringDiffer
    def diff(old)
      Differ.diff(self, old, Differ.separator || "\n")
    end
    alias_method :-, :diff
  end
end

String.class_eval do
  include Differ::StringDiffer
end
