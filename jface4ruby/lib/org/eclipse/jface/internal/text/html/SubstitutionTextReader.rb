require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Html
  module SubstitutionTextReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Reader
    }
  end
  
  # Reads the text contents from a reader and computes for each character
  # a potential substitution. The substitution may eat more characters than
  # only the one passed into the computation routine.
  # <p>
  # Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
  class SubstitutionTextReader < SubstitutionTextReaderImports.const_get :SingleCharReader
    include_class_members SubstitutionTextReaderImports
    
    class_module.module_eval {
      const_set_lazy(:LINE_DELIM) { System.get_property("line.separator", "\n") }
      const_attr_reader  :LINE_DELIM
    }
    
    # $NON-NLS-1$ //$NON-NLS-2$
    attr_accessor :f_reader
    alias_method :attr_f_reader, :f_reader
    undef_method :f_reader
    alias_method :attr_f_reader=, :f_reader=
    undef_method :f_reader=
    
    attr_accessor :f_was_white_space
    alias_method :attr_f_was_white_space, :f_was_white_space
    undef_method :f_was_white_space
    alias_method :attr_f_was_white_space=, :f_was_white_space=
    undef_method :f_was_white_space=
    
    attr_accessor :f_char_after_white_space
    alias_method :attr_f_char_after_white_space, :f_char_after_white_space
    undef_method :f_char_after_white_space
    alias_method :attr_f_char_after_white_space=, :f_char_after_white_space=
    undef_method :f_char_after_white_space=
    
    # Tells whether white space characters are skipped.
    attr_accessor :f_skip_white_space
    alias_method :attr_f_skip_white_space, :f_skip_white_space
    undef_method :f_skip_white_space
    alias_method :attr_f_skip_white_space=, :f_skip_white_space=
    undef_method :f_skip_white_space=
    
    attr_accessor :f_read_from_buffer
    alias_method :attr_f_read_from_buffer, :f_read_from_buffer
    undef_method :f_read_from_buffer
    alias_method :attr_f_read_from_buffer=, :f_read_from_buffer=
    undef_method :f_read_from_buffer=
    
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    attr_accessor :f_index
    alias_method :attr_f_index, :f_index
    undef_method :f_index
    alias_method :attr_f_index=, :f_index=
    undef_method :f_index=
    
    typesig { [Reader] }
    def initialize(reader)
      @f_reader = nil
      @f_was_white_space = false
      @f_char_after_white_space = 0
      @f_skip_white_space = false
      @f_read_from_buffer = false
      @f_buffer = nil
      @f_index = 0
      super()
      @f_skip_white_space = true
      @f_reader = reader
      @f_buffer = StringBuffer.new
      @f_index = 0
      @f_read_from_buffer = false
      @f_char_after_white_space = -1
      @f_was_white_space = true
    end
    
    typesig { [::Java::Int] }
    # Computes the substitution for the given character and if necessary
    # subsequent characters. Implementation should use <code>nextChar</code>
    # to read subsequent characters.
    # 
    # @param c the character to be substituted
    # @return the substitution for <code>c</code>
    # @throws IOException in case computing the substitution fails
    def compute_substitution(c)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the internal reader.
    # 
    # @return the internal reader
    def get_reader
      return @f_reader
    end
    
    typesig { [] }
    # Returns the next character.
    # @return the next character
    # @throws IOException in case reading the character fails
    def next_char
      @f_read_from_buffer = (@f_buffer.length > 0)
      if (@f_read_from_buffer)
        ch = @f_buffer.char_at(((@f_index += 1) - 1))
        if (@f_index >= @f_buffer.length)
          @f_buffer.set_length(0)
          @f_index = 0
        end
        return ch
      end
      ch = @f_char_after_white_space
      if ((ch).equal?(-1))
        ch = @f_reader.read
      end
      if (@f_skip_white_space && Character.is_whitespace(RJava.cast_to_char(ch)))
        begin
          ch = @f_reader.read
        end while (Character.is_whitespace(RJava.cast_to_char(ch)))
        if (!(ch).equal?(-1))
          @f_char_after_white_space = ch
          return Character.new(?\s.ord)
        end
      else
        @f_char_after_white_space = -1
      end
      return ch
    end
    
    typesig { [] }
    # @see Reader#read()
    def read
      c = 0
      begin
        c = next_char
        while (!@f_read_from_buffer)
          s = compute_substitution(c)
          if ((s).nil?)
            break
          end
          if (s.length > 0)
            @f_buffer.insert(0, s)
          end
          c = next_char
        end
      end while (@f_skip_white_space && @f_was_white_space && ((c).equal?(Character.new(?\s.ord))))
      @f_was_white_space = ((c).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\r.ord)) || (c).equal?(Character.new(?\n.ord)))
      return c
    end
    
    typesig { [] }
    # @see Reader#ready()
    def ready
      return @f_reader.ready
    end
    
    typesig { [] }
    # @see Reader#close()
    def close
      @f_reader.close
    end
    
    typesig { [] }
    # @see Reader#reset()
    def reset
      @f_reader.reset
      @f_was_white_space = true
      @f_char_after_white_space = -1
      @f_buffer.set_length(0)
      @f_index = 0
    end
    
    typesig { [::Java::Boolean] }
    def set_skip_whitespace(state)
      @f_skip_white_space = state
    end
    
    typesig { [] }
    def is_skipping_whitespace
      return @f_skip_white_space
    end
    
    private
    alias_method :initialize__substitution_text_reader, :initialize
  end
  
end
