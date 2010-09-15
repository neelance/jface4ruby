require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Contentassist
  module AbstractControlContentAssistSubjectAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :Platform
      include_const ::Org::Eclipse::Jface::Fieldassist, :ControlDecoration
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Viewers, :ILabelProvider
      include_const ::Org::Eclipse::Jface::Viewers, :ILabelProviderListener
      include_const ::Org::Eclipse::Jface::Viewers, :LabelProviderChangedEvent
      include_const ::Org::Eclipse::Jface::Text, :IEventConsumer
    }
  end
  
  # An <code>AbstractControlContentAssistSubjectAdapter</code> delegates assistance requests from a
  # {@linkplain org.eclipse.jface.text.contentassist.ContentAssistant content assistant}
  # to a <code>Control</code>.
  # 
  # A visual feedback can be configured via {@link #setContentAssistCueProvider(ILabelProvider)}.
  # 
  # @since 3.0
  # @deprecated As of 3.2, replaced by Platform UI's field assist support
  class AbstractControlContentAssistSubjectAdapter 
    include_class_members AbstractControlContentAssistSubjectAdapterImports
    include IContentAssistSubjectControl
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { "true".equals_ignore_case(Platform.get_debug_option("org.eclipse.jface.text/debug/ContentAssistSubjectAdapters")) }
      const_attr_reader  :DEBUG
    }
    
    # $NON-NLS-1$//$NON-NLS-2$
    # 
    # VerifyKeyListeners for the control.
    attr_accessor :f_verify_key_listeners
    alias_method :attr_f_verify_key_listeners, :f_verify_key_listeners
    undef_method :f_verify_key_listeners
    alias_method :attr_f_verify_key_listeners=, :f_verify_key_listeners=
    undef_method :f_verify_key_listeners=
    
    # KeyListeners for the control.
    attr_accessor :f_key_listeners
    alias_method :attr_f_key_listeners, :f_key_listeners
    undef_method :f_key_listeners
    alias_method :attr_f_key_listeners=, :f_key_listeners=
    undef_method :f_key_listeners=
    
    # The Listener installed on the control which passes events to
    # {@link #fVerifyKeyListeners fVerifyKeyListeners} and {@link #fKeyListeners}.
    attr_accessor :f_control_listener
    alias_method :attr_f_control_listener, :f_control_listener
    undef_method :f_control_listener
    alias_method :attr_f_control_listener=, :f_control_listener=
    undef_method :f_control_listener=
    
    # The cue label provider, or <code>null</code> iff none.
    # @since 3.3
    attr_accessor :f_cue_label_provider
    alias_method :attr_f_cue_label_provider, :f_cue_label_provider
    undef_method :f_cue_label_provider
    alias_method :attr_f_cue_label_provider=, :f_cue_label_provider=
    undef_method :f_cue_label_provider=
    
    # The control decoration, or <code>null</code> iff fCueLabelProvider is null.
    # @since 3.3
    attr_accessor :f_control_decoration
    alias_method :attr_f_control_decoration, :f_control_decoration
    undef_method :f_control_decoration
    alias_method :attr_f_control_decoration=, :f_control_decoration=
    undef_method :f_control_decoration=
    
    # The default cue image, or <code>null</code> if not cached yet.
    # @since 3.3
    attr_accessor :f_cached_default_cue_image
    alias_method :attr_f_cached_default_cue_image, :f_cached_default_cue_image
    undef_method :f_cached_default_cue_image
    alias_method :attr_f_cached_default_cue_image=, :f_cached_default_cue_image=
    undef_method :f_cached_default_cue_image=
    
    typesig { [] }
    # Creates a new {@link AbstractControlContentAssistSubjectAdapter}.
    def initialize
      @f_verify_key_listeners = nil
      @f_key_listeners = nil
      @f_control_listener = nil
      @f_cue_label_provider = nil
      @f_control_decoration = nil
      @f_cached_default_cue_image = nil
      @f_verify_key_listeners = ArrayList.new(1)
      @f_key_listeners = HashSet.new(1)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getControl()
    def get_control
      raise NotImplementedError
    end
    
    typesig { [KeyListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#addKeyListener(org.eclipse.swt.events.KeyListener)
    def add_key_listener(key_listener)
      @f_key_listeners.add(key_listener)
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#addKeyListener()")
      end # $NON-NLS-1$
      install_control_listener
    end
    
    typesig { [KeyListener] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#removeKeyListener(org.eclipse.swt.events.KeyListener)
    def remove_key_listener(key_listener)
      deleted = @f_key_listeners.remove(key_listener)
      if (DEBUG)
        if (!deleted)
          System.out.println("removeKeyListener -> wasn't here")
        end # $NON-NLS-1$
        System.out.println("AbstractControlContentAssistSubjectAdapter#removeKeyListener() -> " + RJava.cast_to_string(@f_key_listeners.size)) # $NON-NLS-1$
      end
      uninstall_control_listener
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#supportsVerifyKeyListener()
    def supports_verify_key_listener
      return true
    end
    
    typesig { [VerifyKeyListener] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#appendVerifyKeyListener(org.eclipse.swt.custom.VerifyKeyListener)
    def append_verify_key_listener(verify_key_listener)
      @f_verify_key_listeners.add(verify_key_listener)
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#appendVerifyKeyListener() -> " + RJava.cast_to_string(@f_verify_key_listeners.size))
      end # $NON-NLS-1$
      install_control_listener
      return true
    end
    
    typesig { [VerifyKeyListener] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#prependVerifyKeyListener(org.eclipse.swt.custom.VerifyKeyListener)
    def prepend_verify_key_listener(verify_key_listener)
      @f_verify_key_listeners.add(0, verify_key_listener)
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#prependVerifyKeyListener() -> " + RJava.cast_to_string(@f_verify_key_listeners.size))
      end # $NON-NLS-1$
      install_control_listener
      return true
    end
    
    typesig { [VerifyKeyListener] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#removeVerifyKeyListener(org.eclipse.swt.custom.VerifyKeyListener)
    def remove_verify_key_listener(verify_key_listener)
      @f_verify_key_listeners.remove(verify_key_listener)
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#removeVerifyKeyListener() -> " + RJava.cast_to_string(@f_verify_key_listeners.size))
      end # $NON-NLS-1$
      uninstall_control_listener
    end
    
    typesig { [IEventConsumer] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#setEventConsumer(org.eclipse.jface.text.IEventConsumer)
    def set_event_consumer(event_consumer)
      # this is not supported
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#setEventConsumer()")
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getLineDelimiter()
    def get_line_delimiter
      return System.get_property("line.separator") # $NON-NLS-1$
    end
    
    typesig { [] }
    # Installs <code>fControlListener</code>, which handles VerifyEvents and KeyEvents by
    # passing them to {@link #fVerifyKeyListeners} and {@link #fKeyListeners}.
    def install_control_listener
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#installControlListener() -> k: " + RJava.cast_to_string(@f_key_listeners.size) + ", v: " + RJava.cast_to_string(@f_verify_key_listeners.size))
      end # $NON-NLS-1$ //$NON-NLS-2$
      if (!(@f_control_listener).nil?)
        return
      end
      @f_control_listener = Class.new(Listener.class == Class ? Listener : Object) do
        local_class_in AbstractControlContentAssistSubjectAdapter
        include_class_members AbstractControlContentAssistSubjectAdapter
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |e|
          if (!get_control.is_focus_control)
            return
          end # SWT.TRAVERSE_MNEMONIC events can also come in to inactive widgets
          verify_event = self.class::VerifyEvent.new(e)
          key_event = self.class::KeyEvent.new(e)
          case (e.attr_type)
          when SWT::Traverse
            if (DEBUG)
              dump("before traverse", e, verify_event)
            end # $NON-NLS-1$
            verify_event.attr_doit = true
            iter = self.attr_f_verify_key_listeners.iterator
            while iter.has_next
              (iter.next_).verify_key(verify_event)
              if (!verify_event.attr_doit)
                e.attr_detail = SWT::TRAVERSE_NONE
                e.attr_doit = true
                if (DEBUG)
                  dump("traverse eaten by verify", e, verify_event)
                end # $NON-NLS-1$
                return
              end
              if (DEBUG)
                dump("traverse OK", e, verify_event)
              end # $NON-NLS-1$
            end
          when SWT::KeyDown
            iter = self.attr_f_verify_key_listeners.iterator
            while iter.has_next
              (iter.next_).verify_key(verify_event)
              if (!verify_event.attr_doit)
                e.attr_doit = verify_event.attr_doit
                if (DEBUG)
                  dump("keyDown eaten by verify", e, verify_event)
                end # $NON-NLS-1$
                return
              end
            end
            if (DEBUG)
              dump("keyDown OK", e, verify_event)
            end # $NON-NLS-1$
            iter_ = self.attr_f_key_listeners.iterator
            while iter_.has_next
              (iter_.next_).key_pressed(key_event)
            end
          else
            Assert.is_true(false)
          end
        end
        
        typesig { [String, Event, VerifyEvent] }
        # Dump the given events to "standard" output.
        # 
        # @param who who dump's
        # @param e the event
        # @param ve the verify event
        define_method :dump do |who, e, ve|
          sb = self.class::StringBuffer.new("--- [AbstractControlContentAssistSubjectAdapter]\n") # $NON-NLS-1$
          sb.append(who)
          sb.append(" - e: keyCode=" + RJava.cast_to_string(e.attr_key_code) + RJava.cast_to_string(hex(e.attr_key_code))) # $NON-NLS-1$
          sb.append("; character=" + RJava.cast_to_string(e.attr_character) + RJava.cast_to_string(hex(e.attr_character))) # $NON-NLS-1$
          sb.append("; stateMask=" + RJava.cast_to_string(e.attr_state_mask) + RJava.cast_to_string(hex(e.attr_state_mask))) # $NON-NLS-1$
          sb.append("; doit=" + RJava.cast_to_string(e.attr_doit)) # $NON-NLS-1$
          sb.append("; detail=" + RJava.cast_to_string(e.attr_detail) + RJava.cast_to_string(hex(e.attr_detail))) # $NON-NLS-1$
          sb.append("; widget=" + RJava.cast_to_string(e.attr_widget)) # $NON-NLS-1$
          sb.append("\n") # $NON-NLS-1$
          sb.append("  verifyEvent keyCode=" + RJava.cast_to_string(e.attr_key_code) + RJava.cast_to_string(hex(e.attr_key_code))) # $NON-NLS-1$
          sb.append("; character=" + RJava.cast_to_string(e.attr_character) + RJava.cast_to_string(hex(e.attr_character))) # $NON-NLS-1$
          sb.append("; stateMask=" + RJava.cast_to_string(e.attr_state_mask) + RJava.cast_to_string(hex(e.attr_state_mask))) # $NON-NLS-1$
          sb.append("; doit=" + RJava.cast_to_string(ve.attr_doit)) # $NON-NLS-1$
          sb.append("; widget=" + RJava.cast_to_string(e.attr_widget)) # $NON-NLS-1$
          System.out.println(sb)
        end
        
        typesig { [::Java::Int] }
        define_method :hex do |i|
          return "[0x" + RJava.cast_to_string(JavaInteger.to_hex_string(i)) + RJava.cast_to_string(Character.new(?].ord)) # $NON-NLS-1$
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      get_control.add_listener(SWT::Traverse, @f_control_listener)
      get_control.add_listener(SWT::KeyDown, @f_control_listener)
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#installControlListener() - installed")
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    # Uninstalls <code>fControlListener</code> iff there are no <code>KeyListener</code>s and no
    # <code>VerifyKeyListener</code>s registered.
    # Otherwise does nothing.
    def uninstall_control_listener
      if ((@f_control_listener).nil? || !(@f_key_listeners.size + @f_verify_key_listeners.size).equal?(0))
        if (DEBUG)
          System.out.println("AbstractControlContentAssistSubjectAdapter#uninstallControlListener() -> k: " + RJava.cast_to_string(@f_key_listeners.size) + ", v: " + RJava.cast_to_string(@f_verify_key_listeners.size))
        end # $NON-NLS-1$ //$NON-NLS-2$
        return
      end
      get_control.remove_listener(SWT::Traverse, @f_control_listener)
      get_control.remove_listener(SWT::KeyDown, @f_control_listener)
      @f_control_listener = nil
      if (DEBUG)
        System.out.println("AbstractControlContentAssistSubjectAdapter#uninstallControlListener() - done")
      end # $NON-NLS-1$
    end
    
    typesig { [ILabelProvider] }
    # Sets the visual feedback provider for content assist.
    # The given {@link ILabelProvider} methods are called with
    # {@link #getControl()} as argument.
    # 
    # <ul>
    # <li><code>getImage(Object)</code> provides the visual cue image.
    # The image can maximally be 5 pixels wide and 8 pixels high.
    # If <code>getImage(Object)</code> returns <code>null</code>, a default image is used.
    # </li>
    # <li><code>getText(Object)</code> provides the hover info text.
    # It is shown when hovering over the cue image or the adapted {@link Control}.
    # No info text is shown if <code>getText(Object)</code> returns <code>null</code>.
    # </li>
    # </ul>
    # <p>
    # The given {@link ILabelProvider} becomes owned by the {@link AbstractControlContentAssistSubjectAdapter},
    # i.e. it gets disposed when the adapted {@link Control} is disposed
    # or when another {@link ILabelProvider} is set.
    # </p>
    # 
    # @param labelProvider a {@link ILabelProvider}, or <code>null</code>
    # if no visual feedback should be shown
    def set_content_assist_cue_provider(label_provider)
      if (!(@f_cue_label_provider).nil?)
        @f_cue_label_provider.dispose
      end
      @f_cue_label_provider = label_provider
      if ((label_provider).nil?)
        if (!(@f_control_decoration).nil?)
          @f_control_decoration.dispose
          @f_control_decoration = nil
        end
      else
        if ((@f_control_decoration).nil?)
          @f_control_decoration = ControlDecoration.new(get_control, (SWT::TOP | SWT::LEFT))
          get_control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
            local_class_in AbstractControlContentAssistSubjectAdapter
            include_class_members AbstractControlContentAssistSubjectAdapter
            include DisposeListener if DisposeListener.class == Module
            
            typesig { [DisposeEvent] }
            define_method :widget_disposed do |e|
              if (!(self.attr_f_cue_label_provider).nil?)
                self.attr_f_cue_label_provider.dispose
                self.attr_f_cue_label_provider = nil
              end
              if (!(self.attr_f_control_decoration).nil?)
                self.attr_f_control_decoration.dispose
                self.attr_f_control_decoration = nil
              end
              if (!(self.attr_f_cached_default_cue_image).nil?)
                self.attr_f_cached_default_cue_image.dispose
                self.attr_f_cached_default_cue_image = nil
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @f_control_decoration.set_show_hover(true)
          @f_control_decoration.set_show_only_on_focus(true)
        end
        listener = Class.new(ILabelProviderListener.class == Class ? ILabelProviderListener : Object) do
          local_class_in AbstractControlContentAssistSubjectAdapter
          include_class_members AbstractControlContentAssistSubjectAdapter
          include ILabelProviderListener if ILabelProviderListener.class == Module
          
          typesig { [LabelProviderChangedEvent] }
          define_method :label_provider_changed do |event|
            self.attr_f_control_decoration.set_description_text(label_provider.get_text(get_control))
            image = label_provider.get_image(get_control)
            if ((image).nil?)
              image = get_default_cue_image
            end
            self.attr_f_control_decoration.set_image(image)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        label_provider.add_listener(listener)
        # initialize control decoration:
        listener.label_provider_changed(LabelProviderChangedEvent.new(label_provider))
      end
    end
    
    typesig { [] }
    # Returns the default cue image.
    # 
    # @return the default cue image
    # @since 3.3
    def get_default_cue_image
      if ((@f_cached_default_cue_image).nil?)
        cue_id = ImageDescriptor.create_from_file(AbstractControlContentAssistSubjectAdapter, "images/content_assist_cue.gif") # $NON-NLS-1$
        @f_cached_default_cue_image = cue_id.create_image(get_control.get_display)
      end
      return @f_cached_default_cue_image
    end
    
    private
    alias_method :initialize__abstract_control_content_assist_subject_adapter, :initialize
  end
  
end
