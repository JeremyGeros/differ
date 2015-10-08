module Differ
  class Diff
    def initialize(*parts)
      @raw = parts
    end

    def append_to_last(x)
      @raw.last << x
    end

    def same(*str)
      return if str.empty?
      # the items in the @raw array are strings and/or
      # changes. If the last one is a string (not a change),
      # and the item we've just encountered is another
      # unchanged string, we just want to append this string
      # to the one we left off with.

      if @raw.last.is_a? String
        @raw.last << sep
        # we'll append the contents of the string below
      elsif @raw.last.is_a? Change
        if @raw.last.change?
          @raw << sep
        else
          del_or_insert = @raw.last.insert? ? :insert : :delete
          opposite_del_or_insert = del_or_insert == :insert ? :delete : :insert
          change = update_last_change(opposite_del_or_insert)
          append_change(change, del_or_insert)
        end
      else
        # we need a string to append the incoming sameness to
        @raw << ''
      end
      @raw.last << str.join(sep)
    end




    def delete(*str)
      delete_or_insert(:delete, str)
    end

    def insert(*str)
      delete_or_insert(:insert, str)
    end

    def ==(other)
      @raw == other.raw_array
    end

    def to_s
      @raw.join
    end

    # def format_as(f, interesting = false)
    #   f = Differ.format_for(f)

    #   index = 0
    #   # @raw.inject('') do |sum, part|
    #   #   part = case part
    #   #   when String 
    #   #     first_part, last_part = "", ""
    #   #     if interesting && part.length > 200
    #   #       if @raw[index+1] && @raw[index+1].is_a?(Change)
    #   #         first_part = part.split(//).last(100).join
    #   #         first_part = "..." + first_part if first_part.length != part.length
    #   #       end
    #   #       if index > 0 && @raw[index-1] && @raw[index-1].is_a?(Change)
    #   #         last_part = part.split(//).first(100).join
    #   #         last_part += "..." if last_part.length != part.length
    #   #       end
    #   #       excerpt_part = last_part + first_part
            
    #   #       excerpt_part.blank? ? part : excerpt_part
    #   #     else
    #   #       part
    #   #     end
    #   #   when Change then f.format(part)
    #   @raw.reduce('') do |sum, part|
    #     part = case part
    #     when String then part
    #     when Change then f.call(part)
    #     end
    #     index += 1
    #     sum << part
    #   end
    # end

    def format_as(f, interesting = false)
        f = Differ.format_for(f)
        @raw.reduce('') do |sum, part|
          part = case part
          when String then part
          when Change then f.call(part)
          end
          sum << part
        end
      end

    def changes
      @raw.select { |part| Change === part }
    end

    def insert_count
      @raw.count { |part| Change === part && part.insert? }
    end

    def delete_count
      @raw.count { |part| Change === part && part.delete? }
    end

    def change_count
      @raw.count { |part| Change === part }
    end

    def raw_array
      @raw
    end

    private
    def sep
      "#{Differ.separator}"
    end

    #TODO:
    # I've removed the dupe code.
    # Now this needs to be simplified.
    def delete_or_insert(del_or_insert, str)
      # del_or_insert accepts :delete or :insert
      return if str.empty?

      if (@raw.last.is_a? Change)
        change = update_last_change(del_or_insert)

      else # it's either a string, or nil
        change = Change.new(del_or_insert =>( @raw.empty? ? '' : sep))
      end
      append_change(change, del_or_insert, str)
    end


    def append_change(change, del_or_insert, str = nil)
      @raw << change
      if ! str.nil?
        @raw.last.send(del_or_insert) << str.join(sep)
      else
        @raw.last.send(del_or_insert) << sep
        @raw << ''
      end
    end


    def update_last_change(del_or_insert)
      # this was extracted from #delete_or_insert
      # but it's the same code as #same used
      # only with the :insert / :delete flipped
      question = "#{del_or_insert}?".to_sym
      # remove the last item from the @raw
      # so that we can tweak it.
      change = @raw.pop
      if change.has_opposite_of?(del_or_insert) && @raw.last
        opposite_val = change.opposite_of(del_or_insert)
        replacement_made = opposite_val.sub!(/^#{Regexp.quote(sep)}/, '')
        @raw.last << sep if replacement_made
      end
      change.send(del_or_insert) << sep if change.send(question)
      change
    end

  end
end
