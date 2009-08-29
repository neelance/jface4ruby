require "rjava"

# Copyright (c) 2008, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module DecoratingStyledCellLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Viewers::StyledString, :Styler
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # A {@link DecoratingStyledCellLabelProvider} is a
  # {@link DelegatingStyledCellLabelProvider} that uses a nested
  # {@link DelegatingStyledCellLabelProvider.IStyledLabelProvider} to compute
  # styled text label and image and takes a {@link ILabelDecorator} to decorate
  # the label.
  # 
  # <p>
  # Use this label provider as a replacement for the
  # {@link DecoratingLabelProvider} when decorating styled text labels.
  # </p>
  # 
  # <p>
  # The {@link DecoratingStyledCellLabelProvider} will try to evaluate the text
  # decoration added by the {@link ILabelDecorator} and will apply the style
  # returned by {@link #getDecorationStyle(Object)}
  # </p>
  # <p>
  # The {@link ILabelDecorator} can optionally implement {@link IColorDecorator}
  # and {@link IFontDecorator} to provide foreground and background color and
  # font decoration.
  # </p>
  # 
  # @since 3.4
  class DecoratingStyledCellLabelProvider < DecoratingStyledCellLabelProviderImports.const_get :DelegatingStyledCellLabelProvider
    include_class_members DecoratingStyledCellLabelProviderImports
    
    attr_accessor :decorator
    alias_method :attr_decorator, :decorator
    undef_method :decorator
    alias_method :attr_decorator=, :decorator=
    undef_method :decorator=
    
    attr_accessor :decoration_context
    alias_method :attr_decoration_context, :decoration_context
    undef_method :decoration_context
    alias_method :attr_decoration_context=, :decoration_context=
    undef_method :decoration_context=
    
    attr_accessor :label_provider_listener
    alias_method :attr_label_provider_listener, :label_provider_listener
    undef_method :label_provider_listener
    alias_method :attr_label_provider_listener=, :label_provider_listener=
    undef_method :label_provider_listener=
    
    typesig { [IStyledLabelProvider, ILabelDecorator, IDecorationContext] }
    # Creates a {@link DecoratingStyledCellLabelProvider} that delegates the
    # requests for styled labels and for images to a
    # {@link DelegatingStyledCellLabelProvider.IStyledLabelProvider}.
    # 
    # @param labelProvider
    # the styled label provider
    # @param decorator
    # a label decorator or <code>null</code> to not decorate the
    # label
    # @param decorationContext
    # a decoration context or <code>null</code> if the no
    # decorator is configured or the default decorator should be
    # used
    def initialize(label_provider, decorator, decoration_context)
      @decorator = nil
      @decoration_context = nil
      @label_provider_listener = nil
      super(label_provider)
      @decoration_context = DecorationContext::DEFAULT_CONTEXT
      @decorator = decorator
      @decoration_context = !(decoration_context).nil? ? decoration_context : DecorationContext::DEFAULT_CONTEXT
      @label_provider_listener = Class.new(ILabelProviderListener.class == Class ? ILabelProviderListener : Object) do
        extend LocalClass
        include_class_members DecoratingStyledCellLabelProvider
        include ILabelProviderListener if ILabelProviderListener.class == Module
        
        typesig { [LabelProviderChangedEvent] }
        define_method :label_provider_changed do |event|
          fire_label_provider_changed(event)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      label_provider.add_listener(@label_provider_listener)
      if (!(decorator).nil?)
        decorator.add_listener(@label_provider_listener)
      end
    end
    
    typesig { [] }
    # Returns the decoration context associated with this label provider. It
    # will be passed to the decorator if the decorator is an instance of
    # {@link LabelDecorator}.
    # 
    # @return the decoration context associated with this label provider
    def get_decoration_context
      return @decoration_context
    end
    
    typesig { [IDecorationContext] }
    # Set the decoration context that will be based to the decorator for this
    # label provider if that decorator implements {@link LabelDecorator}.
    # 
    # @param decorationContext
    # the decoration context.
    def set_decoration_context(decoration_context)
      Assert.is_not_null(decoration_context)
      @decoration_context = decoration_context
    end
    
    typesig { [ViewerCell] }
    def wait_for_pending_decoration(cell)
      if ((@decorator).nil?)
        return false
      end
      element = cell.get_element
      old_text = cell.get_text
      is_decoration_pending = false
      if (@decorator.is_a?(LabelDecorator))
        is_decoration_pending = !(@decorator).prepare_decoration(element, old_text, get_decoration_context)
      else
        if (@decorator.is_a?(IDelayedLabelDecorator))
          is_decoration_pending = !(@decorator).prepare_decoration(element, old_text)
        end
      end
      if (is_decoration_pending && (old_text.length).equal?(0))
        # item is empty: is shown for the first time: don't wait
        return false
      end
      return is_decoration_pending
    end
    
    typesig { [ViewerCell] }
    def update(cell)
      if (wait_for_pending_decoration(cell))
        return # wait until the decoration is ready
      end
      super(cell)
    end
    
    typesig { [Object] }
    def get_foreground(element)
      if (@decorator.is_a?(IColorDecorator))
        foreground = (@decorator).decorate_foreground(element)
        if (!(foreground).nil?)
          return foreground
        end
      end
      return super(element)
    end
    
    typesig { [Object] }
    def get_background(element)
      if (@decorator.is_a?(IColorDecorator))
        color = (@decorator).decorate_background(element)
        if (!(color).nil?)
          return color
        end
      end
      return super(element)
    end
    
    typesig { [Object] }
    def get_font(element)
      if (@decorator.is_a?(IFontDecorator))
        font = (@decorator).decorate_font(element)
        if (!(font).nil?)
          return font
        end
      end
      return super(element)
    end
    
    typesig { [Object] }
    def get_image(element)
      image = super(element)
      if ((@decorator).nil?)
        return image
      end
      decorated = nil
      if (@decorator.is_a?(LabelDecorator))
        decorated = (@decorator).decorate_image(image, element, get_decoration_context)
      else
        decorated = @decorator.decorate_image(image, element)
      end
      if (!(decorated).nil?)
        return decorated
      end
      return image
    end
    
    typesig { [Object] }
    # Returns the styled text for the label of the given element.
    # 
    # @param element
    # the element for which to provide the styled label text
    # @return the styled text string used to label the element
    def get_styled_text(element)
      styled_string = super(element)
      if ((@decorator).nil?)
        return styled_string
      end
      label = styled_string.get_string
      decorated = nil
      if (@decorator.is_a?(LabelDecorator))
        decorated = RJava.cast_to_string((@decorator).decorate_text(label, element, get_decoration_context))
      else
        decorated = RJava.cast_to_string(@decorator.decorate_text(label, element))
      end
      if ((decorated).nil?)
        return styled_string
      end
      style = get_decoration_style(element)
      return StyledCellLabelProvider.style_decorated_string(decorated, style, styled_string)
    end
    
    typesig { [Object] }
    # Sets the {@link StyledString.Styler} to be used for string
    # decorations. By default the
    # {@link StyledString#DECORATIONS_STYLER decoration style}. Clients
    # can override.
    # 
    # Note that it is the client's responsibility to react on color changes of
    # the decoration color by refreshing the view
    # 
    # @param element
    # the element that has been decorated
    # 
    # @return return the decoration style
    def get_decoration_style(element)
      return StyledString::DECORATIONS_STYLER
    end
    
    typesig { [] }
    # Returns the decorator or <code>null</code> if no decorator is installed
    # 
    # @return the decorator or <code>null</code> if no decorator is installed
    def get_label_decorator
      return @decorator
    end
    
    typesig { [ILabelDecorator] }
    # Sets the label decorator. Removes all known listeners from the old
    # decorator, and adds all known listeners to the new decorator. The old
    # decorator is not disposed. Fires a label provider changed event
    # indicating that all labels should be updated. Has no effect if the given
    # decorator is identical to the current one.
    # 
    # @param newDecorator
    # the label decorator, or <code>null</code> if no decorations
    # are to be applied
    def set_label_decorator(new_decorator)
      old_decorator = @decorator
      if (!(old_decorator).equal?(new_decorator))
        if (!(old_decorator).nil?)
          old_decorator.remove_listener(@label_provider_listener)
        end
        @decorator = new_decorator
        if (!(new_decorator).nil?)
          new_decorator.add_listener(@label_provider_listener)
        end
      end
      fire_label_provider_changed(LabelProviderChangedEvent.new(self))
    end
    
    typesig { [ILabelProviderListener] }
    def add_listener(listener)
      super(listener)
      if (!(@decorator).nil?)
        @decorator.add_listener(@label_provider_listener)
      end
    end
    
    typesig { [ILabelProviderListener] }
    def remove_listener(listener)
      super(listener)
      if (!(@decorator).nil? && !is_listener_attached)
        @decorator.remove_listener(@label_provider_listener)
      end
    end
    
    typesig { [Object, String] }
    def is_label_property(element, property)
      if (super(element, property))
        return true
      end
      return !(@decorator).nil? && @decorator.is_label_property(element, property)
    end
    
    typesig { [] }
    def dispose
      super
      if (!(@decorator).nil?)
        @decorator.remove_listener(@label_provider_listener)
        @decorator.dispose
        @decorator = nil
      end
    end
    
    private
    alias_method :initialize__decorating_styled_cell_label_provider, :initialize
  end
  
end
