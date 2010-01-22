require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Sean Montgomery, sean_montgomery@comcast.net - https://bugs.eclipse.org/bugs/show_bug.cgi?id=45095
module Org::Eclipse::Jface::Text
  module AbstractInformationControlManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Monitor
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :Platform
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogSettings
      include_const ::Org::Eclipse::Jface::Internal::Text, :InformationControlReplacer
      include_const ::Org::Eclipse::Jface::Internal::Text, :InternalAccessor
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Text::ITextViewerExtension8, :EnrichMode
    }
  end
  
  # Manages the life cycle, visibility, layout, and contents of an
  # {@link org.eclipse.jface.text.IInformationControl}. This manager can be
  # installed on and removed from a control, referred to as the subject control,
  # i.e. the one from which the subject of the information to be shown is
  # retrieved. Also a manager can be enabled or disabled. An installed and
  # enabled manager can be forced to show information in its information control
  # using <code>showInformation</code>. An information control manager uses an
  # <code>IInformationControlCloser</code> to define the behavior when a
  # presented information control must be closed. The disposal of the subject and
  # the information control are internally handled by the information control
  # manager and are not the responsibility of the information control closer.
  # 
  # @see org.eclipse.jface.text.IInformationControl
  # @since 2.0
  class AbstractInformationControlManager 
    include_class_members AbstractInformationControlManagerImports
    
    class_module.module_eval {
      # An internal class that gives access to internal methods.
      # 
      # @since 3.4
      const_set_lazy(:MyInternalAccessor) { Class.new(InternalAccessor) do
        extend LocalClass
        include_class_members AbstractInformationControlManager
        
        typesig { [] }
        def get_current_information_control
          return @local_class_parent.get_current_information_control
        end
        
        typesig { [class_self::InformationControlReplacer] }
        def set_information_control_replacer(replacer)
          @local_class_parent.set_information_control_replacer(replacer)
        end
        
        typesig { [] }
        def get_information_control_replacer
          return @local_class_parent.get_information_control_replacer
        end
        
        typesig { [class_self::IInformationControl] }
        def can_replace(control)
          return @local_class_parent.can_replace(control)
        end
        
        typesig { [] }
        def is_replace_in_progress
          return @local_class_parent.is_replace_in_progress
        end
        
        typesig { [::Java::Boolean] }
        def replace_information_control(take_focus)
          @local_class_parent.replace_information_control(take_focus)
        end
        
        typesig { [class_self::Rectangle] }
        def crop_to_closest_monitor(bounds)
          @local_class_parent.crop_to_closest_monitor(bounds)
        end
        
        typesig { [class_self::EnrichMode] }
        def set_hover_enrich_mode(mode)
          raise self.class::UnsupportedOperationException.new("only implemented in AbstractHoverInformationControlManager") # $NON-NLS-1$
        end
        
        typesig { [] }
        def get_allow_mouse_exit
          raise self.class::UnsupportedOperationException.new("only implemented in AnnotationBarHoverManager") # $NON-NLS-1$
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__my_internal_accessor, :initialize
      end }
      
      # Interface of an information control closer. An information control closer
      # monitors its information control and its subject control and closes the
      # information control if necessary.
      # <p>
      # Clients must implement this interface in order to equip an information
      # control manager accordingly.
      const_set_lazy(:IInformationControlCloser) { Module.new do
        include_class_members AbstractInformationControlManager
        
        typesig { [Control] }
        # Sets the closer's subject control. This is the control that parents
        # the information control and from which the subject of the information
        # to be shown is retrieved. <p>
        # Must be called before <code>start</code>. May again be called
        # between <code>start</code> and <code>stop</code>.
        # 
        # @param subject the subject control
        def set_subject_control(subject)
          raise NotImplementedError
        end
        
        typesig { [IInformationControl] }
        # Sets the closer's information control, the one to close if necessary. <p>
        # Must be called before <code>start</code>. May again be called
        # between <code>start</code> and <code>stop</code>.
        # 
        # @param control the information control
        def set_information_control(control)
          raise NotImplementedError
        end
        
        typesig { [Rectangle] }
        # Tells this closer to start monitoring the subject and the information
        # control. The presented information is considered valid for the given
        # area of the subject control's display.
        # 
        # @param subjectArea the area for which the presented information is valid
        def start(subject_area)
          raise NotImplementedError
        end
        
        typesig { [] }
        # Tells this closer to stop monitoring the subject and the information control.
        def stop
          raise NotImplementedError
        end
      end }
      
      # Constitutes entities to enumerate anchors for the layout of the information control.
      const_set_lazy(:Anchor) { Class.new do
        include_class_members AbstractInformationControlManager
        
        attr_accessor :f_flag
        alias_method :attr_f_flag, :f_flag
        undef_method :f_flag
        alias_method :attr_f_flag=, :f_flag=
        undef_method :f_flag=
        
        typesig { [::Java::Int] }
        def initialize(flag)
          @f_flag = 0
          @f_flag = flag
        end
        
        typesig { [] }
        # Returns the SWT direction flag. One of {@link SWT#BOTTOM}, {@link SWT#TOP},
        # {@link SWT#LEFT}, {@link SWT#RIGHT}, {@link SWT#CENTER},
        # 
        # @return the SWT direction flag
        # @since 3.3
        def get_swtflag
          return @f_flag
        end
        
        typesig { [] }
        def to_s
          case (@f_flag)
          # $NON-NLS-1$
          # $NON-NLS-1$
          # $NON-NLS-1$
          # $NON-NLS-1$
          # $NON-NLS-1$
          when SWT::BOTTOM
            return "BOTTOM"
          when SWT::TOP
            return "TOP"
          when SWT::LEFT
            return "LEFT"
          when SWT::RIGHT
            return "RIGHT"
          when SWT::CENTER
            return "CENTER"
          else
            return JavaInteger.to_hex_string(@f_flag)
          end
        end
        
        private
        alias_method :initialize__anchor, :initialize
      end }
      
      # Internal anchor list.
      const_set_lazy(:ANCHORS) { Array.typed(Anchor).new([Anchor.new(SWT::TOP), Anchor.new(SWT::BOTTOM), Anchor.new(SWT::LEFT), Anchor.new(SWT::RIGHT)]) }
      const_attr_reader  :ANCHORS
      
      # Anchor representing the top of the information area
      const_set_lazy(:ANCHOR_TOP) { ANCHORS[0] }
      const_attr_reader  :ANCHOR_TOP
      
      # Anchor representing the bottom of the information area
      const_set_lazy(:ANCHOR_BOTTOM) { ANCHORS[1] }
      const_attr_reader  :ANCHOR_BOTTOM
      
      # Anchor representing the left side of the information area
      const_set_lazy(:ANCHOR_LEFT) { ANCHORS[2] }
      const_attr_reader  :ANCHOR_LEFT
      
      # Anchor representing the right side of the information area
      const_set_lazy(:ANCHOR_RIGHT) { ANCHORS[3] }
      const_attr_reader  :ANCHOR_RIGHT
      
      # Anchor representing the middle of the subject control
      # @since 2.1
      const_set_lazy(:ANCHOR_GLOBAL) { Anchor.new(SWT::CENTER) }
      const_attr_reader  :ANCHOR_GLOBAL
      
      # Dialog store constant for the location's x-coordinate.
      # @since 3.0
      const_set_lazy(:STORE_LOCATION_X) { "location.x" }
      const_attr_reader  :STORE_LOCATION_X
      
      # $NON-NLS-1$
      # 
      # Dialog store constant for the location's y-coordinate.
      # @since 3.0
      const_set_lazy(:STORE_LOCATION_Y) { "location.y" }
      const_attr_reader  :STORE_LOCATION_Y
      
      # $NON-NLS-1$
      # 
      # Dialog store constant for the size's width.
      # @since 3.0
      const_set_lazy(:STORE_SIZE_WIDTH) { "size.width" }
      const_attr_reader  :STORE_SIZE_WIDTH
      
      # $NON-NLS-1$
      # 
      # Dialog store constant for the size's height.
      # @since 3.0
      const_set_lazy(:STORE_SIZE_HEIGHT) { "size.height" }
      const_attr_reader  :STORE_SIZE_HEIGHT
      
      # $NON-NLS-1$
      # 
      # Tells whether this class and its subclasses are in debug mode.
      # <p>
      # Subclasses may use this.
      # </p>
      # @since 3.4
      const_set_lazy(:DEBUG) { "true".equals_ignore_case(Platform.get_debug_option("org.eclipse.jface.text/debug/AbstractInformationControlManager")) }
      const_attr_reader  :DEBUG
    }
    
    # $NON-NLS-1$//$NON-NLS-2$
    # The subject control of the information control
    attr_accessor :f_subject_control
    alias_method :attr_f_subject_control, :f_subject_control
    undef_method :f_subject_control
    alias_method :attr_f_subject_control=, :f_subject_control=
    undef_method :f_subject_control=
    
    # The display area for which the information to be presented is valid
    attr_accessor :f_subject_area
    alias_method :attr_f_subject_area, :f_subject_area
    undef_method :f_subject_area
    alias_method :attr_f_subject_area=, :f_subject_area=
    undef_method :f_subject_area=
    
    # The information to be presented
    attr_accessor :f_information
    alias_method :attr_f_information, :f_information
    undef_method :f_information
    alias_method :attr_f_information=, :f_information=
    undef_method :f_information=
    
    # Indicates whether the information control takes focus when visible
    attr_accessor :f_takes_focus_when_visible
    alias_method :attr_f_takes_focus_when_visible, :f_takes_focus_when_visible
    undef_method :f_takes_focus_when_visible
    alias_method :attr_f_takes_focus_when_visible=, :f_takes_focus_when_visible=
    undef_method :f_takes_focus_when_visible=
    
    # The information control.
    # 
    # <p>This field should not be referenced by subclasses. It is <code>protected</code> for API
    # compatibility reasons.
    attr_accessor :f_information_control
    alias_method :attr_f_information_control, :f_information_control
    undef_method :f_information_control
    alias_method :attr_f_information_control=, :f_information_control=
    undef_method :f_information_control=
    
    # The information control creator.
    # 
    # <p>This field should not be referenced by subclasses. It is <code>protected</code> for API
    # compatibility reasons.
    attr_accessor :f_information_control_creator
    alias_method :attr_f_information_control_creator, :f_information_control_creator
    undef_method :f_information_control_creator
    alias_method :attr_f_information_control_creator=, :f_information_control_creator=
    undef_method :f_information_control_creator=
    
    # The information control closer.
    # 
    # <p>This field should not be referenced by subclasses. It is <code>protected</code> for API
    # compatibility reasons.
    attr_accessor :f_information_control_closer
    alias_method :attr_f_information_control_closer, :f_information_control_closer
    undef_method :f_information_control_closer
    alias_method :attr_f_information_control_closer=, :f_information_control_closer=
    undef_method :f_information_control_closer=
    
    # Indicates that the information control has been disposed.
    # 
    # <p>This field should not be referenced by subclasses. It is <code>protected</code> for API
    # compatibility reasons.
    attr_accessor :f_disposed
    alias_method :attr_f_disposed, :f_disposed
    undef_method :f_disposed
    alias_method :attr_f_disposed=, :f_disposed=
    undef_method :f_disposed=
    
    # The information control replacer to be used when this information control
    # needs to be replaced with another information control.
    # 
    # @since 3.4
    attr_accessor :f_information_control_replacer
    alias_method :attr_f_information_control_replacer, :f_information_control_replacer
    undef_method :f_information_control_replacer
    alias_method :attr_f_information_control_replacer=, :f_information_control_replacer=
    undef_method :f_information_control_replacer=
    
    # Indicates the enable state of this manager
    attr_accessor :f_enabled
    alias_method :attr_f_enabled, :f_enabled
    undef_method :f_enabled
    alias_method :attr_f_enabled=, :f_enabled=
    undef_method :f_enabled=
    
    # Cached, computed size constraints of the information control in points
    attr_accessor :f_size_constraints
    alias_method :attr_f_size_constraints, :f_size_constraints
    undef_method :f_size_constraints
    alias_method :attr_f_size_constraints=, :f_size_constraints=
    undef_method :f_size_constraints=
    
    # The vertical margin when laying out the information control
    attr_accessor :f_margin_y
    alias_method :attr_f_margin_y, :f_margin_y
    undef_method :f_margin_y
    alias_method :attr_f_margin_y=, :f_margin_y=
    undef_method :f_margin_y=
    
    # The horizontal margin when laying out the information control
    attr_accessor :f_margin_x
    alias_method :attr_f_margin_x, :f_margin_x
    undef_method :f_margin_x
    alias_method :attr_f_margin_x=, :f_margin_x=
    undef_method :f_margin_x=
    
    # The width constraint of the information control in characters
    attr_accessor :f_width_constraint
    alias_method :attr_f_width_constraint, :f_width_constraint
    undef_method :f_width_constraint
    alias_method :attr_f_width_constraint=, :f_width_constraint=
    undef_method :f_width_constraint=
    
    # The height constraint of the information control  in characters
    attr_accessor :f_height_constraint
    alias_method :attr_f_height_constraint, :f_height_constraint
    undef_method :f_height_constraint
    alias_method :attr_f_height_constraint=, :f_height_constraint=
    undef_method :f_height_constraint=
    
    # Indicates whether the size constraints should be enforced as minimal control size
    attr_accessor :f_enforce_as_minimal_size
    alias_method :attr_f_enforce_as_minimal_size, :f_enforce_as_minimal_size
    undef_method :f_enforce_as_minimal_size
    alias_method :attr_f_enforce_as_minimal_size=, :f_enforce_as_minimal_size=
    undef_method :f_enforce_as_minimal_size=
    
    # Indicates whether the size constraints should be enforced as maximal control size
    attr_accessor :f_enforce_as_maximal_size
    alias_method :attr_f_enforce_as_maximal_size, :f_enforce_as_maximal_size
    undef_method :f_enforce_as_maximal_size
    alias_method :attr_f_enforce_as_maximal_size=, :f_enforce_as_maximal_size=
    undef_method :f_enforce_as_maximal_size=
    
    # The anchor for laying out the information control in relation to the subject control
    attr_accessor :f_anchor
    alias_method :attr_f_anchor, :f_anchor
    undef_method :f_anchor
    alias_method :attr_f_anchor=, :f_anchor=
    undef_method :f_anchor=
    
    # The anchor sequence used to layout the information control if the original anchor
    # can not be used because the information control would not fit in the display client area.
    # <p>
    # The fallback anchor for a given anchor is the one that comes directly after the given anchor or
    # is the first one in the sequence if the given anchor is the last one in the sequence.
    # <p>
    # </p>
    # Note: This sequence is ignored if the original anchor is not contained in this sequence.
    # </p>
    # 
    # @see #fAnchor
    attr_accessor :f_fallback_anchors
    alias_method :attr_f_fallback_anchors, :f_fallback_anchors
    undef_method :f_fallback_anchors
    alias_method :attr_f_fallback_anchors=, :f_fallback_anchors=
    undef_method :f_fallback_anchors=
    
    # The custom information control creator.
    # @since 3.0
    attr_accessor :f_custom_information_control_creator
    alias_method :attr_f_custom_information_control_creator, :f_custom_information_control_creator
    undef_method :f_custom_information_control_creator
    alias_method :attr_f_custom_information_control_creator=, :f_custom_information_control_creator=
    undef_method :f_custom_information_control_creator=
    
    # Tells whether a custom information control is in use.
    # @since 3.0
    attr_accessor :f_is_custom_information_control
    alias_method :attr_f_is_custom_information_control, :f_is_custom_information_control
    undef_method :f_is_custom_information_control
    alias_method :attr_f_is_custom_information_control=, :f_is_custom_information_control=
    undef_method :f_is_custom_information_control=
    
    # The dialog settings for the control's bounds.
    # @since 3.0
    attr_accessor :f_dialog_settings
    alias_method :attr_f_dialog_settings, :f_dialog_settings
    undef_method :f_dialog_settings
    alias_method :attr_f_dialog_settings=, :f_dialog_settings=
    undef_method :f_dialog_settings=
    
    # Tells whether the control's location should be read
    # from the dialog settings and whether the last
    # valid control's size is stored back into the  settings.
    # 
    # @since 3.0
    attr_accessor :f_is_restoring_location
    alias_method :attr_f_is_restoring_location, :f_is_restoring_location
    undef_method :f_is_restoring_location
    alias_method :attr_f_is_restoring_location=, :f_is_restoring_location=
    undef_method :f_is_restoring_location=
    
    # Tells whether the control's size should be read
    # from the dialog settings and whether the last
    # valid control's size is stored back into the  settings.
    # 
    # @since 3.0
    attr_accessor :f_is_restoring_size
    alias_method :attr_f_is_restoring_size, :f_is_restoring_size
    undef_method :f_is_restoring_size
    alias_method :attr_f_is_restoring_size=, :f_is_restoring_size=
    undef_method :f_is_restoring_size=
    
    # The dispose listener on the subject control.
    # 
    # @since 3.1
    attr_accessor :f_subject_control_dispose_listener
    alias_method :attr_f_subject_control_dispose_listener, :f_subject_control_dispose_listener
    undef_method :f_subject_control_dispose_listener
    alias_method :attr_f_subject_control_dispose_listener=, :f_subject_control_dispose_listener=
    undef_method :f_subject_control_dispose_listener=
    
    typesig { [IInformationControlCreator] }
    # Creates a new information control manager using the given information control creator.
    # By default the following configuration is given:
    # <ul>
    # <li> enabled == false
    # <li> horizontal margin == 5 points
    # <li> vertical margin == 5 points
    # <li> width constraint == 60 characters
    # <li> height constraint == 6 characters
    # <li> enforce constraints as minimal size == false
    # <li> enforce constraints as maximal size == false
    # <li> layout anchor == ANCHOR_BOTTOM
    # <li> fall back anchors == { ANCHOR_TOP, ANCHOR_BOTTOM, ANCHOR_LEFT, ANCHOR_RIGHT, ANCHOR_GLOBAL }
    # <li> takes focus when visible == false
    # </ul>
    # 
    # @param creator the information control creator
    def initialize(creator)
      @f_subject_control = nil
      @f_subject_area = nil
      @f_information = nil
      @f_takes_focus_when_visible = false
      @f_information_control = nil
      @f_information_control_creator = nil
      @f_information_control_closer = nil
      @f_disposed = false
      @f_information_control_replacer = nil
      @f_enabled = false
      @f_size_constraints = nil
      @f_margin_y = 5
      @f_margin_x = 5
      @f_width_constraint = 60
      @f_height_constraint = 6
      @f_enforce_as_minimal_size = false
      @f_enforce_as_maximal_size = false
      @f_anchor = ANCHOR_BOTTOM
      @f_fallback_anchors = ANCHORS
      @f_custom_information_control_creator = nil
      @f_is_custom_information_control = false
      @f_dialog_settings = nil
      @f_is_restoring_location = false
      @f_is_restoring_size = false
      @f_subject_control_dispose_listener = nil
      Assert.is_not_null(creator)
      @f_information_control_creator = creator
    end
    
    typesig { [] }
    # Computes the information to be displayed and the area in which the computed
    # information is valid. Implementation of this method must finish their computation
    # by setting the computation results using <code>setInformation</code>.
    def compute_information
      raise NotImplementedError
    end
    
    typesig { [String, Rectangle] }
    # Sets the parameters of the information to be displayed. These are the information itself and
    # the area for which the given information is valid. This so called subject area is a graphical
    # region of the information control's subject control. This method calls <code>presentInformation()</code>
    # to trigger the presentation of the computed information.
    # 
    # @param information the information, or <code>null</code> if none is available
    # @param subjectArea the subject area, or <code>null</code> if none is available
    def set_information(information, subject_area)
      set_information(information, subject_area)
    end
    
    typesig { [Object, Rectangle] }
    # Sets the parameters of the information to be displayed. These are the information itself and
    # the area for which the given information is valid. This so called subject area is a graphical
    # region of the information control's subject control. This method calls <code>presentInformation()</code>
    # to trigger the presentation of the computed information.
    # 
    # @param information the information, or <code>null</code> if none is available
    # @param subjectArea the subject area, or <code>null</code> if none is available
    # @since  2.1
    def set_information(information, subject_area)
      @f_information = information
      @f_subject_area = subject_area
      present_information
    end
    
    typesig { [IInformationControlCloser] }
    # Sets the information control closer for this manager.
    # 
    # @param closer the information control closer for this manager
    def set_closer(closer)
      @f_information_control_closer = closer
    end
    
    typesig { [InformationControlReplacer] }
    # Sets the information control replacer for this manager and disposes the
    # old one if set.
    # 
    # @param replacer the information control replacer for this manager, or
    # <code>null</code> if no information control replacing should
    # take place
    # @since 3.4
    def set_information_control_replacer(replacer)
      if (!(@f_information_control_replacer).nil?)
        @f_information_control_replacer.dispose
      end
      @f_information_control_replacer = replacer
    end
    
    typesig { [] }
    # Returns the current information control replacer or <code>null</code> if none has been installed.
    # 
    # @return the current information control replacer or <code>null</code> if none has been installed
    # @since 3.4
    def get_information_control_replacer
      return @f_information_control_replacer
    end
    
    typesig { [] }
    # Returns whether an information control replacer has been installed.
    # 
    # @return whether an information control replacer has been installed
    # @since 3.4
    def has_information_control_replacer
      return !(@f_information_control_replacer).nil?
    end
    
    typesig { [IInformationControl] }
    # Tests whether the given information control is replaceable.
    # 
    # @param iControl information control or <code>null</code> if none
    # @return <code>true</code> if information control is replaceable, <code>false</code> otherwise
    # @since 3.4
    def can_replace(i_control)
      return i_control.is_a?(IInformationControlExtension3) && i_control.is_a?(IInformationControlExtension5) && !((i_control).get_information_presenter_control_creator).nil?
    end
    
    typesig { [] }
    # Returns the current information control, or <code>null</code> if none.
    # 
    # @return the current information control, or <code>null</code> if none
    # @since 3.4
    def get_current_information_control
      return @f_information_control
    end
    
    typesig { [] }
    # Tells whether this manager's information control is currently being replaced.
    # 
    # @return <code>true</code> if a replace is in progress
    # @since 3.4
    def is_replace_in_progress
      return !(@f_information_control_replacer).nil? && @f_information_control_replacer.is_replacing
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the horizontal and vertical margin to be used when laying out the
    # information control relative to the subject control.
    # 
    # @param xMargin the x-margin
    # @param yMargin the y-Margin
    def set_margins(x_margin, y_margin)
      @f_margin_x = x_margin
      @f_margin_y = y_margin
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    # Sets the width- and height constraints of the information control.
    # 
    # @param widthInChar the width constraint in number of characters
    # @param heightInChar the height constrain in number of characters
    # @param enforceAsMinimalSize indicates whether the constraints describe the minimal allowed size of the control
    # @param enforceAsMaximalSize indicates whether the constraints describe the maximal allowed size of the control
    def set_size_constraints(width_in_char, height_in_char, enforce_as_minimal_size, enforce_as_maximal_size)
      @f_size_constraints = nil
      @f_width_constraint = width_in_char
      @f_height_constraint = height_in_char
      @f_enforce_as_minimal_size = enforce_as_minimal_size
      @f_enforce_as_maximal_size = enforce_as_maximal_size
    end
    
    typesig { [IDialogSettings, ::Java::Boolean, ::Java::Boolean] }
    # Tells this information control manager to open the information control with the values
    # contained in the given dialog settings and to store the control's last valid size in the
    # given dialog settings.
    # <p>
    # Note: This API is only valid if the information control implements
    # {@link IInformationControlExtension3}. Not following this restriction will later result in an
    # {@link UnsupportedOperationException}.
    # </p>
    # <p>
    # The constants used to store the values are:
    # <ul>
    # <li>{@link AbstractInformationControlManager#STORE_LOCATION_X}</li>
    # <li>{@link AbstractInformationControlManager#STORE_LOCATION_Y}</li>
    # <li>{@link AbstractInformationControlManager#STORE_SIZE_WIDTH}</li>
    # <li>{@link AbstractInformationControlManager#STORE_SIZE_HEIGHT}</li>
    # </ul>
    # </p>
    # 
    # @param dialogSettings the dialog settings
    # @param restoreLocation <code>true</code> iff the location is must be (re-)stored
    # @param restoreSize <code>true</code>iff the size is (re-)stored
    # @since 3.0
    def set_restore_information_control_bounds(dialog_settings, restore_location, restore_size)
      Assert.is_true(!(dialog_settings).nil? && (restore_location || restore_size))
      @f_dialog_settings = dialog_settings
      @f_is_restoring_location = restore_location
      @f_is_restoring_size = restore_size
    end
    
    typesig { [Anchor] }
    # Sets the anchor used for laying out the information control relative to the
    # subject control. E.g, using <code>ANCHOR_TOP</code> indicates that the
    # information control is position above the area for which the information to
    # be displayed is valid.
    # 
    # @param anchor the layout anchor
    def set_anchor(anchor)
      @f_anchor = anchor
    end
    
    typesig { [Array.typed(Anchor)] }
    # Sets the anchors fallback sequence used to layout the information control if the original
    # anchor can not be used because the information control would not fit in the display client
    # area.
    # <p>
    # The fallback anchor for a given anchor is the one that comes directly after the given anchor or
    # is the first one in the sequence if the given anchor is the last one in the sequence.
    # <p>
    # </p>
    # Note: This sequence is ignored if the original anchor is not contained in this list.
    # </p>
    # 
    # @param fallbackAnchors the array with the anchor fallback sequence
    # @see #setAnchor(AbstractInformationControlManager.Anchor)
    def set_fallback_anchors(fallback_anchors)
      if (!(fallback_anchors).nil?)
        @f_fallback_anchors = Array.typed(Anchor).new(fallback_anchors.attr_length) { nil }
        System.arraycopy(fallback_anchors, 0, @f_fallback_anchors, 0, fallback_anchors.attr_length)
      else
        @f_fallback_anchors = nil
      end
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the temporary custom control creator, overriding this manager's default information control creator.
    # 
    # @param informationControlCreator the creator, possibly <code>null</code>
    # @since 3.0
    def set_custom_information_control_creator(information_control_creator)
      if (!(information_control_creator).nil? && @f_custom_information_control_creator.is_a?(IInformationControlCreatorExtension))
        extension = @f_custom_information_control_creator
        if (extension.can_replace(information_control_creator))
          return
        end
      end
      @f_custom_information_control_creator = information_control_creator
    end
    
    typesig { [::Java::Boolean] }
    # Tells the manager whether it should set the focus to the information control when made visible.
    # 
    # @param takesFocus <code>true</code> if information control should take focus when made visible
    def takes_focus_when_visible(takes_focus)
      @f_takes_focus_when_visible = takes_focus
    end
    
    typesig { [] }
    # Handles the disposal of the subject control. By default, the information control
    # is disposed by calling <code>disposeInformationControl</code>. Subclasses may extend
    # this method.
    def handle_subject_control_disposed
      dispose_information_control
    end
    
    typesig { [Control] }
    # Installs this manager on the given control. The control is now taking the role of
    # the subject control. This implementation sets the control also as the information
    # control closer's subject control and automatically enables this manager.
    # 
    # @param subjectControl the subject control
    def install(subject_control)
      if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed && !(@f_subject_control_dispose_listener).nil?)
        @f_subject_control.remove_dispose_listener(@f_subject_control_dispose_listener)
      end
      @f_subject_control = subject_control
      if (!(@f_subject_control).nil?)
        @f_subject_control.add_dispose_listener(get_subject_control_dispose_listener)
      end
      if (!(@f_information_control_closer).nil?)
        @f_information_control_closer.set_subject_control(subject_control)
      end
      set_enabled(true)
      @f_disposed = false
    end
    
    typesig { [] }
    # Returns the dispose listener which gets added
    # to the subject control.
    # 
    # @return the dispose listener
    # @since 3.1
    def get_subject_control_dispose_listener
      if ((@f_subject_control_dispose_listener).nil?)
        @f_subject_control_dispose_listener = Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members AbstractInformationControlManager
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |e|
            handle_subject_control_disposed
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @f_subject_control_dispose_listener
    end
    
    typesig { [] }
    # Returns the subject control of this manager/information control.
    # 
    # @return the subject control
    def get_subject_control
      return @f_subject_control
    end
    
    typesig { [] }
    # Returns the actual subject area.
    # 
    # @return the actual subject area
    def get_subject_area
      return @f_subject_area
    end
    
    typesig { [::Java::Boolean] }
    # Sets the enable state of this manager.
    # 
    # @param enabled the enable state
    # @deprecated visibility will be changed to protected
    def set_enabled(enabled)
      @f_enabled = enabled
    end
    
    typesig { [] }
    # Returns whether this manager is enabled or not.
    # 
    # @return <code>true</code> if this manager is enabled otherwise <code>false</code>
    def is_enabled
      return @f_enabled
    end
    
    typesig { [Control, IInformationControl] }
    # Computes the size constraints of the information control in points based on the
    # default font of the given subject control as well as the size constraints in character
    # width.
    # 
    # @param subjectControl the subject control
    # @param informationControl the information control whose size constraints are computed
    # @return the computed size constraints in points
    def compute_size_constraints(subject_control, information_control)
      if ((@f_size_constraints).nil?)
        if (information_control.is_a?(IInformationControlExtension5))
          i_control5 = information_control
          @f_size_constraints = i_control5.compute_size_constraints(@f_width_constraint, @f_height_constraint)
          if (!(@f_size_constraints).nil?)
            return Geometry.copy(@f_size_constraints)
          end
        end
        if ((subject_control).nil?)
          return nil
        end
        gc = SwtGC.new(subject_control)
        gc.set_font(subject_control.get_font)
        width = gc.get_font_metrics.get_average_char_width
        height = gc.get_font_metrics.get_height
        gc.dispose
        @f_size_constraints = Point.new(@f_width_constraint * width, @f_height_constraint * height)
      end
      return Point.new(@f_size_constraints.attr_x, @f_size_constraints.attr_y)
    end
    
    typesig { [Control, Rectangle, IInformationControl] }
    # Computes the size constraints of the information control in points.
    # 
    # @param subjectControl the subject control
    # @param subjectArea the subject area
    # @param informationControl the information control whose size constraints are computed
    # @return the computed size constraints in points
    # @since 3.0
    def compute_size_constraints(subject_control, subject_area, information_control)
      return compute_size_constraints(subject_control, information_control)
    end
    
    typesig { [] }
    # Handles the disposal of the information control. By default, the information
    # control closer is stopped.
    def handle_information_control_disposed
      store_information_control_bounds
      if (@f_information_control.is_a?(IInformationControlExtension5))
        @f_size_constraints = nil
      end
      @f_information_control = nil
      if (!(@f_information_control_closer).nil?)
        @f_information_control_closer.set_information_control(nil) # XXX: null is against the spec
        @f_information_control_closer.stop
      end
    end
    
    typesig { [] }
    # Returns the information control. If the information control has not been created yet,
    # it is automatically created.
    # 
    # @return the information control
    def get_information_control
      if (@f_disposed)
        return @f_information_control
      end
      creator = nil
      if ((@f_custom_information_control_creator).nil?)
        creator = @f_information_control_creator
        if (@f_is_custom_information_control && !(@f_information_control).nil?)
          if (@f_information_control.is_a?(IInformationControlExtension5))
            @f_size_constraints = nil
          end
          @f_information_control.dispose
          @f_information_control = nil
        end
        @f_is_custom_information_control = false
      else
        creator = @f_custom_information_control_creator
        if (creator.is_a?(IInformationControlCreatorExtension))
          extension = creator
          if (!(@f_information_control).nil? && extension.can_reuse(@f_information_control))
            return @f_information_control
          end
        end
        if (!(@f_information_control).nil?)
          if (@f_information_control.is_a?(IInformationControlExtension5))
            @f_size_constraints = nil
          end
          @f_information_control.dispose
          @f_information_control = nil
        end
        @f_is_custom_information_control = true
      end
      if ((@f_information_control).nil?)
        @f_information_control = creator.create_information_control(@f_subject_control.get_shell)
        @f_information_control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members AbstractInformationControlManager
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |e|
            handle_information_control_disposed
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (!(@f_information_control_closer).nil?)
          @f_information_control_closer.set_information_control(@f_information_control)
        end
      end
      return @f_information_control
    end
    
    typesig { [Rectangle, Point, Anchor] }
    # Computes the display location of the information control. The location is computed
    # considering the given subject area, the anchor at the subject area, and the
    # size of the information control. This method does not care about whether the information
    # control would be completely visible when placed at the result location.
    # 
    # @param subjectArea the subject area
    # @param controlSize the size of the information control
    # @param anchor the anchor at the subject area
    # @return the display location of the information control
    def compute_location(subject_area, control_size, anchor)
      x_shift = 0
      y_shift = 0
      case (anchor.get_swtflag)
      when SWT::CENTER
        subject_control_size = @f_subject_control.get_size
        location = Point.new(subject_control_size.attr_x / 2, subject_control_size.attr_y / 2)
        location.attr_x -= (control_size.attr_x / 2)
        location.attr_y -= (control_size.attr_y / 2)
        return @f_subject_control.to_display(location)
      when SWT::BOTTOM
        y_shift = subject_area.attr_height + @f_margin_y
      when SWT::RIGHT
        x_shift = @f_margin_x + subject_area.attr_width
      when SWT::TOP
        y_shift = -control_size.attr_y - @f_margin_y
      when SWT::LEFT
        x_shift = -control_size.attr_x - @f_margin_x
      end
      is_rtl = !(@f_subject_control).nil? && !((@f_subject_control.get_style & SWT::RIGHT_TO_LEFT)).equal?(0)
      if (is_rtl)
        x_shift += control_size.attr_x
      end
      return @f_subject_control.to_display(Point.new(subject_area.attr_x + x_shift, subject_area.attr_y + y_shift))
    end
    
    typesig { [Rectangle, Rectangle, Anchor] }
    # Computes the area available for an information control given an anchor and the subject area
    # within <code>bounds</code>.
    # 
    # @param subjectArea the subject area
    # @param bounds the bounds
    # @param anchor the anchor at the subject area
    # @return the area available at the given anchor relative to the subject area, confined to the
    # monitor's client area
    # @since 3.3
    def compute_available_area(subject_area, bounds, anchor)
      area = nil
      case (anchor.get_swtflag)
      when SWT::CENTER
        area = bounds
      when SWT::BOTTOM
        y = subject_area.attr_y + subject_area.attr_height + @f_margin_y
        area = Rectangle.new(bounds.attr_x, y, bounds.attr_width, bounds.attr_y + bounds.attr_height - y)
      when SWT::RIGHT
        x = subject_area.attr_x + subject_area.attr_width + @f_margin_x
        area = Rectangle.new(x, bounds.attr_y, bounds.attr_x + bounds.attr_width - x, bounds.attr_height)
      when SWT::TOP
        area = Rectangle.new(bounds.attr_x, bounds.attr_y, bounds.attr_width, subject_area.attr_y - bounds.attr_y - @f_margin_y)
      when SWT::LEFT
        area = Rectangle.new(bounds.attr_x, bounds.attr_y, subject_area.attr_x - bounds.attr_x - @f_margin_x, bounds.attr_height)
      else
        Assert.is_legal(false)
        return nil
      end
      # Don't return negative areas if the subjectArea overlaps with the monitor bounds.
      area.intersect(bounds)
      return area
    end
    
    typesig { [Point, Point, Rectangle, Anchor] }
    # Checks whether a control of the given size at the given location would be completely visible
    # in the given display area when laid out by using the given anchor. If not, this method tries
    # to shift the control orthogonal to the direction given by the anchor to make it visible. If possible
    # it updates the location.<p>
    # This method returns <code>true</code> if the potentially updated position results in a
    # completely visible control, or <code>false</code> otherwise.
    # 
    # 
    # @param location the location of the control
    # @param size the size of the control
    # @param displayArea the display area in which the control should be visible
    # @param anchor anchor for lying out the control
    # @return <code>true</code>if the updated location is useful
    def update_location(location, size, display_area, anchor)
      display_lower_right_x = display_area.attr_x + display_area.attr_width
      display_lower_right_y = display_area.attr_y + display_area.attr_height
      lower_right_x = location.attr_x + size.attr_x
      lower_right_y = location.attr_y + size.attr_y
      if ((ANCHOR_BOTTOM).equal?(anchor) || (ANCHOR_TOP).equal?(anchor))
        if ((ANCHOR_BOTTOM).equal?(anchor))
          if (lower_right_y > display_lower_right_y)
            return false
          end
        else
          if (location.attr_y < display_area.attr_y)
            return false
          end
        end
        if (lower_right_x > display_lower_right_x)
          location.attr_x = location.attr_x - (lower_right_x - display_lower_right_x)
        end
        return (location.attr_x >= display_area.attr_x && location.attr_y >= display_area.attr_y)
      else
        if ((ANCHOR_RIGHT).equal?(anchor) || (ANCHOR_LEFT).equal?(anchor))
          if ((ANCHOR_RIGHT).equal?(anchor))
            if (lower_right_x > display_lower_right_x)
              return false
            end
          else
            if (location.attr_x < display_area.attr_x)
              return false
            end
          end
          if (lower_right_y > display_lower_right_y)
            location.attr_y = location.attr_y - (lower_right_y - display_lower_right_y)
          end
          return (location.attr_x >= display_area.attr_x && location.attr_y >= display_area.attr_y)
        else
          if ((ANCHOR_GLOBAL).equal?(anchor))
            if (lower_right_x > display_lower_right_x)
              location.attr_x = location.attr_x - (lower_right_x - display_lower_right_x)
            end
            if (lower_right_y > display_lower_right_y)
              location.attr_y = location.attr_y - (lower_right_y - display_lower_right_y)
            end
            return (location.attr_x >= display_area.attr_x && location.attr_y >= display_area.attr_y)
          end
        end
      end
      return false
    end
    
    typesig { [Anchor] }
    # Returns the next fallback anchor as specified by this manager's
    # fallback anchor sequence.
    # <p>
    # The fallback anchor for the given anchor is the one that comes directly after
    # the given anchor or is the first one in the sequence if the given anchor is the
    # last one in the sequence.
    # </p>
    # <p>
    # Note: It is the callers responsibility to prevent an endless loop i.e. to test
    # whether a given anchor has already been used once.
    # then
    # </p>
    # 
    # @param anchor the current anchor
    # @return the next fallback anchor or <code>null</code> if no fallback anchor is available
    def get_next_fallback_anchor(anchor)
      if ((anchor).nil? || (@f_fallback_anchors).nil?)
        return nil
      end
      i = 0
      while i < @f_fallback_anchors.attr_length
        if ((@f_fallback_anchors[i]).equal?(anchor))
          return @f_fallback_anchors[(i + 1).equal?(@f_fallback_anchors.attr_length) ? 0 : i + 1]
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Rectangle, Point] }
    # Computes the location of the information control depending on the
    # subject area and the size of the information control. This method attempts
    # to find a location at which the information control lies completely in the display's
    # client area while honoring the manager's default anchor. If this isn't possible using the
    # default anchor, the fallback anchors are tried out.
    # 
    # @param subjectArea the information area
    # @param controlSize the size of the information control
    # @return the computed location of the information control
    def compute_information_control_location(subject_area, control_size)
      subject_area_display_relative = Geometry.to_display(@f_subject_control, subject_area)
      upper_left = nil
      test_anchor = @f_anchor
      best_bounds = nil
      best_area = JavaInteger::MIN_VALUE
      best_anchor = nil
      begin
        upper_left = compute_location(subject_area, control_size, test_anchor)
        monitor = get_closest_monitor(subject_area_display_relative, test_anchor)
        if (update_location(upper_left, control_size, monitor.get_client_area, test_anchor))
          return upper_left
        end
        # compute available area for this anchor and update if better than best
        available = compute_available_area(subject_area_display_relative, monitor.get_client_area, test_anchor)
        proposed = Rectangle.new(upper_left.attr_x, upper_left.attr_y, control_size.attr_x, control_size.attr_y)
        available.intersect(proposed)
        area = available.attr_width * available.attr_height
        if (area > best_area)
          best_area = area
          best_bounds = available
          best_anchor = test_anchor
        end
        test_anchor = get_next_fallback_anchor(test_anchor)
      end while (!(test_anchor).equal?(@f_anchor) && !(test_anchor).nil?)
      # no anchor is perfect - select the one with larges area and set the size to not overlap with the subjectArea
      if (!(best_anchor).equal?(ANCHOR_GLOBAL))
        Geometry.set(control_size, Geometry.get_size(best_bounds))
      end
      return Geometry.get_location(best_bounds)
    end
    
    typesig { [Rectangle, Anchor] }
    # Gets the closest monitor given an anchor and the subject area.
    # 
    # @param area the subject area
    # @param anchor the anchor
    # @return the monitor closest to the edge of <code>area</code> defined by
    # <code>anchor</code>
    # @since 3.3
    def get_closest_monitor(area, anchor)
      center = nil
      if ((ANCHOR_GLOBAL).equal?(anchor))
        center = Geometry.center_point(area)
      else
        center = Geometry.center_point(Geometry.get_extruded_edge(area, 0, anchor.get_swtflag))
      end
      return get_closest_monitor(@f_subject_control.get_display, Geometry.create_rectangle(center, Point.new(0, 0)))
    end
    
    typesig { [Display, Rectangle] }
    # Copied from org.eclipse.jface.window.Window. Returns the monitor whose client area contains
    # the given point. If no monitor contains the point, returns the monitor that is closest to the
    # point. If this is ever made public, it should be moved into a separate utility class.
    # 
    # @param display the display to search for monitors
    # @param rectangle the rectangle to find the closest monitor for (display coordinates)
    # @return the monitor closest to the given point
    # @since 3.3
    def get_closest_monitor(display, rectangle)
      closest = JavaInteger::MAX_VALUE
      to_find = Geometry.center_point(rectangle)
      monitors = display.get_monitors
      result = monitors[0]
      idx = 0
      while idx < monitors.attr_length
        current = monitors[idx]
        client_area = current.get_client_area
        if (client_area.contains(to_find))
          return current
        end
        distance = Geometry.distance_squared(Geometry.center_point(client_area), to_find)
        if (distance < closest)
          closest = distance
          result = current
        end
        idx += 1
      end
      return result
    end
    
    typesig { [] }
    # Computes information to be displayed as well as the subject area
    # and initiates that this information is presented in the information control.
    # This happens only if this controller is enabled.
    def show_information
      if (@f_enabled)
        do_show_information
      end
    end
    
    typesig { [] }
    # Computes information to be displayed as well as the subject area
    # and initiates that this information is presented in the information control.
    def do_show_information
      @f_subject_area = nil
      @f_information = nil
      compute_information
    end
    
    typesig { [] }
    # Presents the information in the information control or hides the information
    # control if no information should be presented. The information has previously
    # been set using <code>setInformation</code>.
    # <p>
    # This method should only be called from overriding methods or from <code>setInformation</code>.
    # </p>
    def present_information
      has_contents = false
      if (@f_information.is_a?(String))
        has_contents = (@f_information).trim.length > 0
      else
        has_contents = (!(@f_information).nil?)
      end
      if (!(@f_subject_area).nil? && has_contents)
        internal_show_information_control(@f_subject_area, @f_information)
      else
        hide_information_control
      end
    end
    
    typesig { [Rectangle, Object] }
    # Opens the information control with the given information and the specified
    # subject area. It also activates the information control closer.
    # 
    # @param subjectArea the information area
    # @param information the information
    def internal_show_information_control(subject_area, information)
      if (self.is_a?(InformationControlReplacer))
        (self).show_information_control(subject_area, information)
        return
      end
      information_control = get_information_control
      if (!(information_control).nil?)
        size_constraints = compute_size_constraints(@f_subject_control, @f_subject_area, information_control)
        if (information_control.is_a?(IInformationControlExtension3))
          i_control3 = information_control
          trim = i_control3.compute_trim
          size_constraints.attr_x += trim.attr_width
          size_constraints.attr_y += trim.attr_height
        end
        information_control.set_size_constraints(size_constraints.attr_x, size_constraints.attr_y)
        if (information_control.is_a?(IInformationControlExtension2))
          (information_control).set_input(information)
        else
          information_control.set_information(information.to_s)
        end
        if (information_control.is_a?(IInformationControlExtension))
          extension = information_control
          if (!extension.has_contents)
            return
          end
        end
        size = nil
        location = nil
        bounds = restore_information_control_bounds
        if (!(bounds).nil?)
          if (bounds.attr_x > -1 && bounds.attr_y > -1)
            location = Geometry.get_location(bounds)
          end
          if (bounds.attr_width > -1 && bounds.attr_height > -1)
            size = Geometry.get_size(bounds)
          end
        end
        if ((size).nil?)
          size = information_control.compute_size_hint
        end
        if (@f_enforce_as_minimal_size)
          size = Geometry.max(size, size_constraints)
        end
        if (@f_enforce_as_maximal_size)
          size = Geometry.min(size, size_constraints)
        end
        if ((location).nil?)
          location = compute_information_control_location(subject_area, size)
        end
        control_bounds = Geometry.create_rectangle(location, size)
        crop_to_closest_monitor(control_bounds)
        location = Geometry.get_location(control_bounds)
        size = Geometry.get_size(control_bounds)
        information_control.set_location(location)
        information_control.set_size(size.attr_x, size.attr_y)
        show_information_control(subject_area)
      end
    end
    
    typesig { [Rectangle] }
    # Crops the given bounds such that they lie completely on the closest monitor.
    # 
    # @param bounds shell bounds to crop
    # @since 3.4
    def crop_to_closest_monitor(bounds)
      monitor_bounds = get_closest_monitor(@f_subject_control.get_display, bounds).get_client_area
      bounds.intersect(monitor_bounds)
    end
    
    typesig { [] }
    # Hides the information control and stops the information control closer.
    def hide_information_control
      if (!(@f_information_control).nil?)
        store_information_control_bounds
        @f_information_control.set_visible(false)
        if (!(@f_information_control_closer).nil?)
          @f_information_control_closer.stop
        end
      end
      @f_subject_area = nil
      @f_information = nil # allow garbage collection of potentially large object
    end
    
    typesig { [Rectangle] }
    # Shows the information control and starts the information control closer.
    # This method may not be called by clients.
    # 
    # @param subjectArea the information area
    def show_information_control(subject_area)
      @f_information_control.set_visible(true)
      if ((@f_information_control).nil?)
        return
      end # could already be disposed if setVisible(..) runs the display loop
      if (@f_takes_focus_when_visible)
        @f_information_control.set_focus
      end
      if (!(@f_information_control_closer).nil?)
        @f_information_control_closer.start(subject_area)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Replaces this manager's information control as defined by
    # the information control replacer.
    # <strong>Must only be called when {@link #fInformationControl} instanceof {@link IInformationControlExtension3}!</strong>
    # 
    # @param takeFocus <code>true</code> iff the replacing information control should take focus
    # 
    # @since 3.4
    def replace_information_control(take_focus)
      if (!(@f_information_control_replacer).nil? && can_replace(@f_information_control))
        i_control3 = @f_information_control
        b = i_control3.get_bounds
        t = i_control3.compute_trim
        content_bounds = Rectangle.new(b.attr_x - t.attr_x, b.attr_y - t.attr_y, b.attr_width - t.attr_width, b.attr_height - t.attr_height)
        information_presenter_control_creator = (@f_information_control).get_information_presenter_control_creator
        @f_information_control_replacer.replace_information_control(information_presenter_control_creator, content_bounds, @f_information, @f_subject_area, take_focus)
      end
      hide_information_control
    end
    
    typesig { [] }
    # Disposes this manager's information control.
    def dispose_information_control
      if (!(@f_information_control).nil?)
        @f_information_control.dispose
        handle_information_control_disposed
      end
    end
    
    typesig { [] }
    # Disposes this manager and if necessary all dependent parts such as
    # the information control. For symmetry it first disables this manager.
    def dispose
      if (!@f_disposed)
        @f_disposed = true
        set_enabled(false)
        dispose_information_control
        if (!(@f_information_control_replacer).nil?)
          @f_information_control_replacer.dispose
          @f_information_control_replacer = nil
        end
        if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed && !(@f_subject_control_dispose_listener).nil?)
          @f_subject_control.remove_dispose_listener(@f_subject_control_dispose_listener)
        end
        @f_subject_control = nil
        @f_subject_control_dispose_listener = nil
        @f_is_custom_information_control = false
        @f_custom_information_control_creator = nil
        @f_information_control_creator = nil
        @f_information_control_closer = nil
      end
    end
    
    typesig { [] }
    # ------ control's size handling dialog settings ------
    # 
    # Stores the information control's bounds.
    # 
    # @since 3.0
    def store_information_control_bounds
      if ((@f_dialog_settings).nil? || (@f_information_control).nil? || !(@f_is_restoring_location || @f_is_restoring_size))
        return
      end
      if (!(@f_information_control.is_a?(IInformationControlExtension3)))
        raise UnsupportedOperationException.new
      end
      control_restores_size = (@f_information_control).restores_size
      control_restores_location = (@f_information_control).restores_location
      bounds = (@f_information_control).get_bounds
      if ((bounds).nil?)
        return
      end
      if (@f_is_restoring_size && control_restores_size)
        @f_dialog_settings.put(STORE_SIZE_WIDTH, bounds.attr_width)
        @f_dialog_settings.put(STORE_SIZE_HEIGHT, bounds.attr_height)
      end
      if (@f_is_restoring_location && control_restores_location)
        @f_dialog_settings.put(STORE_LOCATION_X, bounds.attr_x)
        @f_dialog_settings.put(STORE_LOCATION_Y, bounds.attr_y)
      end
    end
    
    typesig { [] }
    # Restores the information control's bounds.
    # 
    # @return the stored bounds
    # @since 3.0
    def restore_information_control_bounds
      if ((@f_dialog_settings).nil? || !(@f_is_restoring_location || @f_is_restoring_size))
        return nil
      end
      if (!(@f_information_control.is_a?(IInformationControlExtension3)))
        raise UnsupportedOperationException.new
      end
      control_restores_size = (@f_information_control).restores_size
      control_restores_location = (@f_information_control).restores_location
      bounds = Rectangle.new(-1, -1, -1, -1)
      if (@f_is_restoring_size && control_restores_size)
        begin
          bounds.attr_width = @f_dialog_settings.get_int(STORE_SIZE_WIDTH)
          bounds.attr_height = @f_dialog_settings.get_int(STORE_SIZE_HEIGHT)
        rescue NumberFormatException => ex
          bounds.attr_width = -1
          bounds.attr_height = -1
        end
      end
      if (@f_is_restoring_location && control_restores_location)
        begin
          bounds.attr_x = @f_dialog_settings.get_int(STORE_LOCATION_X)
          bounds.attr_y = @f_dialog_settings.get_int(STORE_LOCATION_Y)
        rescue NumberFormatException => ex
          bounds.attr_x = -1
          bounds.attr_y = -1
        end
      end
      # sanity check
      if ((bounds.attr_x).equal?(-1) && (bounds.attr_y).equal?(-1) && (bounds.attr_width).equal?(-1) && (bounds.attr_height).equal?(-1))
        return nil
      end
      max_bounds = nil
      if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
        max_bounds = @f_subject_control.get_display.get_bounds
      else
        # fallback
        display = Display.get_current
        if ((display).nil?)
          display = Display.get_default
        end
        if (!(display).nil? && !display.is_disposed)
          max_bounds = display.get_bounds
        end
      end
      if (bounds.attr_width > -1 && bounds.attr_height > -1)
        if (!(max_bounds).nil?)
          bounds.attr_width = Math.min(bounds.attr_width, max_bounds.attr_width)
          bounds.attr_height = Math.min(bounds.attr_height, max_bounds.attr_height)
        end
        # Enforce an absolute minimal size
        bounds.attr_width = Math.max(bounds.attr_width, 30)
        bounds.attr_height = Math.max(bounds.attr_height, 30)
      end
      if (bounds.attr_x > -1 && bounds.attr_y > -1 && !(max_bounds).nil?)
        bounds.attr_x = Math.max(bounds.attr_x, max_bounds.attr_x)
        bounds.attr_y = Math.max(bounds.attr_y, max_bounds.attr_y)
        if (bounds.attr_width > -1 && bounds.attr_height > -1)
          bounds.attr_x = Math.min(bounds.attr_x, max_bounds.attr_width - bounds.attr_width)
          bounds.attr_y = Math.min(bounds.attr_y, max_bounds.attr_height - bounds.attr_height)
        end
      end
      return bounds
    end
    
    typesig { [] }
    # Returns an adapter that gives access to internal methods.
    # <p>
    # <strong>Note:</strong> This method is not intended to be referenced or overridden by clients.</p>
    # 
    # @return the replaceable information control accessor
    # @since 3.4
    # @noreference This method is not intended to be referenced by clients.
    # @nooverride This method is not intended to be re-implemented or extended by clients.
    def get_internal_accessor
      return MyInternalAccessor.new_local(self)
    end
    
    private
    alias_method :initialize__abstract_information_control_manager, :initialize
  end
  
end
