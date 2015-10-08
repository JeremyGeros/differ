module Differ
  class Change # :nodoc:
    attr_accessor :insert, :delete
    def initialize(options = {})
      @insert = options[:insert] || ''
      @delete = options[:delete] || ''
    end

    def insert?
      !@insert.empty?
    end

    def delete?
      !@delete.empty?
    end

    def has_opposite_of?(delete_or_insert)
      if delete_or_insert == :delete
        self.insert?
      else
        self.delete?
      end
    end

    def opposite_of(delete_or_insert)
      if delete_or_insert == :delete
        @insert
      else
        @delete
      end

    end

    def change?
      insert? && delete?
    end

    def to_s
      Differ.format.call(self)
    end
    alias_method :inspect, :to_s

    def ==(other)
      insert == other.insert && delete == other.delete
    end
  end
end
