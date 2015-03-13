module Differ
  class Diff
    def initialize
      @raw = []
    end

    def same(*str)
      return if str.empty?
      if @raw.last.is_a? String
        @raw.last << sep
      elsif @raw.last.is_a? Change
        if @raw.last.change?
          @raw << sep
        else
          change = @raw.pop
          if change.insert? && @raw.last
            @raw.last << sep if change.insert.sub!(/^#{Regexp.quote(sep)}/, '')
          end
          if change.delete? && @raw.last
            @raw.last << sep if change.delete.sub!(/^#{Regexp.quote(sep)}/, '')
          end
          @raw << change

          @raw.last.insert << sep if @raw.last.insert?
          @raw.last.delete << sep if @raw.last.delete?
          @raw << ''
        end
      else
        @raw << ''
      end
      @raw.last << str.join(sep)
    end
    
    def delete_or_insert(del_or_insert, str)
      # del_or_insert accepts :delete or :insert
      return if str.empty?
      opposite = del_or_insert == :delete ? :insert : :delete
      question = "#{del_or_insert}?".to_sym
      opposite_question = "#{opposite}?".to_sym
      if (@raw.last.is_a? Change)
        change = @raw.pop
        if change.send(opposite_question) && @raw.last
          @raw.last << sep if change.send(opposite).sub!(/^#{Regexp.quote(sep)}/, '')
        end
        change.send(del_or_insert) << sep if change.send(question)

      else
        change = Change.new(del_or_insert =>( @raw.empty? ? '' : sep))
      end
      @raw << change
      @raw.last.send(del_or_insert) << str.join(sep)
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

    def format_as(f)
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

    protected
    def raw_array
      @raw
    end

    private
    def sep
      "#{Differ.separator}"
    end
  end
end
