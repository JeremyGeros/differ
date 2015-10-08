module Differ
  module Format
    module HTML
      class << self
        def call(change)
          if change.change?
            as_change(change)
          elsif change.delete?
            as_delete(change)
          elsif change.insert?
            as_insert(change)
          else
            ''
          end
        end

        private
        def as_insert(change)
          %Q(<ins class="differ">#{change.insert}</ins>)
        end

        def as_delete(change)
          %Q(<del class="differ">#{change.delete}</del>)
        end

        def as_change(change)
          as_delete(change) << as_insert(change)
        end
      end
    end
  end
end
