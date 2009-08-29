require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module FieldDecorationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # FieldDecoration is a simple data structure class for specifying a decoration
  # for a field. A decoration may be rendered in different ways depending on the
  # type of field it is used with.
  # 
  # @see FieldDecorationRegistry
  # 
  # @since 3.2
  class FieldDecoration 
    include_class_members FieldDecorationImports
    
    # The image to be shown in the decoration.
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    # The description to show in the decoration's hover.
    attr_accessor :description
    alias_method :attr_description, :description
    undef_method :description
    alias_method :attr_description=, :description=
    undef_method :description=
    
    typesig { [Image, String] }
    # Create a decoration for a field with the specified image and description
    # text.
    # 
    # @param image
    # the image shown in the decoration. A <code>null</code> image
    # will result in a blank decoration, which may be used to
    # reserve space near the field.
    # @param description
    # the description shown when the user hovers over the
    # decoration. A <code>null</code> description indicates that
    # there will be no hover for the decoration.
    def initialize(image, description)
      @image = nil
      @description = nil
      @image = image
      @description = description
    end
    
    typesig { [] }
    # Return the image shown in the decoration, or <code>null</code> if no
    # image is specified.
    # 
    # @return the image shown in the decoration. A return value of
    # <code>null</code> signifies a blank decoration.
    def get_image
      return @image
    end
    
    typesig { [Image] }
    # Set the image shown in the decoration, or <code>null</code> if no image
    # is specified. It is up to the caller to update any decorated fields that
    # are showing the description in order to display the new image.
    # 
    # @param image
    # the image shown in the decoration. A value of
    # <code>null</code> signifies a blank decoration.
    def set_image(image)
      @image = image
    end
    
    typesig { [] }
    # Return the description for the decoration shown when the user hovers over
    # the decoration.
    # 
    # @return the String description of the decoration. A return value of
    # <code>null</code> indicates that no description will be shown.
    def get_description
      return @description
    end
    
    typesig { [String] }
    # Set the description for the decoration shown when the user hovers over
    # the decoration. It is up to the caller to update any decorated fields
    # showing the description.
    # 
    # @param description
    # the String description of the decoration. A value of
    # <code>null</code> indicates that no description will be
    # shown.
    def set_description(description)
      @description = description
    end
    
    private
    alias_method :initialize__field_decoration, :initialize
  end
  
end
