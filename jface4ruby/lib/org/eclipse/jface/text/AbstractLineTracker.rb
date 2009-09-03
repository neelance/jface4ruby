require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module AbstractLineTrackerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
    }
  end
  
  # Abstract implementation of <code>ILineTracker</code>. It lets the definition of line
  # delimiters to subclasses. Assuming that '\n' is the only line delimiter, this abstract
  # implementation defines the following line scheme:
  # <ul>
  # <li> "" -> [0,0]
  # <li> "a" -> [0,1]
  # <li> "\n" -> [0,1], [1,0]
  # <li> "a\n" -> [0,2], [2,0]
  # <li> "a\nb" -> [0,2], [2,1]
  # <li> "a\nbc\n" -> [0,2], [2,3], [5,0]
  # </ul>
  # <p>
  # This class must be subclassed.
  # </p>
  class AbstractLineTracker 
    include_class_members AbstractLineTrackerImports
    include ILineTracker
    include ILineTrackerExtension
    
    class_module.module_eval {
      # Tells whether this class is in debug mode.
      # 
      # @since 3.1
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      # Combines the information of the occurrence of a line delimiter. <code>delimiterIndex</code>
      # is the index where a line delimiter starts, whereas <code>delimiterLength</code>,
      # indicates the length of the delimiter.
      const_set_lazy(:DelimiterInfo) { Class.new do
        include_class_members AbstractLineTracker
        
        attr_accessor :delimiter_index
        alias_method :attr_delimiter_index, :delimiter_index
        undef_method :delimiter_index
        alias_method :attr_delimiter_index=, :delimiter_index=
        undef_method :delimiter_index=
        
        attr_accessor :delimiter_length
        alias_method :attr_delimiter_length, :delimiter_length
        undef_method :delimiter_length
        alias_method :attr_delimiter_length=, :delimiter_length=
        undef_method :delimiter_length=
        
        attr_accessor :delimiter
        alias_method :attr_delimiter, :delimiter
        undef_method :delimiter
        alias_method :attr_delimiter=, :delimiter=
        undef_method :delimiter=
        
        typesig { [] }
        def initialize
          @delimiter_index = 0
          @delimiter_length = 0
          @delimiter = nil
        end
        
        private
        alias_method :initialize__delimiter_info, :initialize
      end }
      
      # Representation of replace and set requests.
      # 
      # @since 3.1
      const_set_lazy(:Request) { Class.new do
        include_class_members AbstractLineTracker
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        attr_accessor :text
        alias_method :attr_text, :text
        undef_method :text
        alias_method :attr_text=, :text=
        undef_method :text=
        
        typesig { [::Java::Int, ::Java::Int, String] }
        def initialize(offset, length, text)
          @offset = 0
          @length = 0
          @text = nil
          @offset = offset
          @length = length
          @text = text
        end
        
        typesig { [String] }
        def initialize(text)
          @offset = 0
          @length = 0
          @text = nil
          @offset = -1
          @length = -1
          @text = text
        end
        
        typesig { [] }
        def is_replace_request
          return @offset > -1 && @length > -1
        end
        
        private
        alias_method :initialize__request, :initialize
      end }
    }
    
    # The active rewrite session.
    # 
    # @since 3.1
    attr_accessor :f_active_rewrite_session
    alias_method :attr_f_active_rewrite_session, :f_active_rewrite_session
    undef_method :f_active_rewrite_session
    alias_method :attr_f_active_rewrite_session=, :f_active_rewrite_session=
    undef_method :f_active_rewrite_session=
    
    # The list of pending requests.
    # 
    # @since 3.1
    attr_accessor :f_pending_requests
    alias_method :attr_f_pending_requests, :f_pending_requests
    undef_method :f_pending_requests
    alias_method :attr_f_pending_requests=, :f_pending_requests=
    undef_method :f_pending_requests=
    
    # The implementation that this tracker delegates to.
    # 
    # @since 3.2
    attr_accessor :f_delegate
    alias_method :attr_f_delegate, :f_delegate
    undef_method :f_delegate
    alias_method :attr_f_delegate=, :f_delegate=
    undef_method :f_delegate=
    
    # Whether the delegate needs conversion when the line structure is modified.
    attr_accessor :f_needs_conversion
    alias_method :attr_f_needs_conversion, :f_needs_conversion
    undef_method :f_needs_conversion
    alias_method :attr_f_needs_conversion=, :f_needs_conversion=
    undef_method :f_needs_conversion=
    
    typesig { [] }
    # Creates a new line tracker.
    def initialize
      @f_active_rewrite_session = nil
      @f_pending_requests = nil
      @f_delegate = Class.new(ListLineTracker.class == Class ? ListLineTracker : Object) do
        extend LocalClass
        include_class_members AbstractLineTracker
        include ListLineTracker if ListLineTracker.class == Module
        
        typesig { [] }
        define_method :get_legal_line_delimiters do
          return @local_class_parent.get_legal_line_delimiters
        end
        
        typesig { [String, ::Java::Int] }
        define_method :next_delimiter_info do |text, offset|
          return @local_class_parent.next_delimiter_info(text, offset)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_needs_conversion = true
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ILineTracker#computeNumberOfLines(java.lang.String)
    def compute_number_of_lines(text)
      return @f_delegate.compute_number_of_lines(text)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineDelimiter(int)
    def get_line_delimiter(line)
      check_rewrite_session
      return @f_delegate.get_line_delimiter(line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineInformation(int)
    def get_line_information(line)
      check_rewrite_session
      return @f_delegate.get_line_information(line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineInformationOfOffset(int)
    def get_line_information_of_offset(offset)
      check_rewrite_session
      return @f_delegate.get_line_information_of_offset(offset)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineLength(int)
    def get_line_length(line)
      check_rewrite_session
      return @f_delegate.get_line_length(line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineNumberOfOffset(int)
    def get_line_number_of_offset(offset)
      check_rewrite_session
      return @f_delegate.get_line_number_of_offset(offset)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineOffset(int)
    def get_line_offset(line)
      check_rewrite_session
      return @f_delegate.get_line_offset(line)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ILineTracker#getNumberOfLines()
    def get_number_of_lines
      begin
        check_rewrite_session
      rescue BadLocationException => x
        # TODO there is currently no way to communicate that exception back to the document
      end
      return @f_delegate.get_number_of_lines
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getNumberOfLines(int, int)
    def get_number_of_lines(offset, length)
      check_rewrite_session
      return @f_delegate.get_number_of_lines(offset, length)
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ILineTracker#set(java.lang.String)
    def set(text)
      if (has_active_rewrite_session)
        @f_pending_requests.clear
        @f_pending_requests.add(Request.new(text))
        return
      end
      @f_delegate.set(text)
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.ILineTracker#replace(int, int, java.lang.String)
    def replace(offset, length, text)
      if (has_active_rewrite_session)
        @f_pending_requests.add(Request.new(offset, length, text))
        return
      end
      check_implementation
      @f_delegate.replace(offset, length, text)
    end
    
    typesig { [] }
    # Converts the implementation to be a {@link TreeLineTracker} if it isn't yet.
    # 
    # @since 3.2
    def check_implementation
      if (@f_needs_conversion)
        @f_needs_conversion = false
        @f_delegate = Class.new(TreeLineTracker.class == Class ? TreeLineTracker : Object) do
          extend LocalClass
          include_class_members AbstractLineTracker
          include TreeLineTracker if TreeLineTracker.class == Module
          
          typesig { [String, ::Java::Int] }
          define_method :next_delimiter_info do |text, offset|
            return @local_class_parent.next_delimiter_info(text, offset)
          end
          
          typesig { [] }
          define_method :get_legal_line_delimiters do
            return @local_class_parent.get_legal_line_delimiters
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, @f_delegate)
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Returns the information about the first delimiter found in the given text starting at the
    # given offset.
    # 
    # @param text the text to be searched
    # @param offset the offset in the given text
    # @return the information of the first found delimiter or <code>null</code>
    def next_delimiter_info(text, offset)
      raise NotImplementedError
    end
    
    typesig { [DocumentRewriteSession] }
    # @see org.eclipse.jface.text.ILineTrackerExtension#startRewriteSession(org.eclipse.jface.text.DocumentRewriteSession)
    # @since 3.1
    def start_rewrite_session(session)
      if (!(@f_active_rewrite_session).nil?)
        raise IllegalStateException.new
      end
      @f_active_rewrite_session = session
      @f_pending_requests = ArrayList.new(20)
    end
    
    typesig { [DocumentRewriteSession, String] }
    # @see org.eclipse.jface.text.ILineTrackerExtension#stopRewriteSession(org.eclipse.jface.text.DocumentRewriteSession, java.lang.String)
    # @since 3.1
    def stop_rewrite_session(session, text)
      if ((@f_active_rewrite_session).equal?(session))
        @f_active_rewrite_session = nil
        @f_pending_requests = nil
        set(text)
      end
    end
    
    typesig { [] }
    # Tells whether there's an active rewrite session.
    # 
    # @return <code>true</code> if there is an active rewrite session, <code>false</code>
    # otherwise
    # @since 3.1
    def has_active_rewrite_session
      return !(@f_active_rewrite_session).nil?
    end
    
    typesig { [] }
    # Flushes the active rewrite session.
    # 
    # @throws BadLocationException in case the recorded requests cannot be processed correctly
    # @since 3.1
    def flush_rewrite_session
      if (DEBUG)
        System.out.println("AbstractLineTracker: Flushing rewrite session: " + RJava.cast_to_string(@f_active_rewrite_session))
      end # $NON-NLS-1$
      e = @f_pending_requests.iterator
      @f_pending_requests = nil
      @f_active_rewrite_session = nil
      while (e.has_next)
        request = e.next_
        if (request.is_replace_request)
          replace(request.attr_offset, request.attr_length, request.attr_text)
        else
          set(request.attr_text)
        end
      end
    end
    
    typesig { [] }
    # Checks the presence of a rewrite session and flushes it.
    # 
    # @throws BadLocationException in case flushing does not succeed
    # @since 3.1
    def check_rewrite_session
      if (has_active_rewrite_session)
        flush_rewrite_session
      end
    end
    
    private
    alias_method :initialize__abstract_line_tracker, :initialize
  end
  
end
