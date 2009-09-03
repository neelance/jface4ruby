require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Formatter
  module ContextBasedFormattingStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Formatter
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :Map
    }
  end
  
  # Formatting strategy for context based content formatting. Retrieves the preferences
  # set on the formatting context's {@link FormattingContextProperties#CONTEXT_PREFERENCES}
  # property and makes them available to subclasses.
  # <p>
  # 
  # @since 3.0
  class ContextBasedFormattingStrategy 
    include_class_members ContextBasedFormattingStrategyImports
    include IFormattingStrategy
    include IFormattingStrategyExtension
    
    # The current preferences for formatting
    attr_accessor :f_current_preferences
    alias_method :attr_f_current_preferences, :f_current_preferences
    undef_method :f_current_preferences
    alias_method :attr_f_current_preferences=, :f_current_preferences=
    undef_method :f_current_preferences=
    
    # The list of preferences for initiated the formatting steps
    attr_accessor :f_preferences
    alias_method :attr_f_preferences, :f_preferences
    undef_method :f_preferences
    alias_method :attr_f_preferences=, :f_preferences=
    undef_method :f_preferences=
    
    typesig { [] }
    # @see org.eclipse.jface.text.formatter.IFormattingStrategyExtension#format()
    def format
      @f_current_preferences = @f_preferences.remove_first
    end
    
    typesig { [String, ::Java::Boolean, String, Array.typed(::Java::Int)] }
    # @see org.eclipse.jface.text.formatter.IFormattingStrategy#format(java.lang.String, boolean, java.lang.String, int[])
    def format(content, start, indentation, positions)
      return nil
    end
    
    typesig { [IFormattingContext] }
    # @see org.eclipse.jface.text.formatter.IFormattingStrategyExtension#formatterStarts(org.eclipse.jface.text.formatter.IFormattingContext)
    def formatter_starts(context)
      @f_preferences.add_last(context.get_property(FormattingContextProperties::CONTEXT_PREFERENCES))
    end
    
    typesig { [String] }
    # @see IFormattingStrategy#formatterStarts(String)
    def formatter_starts(indentation)
      # Do nothing
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.formatter.IFormattingStrategyExtension#formatterStops()
    def formatter_stops
      @f_preferences.clear
      @f_current_preferences = nil
    end
    
    typesig { [] }
    # Returns the preferences used for the current formatting step.
    # 
    # @return The preferences for the current formatting step
    def get_preferences
      return @f_current_preferences
    end
    
    typesig { [] }
    def initialize
      @f_current_preferences = nil
      @f_preferences = LinkedList.new
    end
    
    private
    alias_method :initialize__context_based_formatting_strategy, :initialize
  end
  
end
