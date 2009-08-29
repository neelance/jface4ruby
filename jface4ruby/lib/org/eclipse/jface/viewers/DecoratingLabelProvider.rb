require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module DecoratingLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # A decorating label provider is a label provider which combines
  # a nested label provider and an optional decorator.
  # The decorator decorates the label text, image, font and colors provided by
  # the nested label provider.
  class DecoratingLabelProvider < DecoratingLabelProviderImports.const_get :LabelProvider
    include_class_members DecoratingLabelProviderImports
    overload_protected {
      include ILabelProvider
      include IViewerLabelProvider
      include IColorProvider
      include IFontProvider
      include ITreePathLabelProvider
    }
    
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    attr_accessor :decorator
    alias_method :attr_decorator, :decorator
    undef_method :decorator
    alias_method :attr_decorator=, :decorator=
    undef_method :decorator=
    
    # Need to keep our own list of listeners
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    attr_accessor :decoration_context
    alias_method :attr_decoration_context, :decoration_context
    undef_method :decoration_context
    alias_method :attr_decoration_context=, :decoration_context=
    undef_method :decoration_context=
    
    typesig { [ILabelProvider, ILabelDecorator] }
    # Creates a decorating label provider which uses the given label decorator
    # to decorate labels provided by the given label provider.
    # 
    # @param provider the nested label provider
    # @param decorator the label decorator, or <code>null</code> if no decorator is to be used initially
    def initialize(provider, decorator)
      @provider = nil
      @decorator = nil
      @listeners = nil
      @decoration_context = nil
      super()
      @listeners = ListenerList.new
      @decoration_context = DecorationContext::DEFAULT_CONTEXT
      Assert.is_not_null(provider)
      @provider = provider
      @decorator = decorator
    end
    
    typesig { [ILabelProviderListener] }
    # The <code>DecoratingLabelProvider</code> implementation of this <code>IBaseLabelProvider</code> method
    # adds the listener to both the nested label provider and the label decorator.
    # 
    # @param listener a label provider listener
    def add_listener(listener)
      super(listener)
      @provider.add_listener(listener)
      if (!(@decorator).nil?)
        @decorator.add_listener(listener)
      end
      @listeners.add(listener)
    end
    
    typesig { [] }
    # The <code>DecoratingLabelProvider</code> implementation of this <code>IBaseLabelProvider</code> method
    # disposes both the nested label provider and the label decorator.
    def dispose
      @provider.dispose
      if (!(@decorator).nil?)
        @decorator.dispose
      end
    end
    
    typesig { [Object] }
    # The <code>DecoratingLabelProvider</code> implementation of this
    # <code>ILabelProvider</code> method returns the image provided
    # by the nested label provider's <code>getImage</code> method,
    # decorated with the decoration provided by the label decorator's
    # <code>decorateImage</code> method.
    def get_image(element)
      image = @provider.get_image(element)
      if (!(@decorator).nil?)
        if (@decorator.is_a?(LabelDecorator))
          ld2 = @decorator
          decorated = ld2.decorate_image(image, element, get_decoration_context)
          if (!(decorated).nil?)
            return decorated
          end
        else
          decorated = @decorator.decorate_image(image, element)
          if (!(decorated).nil?)
            return decorated
          end
        end
      end
      return image
    end
    
    typesig { [] }
    # Returns the label decorator, or <code>null</code> if none has been set.
    # 
    # @return the label decorator, or <code>null</code> if none has been set.
    def get_label_decorator
      return @decorator
    end
    
    typesig { [] }
    # Returns the nested label provider.
    # 
    # @return the nested label provider
    def get_label_provider
      return @provider
    end
    
    typesig { [Object] }
    # The <code>DecoratingLabelProvider</code> implementation of this
    # <code>ILabelProvider</code> method returns the text label provided
    # by the nested label provider's <code>getText</code> method,
    # decorated with the decoration provided by the label decorator's
    # <code>decorateText</code> method.
    def get_text(element)
      text = @provider.get_text(element)
      if (!(@decorator).nil?)
        if (@decorator.is_a?(LabelDecorator))
          ld2 = @decorator
          decorated = ld2.decorate_text(text, element, get_decoration_context)
          if (!(decorated).nil?)
            return decorated
          end
        else
          decorated = @decorator.decorate_text(text, element)
          if (!(decorated).nil?)
            return decorated
          end
        end
      end
      return text
    end
    
    typesig { [Object, String] }
    # The <code>DecoratingLabelProvider</code> implementation of this
    # <code>IBaseLabelProvider</code> method returns <code>true</code> if the corresponding method
    # on the nested label provider returns <code>true</code> or if the corresponding method on the
    # decorator returns <code>true</code>.
    def is_label_property(element, property)
      if (@provider.is_label_property(element, property))
        return true
      end
      if (!(@decorator).nil? && @decorator.is_label_property(element, property))
        return true
      end
      return false
    end
    
    typesig { [ILabelProviderListener] }
    # The <code>DecoratingLabelProvider</code> implementation of this <code>IBaseLabelProvider</code> method
    # removes the listener from both the nested label provider and the label decorator.
    # 
    # @param listener a label provider listener
    def remove_listener(listener)
      super(listener)
      @provider.remove_listener(listener)
      if (!(@decorator).nil?)
        @decorator.remove_listener(listener)
      end
      @listeners.remove(listener)
    end
    
    typesig { [ILabelDecorator] }
    # Sets the label decorator.
    # Removes all known listeners from the old decorator, and adds all known listeners to the new decorator.
    # The old decorator is not disposed.
    # Fires a label provider changed event indicating that all labels should be updated.
    # Has no effect if the given decorator is identical to the current one.
    # 
    # @param decorator the label decorator, or <code>null</code> if no decorations are to be applied
    def set_label_decorator(decorator)
      old_decorator = @decorator
      if (!(old_decorator).equal?(decorator))
        listener_list = @listeners.get_listeners
        if (!(old_decorator).nil?)
          i = 0
          while i < listener_list.attr_length
            old_decorator.remove_listener(listener_list[i])
            (i += 1)
          end
        end
        @decorator = decorator
        if (!(decorator).nil?)
          i = 0
          while i < listener_list.attr_length
            decorator.add_listener(listener_list[i])
            (i += 1)
          end
        end
        fire_label_provider_changed(LabelProviderChangedEvent.new(self))
      end
    end
    
    typesig { [ViewerLabel, Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IViewerLabelProvider#updateLabel(org.eclipse.jface.viewers.ViewerLabel, java.lang.Object)
    def update_label(settings, element)
      current_decorator = get_label_decorator
      old_text = settings.get_text
      decoration_ready = true
      if (current_decorator.is_a?(IDelayedLabelDecorator))
        delayed_decorator = current_decorator
        if (!delayed_decorator.prepare_decoration(element, old_text))
          # The decoration is not ready but has been queued for processing
          decoration_ready = false
        end
      end
      # update icon and label
      if (decoration_ready || (old_text).nil? || (settings.get_text.length).equal?(0))
        settings.set_text(get_text(element))
      end
      old_image = settings.get_image
      if (decoration_ready || (old_image).nil?)
        settings.set_image(get_image(element))
      end
      if (decoration_ready)
        update_for_decoration_ready(settings, element)
      end
    end
    
    typesig { [ViewerLabel, Object] }
    # Decoration is ready. Update anything else for the settings.
    # @param settings The object collecting the settings.
    # @param element The Object being decorated.
    # @since 3.1
    def update_for_decoration_ready(settings, element)
      if (@decorator.is_a?(IColorDecorator))
        color_decorator = @decorator
        settings.set_background(color_decorator.decorate_background(element))
        settings.set_foreground(color_decorator.decorate_foreground(element))
      end
      if (@decorator.is_a?(IFontDecorator))
        settings.set_font((@decorator).decorate_font(element))
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IColorProvider#getBackground(java.lang.Object)
    def get_background(element)
      if (@provider.is_a?(IColorProvider))
        return (@provider).get_background(element)
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IFontProvider#getFont(java.lang.Object)
    def get_font(element)
      if (@provider.is_a?(IFontProvider))
        return (@provider).get_font(element)
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IColorProvider#getForeground(java.lang.Object)
    def get_foreground(element)
      if (@provider.is_a?(IColorProvider))
        return (@provider).get_foreground(element)
      end
      return nil
    end
    
    typesig { [] }
    # Return the decoration context associated with this label provider.
    # It will be passed to the decorator if the decorator is an
    # instance of {@link LabelDecorator}.
    # @return the decoration context associated with this label provider
    # 
    # @since 3.2
    def get_decoration_context
      return @decoration_context
    end
    
    typesig { [IDecorationContext] }
    # Set the decoration context that will be based to the decorator
    # for this label provider if that decorator implements {@link LabelDecorator}.
    # @param decorationContext the decoration context.
    # 
    # @since 3.2
    def set_decoration_context(decoration_context)
      Assert.is_not_null(decoration_context)
      @decoration_context = decoration_context
    end
    
    typesig { [ViewerLabel, TreePath] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ITreePathLabelProvider#updateLabel(org.eclipse.jface.viewers.ViewerLabel, org.eclipse.jface.viewers.TreePath)
    def update_label(settings, element_path)
      current_decorator = get_label_decorator
      old_text = settings.get_text
      element = element_path.get_last_segment
      decoration_ready = true
      if (current_decorator.is_a?(LabelDecorator))
        label_decorator = current_decorator
        if (!label_decorator.prepare_decoration(element, old_text, get_decoration_context))
          # The decoration is not ready but has been queued for processing
          decoration_ready = false
        end
      else
        if (current_decorator.is_a?(IDelayedLabelDecorator))
          delayed_decorator = current_decorator
          if (!delayed_decorator.prepare_decoration(element, old_text))
            # The decoration is not ready but has been queued for processing
            decoration_ready = false
          end
        end
      end
      settings.set_has_pending_decorations(!decoration_ready)
      # update icon and label
      if (@provider.is_a?(ITreePathLabelProvider))
        pprov = @provider
        if (decoration_ready || (old_text).nil? || (settings.get_text.length).equal?(0))
          pprov.update_label(settings, element_path)
          decorate_settings(settings, element_path)
        end
      else
        if (decoration_ready || (old_text).nil? || (settings.get_text.length).equal?(0))
          settings.set_text(get_text(element))
        end
        old_image = settings.get_image
        if (decoration_ready || (old_image).nil?)
          settings.set_image(get_image(element))
        end
        if (decoration_ready)
          update_for_decoration_ready(settings, element)
        end
      end
    end
    
    typesig { [ViewerLabel, TreePath] }
    # Decorate the settings
    # @param settings the settings obtained from the label provider
    # @param elementPath the element path being decorated
    def decorate_settings(settings, element_path)
      element = element_path.get_last_segment
      if (!(@decorator).nil?)
        if (@decorator.is_a?(LabelDecorator))
          label_decorator = @decorator
          text = label_decorator.decorate_text(settings.get_text, element, get_decoration_context)
          if (!(text).nil? && text.length > 0)
            settings.set_text(text)
          end
          image = label_decorator.decorate_image(settings.get_image, element, get_decoration_context)
          if (!(image).nil?)
            settings.set_image(image)
          end
        else
          text = @decorator.decorate_text(settings.get_text, element)
          if (!(text).nil? && text.length > 0)
            settings.set_text(text)
          end
          image = @decorator.decorate_image(settings.get_image, element)
          if (!(image).nil?)
            settings.set_image(image)
          end
        end
        if (@decorator.is_a?(IColorDecorator))
          color_decorator = @decorator
          background = color_decorator.decorate_background(element)
          if (!(background).nil?)
            settings.set_background(background)
          end
          foreground = color_decorator.decorate_foreground(element)
          if (!(foreground).nil?)
            settings.set_foreground(foreground)
          end
        end
        if (@decorator.is_a?(IFontDecorator))
          font = (@decorator).decorate_font(element)
          if (!(font).nil?)
            settings.set_font(font)
          end
        end
      end
    end
    
    private
    alias_method :initialize__decorating_label_provider, :initialize
  end
  
end
