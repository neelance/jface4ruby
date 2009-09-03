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
  module BrowserInformationControlInputImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
    }
  end
  
  # Provides input for a {@link BrowserInformationControl}.
  # 
  # @since 3.4
  class BrowserInformationControlInput < BrowserInformationControlInputImports.const_get :BrowserInput
    include_class_members BrowserInformationControlInputImports
    
    typesig { [] }
    # Returns the leading image width.
    # 
    # @return the size of the leading image, by default <code>0</code> is returned
    # @since 3.4
    def get_leading_image_width
      return 0
    end
    
    typesig { [BrowserInformationControlInput] }
    # Creates the next browser input with the given input as previous one.
    # 
    # @param previous the previous input or <code>null</code> if none
    def initialize(previous)
      super(previous)
    end
    
    typesig { [] }
    # @return the HTML contents
    def get_html
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the HTML from {@link #getHtml()}.
    # This is a fallback mode for platforms where the {@link BrowserInformationControl}
    # is not available and this input is passed to a {@link DefaultInformationControl}.
    # 
    # @return {@link #getHtml()}
    def to_s
      return get_html
    end
    
    private
    alias_method :initialize__browser_information_control_input, :initialize
  end
  
end
