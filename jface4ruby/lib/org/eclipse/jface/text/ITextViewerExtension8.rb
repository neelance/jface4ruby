require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ITextViewerExtension8Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Custom, :StyledTextPrintOptions
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextViewer}. Adds the
  # ability to print and set how hovers should be enriched when the mouse is moved into them.
  # 
  # @since 3.4
  module ITextViewerExtension8
    include_class_members ITextViewerExtension8Imports
    
    typesig { [StyledTextPrintOptions] }
    # Print the text viewer contents using the given options.
    # 
    # @param options the print options
    def print(options)
      raise NotImplementedError
    end
    
    typesig { [EnrichMode] }
    # Sets the hover enrich mode.
    # A non-<code>null</code> <code>mode</code> defines when hovers
    # should be enriched once the mouse is moved into them.
    # If <code>mode</code> is <code>null</code>, hovers are automatically closed
    # when the mouse is moved out of the {@link ITextHover#getHoverRegion(ITextViewer, int) hover region}.
    # <p>
    # Note that a hover can only be enriched if its {@link IInformationControlExtension5#getInformationPresenterControlCreator()}
    # is not <code>null</code>.
    # </p>
    # 
    # @param mode the enrich mode, or <code>null</code>
    def set_hover_enrich_mode(mode)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # Type-safe enum of the available enrich modes.
      const_set_lazy(:EnrichMode) { Class.new do
        include_class_members ITextViewerExtension8
        
        class_module.module_eval {
          # Enrich the hover shortly after the mouse has been moved into it and
          # stopped moving.
          # 
          # @see ITextViewerExtension8#setHoverEnrichMode(org.eclipse.jface.text.ITextViewerExtension8.EnrichMode)
          const_set_lazy(:AFTER_DELAY) { class_self::EnrichMode.new("after delay") }
          const_attr_reader  :AFTER_DELAY
          
          # $NON-NLS-1$
          # 
          # Enrich the hover immediately when the mouse is moved into it.
          # 
          # @see ITextViewerExtension8#setHoverEnrichMode(org.eclipse.jface.text.ITextViewerExtension8.EnrichMode)
          const_set_lazy(:IMMEDIATELY) { class_self::EnrichMode.new("immediately") }
          const_attr_reader  :IMMEDIATELY
          
          # $NON-NLS-1$
          # 
          # Enrich the hover on explicit mouse click.
          # 
          # @see ITextViewerExtension8#setHoverEnrichMode(org.eclipse.jface.text.ITextViewerExtension8.EnrichMode)
          const_set_lazy(:ON_CLICK) { class_self::EnrichMode.new("on click") }
          const_attr_reader  :ON_CLICK
        }
        
        # $NON-NLS-1$;
        attr_accessor :f_name
        alias_method :attr_f_name, :f_name
        undef_method :f_name
        alias_method :attr_f_name=, :f_name=
        undef_method :f_name=
        
        typesig { [String] }
        def initialize(name)
          @f_name = nil
          @f_name = name
        end
        
        typesig { [] }
        # @see java.lang.Object#toString()
        def to_s
          return @f_name
        end
        
        private
        alias_method :initialize__enrich_mode, :initialize
      end }
    }
  end
  
end
