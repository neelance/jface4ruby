require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module ContextInformationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A default implementation of the <code>IContextInformation</code> interface.
  class ContextInformation 
    include_class_members ContextInformationImports
    include IContextInformation
    
    # The name of the context.
    attr_accessor :f_context_display_string
    alias_method :attr_f_context_display_string, :f_context_display_string
    undef_method :f_context_display_string
    alias_method :attr_f_context_display_string=, :f_context_display_string=
    undef_method :f_context_display_string=
    
    # The information to be displayed.
    attr_accessor :f_information_display_string
    alias_method :attr_f_information_display_string, :f_information_display_string
    undef_method :f_information_display_string
    alias_method :attr_f_information_display_string=, :f_information_display_string=
    undef_method :f_information_display_string=
    
    # The image to be displayed.
    attr_accessor :f_image
    alias_method :attr_f_image, :f_image
    undef_method :f_image
    alias_method :attr_f_image=, :f_image=
    undef_method :f_image=
    
    typesig { [String, String] }
    # Creates a new context information without an image.
    # 
    # @param contextDisplayString the string to be used when presenting the context
    # @param informationDisplayString the string to be displayed when presenting the context information
    def initialize(context_display_string, information_display_string)
      initialize__context_information(nil, context_display_string, information_display_string)
    end
    
    typesig { [Image, String, String] }
    # Creates a new context information with an image.
    # 
    # @param image the image to display when presenting the context information
    # @param contextDisplayString the string to be used when presenting the context
    # @param informationDisplayString the string to be displayed when presenting the context information,
    # may not be <code>null</code>
    def initialize(image, context_display_string, information_display_string)
      @f_context_display_string = nil
      @f_information_display_string = nil
      @f_image = nil
      Assert.is_not_null(information_display_string)
      @f_image = image
      @f_context_display_string = context_display_string
      @f_information_display_string = information_display_string
    end
    
    typesig { [Object] }
    # @see IContextInformation#equals(Object)
    def ==(object)
      if (object.is_a?(IContextInformation))
        context_information = object
        equals = @f_information_display_string.equals_ignore_case(context_information.get_information_display_string)
        if (!(@f_context_display_string).nil?)
          equals = equals && @f_context_display_string.equals_ignore_case(context_information.get_context_display_string)
        end
        return equals
      end
      return false
    end
    
    typesig { [] }
    # @see java.lang.Object#hashCode()
    # @since 3.1
    def hash_code
      low = !(@f_context_display_string).nil? ? @f_context_display_string.hash_code : 0
      return (@f_information_display_string.hash_code << 16) | low
    end
    
    typesig { [] }
    # @see IContextInformation#getInformationDisplayString()
    def get_information_display_string
      return @f_information_display_string
    end
    
    typesig { [] }
    # @see IContextInformation#getImage()
    def get_image
      return @f_image
    end
    
    typesig { [] }
    # @see IContextInformation#getContextDisplayString()
    def get_context_display_string
      if (!(@f_context_display_string).nil?)
        return @f_context_display_string
      end
      return @f_information_display_string
    end
    
    private
    alias_method :initialize__context_information, :initialize
  end
  
end
