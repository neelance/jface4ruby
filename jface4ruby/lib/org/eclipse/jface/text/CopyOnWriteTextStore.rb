require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Anton Leherbauer (anton.leherbauer@windriver.com) - initial API and implementation
module Org::Eclipse::Jface::Text
  module CopyOnWriteTextStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Copy-on-write <code>ITextStore</code> wrapper.
  # <p>
  # This implementation uses an unmodifiable text store for the initial content. Upon first
  # modification attempt, the unmodifiable store is replaced with a modifiable instance which must be
  # supplied in the constructor.
  # </p>
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # 
  # @since 3.2
  # @noextend This class is not intended to be subclassed by clients.
  class CopyOnWriteTextStore 
    include_class_members CopyOnWriteTextStoreImports
    include ITextStore
    
    class_module.module_eval {
      # An unmodifiable String based text store. It is not possible to modify the content other than
      # using {@link #set}. Trying to {@link #replace} a text range will throw an
      # <code>UnsupportedOperationException</code>.
      const_set_lazy(:StringTextStore) { Class.new do
        include_class_members CopyOnWriteTextStore
        include ITextStore
        
        # Represents the content of this text store.
        attr_accessor :f_text
        alias_method :attr_f_text, :f_text
        undef_method :f_text
        alias_method :attr_f_text=, :f_text=
        undef_method :f_text=
        
        typesig { [] }
        # $NON-NLS-1$
        # 
        # Create an empty text store.
        def initialize
          @f_text = ""
        end
        
        typesig { [String] }
        # Create a text store with initial content.
        # 
        # @param text the initial content
        def initialize(text)
          @f_text = ""
          set(text)
        end
        
        typesig { [::Java::Int] }
        # @see org.eclipse.jface.text.ITextStore#get(int)
        def get(offset)
          return @f_text.char_at(offset)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # @see org.eclipse.jface.text.ITextStore#get(int, int)
        def get(offset, length)
          return @f_text.substring(offset, offset + length)
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.ITextStore#getLength()
        def get_length
          return @f_text.length
        end
        
        typesig { [::Java::Int, ::Java::Int, String] }
        # @see org.eclipse.jface.text.ITextStore#replace(int, int, java.lang.String)
        def replace(offset, length_, text)
          # modification not supported
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [String] }
        # @see org.eclipse.jface.text.ITextStore#set(java.lang.String)
        def set(text)
          @f_text = RJava.cast_to_string(!(text).nil? ? text : "") # $NON-NLS-1$
        end
        
        private
        alias_method :initialize__string_text_store, :initialize
      end }
    }
    
    # The underlying "real" text store
    attr_accessor :f_text_store
    alias_method :attr_f_text_store, :f_text_store
    undef_method :f_text_store
    alias_method :attr_f_text_store=, :f_text_store=
    undef_method :f_text_store=
    
    # A modifiable <code>ITextStore</code> instance
    attr_accessor :f_modifiable_text_store
    alias_method :attr_f_modifiable_text_store, :f_modifiable_text_store
    undef_method :f_modifiable_text_store
    alias_method :attr_f_modifiable_text_store=, :f_modifiable_text_store=
    undef_method :f_modifiable_text_store=
    
    typesig { [ITextStore] }
    # Creates an empty text store. The given text store will be used upon first modification
    # attempt.
    # 
    # @param modifiableTextStore a modifiable <code>ITextStore</code> instance, may not be
    # <code>null</code>
    def initialize(modifiable_text_store)
      @f_text_store = StringTextStore.new
      @f_modifiable_text_store = nil
      Assert.is_not_null(modifiable_text_store)
      @f_text_store = StringTextStore.new
      @f_modifiable_text_store = modifiable_text_store
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ITextStore#get(int)
    def get(offset)
      return @f_text_store.get(offset)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.ITextStore#get(int, int)
    def get(offset, length)
      return @f_text_store.get(offset, length)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextStore#getLength()
    def get_length
      return @f_text_store.get_length
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.ITextStore#replace(int, int, java.lang.String)
    def replace(offset, length, text)
      if (!(@f_text_store).equal?(@f_modifiable_text_store))
        content = @f_text_store.get(0, @f_text_store.get_length)
        @f_text_store = @f_modifiable_text_store
        @f_text_store.set(content)
      end
      @f_text_store.replace(offset, length, text)
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ITextStore#set(java.lang.String)
    def set(text)
      @f_text_store = StringTextStore.new(text)
      @f_modifiable_text_store.set("") # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__copy_on_write_text_store, :initialize
  end
  
end
