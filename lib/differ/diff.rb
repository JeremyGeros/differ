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

    def delete(*str)
      return if str.empty?
      if @raw.last.is_a? Change
        change = @raw.pop
        if change.insert? && @raw.last
          @raw.last << sep if change.insert.sub!(/^#{Regexp.quote(sep)}/, '')
        end
        change.delete << sep if change.delete?
      else
        change = Change.new(:delete => @raw.empty? ? '' : sep)
      end

      @raw << change
      @raw.last.delete << str.join(sep)
    end

    def insert(*str)
      return if str.empty?
      if @raw.last.is_a? Change
        change = @raw.pop
        if change.delete? && @raw.last
          @raw.last << sep if change.delete.sub!(/^#{Regexp.quote(sep)}/, '')
        end
        change.insert << sep if change.insert?
      else
        change = Change.new(:insert => @raw.empty? ? '' : sep)
      end

      @raw << change
      @raw.last.insert << str.join(sep)
    end

    def ==(other)
      @raw == other.raw_array
    end

    def to_s
      @raw.join()
    end

    def format_as(f, interesting = false)
      f = Differ.format_for(f)
      index = 0
      @raw.inject('') do |sum, part|
        part = case part
        when String 
          first_part, last_part = "", ""
          if interesting && part.length > 200
            if @raw[index+1] && @raw[index+1].is_a?(Change)
              first_part = part.split(//).last(100).join
              first_part = "..." + first_part if first_part.length != part.length
            end
            if index > 0 && @raw[index-1] && @raw[index-1].is_a?(Change)
              last_part = part.split(//).first(100).join
              last_part += "..." if last_part.length != part.length
            end
            excerpt_part = last_part + first_part
            
            excerpt_part.blank? ? part : excerpt_part
          else
            part
          end
        when Change then f.format(part)
        end
        index += 1
        sum << part
      end
    end

  protected
    def raw_array
      @raw
    end

  private
    def sep
      "#{$;}"
    end
  end
end
