require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module DelegatingStyledCellLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Arrays
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # A {@link DelegatingStyledCellLabelProvider} is a
  # {@link StyledCellLabelProvider} that delegates requests for the styled string
  # and the image to a
  # {@link DelegatingStyledCellLabelProvider.IStyledLabelProvider}.
  # 
  # <p>
  # Existing label providers can be enhanced by implementing
  # {@link DelegatingStyledCellLabelProvider.IStyledLabelProvider} so they can be
  # used in viewers with styled labels.
  # </p>
  # 
  # <p>
  # The {@link DelegatingStyledCellLabelProvider.IStyledLabelProvider} can
  # optionally implement {@link IColorProvider} and {@link IFontProvider} to
  # provide foreground and background color and a default font.
  # </p>
  # 
  # @since 3.4
  class DelegatingStyledCellLabelProvider < DelegatingStyledCellLabelProviderImports.const_get :StyledCellLabelProvider
    include_class_members DelegatingStyledCellLabelProviderImports
    
    class_module.module_eval {
      # Interface marking a label provider that provides styled text labels and
      # images.
      # <p>
      # The {@link DelegatingStyledCellLabelProvider.IStyledLabelProvider} can
      # optionally implement {@link IColorProvider} and {@link IFontProvider} to
      # provide foreground and background color and a default font.
      # </p>
      const_set_lazy(:IStyledLabelProvider) { Module.new do
        include_class_members DelegatingStyledCellLabelProvider
        include IBaseLabelProvider
        
        typesig { [Object] }
        # Returns the styled text label for the given element
        # 
        # @param element
        # the element to evaluate the styled string for
        # 
        # @return the styled string.
        def get_styled_text(element)
          raise NotImplementedError
        end
        
        typesig { [Object] }
        # Returns the image for the label of the given element. The image is
        # owned by the label provider and must not be disposed directly.
        # Instead, dispose the label provider when no longer needed.
        # 
        # @param element
        # the element for which to provide the label image
        # @return the image used to label the element, or <code>null</code>
        # if there is no image for the given object
        def get_image(element)
          raise NotImplementedError
        end
      end }
    }
    
    attr_accessor :styled_label_provider
    alias_method :attr_styled_label_provider, :styled_label_provider
    undef_method :styled_label_provider
    alias_method :attr_styled_label_provider=, :styled_label_provider=
    undef_method :styled_label_provider=
    
    typesig { [IStyledLabelProvider] }
    # Creates a {@link DelegatingStyledCellLabelProvider} that delegates the
    # requests for the styled labels and the images to a
    # {@link IStyledLabelProvider}.
    # 
    # @param labelProvider
    # the label provider that provides the styled labels and the
    # images
    def initialize(label_provider)
      @styled_label_provider = nil
      super()
      if ((label_provider).nil?)
        raise IllegalArgumentException.new("Label provider must not be null")
      end # $NON-NLS-1$
      @styled_label_provider = label_provider
    end
    
    typesig { [ViewerCell] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StyledCellLabelProvider#update(org.eclipse.jface.viewers.ViewerCell)
    def update(cell)
      element = cell.get_element
      styled_string = get_styled_text(element)
      new_text = styled_string.to_s
      old_style_ranges = cell.get_style_ranges
      new_style_ranges = is_owner_draw_enabled ? styled_string.get_style_ranges : nil
      if (!Arrays.==(old_style_ranges, new_style_ranges))
        cell.set_style_ranges(new_style_ranges)
        if ((cell.get_text == new_text))
          # make sure there will be a refresh from a change
          cell.set_text("") # $NON-NLS-1$
        end
      end
      cell.set_text(new_text)
      cell.set_image(get_image(element))
      cell.set_font(get_font(element))
      cell.set_foreground(get_foreground(element))
      cell.set_background(get_background(element))
      # no super call required. changes on item will trigger the refresh.
    end
    
    typesig { [Object] }
    # Provides a foreground color for the given element.
    # 
    # @param element
    # the element
    # @return the foreground color for the element, or <code>null</code> to
    # use the default foreground color
    def get_foreground(element)
      if (@styled_label_provider.is_a?(IColorProvider))
        return (@styled_label_provider).get_foreground(element)
      end
      return nil
    end
    
    typesig { [Object] }
    # Provides a background color for the given element.
    # 
    # @param element
    # the element
    # @return the background color for the element, or <code>null</code> to
    # use the default background color
    def get_background(element)
      if (@styled_label_provider.is_a?(IColorProvider))
        return (@styled_label_provider).get_background(element)
      end
      return nil
    end
    
    typesig { [Object] }
    # Provides a font for the given element.
    # 
    # @param element
    # the element
    # @return the font for the element, or <code>null</code> to use the
    # default font
    def get_font(element)
      if (@styled_label_provider.is_a?(IFontProvider))
        return (@styled_label_provider).get_font(element)
      end
      return nil
    end
    
    typesig { [Object] }
    # Returns the image for the label of the given element. The image is owned
    # by the label provider and must not be disposed directly. Instead, dispose
    # the label provider when no longer needed.
    # 
    # @param element
    # the element for which to provide the label image
    # @return the image used to label the element, or <code>null</code> if
    # there is no image for the given object
    def get_image(element)
      return @styled_label_provider.get_image(element)
    end
    
    typesig { [Object] }
    # Returns the styled text for the label of the given element.
    # 
    # @param element
    # the element for which to provide the styled label text
    # @return the styled text string used to label the element
    def get_styled_text(element)
      return @styled_label_provider.get_styled_text(element)
    end
    
    typesig { [] }
    # Returns the styled string provider.
    # 
    # @return the wrapped label provider
    def get_styled_string_provider
      return @styled_label_provider
    end
    
    typesig { [ILabelProviderListener] }
    def add_listener(listener)
      super(listener)
      @styled_label_provider.add_listener(listener)
    end
    
    typesig { [ILabelProviderListener] }
    def remove_listener(listener)
      super(listener)
      @styled_label_provider.remove_listener(listener)
    end
    
    typesig { [Object, String] }
    def is_label_property(element, property)
      return @styled_label_provider.is_label_property(element, property)
    end
    
    typesig { [] }
    def dispose
      super
      @styled_label_provider.dispose
    end
    
    private
    alias_method :initialize__delegating_styled_cell_label_provider, :initialize
  end
  
end
