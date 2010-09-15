require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DefaultInformationControlImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Drawable
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :FillLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Jface::Action, :ToolBarManager
      include_const ::Org::Eclipse::Jface::Internal::Text::Html, :HTMLTextPresenter
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Geometry
    }
  end
  
  # Default implementation of {@link org.eclipse.jface.text.IInformationControl}.
  # <p>
  # Displays textual information in a {@link org.eclipse.swt.custom.StyledText}
  # widget. Before displaying, the information set to this information control is
  # processed by an <code>IInformationPresenter</code>.
  # 
  # @since 2.0
  class DefaultInformationControl < DefaultInformationControlImports.const_get :AbstractInformationControl
    include_class_members DefaultInformationControlImports
    overload_protected {
      include DisposeListener
    }
    
    class_module.module_eval {
      # An information presenter determines the style presentation
      # of information displayed in the default information control.
      # The interface can be implemented by clients.
      const_set_lazy(:IInformationPresenter) { Module.new do
        include_class_members DefaultInformationControl
        
        typesig { [Display, String, TextPresentation, ::Java::Int, ::Java::Int] }
        # Updates the given presentation of the given information and
        # thereby may manipulate the information to be displayed. The manipulation
        # could be the extraction of textual encoded style information etc. Returns the
        # manipulated information.
        # <p>
        # <strong>Note:</strong> The given display must only be used for measuring.</p>
        # 
        # @param display the display of the information control
        # @param hoverInfo the information to be presented
        # @param presentation the presentation to be updated
        # @param maxWidth the maximal width in pixels
        # @param maxHeight the maximal height in pixels
        # 
        # @return the manipulated information
        # @deprecated As of 3.2, replaced by {@link DefaultInformationControl.IInformationPresenterExtension#updatePresentation(Drawable, String, TextPresentation, int, int)}
        def update_presentation(display, hover_info, presentation, max_width, max_height)
          raise NotImplementedError
        end
      end }
      
      # An information presenter determines the style presentation
      # of information displayed in the default information control.
      # The interface can be implemented by clients.
      # 
      # @since 3.2
      const_set_lazy(:IInformationPresenterExtension) { Module.new do
        include_class_members DefaultInformationControl
        
        typesig { [Drawable, String, TextPresentation, ::Java::Int, ::Java::Int] }
        # Updates the given presentation of the given information and
        # thereby may manipulate the information to be displayed. The manipulation
        # could be the extraction of textual encoded style information etc. Returns the
        # manipulated information.
        # <p>
        # Replaces {@link DefaultInformationControl.IInformationPresenter#updatePresentation(Display, String, TextPresentation, int, int)}
        # Implementations should use the font of the given <code>drawable</code> to calculate
        # the size of the text to be presented.
        # </p>
        # 
        # @param drawable the drawable of the information control
        # @param hoverInfo the information to be presented
        # @param presentation the presentation to be updated
        # @param maxWidth the maximal width in pixels
        # @param maxHeight the maximal height in pixels
        # 
        # @return the manipulated information
        def update_presentation(drawable, hover_info, presentation, max_width, max_height)
          raise NotImplementedError
        end
      end }
      
      # Inner border thickness in pixels.
      # @since 3.1
      const_set_lazy(:INNER_BORDER) { 1 }
      const_attr_reader  :INNER_BORDER
    }
    
    # The control's text widget
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    # The information presenter, or <code>null</code> if none.
    attr_accessor :f_presenter
    alias_method :attr_f_presenter, :f_presenter
    undef_method :f_presenter
    alias_method :attr_f_presenter=, :f_presenter=
    undef_method :f_presenter=
    
    # A cached text presentation
    attr_accessor :f_presentation
    alias_method :attr_f_presentation, :f_presentation
    undef_method :f_presentation
    alias_method :attr_f_presentation=, :f_presentation=
    undef_method :f_presentation=
    
    # Additional styles to use for the text control.
    # @since 3.4, previously called <code>fTextStyle</code>
    attr_accessor :f_additional_text_styles
    alias_method :attr_f_additional_text_styles, :f_additional_text_styles
    undef_method :f_additional_text_styles
    alias_method :attr_f_additional_text_styles=, :f_additional_text_styles=
    undef_method :f_additional_text_styles=
    
    typesig { [Shell, ::Java::Boolean] }
    # Creates a default information control with the given shell as parent. An information
    # presenter that can handle simple HTML is used to process the information to be displayed.
    # 
    # @param parent the parent shell
    # @param isResizeable <code>true</code> if the control should be resizable
    # @since 3.4
    def initialize(parent, is_resizeable)
      @f_text = nil
      @f_presenter = nil
      @f_presentation = nil
      @f_additional_text_styles = 0
      super(parent, is_resizeable)
      @f_presentation = TextPresentation.new
      @f_additional_text_styles = is_resizeable ? SWT::V_SCROLL | SWT::H_SCROLL : SWT::NONE
      @f_presenter = HTMLTextPresenter.new(!is_resizeable)
      create
    end
    
    typesig { [Shell, String] }
    # Creates a default information control with the given shell as parent. An information
    # presenter that can handle simple HTML is used to process the information to be displayed.
    # 
    # @param parent the parent shell
    # @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
    # @since 3.4
    def initialize(parent, status_field_text)
      initialize__default_information_control(parent, status_field_text, HTMLTextPresenter.new(true))
    end
    
    typesig { [Shell, String, IInformationPresenter] }
    # Creates a default information control with the given shell as parent. The
    # given information presenter is used to process the information to be
    # displayed.
    # 
    # @param parent the parent shell
    # @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
    # @param presenter the presenter to be used, or <code>null</code> if no presenter should be used
    # @since 3.4
    def initialize(parent, status_field_text, presenter)
      @f_text = nil
      @f_presenter = nil
      @f_presentation = nil
      @f_additional_text_styles = 0
      super(parent, status_field_text)
      @f_presentation = TextPresentation.new
      @f_additional_text_styles = SWT::NONE
      @f_presenter = presenter
      create
    end
    
    typesig { [Shell, ToolBarManager] }
    # Creates a resizable default information control with the given shell as parent. An
    # information presenter that can handle simple HTML is used to process the information to be
    # displayed.
    # 
    # @param parent the parent shell
    # @param toolBarManager the manager or <code>null</code> if toolbar is not desired
    # @since 3.4
    def initialize(parent, tool_bar_manager)
      initialize__default_information_control(parent, tool_bar_manager, HTMLTextPresenter.new(false))
    end
    
    typesig { [Shell, ToolBarManager, IInformationPresenter] }
    # Creates a resizable default information control with the given shell as
    # parent. The given information presenter is used to process the
    # information to be displayed.
    # 
    # @param parent the parent shell
    # @param toolBarManager the manager or <code>null</code> if toolbar is not desired
    # @param presenter the presenter to be used, or <code>null</code> if no presenter should be used
    # @since 3.4
    def initialize(parent, tool_bar_manager, presenter)
      @f_text = nil
      @f_presenter = nil
      @f_presentation = nil
      @f_additional_text_styles = 0
      super(parent, tool_bar_manager)
      @f_presentation = TextPresentation.new
      @f_additional_text_styles = SWT::V_SCROLL | SWT::H_SCROLL
      @f_presenter = presenter
      create
    end
    
    typesig { [Shell] }
    # Creates a default information control with the given shell as parent.
    # No information presenter is used to process the information
    # to be displayed.
    # 
    # @param parent the parent shell
    def initialize(parent)
      initialize__default_information_control(parent, nil, nil)
    end
    
    typesig { [Shell, IInformationPresenter] }
    # Creates a default information control with the given shell as parent. The given
    # information presenter is used to process the information to be displayed.
    # 
    # @param parent the parent shell
    # @param presenter the presenter to be used
    def initialize(parent, presenter)
      initialize__default_information_control(parent, nil, presenter)
    end
    
    typesig { [Shell, ::Java::Int, ::Java::Int, IInformationPresenter] }
    # Creates a default information control with the given shell as parent. The
    # given information presenter is used to process the information to be
    # displayed. The given styles are applied to the created styled text
    # widget.
    # 
    # @param parent the parent shell
    # @param shellStyle the additional styles for the shell
    # @param style the additional styles for the styled text widget
    # @param presenter the presenter to be used
    # @deprecated As of 3.4, replaced by simpler constructors
    def initialize(parent, shell_style, style, presenter)
      initialize__default_information_control(parent, shell_style, style, presenter, nil)
    end
    
    typesig { [Shell, ::Java::Int, ::Java::Int, IInformationPresenter, String] }
    # Creates a default information control with the given shell as parent. The
    # given information presenter is used to process the information to be
    # displayed. The given styles are applied to the created styled text
    # widget.
    # 
    # @param parentShell the parent shell
    # @param shellStyle the additional styles for the shell
    # @param style the additional styles for the styled text widget
    # @param presenter the presenter to be used
    # @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
    # @since 3.0
    # @deprecated As of 3.4, replaced by simpler constructors
    def initialize(parent_shell, shell_style, style, presenter, status_field_text)
      @f_text = nil
      @f_presenter = nil
      @f_presentation = nil
      @f_additional_text_styles = 0
      super(parent_shell, SWT::NO_FOCUS | SWT::ON_TOP | shell_style, status_field_text, nil)
      @f_presentation = TextPresentation.new
      @f_additional_text_styles = style
      @f_presenter = presenter
      create
    end
    
    typesig { [Shell, ::Java::Int, IInformationPresenter] }
    # Creates a default information control with the given shell as parent. The
    # given information presenter is used to process the information to be
    # displayed.
    # 
    # @param parent the parent shell
    # @param textStyles the additional styles for the styled text widget
    # @param presenter the presenter to be used
    # @deprecated As of 3.4, replaced by {@link #DefaultInformationControl(Shell, DefaultInformationControl.IInformationPresenter)}
    def initialize(parent, text_styles, presenter)
      initialize__default_information_control(parent, text_styles, presenter, nil)
    end
    
    typesig { [Shell, ::Java::Int, IInformationPresenter, String] }
    # Creates a default information control with the given shell as parent. The
    # given information presenter is used to process the information to be
    # displayed.
    # 
    # @param parent the parent shell
    # @param textStyles the additional styles for the styled text widget
    # @param presenter the presenter to be used
    # @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
    # @since 3.0
    # @deprecated As of 3.4, replaced by {@link #DefaultInformationControl(Shell, String, DefaultInformationControl.IInformationPresenter)}
    def initialize(parent, text_styles, presenter, status_field_text)
      @f_text = nil
      @f_presenter = nil
      @f_presentation = nil
      @f_additional_text_styles = 0
      super(parent, status_field_text)
      @f_presentation = TextPresentation.new
      @f_additional_text_styles = text_styles
      @f_presenter = presenter
      create
    end
    
    typesig { [Composite] }
    # @see org.eclipse.jface.text.AbstractInformationControl#createContent(org.eclipse.swt.widgets.Composite)
    def create_content(parent)
      @f_text = StyledText.new(parent, SWT::MULTI | SWT::READ_ONLY | @f_additional_text_styles)
      @f_text.set_foreground(parent.get_foreground)
      @f_text.set_background(parent.get_background)
      @f_text.set_font(JFaceResources.get_dialog_font)
      layout = parent.get_layout
      if (@f_text.get_word_wrap)
        # indent does not work for wrapping StyledText, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=56342 and https://bugs.eclipse.org/bugs/show_bug.cgi?id=115432
        layout.attr_margin_height = INNER_BORDER
        layout.attr_margin_width = INNER_BORDER
      else
        @f_text.set_indent(INNER_BORDER)
      end
    end
    
    typesig { [String] }
    # @see IInformationControl#setInformation(String)
    def set_information(content)
      if ((@f_presenter).nil?)
        @f_text.set_text(content)
      else
        @f_presentation.clear
        max_width = -1
        max_height = -1
        constraints = get_size_constraints
        if (!(constraints).nil?)
          max_width = constraints.attr_x
          max_height = constraints.attr_y
          if (@f_text.get_word_wrap)
            max_width -= INNER_BORDER * 2
            max_height -= INNER_BORDER * 2
          else
            max_width -= INNER_BORDER # indent
          end
          trim = compute_trim
          max_width -= trim.attr_width
          max_height -= trim.attr_height
          max_width -= @f_text.get_caret.get_size.attr_x # StyledText adds a border at the end of the line for the caret.
        end
        if (is_resizable)
          max_height = JavaInteger::MAX_VALUE
        end
        if (@f_presenter.is_a?(IInformationPresenterExtension))
          content = RJava.cast_to_string((@f_presenter).update_presentation(@f_text, content, @f_presentation, max_width, max_height))
        else
          content = RJava.cast_to_string(@f_presenter.update_presentation(get_shell.get_display, content, @f_presentation, max_width, max_height))
        end
        if (!(content).nil?)
          @f_text.set_text(content)
          TextPresentation.apply_text_presentation(@f_presentation, @f_text)
        else
          @f_text.set_text("") # $NON-NLS-1$
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see IInformationControl#setVisible(boolean)
    def set_visible(visible)
      if (visible)
        if (@f_text.get_word_wrap)
          current_size = get_shell.get_size
          get_shell.pack(true)
          new_size = get_shell.get_size
          if (new_size.attr_x > current_size.attr_x || new_size.attr_y > current_size.attr_y)
            set_size(current_size.attr_x, current_size.attr_y)
          end # restore previous size
        end
      end
      super(visible)
    end
    
    typesig { [] }
    # @see IInformationControl#computeSizeHint()
    def compute_size_hint
      # see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=117602
      width_hint = SWT::DEFAULT
      constraints = get_size_constraints
      if (!(constraints).nil? && @f_text.get_word_wrap)
        width_hint = constraints.attr_x
      end
      return get_shell.compute_size(width_hint, SWT::DEFAULT, true)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControl#computeTrim()
    def compute_trim
      return Geometry.add(super, @f_text.compute_trim(0, 0, 0, 0))
    end
    
    typesig { [Color] }
    # @see IInformationControl#setForegroundColor(Color)
    def set_foreground_color(foreground)
      super(foreground)
      @f_text.set_foreground(foreground)
    end
    
    typesig { [Color] }
    # @see IInformationControl#setBackgroundColor(Color)
    def set_background_color(background)
      super(background)
      @f_text.set_background(background)
    end
    
    typesig { [] }
    # @see IInformationControlExtension#hasContents()
    def has_contents
      return @f_text.get_char_count > 0
    end
    
    typesig { [DisposeEvent] }
    # @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
    # @since 3.0
    # @deprecated As of 3.2, no longer used and called
    def widget_disposed(event)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension5#getInformationPresenterControlCreator()
    # @since 3.4
    def get_information_presenter_control_creator
      return Class.new(IInformationControlCreator.class == Class ? IInformationControlCreator : Object) do
        local_class_in DefaultInformationControl
        include_class_members DefaultInformationControl
        include IInformationControlCreator if IInformationControlCreator.class == Module
        
        typesig { [Shell] }
        # @see org.eclipse.jface.text.IInformationControlCreator#createInformationControl(org.eclipse.swt.widgets.Shell)
        define_method :create_information_control do |parent|
          return self.class::DefaultInformationControl.new(parent, nil, self.attr_f_presenter)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__default_information_control, :initialize
  end
  
end
