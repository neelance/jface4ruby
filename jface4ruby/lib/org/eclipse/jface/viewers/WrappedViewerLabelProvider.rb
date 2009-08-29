require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module WrappedViewerLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # The WrappedViewerLabelProvider is a label provider that allows
  # {@link ILabelProvider}, {@link IColorProvider} and {@link IFontProvider} to
  # be mapped to a ColumnLabelProvider.
  # 
  # @since 3.3
  class WrappedViewerLabelProvider < WrappedViewerLabelProviderImports.const_get :ColumnLabelProvider
    include_class_members WrappedViewerLabelProviderImports
    
    class_module.module_eval {
      
      def default_label_provider
        defined?(@@default_label_provider) ? @@default_label_provider : @@default_label_provider= LabelProvider.new
      end
      alias_method :attr_default_label_provider, :default_label_provider
      
      def default_label_provider=(value)
        @@default_label_provider = value
      end
      alias_method :attr_default_label_provider=, :default_label_provider=
    }
    
    attr_accessor :label_provider
    alias_method :attr_label_provider, :label_provider
    undef_method :label_provider
    alias_method :attr_label_provider=, :label_provider=
    undef_method :label_provider=
    
    attr_accessor :color_provider
    alias_method :attr_color_provider, :color_provider
    undef_method :color_provider
    alias_method :attr_color_provider=, :color_provider=
    undef_method :color_provider=
    
    attr_accessor :font_provider
    alias_method :attr_font_provider, :font_provider
    undef_method :font_provider
    alias_method :attr_font_provider=, :font_provider=
    undef_method :font_provider=
    
    attr_accessor :viewer_label_provider
    alias_method :attr_viewer_label_provider, :viewer_label_provider
    undef_method :viewer_label_provider
    alias_method :attr_viewer_label_provider=, :viewer_label_provider=
    undef_method :viewer_label_provider=
    
    attr_accessor :tree_path_label_provider
    alias_method :attr_tree_path_label_provider, :tree_path_label_provider
    undef_method :tree_path_label_provider
    alias_method :attr_tree_path_label_provider=, :tree_path_label_provider=
    undef_method :tree_path_label_provider=
    
    typesig { [IBaseLabelProvider] }
    # Create a new instance of the receiver based on labelProvider.
    # 
    # @param labelProvider
    def initialize(label_provider)
      @label_provider = nil
      @color_provider = nil
      @font_provider = nil
      @viewer_label_provider = nil
      @tree_path_label_provider = nil
      super()
      @label_provider = self.attr_default_label_provider
      set_providers(label_provider)
    end
    
    typesig { [Object] }
    # Set the any providers for the receiver that can be adapted from provider.
    # 
    # @param provider
    # {@link Object}
    def set_providers(provider)
      if (provider.is_a?(ITreePathLabelProvider))
        @tree_path_label_provider = (provider)
      end
      if (provider.is_a?(IViewerLabelProvider))
        @viewer_label_provider = (provider)
      end
      if (provider.is_a?(ILabelProvider))
        @label_provider = (provider)
      end
      if (provider.is_a?(IColorProvider))
        @color_provider = provider
      end
      if (provider.is_a?(IFontProvider))
        @font_provider = provider
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.IFontProvider#getFont(java.lang.Object)
    def get_font(element)
      if ((@font_provider).nil?)
        return nil
      end
      return @font_provider.get_font(element)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.IColorProvider#getBackground(java.lang.Object)
    def get_background(element)
      if ((@color_provider).nil?)
        return nil
      end
      return @color_provider.get_background(element)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ILabelProvider#getText(java.lang.Object)
    def get_text(element)
      return get_label_provider.get_text(element)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ILabelProvider#getImage(java.lang.Object)
    def get_image(element)
      return get_label_provider.get_image(element)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.IColorProvider#getForeground(java.lang.Object)
    def get_foreground(element)
      if ((@color_provider).nil?)
        return nil
      end
      return @color_provider.get_foreground(element)
    end
    
    typesig { [] }
    # Get the label provider
    # 
    # @return {@link ILabelProvider}
    def get_label_provider
      return @label_provider
    end
    
    typesig { [] }
    # Get the color provider
    # 
    # @return {@link IColorProvider}
    def get_color_provider
      return @color_provider
    end
    
    typesig { [] }
    # Get the font provider
    # 
    # @return {@link IFontProvider}.
    def get_font_provider
      return @font_provider
    end
    
    typesig { [ViewerCell] }
    def update(cell)
      element = cell.get_element
      if ((@viewer_label_provider).nil? && (@tree_path_label_provider).nil?)
        # inlined super implementation with performance optimizations
        cell.set_text(get_text(element))
        image = get_image(element)
        cell.set_image(image)
        if (!(@color_provider).nil?)
          cell.set_background(get_background(element))
          cell.set_foreground(get_foreground(element))
        end
        if (!(@font_provider).nil?)
          cell.set_font(get_font(element))
        end
        return
      end
      label = ViewerLabel.new(cell.get_text, cell.get_image)
      if (!(@tree_path_label_provider).nil?)
        tree_path = cell.get_viewer_row.get_tree_path
        Assert.is_not_null(tree_path)
        @tree_path_label_provider.update_label(label, tree_path)
      else
        if (!(@viewer_label_provider).nil?)
          @viewer_label_provider.update_label(label, element)
        end
      end
      if (!label.has_new_foreground && !(@color_provider).nil?)
        label.set_foreground(get_foreground(element))
      end
      if (!label.has_new_background && !(@color_provider).nil?)
        label.set_background(get_background(element))
      end
      if (!label.has_new_font && !(@font_provider).nil?)
        label.set_font(get_font(element))
      end
      apply_viewer_label(cell, label)
    end
    
    typesig { [ViewerCell, ViewerLabel] }
    def apply_viewer_label(cell, label)
      if (label.has_new_text)
        cell.set_text(label.get_text)
      end
      if (label.has_new_image)
        cell.set_image(label.get_image)
      end
      if (!(@color_provider).nil? || label.has_new_background)
        cell.set_background(label.get_background)
      end
      if (!(@color_provider).nil? || label.has_new_foreground)
        cell.set_foreground(label.get_foreground)
      end
      if (!(@font_provider).nil? || label.has_new_font)
        cell.set_font(label.get_font)
      end
    end
    
    private
    alias_method :initialize__wrapped_viewer_label_provider, :initialize
  end
  
end
