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
  module ContentViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Internal, :InternalPolicy
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A content viewer is a model-based adapter on a widget which accesses its
  # model by means of a content provider and a label provider.
  # <p>
  # A viewer's model consists of elements, represented by objects.
  # A viewer defines and implements generic infrastructure for handling model
  # input, updates, and selections in terms of elements.
  # Input is obtained by querying an <code>IContentProvider</code> which returns
  # elements. The elements themselves are not displayed directly.  They are
  # mapped to labels, containing text and/or an image, using the viewer's
  # <code>ILabelProvider</code>.
  # </p>
  # <p>
  # Implementing a concrete content viewer typically involves the following steps:
  # <ul>
  # <li>
  # create SWT controls for viewer (in constructor) (optional)
  # </li>
  # <li>
  # initialize SWT controls from input (inputChanged)
  # </li>
  # <li>
  # define viewer-specific update methods
  # </li>
  # <li>
  # support selections (<code>setSelection</code>, <code>getSelection</code>)
  # </ul>
  # </p>
  class ContentViewer < ContentViewerImports.const_get :Viewer
    include_class_members ContentViewerImports
    
    # This viewer's content provider, or <code>null</code> if none.
    attr_accessor :content_provider
    alias_method :attr_content_provider, :content_provider
    undef_method :content_provider
    alias_method :attr_content_provider=, :content_provider=
    undef_method :content_provider=
    
    # This viewer's input, or <code>null</code> if none.
    # The viewer's input provides the "model" for the viewer's content.
    attr_accessor :input
    alias_method :attr_input, :input
    undef_method :input
    alias_method :attr_input=, :input=
    undef_method :input=
    
    # This viewer's label provider. Initially <code>null</code>, but
    # lazily initialized (to a <code>SimpleLabelProvider</code>).
    attr_accessor :label_provider
    alias_method :attr_label_provider, :label_provider
    undef_method :label_provider
    alias_method :attr_label_provider=, :label_provider=
    undef_method :label_provider=
    
    # This viewer's label provider listener.
    # Note: Having a viewer register a label provider listener with
    # a label provider avoids having to define public methods
    # for internal events.
    attr_accessor :label_provider_listener
    alias_method :attr_label_provider_listener, :label_provider_listener
    undef_method :label_provider_listener
    alias_method :attr_label_provider_listener=, :label_provider_listener=
    undef_method :label_provider_listener=
    
    typesig { [] }
    # Creates a content viewer with no input, no content provider, and a
    # default label provider.
    def initialize
      @content_provider = nil
      @input = nil
      @label_provider = nil
      @label_provider_listener = nil
      super()
      @content_provider = nil
      @input = nil
      @label_provider = nil
      @label_provider_listener = Class.new(ILabelProviderListener.class == Class ? ILabelProviderListener : Object) do
        extend LocalClass
        include_class_members ContentViewer
        include ILabelProviderListener if ILabelProviderListener.class == Module
        
        attr_accessor :log_when_disposed
        alias_method :attr_log_when_disposed, :log_when_disposed
        undef_method :log_when_disposed
        alias_method :attr_log_when_disposed=, :log_when_disposed=
        undef_method :log_when_disposed=
        
        typesig { [LabelProviderChangedEvent] }
        # initially true, set to false
        define_method :label_provider_changed do |event|
          control = get_control
          if ((control).nil? || control.is_disposed)
            if (@log_when_disposed)
              # $NON-NLS-1$
              message = "Ignored labelProviderChanged notification because control is diposed." + " This indicates a potential memory leak." # $NON-NLS-1$
              if (!InternalPolicy::DEBUG_LOG_LABEL_PROVIDER_NOTIFICATIONS_WHEN_DISPOSED)
                # stop logging after the first
                @log_when_disposed = false
                # $NON-NLS-1$
                message += " This is only logged once per viewer instance," + " but similar calls will still be ignored." # $NON-NLS-1$
              end
              Policy.get_log.log(self.class::Status.new(IStatus::WARNING, Policy::JFACE, message, self.class::RuntimeException.new))
            end
            return
          end
          @local_class_parent.handle_label_provider_changed(event)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @log_when_disposed = false
          super(*args)
          @log_when_disposed = true
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # Returns the content provider used by this viewer,
    # or <code>null</code> if this view does not yet have a content
    # provider.
    # <p>
    # The <code>ContentViewer</code> implementation of this method returns the content
    # provider recorded is an internal state variable.
    # Overriding this method is generally not required;
    # however, if overriding in a subclass,
    # <code>super.getContentProvider</code> must be invoked.
    # </p>
    # 
    # @return the content provider, or <code>null</code> if none
    def get_content_provider
      return @content_provider
    end
    
    typesig { [] }
    # The <code>ContentViewer</code> implementation of this <code>IInputProvider</code>
    # method returns the current input of this viewer, or <code>null</code>
    # if none. The viewer's input provides the "model" for the viewer's
    # content.
    def get_input
      return @input
    end
    
    typesig { [] }
    # Returns the label provider used by this viewer.
    # <p>
    # The <code>ContentViewer</code> implementation of this method returns the label
    # provider recorded in an internal state variable; if none has been
    # set (with <code>setLabelProvider</code>) a default label provider
    # will be created, remembered, and returned.
    # Overriding this method is generally not required;
    # however, if overriding in a subclass,
    # <code>super.getLabelProvider</code> must be invoked.
    # </p>
    # 
    # @return a label provider
    def get_label_provider
      if ((@label_provider).nil?)
        @label_provider = LabelProvider.new
      end
      return @label_provider
    end
    
    typesig { [DisposeEvent] }
    # Handles a dispose event on this viewer's control.
    # <p>
    # The <code>ContentViewer</code> implementation of this method disposes of this
    # viewer's label provider and content provider (if it has one).
    # Subclasses should override this method to perform any additional
    # cleanup of resources; however, overriding methods must invoke
    # <code>super.handleDispose</code>.
    # </p>
    # 
    # @param event a dispose event
    def handle_dispose(event)
      if (!(@content_provider).nil?)
        @content_provider.input_changed(self, get_input, nil)
        @content_provider.dispose
        @content_provider = nil
      end
      if (!(@label_provider).nil?)
        @label_provider.remove_listener(@label_provider_listener)
        @label_provider.dispose
        @label_provider = nil
      end
      @input = nil
    end
    
    typesig { [LabelProviderChangedEvent] }
    # Handles a label provider changed event.
    # <p>
    # The <code>ContentViewer</code> implementation of this method calls <code>labelProviderChanged()</code>
    # to cause a complete refresh of the viewer.
    # Subclasses may reimplement or extend.
    # </p>
    # @param event the change event
    def handle_label_provider_changed(event)
      label_provider_changed
    end
    
    typesig { [Control] }
    # Adds event listener hooks to the given control.
    # <p>
    # All subclasses must call this method when their control is
    # first established.
    # </p>
    # <p>
    # The <code>ContentViewer</code> implementation of this method hooks
    # dispose events for the given control.
    # Subclasses may override if they need to add other control hooks;
    # however, <code>super.hookControl</code> must be invoked.
    # </p>
    # 
    # @param control the control
    def hook_control(control)
      control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members ContentViewer
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |event|
          handle_dispose(event)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # Notifies that the label provider has changed.
    # <p>
    # The <code>ContentViewer</code> implementation of this method calls <code>refresh()</code>.
    # Subclasses may reimplement or extend.
    # </p>
    def label_provider_changed
      refresh
    end
    
    typesig { [IContentProvider] }
    # Sets the content provider used by this viewer.
    # <p>
    # The <code>ContentViewer</code> implementation of this method records the
    # content provider in an internal state variable.
    # Overriding this method is generally not required;
    # however, if overriding in a subclass,
    # <code>super.setContentProvider</code> must be invoked.
    # </p>
    # 
    # @param contentProvider the content provider
    # @see #getContentProvider
    def set_content_provider(content_provider)
      Assert.is_not_null(content_provider)
      old_content_provider = @content_provider
      @content_provider = content_provider
      if (!(old_content_provider).nil?)
        current_input = get_input
        old_content_provider.input_changed(self, current_input, nil)
        old_content_provider.dispose
        content_provider.input_changed(self, nil, current_input)
        refresh
      end
    end
    
    typesig { [Object] }
    # The <code>ContentViewer</code> implementation of this <code>Viewer</code>
    # method invokes <code>inputChanged</code> on the content provider and then the
    # <code>inputChanged</code> hook method. This method fails if this viewer does
    # not have a content provider. Subclassers are advised to override
    # <code>inputChanged</code> rather than this method, but may extend this method
    # if required.
    def set_input(input)
      Assert.is_true(!(get_content_provider).nil?, "ContentViewer must have a content provider when input is set.") # $NON-NLS-1$
      old_input = get_input
      @content_provider.input_changed(self, old_input, input)
      @input = input
      # call input hook
      input_changed(@input, old_input)
    end
    
    typesig { [IBaseLabelProvider] }
    # Sets the label provider for this viewer.
    # <p>
    # The <code>ContentViewer</code> implementation of this method ensures that the
    # given label provider is connected to this viewer and the
    # former label provider is disconnected from this viewer.
    # Overriding this method is generally not required;
    # however, if overriding in a subclass,
    # <code>super.setLabelProvider</code> must be invoked.
    # </p>
    # 
    # @param labelProvider the label provider, or <code>null</code> if none
    def set_label_provider(label_provider)
      old_provider = @label_provider
      # If it hasn't changed, do nothing.
      # This also ensures that the provider is not disposed
      # if set a second time.
      if ((label_provider).equal?(old_provider))
        return
      end
      if (!(old_provider).nil?)
        old_provider.remove_listener(@label_provider_listener)
      end
      @label_provider = label_provider
      if (!(label_provider).nil?)
        label_provider.add_listener(@label_provider_listener)
      end
      refresh
      # Dispose old provider after refresh, so that items never refer to stale images.
      if (!(old_provider).nil?)
        internal_dispose_label_provider(old_provider)
      end
    end
    
    typesig { [IBaseLabelProvider] }
    # @param oldProvider
    # 
    # @since 3.4
    def internal_dispose_label_provider(old_provider)
      old_provider.dispose
    end
    
    private
    alias_method :initialize__content_viewer, :initialize
  end
  
end
