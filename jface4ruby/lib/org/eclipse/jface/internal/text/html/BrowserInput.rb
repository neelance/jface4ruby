require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Html
  module BrowserInputImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
    }
  end
  
  # A browser input contains an input element and
  # a previous and a next input, if available.
  # 
  # The browser input also provides a human readable
  # name of its input element.
  # 
  # @since 3.4
  class BrowserInput 
    include_class_members BrowserInputImports
    
    attr_accessor :f_previous
    alias_method :attr_f_previous, :f_previous
    undef_method :f_previous
    alias_method :attr_f_previous=, :f_previous=
    undef_method :f_previous=
    
    attr_accessor :f_next
    alias_method :attr_f_next, :f_next
    undef_method :f_next
    alias_method :attr_f_next=, :f_next=
    undef_method :f_next=
    
    typesig { [BrowserInput] }
    # Create a new Browser input.
    # 
    # @param previous the input previous to this or <code>null</code> if this is the first
    def initialize(previous)
      @f_previous = nil
      @f_next = nil
      @f_previous = previous
      if (!(previous).nil?)
        previous.attr_f_next = self
      end
    end
    
    typesig { [] }
    # The previous input or <code>null</code> if this
    # is the first.
    # 
    # @return the previous input or <code>null</code>
    def get_previous
      return @f_previous
    end
    
    typesig { [] }
    # The next input or <code>null</code> if this
    # is the last.
    # 
    # @return the next input or <code>null</code>
    def get_next
      return @f_next
    end
    
    typesig { [] }
    # The element to use to set the browsers input.
    # 
    # @return the input element
    def get_input_element
      raise NotImplementedError
    end
    
    typesig { [] }
    # A human readable name for the input.
    # 
    # @return the input name
    def get_input_name
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__browser_input, :initialize
  end
  
end
