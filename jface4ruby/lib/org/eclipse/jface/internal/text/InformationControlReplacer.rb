require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text
  module InformationControlReplacerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :AbstractReusableInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension2
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension3
    }
  end
  
  # An information control replacer can replace an {@link AbstractInformationControlManager}'s
  # control.
  # <p>
  # The {@link AbstractInformationControlManager} can be configured with such a replacer by calling
  # <code>setInformationControlReplacer</code>.
  # </p>
  # 
  # @since 3.4
  class InformationControlReplacer < InformationControlReplacerImports.const_get :AbstractInformationControlManager
    include_class_members InformationControlReplacerImports
    
    class_module.module_eval {
      # Minimal width in pixels.
      const_set_lazy(:MIN_WIDTH) { 80 }
      const_attr_reader  :MIN_WIDTH
      
      # Minimal height in pixels.
      const_set_lazy(:MIN_HEIGHT) { 50 }
      const_attr_reader  :MIN_HEIGHT
      
      # Default control creator.
      const_set_lazy(:DefaultInformationControlCreator) { Class.new(AbstractReusableInformationControlCreator) do
        include_class_members InformationControlReplacer
        
        typesig { [class_self::Shell] }
        def do_create_information_control(shell)
          return self.class::DefaultInformationControl.new(shell, true)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__default_information_control_creator, :initialize
      end }
    }
    
    attr_accessor :f_is_replacing
    alias_method :attr_f_is_replacing, :f_is_replacing
    undef_method :f_is_replacing
    alias_method :attr_f_is_replacing=, :f_is_replacing=
    undef_method :f_is_replacing=
    
    attr_accessor :f_replacable_information
    alias_method :attr_f_replacable_information, :f_replacable_information
    undef_method :f_replacable_information
    alias_method :attr_f_replacable_information=, :f_replacable_information=
    undef_method :f_replacable_information=
    
    attr_accessor :f_delayed_information_set
    alias_method :attr_f_delayed_information_set, :f_delayed_information_set
    undef_method :f_delayed_information_set
    alias_method :attr_f_delayed_information_set=, :f_delayed_information_set=
    undef_method :f_delayed_information_set=
    
    attr_accessor :f_replaceable_area
    alias_method :attr_f_replaceable_area, :f_replaceable_area
    undef_method :f_replaceable_area
    alias_method :attr_f_replaceable_area=, :f_replaceable_area=
    undef_method :f_replaceable_area=
    
    attr_accessor :f_content_bounds
    alias_method :attr_f_content_bounds, :f_content_bounds
    undef_method :f_content_bounds
    alias_method :attr_f_content_bounds=, :f_content_bounds=
    undef_method :f_content_bounds=
    
    typesig { [IInformationControlCreator] }
    # Creates a new information control replacer.
    # 
    # @param creator the default information control creator
    def initialize(creator)
      @f_is_replacing = false
      @f_replacable_information = nil
      @f_delayed_information_set = false
      @f_replaceable_area = nil
      @f_content_bounds = nil
      super(creator)
      takes_focus_when_visible(false)
    end
    
    typesig { [IInformationControlCreator, Rectangle, Object, Rectangle, ::Java::Boolean] }
    # Replace the information control.
    # 
    # @param informationPresenterControlCreator the information presenter control creator
    # @param contentBounds the bounds of the content area of the information control
    # @param information the information to show
    # @param subjectArea the subject area
    # @param takeFocus <code>true</code> iff the replacing information control should take focus
    def replace_information_control(information_presenter_control_creator, content_bounds, information, subject_area, take_focus)
      begin
        @f_is_replacing = true
        if (!@f_delayed_information_set)
          @f_replacable_information = information
        else
          take_focus = true
        end # delayed input has been set, so the original info control must have been focused
        @f_content_bounds = content_bounds
        @f_replaceable_area = subject_area
        set_custom_information_control_creator(information_presenter_control_creator)
        takes_focus_when_visible(take_focus)
        show_information
      ensure
        @f_is_replacing = false
        @f_replacable_information = nil
        @f_delayed_information_set = false
        @f_replaceable_area = nil
        set_custom_information_control_creator(nil)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#computeInformation()
    def compute_information
      if (@f_is_replacing && !(@f_replacable_information).nil?)
        set_information(@f_replacable_information, @f_replaceable_area)
        return
      end
      if (DEBUG)
        System.out.println("InformationControlReplacer: no active replaceable")
      end # $NON-NLS-1$
    end
    
    typesig { [Rectangle, Object] }
    # Opens the information control with the given information and the specified
    # subject area. It also activates the information control closer.
    # 
    # @param subjectArea the information area
    # @param information the information
    def show_information_control(subject_area, information)
      information_control = get_information_control
      control_bounds = @f_content_bounds
      if (information_control.is_a?(IInformationControlExtension3))
        i_control3 = information_control
        trim = i_control3.compute_trim
        control_bounds = Geometry.add(control_bounds, trim)
        # Ensure minimal size. Interacting with a tiny information control
        # (resizing, selecting text) would be a pain.
        control_bounds.attr_width = Math.max(control_bounds.attr_width, MIN_WIDTH)
        control_bounds.attr_height = Math.max(control_bounds.attr_height, MIN_HEIGHT)
        get_internal_accessor.crop_to_closest_monitor(control_bounds)
      end
      location = Geometry.get_location(control_bounds)
      size = Geometry.get_size(control_bounds)
      # Caveat: some IInformationControls fail unless setSizeConstraints(..) is called with concrete values
      information_control.set_size_constraints(size.attr_x, size.attr_y)
      if (information_control.is_a?(IInformationControlExtension2))
        (information_control).set_input(information)
      else
        information_control.set_information(information.to_s)
      end
      information_control.set_location(location)
      information_control.set_size(size.attr_x, size.attr_y)
      show_information_control(subject_area)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#hideInformationControl()
    def hide_information_control
      super
    end
    
    typesig { [Object] }
    # @param input the delayed input, or <code>null</code> to request cancellation
    def set_delayed_input(input)
      @f_replacable_information = input
      if (!is_replacing)
        @f_delayed_information_set = true
      else
        if (get_current_information_control2.is_a?(IInformationControlExtension2))
          (get_current_information_control2).set_input(input)
        else
          if (!(get_current_information_control2).nil?)
            get_current_information_control2.set_information(input.to_s)
          end
        end
      end
    end
    
    typesig { [] }
    # Tells whether the replacer is currently replacing another information control.
    # 
    # @return <code>true</code> while code from {@link #replaceInformationControl(IInformationControlCreator, Rectangle, Object, Rectangle, boolean)} is run
    def is_replacing
      return @f_is_replacing
    end
    
    typesig { [] }
    # @return the current information control, or <code>null</code> if none available
    def get_current_information_control2
      return get_internal_accessor.get_current_information_control
    end
    
    typesig { [] }
    # The number of pixels to blow up the keep-up zone.
    # 
    # @return the margin in pixels
    def get_keep_up_margin
      return 15
    end
    
    private
    alias_method :initialize__information_control_replacer, :initialize
  end
  
end
