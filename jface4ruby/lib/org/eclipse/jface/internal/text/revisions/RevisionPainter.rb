require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module RevisionPainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util::Map, :Entry
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :Platform
      include_const ::Org::Eclipse::Jface::Internal::Text::Html, :BrowserInformationControl
      include_const ::Org::Eclipse::Jface::Internal::Text::Html, :HTMLPrinter
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Text, :AbstractReusableInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text::Information, :IInformationProviderExtension2
      include_const ::Org::Eclipse::Jface::Text::Revisions, :IRevisionListener
      include_const ::Org::Eclipse::Jface::Text::Revisions, :IRevisionRulerColumnExtension
      include_const ::Org::Eclipse::Jface::Text::Revisions, :Revision
      include_const ::Org::Eclipse::Jface::Text::Revisions, :RevisionEvent
      include_const ::Org::Eclipse::Jface::Text::Revisions, :RevisionInformation
      include_const ::Org::Eclipse::Jface::Text::Revisions, :RevisionRange
      include_const ::Org::Eclipse::Jface::Text::Revisions::IRevisionRulerColumnExtension, :RenderingMode
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :CompositeRuler
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationHover
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationHoverExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationHoverExtension2
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelListener
      include_const ::Org::Eclipse::Jface::Text::Source, :IChangeRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineDiffer
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
      include_const ::Org::Eclipse::Jface::Text::Source, :ISharedTextColors
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewer
      include_const ::Org::Eclipse::Jface::Text::Source, :IVerticalRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Source, :LineRange
    }
  end
  
  # A strategy for painting the live annotate colors onto the vertical ruler column. It also manages
  # the revision hover.
  # 
  # @since 3.2
  class RevisionPainter 
    include_class_members RevisionPainterImports
    
    class_module.module_eval {
      # Tells whether this class is in debug mode.
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= "true".equals_ignore_case(Platform.get_debug_option("org.eclipse.jface.text.source/debug/RevisionRulerColumn"))
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # $NON-NLS-1$//$NON-NLS-2$
      # RGBs provided by UI Designer
      const_set_lazy(:BY_DATE_START_COLOR) { RGB.new(199, 134, 57) }
      const_attr_reader  :BY_DATE_START_COLOR
      
      const_set_lazy(:BY_DATE_END_COLOR) { RGB.new(241, 225, 206) }
      const_attr_reader  :BY_DATE_END_COLOR
      
      # The annotations created to show a revision in the overview ruler.
      const_set_lazy(:RevisionAnnotation) { Class.new(Annotation) do
        include_class_members RevisionPainter
        
        typesig { [String] }
        def initialize(text)
          super("org.eclipse.ui.workbench.texteditor.revisionAnnotation", false, text) # $NON-NLS-1$
        end
        
        private
        alias_method :initialize__revision_annotation, :initialize
      end }
      
      # The color tool manages revision colors and computes shaded colors based on the relative age
      # and author of a revision.
      const_set_lazy(:ColorTool) { Class.new do
        extend LocalClass
        include_class_members RevisionPainter
        
        class_module.module_eval {
          # The average perceived intensity of a base color. 0 means black, 1 means white. A base
          # revision color perceived as light such as yellow will be darkened, while colors perceived
          # as dark such as blue will be lightened up.
          const_set_lazy(:AVERAGE_INTENSITY) { 0.5 }
          const_attr_reader  :AVERAGE_INTENSITY
          
          # The maximum shading in [0, 1] - this is the shade that the most recent revision will
          # receive.
          const_set_lazy(:MAX_SHADING) { 0.7 }
          const_attr_reader  :MAX_SHADING
          
          # The minimum shading in [0, 1] - this is the shade that the oldest revision will receive.
          const_set_lazy(:MIN_SHADING) { 0.2 }
          const_attr_reader  :MIN_SHADING
          
          # The shade for the focus boxes.
          const_set_lazy(:FOCUS_COLOR_SHADING) { 1 }
          const_attr_reader  :FOCUS_COLOR_SHADING
        }
        
        # A list of {@link Long}, storing the age of each revision in a sorted list.
        attr_accessor :f_revisions
        alias_method :attr_f_revisions, :f_revisions
        undef_method :f_revisions
        alias_method :attr_f_revisions=, :f_revisions=
        undef_method :f_revisions=
        
        # The stored shaded colors.
        attr_accessor :f_colors
        alias_method :attr_f_colors, :f_colors
        undef_method :f_colors
        alias_method :attr_f_colors=, :f_colors=
        undef_method :f_colors=
        
        # The stored focus colors.
        attr_accessor :f_focus_colors
        alias_method :attr_f_focus_colors, :f_focus_colors
        undef_method :f_focus_colors
        alias_method :attr_f_focus_colors=, :f_focus_colors=
        undef_method :f_focus_colors=
        
        typesig { [class_self::RevisionInformation] }
        # Sets the revision information, which is needed to compute the relative age of a revision.
        # 
        # @param info the new revision info, <code>null</code> for none.
        def set_info(info)
          @f_revisions = nil
          @f_colors.clear
          @f_focus_colors.clear
          if ((info).nil?)
            return
          end
          revisions = self.class::ArrayList.new
          it = info.get_revisions.iterator
          while it.has_next
            revision = it.next_
            revisions.add(self.class::Long.new(compute_age(revision)))
          end
          Collections.sort(revisions)
          @f_revisions = revisions
        end
        
        typesig { [class_self::Revision, ::Java::Boolean] }
        def adapt_color(revision, focus)
          rgb = nil
          scale = 0.0
          if ((self.attr_f_rendering_mode).equal?(IRevisionRulerColumnExtension::AGE))
            index = compute_age_index(revision)
            if ((index).equal?(-1) || (@f_revisions.size).equal?(0))
              rgb = get_background.get_rgb
            else
              # gradient from intense red for most recent to faint yellow for oldest
              gradient = Colors.palette(BY_DATE_START_COLOR, BY_DATE_END_COLOR, @f_revisions.size)
              rgb = gradient[gradient.attr_length - index - 1]
            end
            scale = 0.99
          else
            if ((self.attr_f_rendering_mode).equal?(IRevisionRulerColumnExtension::AUTHOR))
              rgb = revision.get_color
              rgb = Colors.adjust_brightness(rgb, self.class::AVERAGE_INTENSITY)
              scale = 0.6
            else
              if ((self.attr_f_rendering_mode).equal?(IRevisionRulerColumnExtension::AUTHOR_SHADED_BY_AGE))
                rgb = revision.get_color
                rgb = Colors.adjust_brightness(rgb, self.class::AVERAGE_INTENSITY)
                index = compute_age_index(revision)
                size_ = @f_revisions.size
                # relative age: newest is 0, oldest is 1
                # if there is only one revision, use an intermediate value to avoid extreme coloring
                if ((index).equal?(-1) || size_ < 2)
                  scale = 0.5
                else
                  scale = (index).to_f / (size_ - 1)
                end
              else
                Assert.is_true(false)
                return nil # dummy
              end
            end
          end
          rgb = get_shaded_color(rgb, scale, focus)
          return rgb
        end
        
        typesig { [class_self::Revision] }
        def compute_age_index(revision)
          age = compute_age(revision)
          index = @f_revisions.index_of(self.class::Long.new(age))
          return index
        end
        
        typesig { [class_self::RGB, ::Java::Float, ::Java::Boolean] }
        def get_shaded_color(color, scale, focus)
          Assert.is_legal(scale >= 0.0)
          Assert.is_legal(scale <= 1.0)
          background = get_background.get_rgb
          # normalize to lie within [MIN_SHADING, MAX_SHADING]
          # use more intense colors if the ruler is narrow (i.e. not showing line numbers)
          make_intense = get_width <= 15
          intensity_shift = make_intense ? 0.3 : 0
          max = self.class::MAX_SHADING + intensity_shift
          min = self.class::MIN_SHADING + intensity_shift
          scale = (max - min) * scale + min
          # focus coloring
          if (focus)
            scale += self.class::FOCUS_COLOR_SHADING
            if (scale > 1)
              background = self.class::RGB.new(255 - background.attr_red, 255 - background.attr_green, 255 - background.attr_blue)
              scale = 2 - scale
            end
          end
          return Colors.blend(background, color, scale)
        end
        
        typesig { [class_self::Revision] }
        def compute_age(revision)
          return revision.get_date.get_time
        end
        
        typesig { [class_self::Revision, ::Java::Boolean] }
        # Returns the color for a revision based on relative age and author.
        # 
        # @param revision the revision
        # @param focus <code>true</code> to return the focus color
        # @return the color for a revision
        def get_color(revision, focus)
          map = focus ? @f_focus_colors : @f_colors
          color = map.get(revision)
          if (!(color).nil?)
            return color
          end
          color = adapt_color(revision, focus)
          map.put(revision, color)
          return color
        end
        
        typesig { [] }
        def initialize
          @f_revisions = nil
          @f_colors = self.class::HashMap.new
          @f_focus_colors = self.class::HashMap.new
        end
        
        private
        alias_method :initialize__color_tool, :initialize
      end }
      
      # Handles all the mouse interaction in this line number ruler column.
      const_set_lazy(:MouseHandler) { Class.new do
        extend LocalClass
        include_class_members RevisionPainter
        include MouseMoveListener
        include MouseTrackListener
        include Listener
        
        attr_accessor :f_mouse_down_region
        alias_method :attr_f_mouse_down_region, :f_mouse_down_region
        undef_method :f_mouse_down_region
        alias_method :attr_f_mouse_down_region=, :f_mouse_down_region=
        undef_method :f_mouse_down_region=
        
        typesig { [class_self::Event] }
        def handle_mouse_up(e)
          if ((e.attr_button).equal?(1))
            up_region = self.attr_f_focus_range
            down_region = @f_mouse_down_region
            @f_mouse_down_region = nil
            if ((up_region).equal?(down_region))
              revision = (up_region).nil? ? nil : up_region.get_revision
              if ((revision).equal?(self.attr_f_selected_revision))
                revision = nil
              end # deselect already selected revision
              handle_revision_selected(revision)
            end
          end
        end
        
        typesig { [class_self::Event] }
        def handle_mouse_down(e)
          if ((e.attr_button).equal?(3))
            update_focus_revision(nil)
          end # kill any focus as the ctx menu is going to show
          if ((e.attr_button).equal?(1))
            @f_mouse_down_region = self.attr_f_focus_range
            post_redraw
          end
        end
        
        typesig { [class_self::Event] }
        # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
        def handle_event(event)
          case (event.attr_type)
          when SWT::MouseWheel
            handle_mouse_wheel(event)
          when SWT::MouseDown
            handle_mouse_down(event)
          when SWT::MouseUp
            handle_mouse_up(event)
          else
            Assert.is_legal(false)
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseTrackListener#mouseEnter(org.eclipse.swt.events.MouseEvent)
        def mouse_enter(e)
          update_focus_line(to_document_line_number(e.attr_y))
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseTrackListener#mouseExit(org.eclipse.swt.events.MouseEvent)
        def mouse_exit(e)
          update_focus_line(-1)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseTrackListener#mouseHover(org.eclipse.swt.events.MouseEvent)
        def mouse_hover(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseMoveListener#mouseMove(org.eclipse.swt.events.MouseEvent)
        def mouse_move(e)
          update_focus_line(to_document_line_number(e.attr_y))
        end
        
        typesig { [] }
        def initialize
          @f_mouse_down_region = nil
        end
        
        private
        alias_method :initialize__mouse_handler, :initialize
      end }
      
      # Internal listener class that will update the ruler when the underlying model changes.
      const_set_lazy(:AnnotationListener) { Class.new do
        extend LocalClass
        include_class_members RevisionPainter
        include IAnnotationModelListener
        
        typesig { [class_self::IAnnotationModel] }
        # @see org.eclipse.jface.text.source.IAnnotationModelListener#modelChanged(org.eclipse.jface.text.source.IAnnotationModel)
        def model_changed(model)
          clear_range_cache
          post_redraw
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__annotation_listener, :initialize
      end }
      
      # The information control creator.
      const_set_lazy(:HoverInformationControlCreator) { Class.new(AbstractReusableInformationControlCreator) do
        include_class_members RevisionPainter
        
        attr_accessor :f_is_focusable
        alias_method :attr_f_is_focusable, :f_is_focusable
        undef_method :f_is_focusable
        alias_method :attr_f_is_focusable=, :f_is_focusable=
        undef_method :f_is_focusable=
        
        typesig { [::Java::Boolean] }
        def initialize(is_focusable)
          @f_is_focusable = false
          super()
          @f_is_focusable = is_focusable
        end
        
        typesig { [class_self::Shell] }
        # @see org.eclipse.jface.internal.text.revisions.AbstractReusableInformationControlCreator#doCreateInformationControl(org.eclipse.swt.widgets.Shell)
        def do_create_information_control(parent)
          if (BrowserInformationControl.is_available(parent))
            return Class.new(self.class::BrowserInformationControl.class == Class ? self.class::BrowserInformationControl : Object) do
              extend LocalClass
              include_class_members HoverInformationControlCreator
              include class_self::BrowserInformationControl if class_self::BrowserInformationControl.class == Module
              
              typesig { [String] }
              # {@inheritDoc}
              # 
              # @deprecated use {@link #setInput(Object)}
              define_method :set_information do |content|
                content = RJava.cast_to_string(add_cssto_htmlfragment(content))
                super(content)
              end
              
              typesig { [String] }
              # Adds a HTML header and CSS info if <code>html</code> is only an HTML fragment (has no
              # &lt;html&gt; section).
              # 
              # @param html the html / text produced by a revision
              # @return modified html
              define_method :add_cssto_htmlfragment do |html|
                max = Math.min(100, html.length)
                if (!(html.substring(0, max).index_of("<html>")).equal?(-1))
                  # $NON-NLS-1$
                  # there is already a header
                  return html
                end
                info = self.class::StringBuffer.new(512 + html.length)
                HTMLPrinter.insert_page_prolog(info, 0, FgStyleSheet)
                info.append(html)
                HTMLPrinter.add_page_epilog(info)
                return info.to_s
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self, parent, JFaceResources::DIALOG_FONT, @f_is_focusable)
          end
          return self.class::DefaultInformationControl.new(parent, @f_is_focusable)
        end
        
        typesig { [class_self::IInformationControlCreator] }
        # @see org.eclipse.jface.text.AbstractReusableInformationControlCreator#canReplace(org.eclipse.jface.text.IInformationControlCreator)
        def can_replace(creator)
          return (creator.get_class).equal?(get_class) && ((creator).attr_f_is_focusable).equal?(@f_is_focusable)
        end
        
        private
        alias_method :initialize__hover_information_control_creator, :initialize
      end }
      
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      const_set_lazy(:FgStyleSheet) { "/* Font definitions */\n" + "body, h1, h2, h3, h4, h5, h6, p, table, td, caption, th, ul, ol, dl, li, dd, dt {font-family: sans-serif; font-size: 9pt }\n" + "pre				{ font-family: monospace; font-size: 9pt }\n" + "\n" + "/* Margins */\n" + "body	     { overflow: auto; margin-top: 0; margin-bottom: 4; margin-left: 3; margin-right: 0 }\n" + "h1           { margin-top: 5; margin-bottom: 1 }	\n" + "h2           { margin-top: 25; margin-bottom: 3 }\n" + "h3           { margin-top: 20; margin-bottom: 3 }\n" + "h4           { margin-top: 20; margin-bottom: 3 }\n" + "h5           { margin-top: 0; margin-bottom: 0 }\n" + "p            { margin-top: 10px; margin-bottom: 10px }\n" + "pre	         { margin-left: 6 }\n" + "ul	         { margin-top: 0; margin-bottom: 10 }\n" + "li	         { margin-top: 0; margin-bottom: 0 } \n" + "li p	     { margin-top: 0; margin-bottom: 0 } \n" + "ol	         { margin-top: 0; margin-bottom: 10 }\n" + "dl	         { margin-top: 0; margin-bottom: 10 }\n" + "dt	         { margin-top: 0; margin-bottom: 0; font-weight: bold }\n" + "dd	         { margin-top: 0; margin-bottom: 0 }\n" + "\n" + "/* Styles and colors */\n" + "a:link	     { color: #0000FF }\n" + "a:hover	     { color: #000080 }\n" + "a:visited    { text-decoration: underline }\n" + "h4           { font-style: italic }\n" + "strong	     { font-weight: bold }\n" + "em	         { font-style: italic }\n" + "var	         { font-style: italic }\n" + "th	         { font-weight: bold }\n" + "" }
      const_attr_reader  :FgStyleSheet
      
      # $NON-NLS-1$
      # 
      # The revision hover displays information about the currently selected revision.
      const_set_lazy(:RevisionHover) { Class.new do
        extend LocalClass
        include_class_members RevisionPainter
        include IAnnotationHover
        include IAnnotationHoverExtension
        include IAnnotationHoverExtension2
        include IInformationProviderExtension2
        
        typesig { [class_self::ISourceViewer, ::Java::Int] }
        # @see org.eclipse.jface.text.source.IAnnotationHover#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer,
        # int)
        def get_hover_info(source_viewer, line_number)
          info = get_hover_info(source_viewer, get_hover_line_range(source_viewer, line_number), 0)
          return (info).nil? ? nil : info.to_s
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverControlCreator()
        def get_hover_control_creator
          revision_info = self.attr_f_revision_info
          if (!(revision_info).nil?)
            creator = revision_info.get_hover_control_creator
            if (!(creator).nil?)
              return creator
            end
          end
          return self.class::HoverInformationControlCreator.new(false)
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#canHandleMouseCursor()
        def can_handle_mouse_cursor
          return false
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.source.IAnnotationHoverExtension2#canHandleMouseWheel()
        def can_handle_mouse_wheel
          return true
        end
        
        typesig { [class_self::ISourceViewer, class_self::ILineRange, ::Java::Int] }
        # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer,
        # org.eclipse.jface.text.source.ILineRange, int)
        def get_hover_info(source_viewer, line_range, visible_number_of_lines)
          range = get_range(line_range.get_start_line)
          info = (range).nil? ? nil : range.get_revision.get_hover_info
          return info
        end
        
        typesig { [class_self::ISourceViewer, ::Java::Int] }
        # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverLineRange(org.eclipse.jface.text.source.ISourceViewer,
        # int)
        def get_hover_line_range(viewer, line_number)
          range = get_range(line_number)
          return (range).nil? ? nil : self.class::LineRange.new(line_number, 1)
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.information.IInformationProviderExtension2#getInformationPresenterControlCreator()
        def get_information_presenter_control_creator
          revision_info = self.attr_f_revision_info
          if (!(revision_info).nil?)
            creator = revision_info.get_information_presenter_control_creator
            if (!(creator).nil?)
              return creator
            end
          end
          return self.class::HoverInformationControlCreator.new(true)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__revision_hover, :initialize
      end }
    }
    
    # Listeners and helpers.
    # The shared color provider.
    attr_accessor :f_shared_colors
    alias_method :attr_f_shared_colors, :f_shared_colors
    undef_method :f_shared_colors
    alias_method :attr_f_shared_colors=, :f_shared_colors=
    undef_method :f_shared_colors=
    
    # The color tool.
    attr_accessor :f_color_tool
    alias_method :attr_f_color_tool, :f_color_tool
    undef_method :f_color_tool
    alias_method :attr_f_color_tool=, :f_color_tool=
    undef_method :f_color_tool=
    
    # The mouse handler.
    attr_accessor :f_mouse_handler
    alias_method :attr_f_mouse_handler, :f_mouse_handler
    undef_method :f_mouse_handler
    alias_method :attr_f_mouse_handler=, :f_mouse_handler=
    undef_method :f_mouse_handler=
    
    # The hover.
    attr_accessor :f_hover
    alias_method :attr_f_hover, :f_hover
    undef_method :f_hover
    alias_method :attr_f_hover=, :f_hover=
    undef_method :f_hover=
    
    # The annotation listener.
    attr_accessor :f_annotation_listener
    alias_method :attr_f_annotation_listener, :f_annotation_listener
    undef_method :f_annotation_listener
    alias_method :attr_f_annotation_listener=, :f_annotation_listener=
    undef_method :f_annotation_listener=
    
    # The selection provider.
    attr_accessor :f_revision_selection_provider
    alias_method :attr_f_revision_selection_provider, :f_revision_selection_provider
    undef_method :f_revision_selection_provider
    alias_method :attr_f_revision_selection_provider=, :f_revision_selection_provider=
    undef_method :f_revision_selection_provider=
    
    # The list of revision listeners.
    # @since 3.3.
    attr_accessor :f_revision_listeners
    alias_method :attr_f_revision_listeners, :f_revision_listeners
    undef_method :f_revision_listeners
    alias_method :attr_f_revision_listeners=, :f_revision_listeners=
    undef_method :f_revision_listeners=
    
    # The context - column and viewer we are connected to.
    # The vertical ruler column that delegates painting to this painter.
    attr_accessor :f_column
    alias_method :attr_f_column, :f_column
    undef_method :f_column
    alias_method :attr_f_column=, :f_column=
    undef_method :f_column=
    
    # The parent ruler.
    attr_accessor :f_parent_ruler
    alias_method :attr_f_parent_ruler, :f_parent_ruler
    undef_method :f_parent_ruler
    alias_method :attr_f_parent_ruler=, :f_parent_ruler=
    undef_method :f_parent_ruler=
    
    # The column's control, typically a {@link Canvas}, possibly <code>null</code>.
    attr_accessor :f_control
    alias_method :attr_f_control, :f_control
    undef_method :f_control
    alias_method :attr_f_control=, :f_control=
    undef_method :f_control=
    
    # The text viewer that the column is attached to.
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The viewer's text widget.
    attr_accessor :f_widget
    alias_method :attr_f_widget, :f_widget
    undef_method :f_widget
    alias_method :attr_f_widget=, :f_widget=
    undef_method :f_widget=
    
    # The models we operate on.
    # The revision model object.
    attr_accessor :f_revision_info
    alias_method :attr_f_revision_info, :f_revision_info
    undef_method :f_revision_info
    alias_method :attr_f_revision_info=, :f_revision_info=
    undef_method :f_revision_info=
    
    # The line differ.
    attr_accessor :f_line_differ
    alias_method :attr_f_line_differ, :f_line_differ
    undef_method :f_line_differ
    alias_method :attr_f_line_differ=, :f_line_differ=
    undef_method :f_line_differ=
    
    # The annotation model.
    attr_accessor :f_annotation_model
    alias_method :attr_f_annotation_model, :f_annotation_model
    undef_method :f_annotation_model
    alias_method :attr_f_annotation_model=, :f_annotation_model=
    undef_method :f_annotation_model=
    
    # The background color, possibly <code>null</code>.
    attr_accessor :f_background
    alias_method :attr_f_background, :f_background
    undef_method :f_background
    alias_method :attr_f_background=, :f_background=
    undef_method :f_background=
    
    # Cache.
    # The cached list of ranges adapted to quick diff.
    attr_accessor :f_revision_ranges
    alias_method :attr_f_revision_ranges, :f_revision_ranges
    undef_method :f_revision_ranges
    alias_method :attr_f_revision_ranges=, :f_revision_ranges=
    undef_method :f_revision_ranges=
    
    # The annotations created for the overview ruler temporary display.
    attr_accessor :f_annotations
    alias_method :attr_f_annotations, :f_annotations
    undef_method :f_annotations
    alias_method :attr_f_annotations=, :f_annotations=
    undef_method :f_annotations=
    
    # State
    # The current focus line, -1 for none.
    attr_accessor :f_focus_line
    alias_method :attr_f_focus_line, :f_focus_line
    undef_method :f_focus_line
    alias_method :attr_f_focus_line=, :f_focus_line=
    undef_method :f_focus_line=
    
    # The current focus region, <code>null</code> if none.
    attr_accessor :f_focus_range
    alias_method :attr_f_focus_range, :f_focus_range
    undef_method :f_focus_range
    alias_method :attr_f_focus_range=, :f_focus_range=
    undef_method :f_focus_range=
    
    # The current focus revision, <code>null</code> if none.
    attr_accessor :f_focus_revision
    alias_method :attr_f_focus_revision, :f_focus_revision
    undef_method :f_focus_revision
    alias_method :attr_f_focus_revision=, :f_focus_revision=
    undef_method :f_focus_revision=
    
    # The currently selected revision, <code>null</code> if none. The difference between
    # {@link #fFocusRevision} and {@link #fSelectedRevision} may not be obvious: the focus revision
    # is the one focused by the mouse (by hovering over a block of the revision), while the
    # selected revision is sticky, i.e. is not removed when the mouse leaves the ruler.
    # 
    # @since 3.3
    attr_accessor :f_selected_revision
    alias_method :attr_f_selected_revision, :f_selected_revision
    undef_method :f_selected_revision
    alias_method :attr_f_selected_revision=, :f_selected_revision=
    undef_method :f_selected_revision=
    
    # <code>true</code> if the mouse wheel handler is installed, <code>false</code> otherwise.
    attr_accessor :f_wheel_handler_installed
    alias_method :attr_f_wheel_handler_installed, :f_wheel_handler_installed
    undef_method :f_wheel_handler_installed
    alias_method :attr_f_wheel_handler_installed=, :f_wheel_handler_installed=
    undef_method :f_wheel_handler_installed=
    
    # The revision rendering mode.
    attr_accessor :f_rendering_mode
    alias_method :attr_f_rendering_mode, :f_rendering_mode
    undef_method :f_rendering_mode
    alias_method :attr_f_rendering_mode=, :f_rendering_mode=
    undef_method :f_rendering_mode=
    
    # The required with in characters.
    # @since 3.3
    attr_accessor :f_required_width
    alias_method :attr_f_required_width, :f_required_width
    undef_method :f_required_width
    alias_method :attr_f_required_width=, :f_required_width=
    undef_method :f_required_width=
    
    # The width of the revision field in chars to compute {@link #fAuthorInset} from.
    # @since 3.3
    attr_accessor :f_revision_id_chars
    alias_method :attr_f_revision_id_chars, :f_revision_id_chars
    undef_method :f_revision_id_chars
    alias_method :attr_f_revision_id_chars=, :f_revision_id_chars=
    undef_method :f_revision_id_chars=
    
    # <code>true</code> to show revision ids, <code>false</code> otherwise.
    # @since 3.3
    attr_accessor :f_show_revision
    alias_method :attr_f_show_revision, :f_show_revision
    undef_method :f_show_revision
    alias_method :attr_f_show_revision=, :f_show_revision=
    undef_method :f_show_revision=
    
    # <code>true</code> to show the author, <code>false</code> otherwise.
    # @since 3.3
    attr_accessor :f_show_author
    alias_method :attr_f_show_author, :f_show_author
    undef_method :f_show_author
    alias_method :attr_f_show_author=, :f_show_author=
    undef_method :f_show_author=
    
    # The author inset in pixels for when author *and* revision id are shown.
    # @since 3.3
    attr_accessor :f_author_inset
    alias_method :attr_f_author_inset, :f_author_inset
    undef_method :f_author_inset
    alias_method :attr_f_author_inset=, :f_author_inset=
    undef_method :f_author_inset=
    
    # The remembered ruler width (as changing the ruler width triggers recomputation of the colors.
    # @since 3.3
    attr_accessor :f_last_width
    alias_method :attr_f_last_width, :f_last_width
    undef_method :f_last_width
    alias_method :attr_f_last_width=, :f_last_width=
    undef_method :f_last_width=
    
    typesig { [IVerticalRulerColumn, ISharedTextColors] }
    # Creates a new revision painter for a vertical ruler column.
    # 
    # @param column the column that will delegate{@link #paint(GC, ILineRange) painting} to the
    # newly created painter.
    # @param sharedColors a shared colors object to store shaded colors in
    def initialize(column, shared_colors)
      @f_shared_colors = nil
      @f_color_tool = ColorTool.new_local(self)
      @f_mouse_handler = MouseHandler.new_local(self)
      @f_hover = RevisionHover.new_local(self)
      @f_annotation_listener = AnnotationListener.new_local(self)
      @f_revision_selection_provider = RevisionSelectionProvider.new(self)
      @f_revision_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_column = nil
      @f_parent_ruler = nil
      @f_control = nil
      @f_viewer = nil
      @f_widget = nil
      @f_revision_info = nil
      @f_line_differ = nil
      @f_annotation_model = nil
      @f_background = nil
      @f_revision_ranges = nil
      @f_annotations = ArrayList.new
      @f_focus_line = -1
      @f_focus_range = nil
      @f_focus_revision = nil
      @f_selected_revision = nil
      @f_wheel_handler_installed = false
      @f_rendering_mode = IRevisionRulerColumnExtension::AUTHOR_SHADED_BY_AGE
      @f_required_width = -1
      @f_revision_id_chars = 0
      @f_show_revision = false
      @f_show_author = false
      @f_author_inset = 0
      @f_last_width = -1
      Assert.is_legal(!(column).nil?)
      Assert.is_legal(!(shared_colors).nil?)
      @f_column = column
      @f_shared_colors = shared_colors
    end
    
    typesig { [RevisionInformation] }
    # Sets the revision information to be drawn and triggers a redraw.
    # 
    # @param info the revision information to show, <code>null</code> to draw none
    def set_revision_information(info)
      if (!(@f_revision_info).equal?(info))
        @f_required_width = -1
        @f_revision_id_chars = 0
        @f_revision_info = info
        clear_range_cache
        update_focus_range(nil)
        handle_revision_selected(nil)
        @f_color_tool.set_info(info)
        post_redraw
        inform_listeners
      end
    end
    
    typesig { [RenderingMode] }
    # Changes the rendering mode and triggers redrawing if needed.
    # 
    # @param renderingMode the rendering mode
    # @since 3.3
    def set_rendering_mode(rendering_mode)
      Assert.is_legal(!(rendering_mode).nil?)
      if (!(@f_rendering_mode).equal?(rendering_mode))
        @f_rendering_mode = rendering_mode
        @f_color_tool.set_info(@f_revision_info)
        post_redraw
      end
    end
    
    typesig { [Color] }
    # Sets the background color.
    # 
    # @param background the background color, <code>null</code> for the platform's list
    # background
    def set_background(background)
      @f_background = background
    end
    
    typesig { [CompositeRuler] }
    # Sets the parent ruler - the delegating column must call this method as soon as it creates its
    # control.
    # 
    # @param parentRuler the parent ruler
    def set_parent_ruler(parent_ruler)
      @f_parent_ruler = parent_ruler
    end
    
    typesig { [SwtGC, ILineRange] }
    # Delegates the painting of the quick diff colors to this painter. The painter will draw the
    # color boxes onto the passed {@link GC} for all model (document) lines in
    # <code>visibleModelLines</code>.
    # 
    # @param gc the {@link GC} to draw onto
    # @param visibleLines the lines (in document offsets) that are currently (perhaps only
    # partially) visible
    def paint(gc, visible_lines)
      connect_if_needed
      if (!is_connected)
        return
      end
      # compute the horizontal indent of the author for the case that we show revision
      # and author
      if (@f_show_author && @f_show_revision)
        string = CharArray.new(@f_revision_id_chars + 1)
        Arrays.fill(string, Character.new(?9.ord))
        if (string.attr_length > 1)
          string[0] = Character.new(?..ord)
          string[1] = Character.new(?\s.ord)
        end
        @f_author_inset = gc.string_extent(String.new(string)).attr_x
      end
      # recompute colors (show intense colors if ruler is narrow)
      width = get_width
      if (!(width).equal?(@f_last_width))
        @f_color_tool.set_info(@f_revision_info)
        @f_last_width = width
      end
      # draw change regions
      # <RevisionRange>
      ranges = get_ranges(visible_lines)
      it = ranges.iterator
      while it.has_next
        region = it.next_
        paint_range(region, gc)
      end
    end
    
    typesig { [] }
    # Ensures that the column is fully instantiated, i.e. has a control, and that the viewer is
    # visible.
    def connect_if_needed
      if (is_connected || (@f_parent_ruler).nil?)
        return
      end
      @f_viewer = @f_parent_ruler.get_text_viewer
      if ((@f_viewer).nil?)
        return
      end
      @f_widget = @f_viewer.get_text_widget
      if ((@f_widget).nil?)
        return
      end
      @f_control = @f_column.get_control
      if ((@f_control).nil?)
        return
      end
      @f_control.add_mouse_track_listener(@f_mouse_handler)
      @f_control.add_mouse_move_listener(@f_mouse_handler)
      @f_control.add_listener(SWT::MouseUp, @f_mouse_handler)
      @f_control.add_listener(SWT::MouseDown, @f_mouse_handler)
      @f_control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members RevisionPainter
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        # @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
        define_method :widget_disposed do |e|
          handle_dispose
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_revision_selection_provider.install(@f_viewer)
    end
    
    typesig { [] }
    # Returns <code>true</code> if the column is fully connected.
    # 
    # @return <code>true</code> if the column is fully connected, false otherwise
    def is_connected
      return !(@f_control).nil?
    end
    
    typesig { [IAnnotationModel] }
    # Sets the annotation model.
    # 
    # @param model the annotation model, possibly <code>null</code>
    # @see IVerticalRulerColumn#setModel(IAnnotationModel)
    def set_model(model)
      diff_model = nil
      if (model.is_a?(IAnnotationModelExtension))
        diff_model = (model).get_annotation_model(IChangeRulerColumn::QUICK_DIFF_MODEL_ID)
      else
        diff_model = model
      end
      set_differ(diff_model)
      set_annotation_model(model)
    end
    
    typesig { [IAnnotationModel] }
    # Sets the annotation model.
    # 
    # @param model the annotation model.
    def set_annotation_model(model)
      if (!(@f_annotation_model).equal?(model))
        @f_annotation_model = model
      end
    end
    
    typesig { [IAnnotationModel] }
    # Sets the line differ.
    # 
    # @param differ the line differ or <code>null</code> if none
    def set_differ(differ)
      if (differ.is_a?(ILineDiffer) || (differ).nil?)
        if (!(@f_line_differ).equal?(differ))
          if (!(@f_line_differ).nil?)
            (@f_line_differ).remove_annotation_model_listener(@f_annotation_listener)
          end
          @f_line_differ = differ
          if (!(@f_line_differ).nil?)
            (@f_line_differ).add_annotation_model_listener(@f_annotation_listener)
          end
        end
      end
    end
    
    typesig { [] }
    # Disposes of the painter's resources.
    def handle_dispose
      update_focus_line(-1)
      if (!(@f_line_differ).nil?)
        (@f_line_differ).remove_annotation_model_listener(@f_annotation_listener)
        @f_line_differ = nil
      end
      @f_revision_selection_provider.uninstall
    end
    
    typesig { [RevisionRange, SwtGC] }
    # Paints a single change region onto <code>gc</code>.
    # 
    # @param range the range to paint
    # @param gc the {@link GC} to paint on
    def paint_range(range, gc)
      widget_range = model_lines_to_widget_lines(range)
      if ((widget_range).nil?)
        return
      end
      revision = range.get_revision
      draw_armed_focus = (range).equal?(@f_mouse_handler.attr_f_mouse_down_region)
      draw_selection = !draw_armed_focus && (revision).equal?(@f_selected_revision)
      draw_focus = !draw_selection && !draw_armed_focus && (revision).equal?(@f_focus_revision)
      box = compute_box_bounds(widget_range)
      gc.set_background(lookup_color(revision, false))
      if (draw_armed_focus)
        foreground = gc.get_foreground
        focus_color = lookup_color(revision, true)
        gc.set_foreground(focus_color)
        gc.fill_rectangle(box)
        gc.draw_rectangle(box.attr_x, box.attr_y, box.attr_width - 1, box.attr_height - 1) # highlight box
        gc.draw_rectangle(box.attr_x + 1, box.attr_y + 1, box.attr_width - 3, box.attr_height - 3) # inner highlight box
        gc.set_foreground(foreground)
      else
        if (draw_focus || draw_selection)
          foreground = gc.get_foreground
          focus_color = lookup_color(revision, true)
          gc.set_foreground(focus_color)
          gc.fill_rectangle(box)
          gc.draw_rectangle(box.attr_x, box.attr_y, box.attr_width - 1, box.attr_height - 1) # highlight box
          gc.set_foreground(foreground)
        else
          gc.fill_rectangle(box)
        end
      end
      if ((@f_show_author || @f_show_revision))
        indentation = 1
        baseline_bias = get_baseline_bias(gc, widget_range.get_start_line)
        if (@f_show_author && @f_show_revision)
          gc.draw_string(revision.get_id, indentation, box.attr_y + baseline_bias, true)
          gc.draw_string(revision.get_author, @f_author_inset, box.attr_y + baseline_bias, true)
        else
          if (@f_show_author)
            gc.draw_string(revision.get_author, indentation, box.attr_y + baseline_bias, true)
          else
            if (@f_show_revision)
              gc.draw_string(revision.get_id, indentation, box.attr_y + baseline_bias, true)
            end
          end
        end
      end
    end
    
    typesig { [SwtGC, ::Java::Int] }
    # Returns the difference between the baseline of the widget and the
    # baseline as specified by the font for <code>gc</code>. When drawing
    # line numbers, the returned bias should be added to obtain text lined up
    # on the correct base line of the text widget.
    # 
    # @param gc the <code>GC</code> to get the font metrics from
    # @param widgetLine the widget line
    # @return the baseline bias to use when drawing text that is lined up with
    # <code>fCachedTextWidget</code>
    # @since 3.3
    def get_baseline_bias(gc, widget_line)
      # https://bugs.eclipse.org/bugs/show_bug.cgi?id=62951
      # widget line height may be more than the font height used for the
      # line numbers, since font styles (bold, italics...) can have larger
      # font metrics than the simple font used for the numbers.
      offset = @f_widget.get_offset_at_line(widget_line)
      widget_baseline = @f_widget.get_baseline(offset)
      fm = gc.get_font_metrics
      font_baseline = fm.get_ascent + fm.get_leading
      baseline_bias = widget_baseline - font_baseline
      return Math.max(0, baseline_bias)
    end
    
    typesig { [Revision, ::Java::Boolean] }
    # Looks up the color for a certain revision.
    # 
    # @param revision the revision to get the color for
    # @param focus <code>true</code> if it is the focus revision
    # @return the color for the revision
    def lookup_color(revision, focus)
      return @f_shared_colors.get_color(@f_color_tool.get_color(revision, focus))
    end
    
    typesig { [::Java::Int] }
    # Returns the revision range that contains the given line, or
    # <code>null</code> if there is none.
    # 
    # @param line the line of interest
    # @return the corresponding <code>RevisionRange</code> or <code>null</code>
    def get_range(line)
      ranges = get_range_cache
      if (ranges.is_empty || (line).equal?(-1))
        return nil
      end
      it = ranges.iterator
      while it.has_next
        range = it.next_
        if (contains(range, line))
          return range
        end
      end
      # line may be right after the last region
      last_region = ranges.get(ranges.size - 1)
      if ((line).equal?(end_(last_region)))
        return last_region
      end
      return nil
    end
    
    typesig { [ILineRange] }
    # Returns the sublist of all <code>RevisionRange</code>s that intersect with the given lines.
    # 
    # @param lines the model based lines of interest
    # @return elementType: RevisionRange
    def get_ranges(lines)
      ranges = get_range_cache
      # return the interesting subset
      end__ = end_(lines)
      first = -1
      last = -1
      i = 0
      while i < ranges.size
        range = ranges.get(i)
        range_end = end_(range)
        if ((first).equal?(-1) && range_end > lines.get_start_line)
          first = i
        end
        if (!(first).equal?(-1) && range_end > end__)
          last = i
          break
        end
        i += 1
      end
      if ((first).equal?(-1))
        return Collections::EMPTY_LIST
      end
      if ((last).equal?(-1))
        last = ranges.size - 1
      end # bottom index may be one too much
      return ranges.sub_list(first, last + 1)
    end
    
    typesig { [] }
    # Gets all change ranges of the revisions in the revision model and adapts them to the current
    # quick diff information. The list is cached.
    # 
    # @return the list of all change regions, with diff information applied
    def get_range_cache
      if ((@f_revision_ranges).nil?)
        if ((@f_revision_info).nil?)
          @f_revision_ranges = Collections::EMPTY_LIST
        else
          hunks = HunkComputer.compute_hunks(@f_line_differ, @f_viewer.get_document.get_number_of_lines)
          @f_revision_info.apply_diff(hunks)
          @f_revision_ranges = @f_revision_info.get_ranges
          update_overview_annotations
          inform_listeners
        end
      end
      return @f_revision_ranges
    end
    
    typesig { [] }
    # Clears the range cache.
    # 
    # @since 3.3
    def clear_range_cache
      @f_revision_ranges = nil
    end
    
    class_module.module_eval {
      typesig { [ILineRange, ::Java::Int] }
      # Returns <code>true</code> if <code>range</code> contains <code>line</code>. A line is
      # not contained in a range if it is the range's exclusive end line.
      # 
      # @param range the range to check whether it contains <code>line</code>
      # @param line the line the line
      # @return <code>true</code> if <code>range</code> contains <code>line</code>,
      # <code>false</code> if not
      def contains(range, line)
        return range.get_start_line <= line && end_(range) > line
      end
      
      typesig { [ILineRange] }
      # Computes the end index of a line range.
      # 
      # @param range a line range
      # @return the last line (exclusive) of <code>range</code>
      def end_(range)
        return range.get_start_line + range.get_number_of_lines
      end
    }
    
    typesig { [ILineRange] }
    # Returns the visible extent of a document line range in widget lines.
    # 
    # @param range the document line range
    # @return the visible extent of <code>range</code> in widget lines
    def model_lines_to_widget_lines(range)
      widget_start_line = -1
      widget_end_line = -1
      if (@f_viewer.is_a?(ITextViewerExtension5))
        extension = @f_viewer
        model_end_line = end_(range)
        model_line = range.get_start_line
        while model_line < model_end_line
          widget_line = extension.model_line2widget_line(model_line)
          if (!(widget_line).equal?(-1))
            if ((widget_start_line).equal?(-1))
              widget_start_line = widget_line
            end
            widget_end_line = widget_line
          end
          model_line += 1
        end
      else
        region = @f_viewer.get_visible_region
        document = @f_viewer.get_document
        begin
          visible_start_line = document.get_line_of_offset(region.get_offset)
          visible_end_line = document.get_line_of_offset(region.get_offset + region.get_length)
          widget_start_line = Math.max(0, range.get_start_line - visible_start_line)
          widget_end_line = Math.min(visible_end_line, end_(range) - 1)
        rescue BadLocationException => x
          x.print_stack_trace
          # ignore and return null
        end
      end
      if ((widget_start_line).equal?(-1) || (widget_end_line).equal?(-1))
        return nil
      end
      return LineRange.new(widget_start_line, widget_end_line - widget_start_line + 1)
    end
    
    typesig { [] }
    # Returns the revision hover.
    # 
    # @return the revision hover
    def get_hover
      return @f_hover
    end
    
    typesig { [ILineRange] }
    # Computes and returns the bounds of the rectangle corresponding to a widget line range. The
    # rectangle is in pixel coordinates relative to the text widget's
    # {@link StyledText#getClientArea() client area} and has the width of the ruler.
    # 
    # @param range the widget line range
    # @return the box bounds corresponding to <code>range</code>
    def compute_box_bounds(range)
      y1 = @f_widget.get_line_pixel(range.get_start_line)
      y2 = @f_widget.get_line_pixel(range.get_start_line + range.get_number_of_lines)
      return Rectangle.new(0, y1, get_width, y2 - y1 - 1)
    end
    
    typesig { [] }
    # Shows (or hides) the overview annotations.
    def update_overview_annotations
      if ((@f_annotation_model).nil?)
        return
      end
      revision = !(@f_focus_revision).nil? ? @f_focus_revision : @f_selected_revision
      added = nil
      if (!(revision).nil?)
        added = HashMap.new
        it = revision.get_regions.iterator
        while it.has_next
          range = it.next_
          begin
            char_region = to_char_region(range)
            position = Position.new(char_region.get_offset, char_region.get_length)
            annotation = RevisionAnnotation.new(revision.get_id)
            added.put(annotation, position)
          rescue BadLocationException => x
            # ignore - document was changed, show no annotations
          end
        end
      end
      if (@f_annotation_model.is_a?(IAnnotationModelExtension))
        ext = @f_annotation_model
        ext.replace_annotations(@f_annotations.to_array(Array.typed(Annotation).new(@f_annotations.size) { nil }), added)
      else
        it = @f_annotations.iterator
        while it.has_next
          annotation = it.next_
          @f_annotation_model.remove_annotation(annotation)
        end
        if (!(added).nil?)
          it_ = added.entry_set.iterator
          while it_.has_next
            entry = it_.next_
            @f_annotation_model.add_annotation(entry.get_key, entry.get_value)
          end
        end
      end
      @f_annotations.clear
      if (!(added).nil?)
        @f_annotations.add_all(added.key_set)
      end
    end
    
    typesig { [ILineRange] }
    # Returns the character offset based region of a line range.
    # 
    # @param lines the line range to convert
    # @return the character offset range corresponding to <code>range</code>
    # @throws BadLocationException if the line range is not within the document bounds
    def to_char_region(lines)
      document = @f_viewer.get_document
      offset = document.get_line_offset(lines.get_start_line)
      next_line = end_(lines)
      end_offset = 0
      if (next_line >= document.get_number_of_lines)
        end_offset = document.get_length
      else
        end_offset = document.get_line_offset(next_line)
      end
      return Region.new(offset, end_offset - offset)
    end
    
    typesig { [Revision] }
    # Handles the selection of a revision and informs listeners.
    # 
    # @param revision the selected revision, <code>null</code> for none
    def handle_revision_selected(revision)
      @f_selected_revision = revision
      @f_revision_selection_provider.revision_selected(revision)
      update_overview_annotations
      post_redraw
    end
    
    typesig { [String] }
    # Handles the selection of a revision id and informs listeners
    # 
    # @param id the selected revision id
    def handle_revision_selected(id)
      Assert.is_legal(!(id).nil?)
      if ((@f_revision_info).nil?)
        return
      end
      it = @f_revision_info.get_revisions.iterator
      while it.has_next
        revision = it.next_
        if ((id == revision.get_id))
          handle_revision_selected(revision)
          return
        end
      end
      # clear selection if it does not exist
      handle_revision_selected(nil)
    end
    
    typesig { [] }
    # Returns the selection provider.
    # 
    # @return the selection provider
    def get_revision_selection_provider
      return @f_revision_selection_provider
    end
    
    typesig { [::Java::Int] }
    # Updates the focus line with a new line.
    # 
    # @param line the new focus line, -1 for no focus
    def update_focus_line(line)
      if (!(@f_focus_line).equal?(line))
        on_focus_line_changed(@f_focus_line, line)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Handles a changing focus line.
    # 
    # @param previousLine the old focus line (-1 for no focus)
    # @param nextLine the new focus line (-1 for no focus)
    def on_focus_line_changed(previous_line, next_line)
      if (self.attr_debug)
        System.out.println("line: " + RJava.cast_to_string(previous_line) + " > " + RJava.cast_to_string(next_line))
      end # $NON-NLS-1$ //$NON-NLS-2$
      @f_focus_line = next_line
      region = get_range(next_line)
      update_focus_range(region)
    end
    
    typesig { [RevisionRange] }
    # Updates the focus range.
    # 
    # @param range the new focus range, <code>null</code> for no focus
    def update_focus_range(range)
      if (!(range).equal?(@f_focus_range))
        on_focus_range_changed(@f_focus_range, range)
      end
    end
    
    typesig { [RevisionRange, RevisionRange] }
    # Handles a changing focus range.
    # 
    # @param previousRange the old focus range (<code>null</code> for no focus)
    # @param nextRange the new focus range (<code>null</code> for no focus)
    def on_focus_range_changed(previous_range, next_range)
      if (self.attr_debug)
        System.out.println("range: " + RJava.cast_to_string(previous_range) + " > " + RJava.cast_to_string(next_range))
      end # $NON-NLS-1$ //$NON-NLS-2$
      @f_focus_range = next_range
      revision = (next_range).nil? ? nil : next_range.get_revision
      update_focus_revision(revision)
    end
    
    typesig { [Revision] }
    def update_focus_revision(revision)
      if (!(@f_focus_revision).equal?(revision))
        on_focus_revision_changed(@f_focus_revision, revision)
      end
    end
    
    typesig { [Revision, Revision] }
    # Handles a changing focus revision.
    # 
    # @param previousRevision the old focus revision (<code>null</code> for no focus)
    # @param nextRevision the new focus revision (<code>null</code> for no focus)
    def on_focus_revision_changed(previous_revision, next_revision)
      if (self.attr_debug)
        System.out.println("revision: " + RJava.cast_to_string(previous_revision) + " > " + RJava.cast_to_string(next_revision))
      end # $NON-NLS-1$ //$NON-NLS-2$
      @f_focus_revision = next_revision
      uninstall_wheel_handler
      install_wheel_handler
      update_overview_annotations
      redraw # pick up new highlights
    end
    
    typesig { [] }
    # Uninstalls the mouse wheel handler.
    def uninstall_wheel_handler
      @f_control.remove_listener(SWT::MouseWheel, @f_mouse_handler)
      @f_wheel_handler_installed = false
    end
    
    typesig { [] }
    # Installs the mouse wheel handler.
    def install_wheel_handler
      if (!(@f_focus_revision).nil? && !@f_wheel_handler_installed)
        # FIXME: does not work on Windows, because Canvas cannot get focus and therefore does not send out mouse wheel events:
        # https://bugs.eclipse.org/bugs/show_bug.cgi?id=81189
        # see also https://bugs.eclipse.org/bugs/show_bug.cgi?id=75766
        @f_control.add_listener(SWT::MouseWheel, @f_mouse_handler)
        @f_wheel_handler_installed = true
      end
    end
    
    typesig { [Event] }
    # Handles a mouse wheel event.
    # 
    # @param event the mouse wheel event
    def handle_mouse_wheel(event)
      up = event.attr_count > 0
      document_hover_line = @f_focus_line
      next_widget_range = nil
      last = nil
      ranges = @f_focus_revision.get_regions
      if (up)
        it = ranges.iterator
        while it.has_next
          range = it.next_
          widget_range = model_lines_to_widget_lines(range)
          if (contains(range, document_hover_line))
            next_widget_range = last
            break
          end
          if (!(widget_range).nil?)
            last = widget_range
          end
        end
      else
        it = ranges.list_iterator(ranges.size)
        while it.has_previous
          range = it.previous
          widget_range = model_lines_to_widget_lines(range)
          if (contains(range, document_hover_line))
            next_widget_range = last
            break
          end
          if (!(widget_range).nil?)
            last = widget_range
          end
        end
      end
      if ((next_widget_range).nil?)
        return
      end
      widget_current_focus_line = model_lines_to_widget_lines(LineRange.new(document_hover_line, 1)).get_start_line
      widget_next_focus_line = next_widget_range.get_start_line
      new_top_pixel = @f_widget.get_top_pixel + JFaceTextUtil.compute_line_height(@f_widget, widget_current_focus_line, widget_next_focus_line, widget_next_focus_line - widget_current_focus_line)
      @f_widget.set_top_pixel(new_top_pixel)
      if (new_top_pixel < 0)
        cursor_location = @f_widget.get_display.get_cursor_location
        cursor_location.attr_y += new_top_pixel
        @f_widget.get_display.set_cursor_location(cursor_location)
      else
        top_pixel = @f_widget.get_top_pixel
        if (top_pixel < new_top_pixel)
          cursor_location = @f_widget.get_display.get_cursor_location
          cursor_location.attr_y += new_top_pixel - top_pixel
          @f_widget.get_display.set_cursor_location(cursor_location)
        end
      end
      update_focus_line(to_document_line_number(@f_widget.to_control(@f_widget.get_display.get_cursor_location).attr_y))
      immediate_update
    end
    
    typesig { [] }
    # Triggers a redraw in the display thread.
    def post_redraw
      if (is_connected && !@f_control.is_disposed)
        d = @f_control.get_display
        if (!(d).nil?)
          d.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members RevisionPainter
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              redraw
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Translates a y coordinate in the pixel coordinates of the column's control to a document line
    # number.
    # 
    # @param y the y coordinate
    # @return the corresponding document line, -1 for no line
    # @see CompositeRuler#toDocumentLineNumber(int)
    def to_document_line_number(y)
      return @f_parent_ruler.to_document_line_number(y)
    end
    
    typesig { [] }
    # Triggers redrawing of the column.
    def redraw
      @f_column.redraw
    end
    
    typesig { [] }
    # Triggers immediate redrawing of the entire column - use with care.
    def immediate_update
      @f_parent_ruler.immediate_update
    end
    
    typesig { [] }
    # Returns the width of the column.
    # 
    # @return the width of the column
    def get_width
      return @f_column.get_width
    end
    
    typesig { [] }
    # Returns the System background color for list widgets.
    # 
    # @return the System background color for list widgets
    def get_background
      if ((@f_background).nil?)
        return @f_widget.get_display.get_system_color(SWT::COLOR_LIST_BACKGROUND)
      end
      return @f_background
    end
    
    typesig { [IAnnotationHover] }
    # Sets the hover later returned by {@link #getHover()}.
    # 
    # @param hover the hover
    def set_hover(hover)
      # TODO ignore for now - must make revision hover settable from outside
    end
    
    typesig { [::Java::Int] }
    # Returns <code>true</code> if the receiver can provide a hover for a certain document line.
    # 
    # @param activeLine the document line of interest
    # @return <code>true</code> if the receiver can provide a hover
    def has_hover(active_line)
      return @f_viewer.is_a?(ISourceViewer) && !(@f_hover.get_hover_line_range(@f_viewer, active_line)).nil?
    end
    
    typesig { [::Java::Int] }
    # Returns the revision at a certain document offset, or <code>null</code> for none.
    # 
    # @param offset the document offset
    # @return the revision at offset, or <code>null</code> for none
    def get_revision(offset)
      document = @f_viewer.get_document
      line = 0
      begin
        line = document.get_line_of_offset(offset)
      rescue BadLocationException => x
        return nil
      end
      if (!(line).equal?(-1))
        range = get_range(line)
        if (!(range).nil?)
          return range.get_revision
        end
      end
      return nil
    end
    
    typesig { [] }
    # Returns <code>true</code> if a revision model has been set, <code>false</code> otherwise.
    # 
    # @return <code>true</code> if a revision model has been set, <code>false</code> otherwise
    def has_information
      return !(@f_revision_info).nil?
    end
    
    typesig { [] }
    # Returns the width in chars required to display information.
    # 
    # @return the width in chars required to display information
    # @since 3.3
    def get_required_width
      if ((@f_required_width).equal?(-1))
        if (has_information && (@f_show_revision || @f_show_author))
          revision_width = 0
          author_width = 0
          it = @f_revision_info.get_revisions.iterator
          while it.has_next
            revision = it.next_
            revision_width = Math.max(revision_width, revision.get_id.length)
            author_width = Math.max(author_width, revision.get_author.length)
          end
          @f_revision_id_chars = revision_width + 1
          if (@f_show_author && @f_show_revision)
            @f_required_width = revision_width + author_width + 2
          else
            if (@f_show_author)
              @f_required_width = author_width + 1
            else
              @f_required_width = revision_width + 1
            end
          end
        else
          @f_required_width = 0
        end
      end
      return @f_required_width
    end
    
    typesig { [::Java::Boolean] }
    # Enables showing the revision id.
    # 
    # @param show <code>true</code> to show the revision, <code>false</code> to hide it
    def show_revision_id(show)
      if (!(@f_show_revision).equal?(show))
        @f_required_width = -1
        @f_revision_id_chars = 0
        @f_show_revision = show
        post_redraw
      end
    end
    
    typesig { [::Java::Boolean] }
    # Enables showing the revision author.
    # 
    # @param show <code>true</code> to show the author, <code>false</code> to hide it
    def show_revision_author(show)
      if (!(@f_show_author).equal?(show))
        @f_required_width = -1
        @f_revision_id_chars = 0
        @f_show_author = show
        post_redraw
      end
    end
    
    typesig { [IRevisionListener] }
    # Adds a revision listener.
    # 
    # @param listener the listener
    # @since 3.3
    def add_revision_listener(listener)
      @f_revision_listeners.add(listener)
    end
    
    typesig { [IRevisionListener] }
    # Removes a revision listener.
    # 
    # @param listener the listener
    # @since 3.3
    def remove_revision_listener(listener)
      @f_revision_listeners.remove(listener)
    end
    
    typesig { [] }
    # Informs the revision listeners about a change.
    # 
    # @since 3.3
    def inform_listeners
      if ((@f_revision_info).nil? || @f_revision_listeners.is_empty)
        return
      end
      event = RevisionEvent.new(@f_revision_info)
      listeners = @f_revision_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.revision_information_changed(event)
        i += 1
      end
    end
    
    private
    alias_method :initialize__revision_painter, :initialize
  end
  
end
