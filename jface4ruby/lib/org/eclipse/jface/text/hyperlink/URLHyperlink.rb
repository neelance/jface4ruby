require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module URLHyperlinkImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Com::Ibm::Icu::Text, :MessageFormat
      include_const ::Org::Eclipse::Swt::Program, :Program
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # URL hyperlink.
  # 
  # @since 3.1
  class URLHyperlink 
    include_class_members URLHyperlinkImports
    include IHyperlink
    
    attr_accessor :f_urlstring
    alias_method :attr_f_urlstring, :f_urlstring
    undef_method :f_urlstring
    alias_method :attr_f_urlstring=, :f_urlstring=
    undef_method :f_urlstring=
    
    attr_accessor :f_region
    alias_method :attr_f_region, :f_region
    undef_method :f_region
    alias_method :attr_f_region=, :f_region=
    undef_method :f_region=
    
    typesig { [IRegion, String] }
    # Creates a new URL hyperlink.
    # 
    # @param region the region
    # @param urlString the URL string
    def initialize(region, url_string)
      @f_urlstring = nil
      @f_region = nil
      Assert.is_not_null(url_string)
      Assert.is_not_null(region)
      @f_region = region
      @f_urlstring = url_string
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#getHyperlinkRegion()
    def get_hyperlink_region
      return @f_region
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#open()
    def open
      if (!(@f_urlstring).nil?)
        Program.launch(@f_urlstring)
        return
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#getTypeLabel()
    def get_type_label
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#getHyperlinkText()
    def get_hyperlink_text
      return MessageFormat.format(HyperlinkMessages.get_string("URLHyperlink.hyperlinkText"), Array.typed(Object).new([@f_urlstring])) # $NON-NLS-1$
    end
    
    typesig { [] }
    # Returns the URL string of this hyperlink.
    # 
    # @return the URL string
    # @since 3.2
    def get_urlstring
      return @f_urlstring
    end
    
    private
    alias_method :initialize__urlhyperlink, :initialize
  end
  
end
