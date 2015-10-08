require 'differ/change'
require 'differ/diff'
require 'differ/format/ascii'
require 'differ/format/color'
require 'differ/format/html'

module Differ
  class << self
    @@separator = ''

    def separator=(separator)
      @@separator = separator
    end

    def separator
      @@separator
    end

    def diff(target, source, new_sep = "\n")
      old_sep = separator
      self.separator = new_sep

      target = target.split(new_sep)
      source = source.split(new_sep)

      self.separator = '' if new_sep.is_a? Regexp

      @diff = Diff.new
      advance(source, target) until source.empty? || target.empty?
      @diff.insert(*target) || @diff.delete(*source)
      return @diff
    ensure
      self.separator = old_sep
    end

    def diff_by_char(to, from)
      diff(to, from, '')
    end

    def diff_by_word(to, from)
      diff(to, from, /\b/)
    end

    def diff_by_line(to, from)
      diff(to, from, "\n")
    end

    def format=(f)
      @format = format_for(f)
    end

    def format
      @format || Format::Ascii
    end

    def format_for(f)
      if f.respond_to? :call
        f
      else
        case f
        when :ascii then Format::Ascii
        when :color then Format::Color
        when :html  then Format::HTML
        when nil    then nil
        else fail "Unknown format type #{f.inspect}"
        end
      end
    end

    private
    def advance(source, target)
      # items moving from source -> target

      # shift the first thing off
      first_source_item, first_target_item = source.shift, target.shift

      prioritize_insert = target.length > source.length

      insertion_idx = target.index(first_source_item)
      # does the first_source_item
      # exist in the target still?
      deletion_idx = source.index(first_target_item)
      # did the first_target_item
      # exist in the source


      if first_source_item == first_target_item
        @diff.same(first_target_item)
      elsif insertion_idx && prioritize_insert #see note below
        insert(target.unshift(first_target_item), insertion_idx)
      elsif deletion_idx
        delete(source.unshift(first_source_item), deletion_idx)
      elsif insertion_idx && !prioritize_insert # see note below
        insert(target.unshift(first_target_item), insertion_idx)
      else
        @diff.insert(first_target_item) && @diff.delete(first_source_item)
      end
      # It looks like both of the inserts above could be combined.
      # They can't. They also can't be reordered.
      # The reason is that sometimes the deletion_idx and insertion_idx
      # are both non-nil
    end

    def insert(array, index)
      change(:insert, array, index)
    end
    def delete(array, index)
      change(:delete, array, index)
    end
    def change(method, array, index)
      @diff.send(method, *array.slice!(0..index))
      @diff.same(array.shift)
    end
  end
end
