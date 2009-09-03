require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Eicher (Avaloq Evolution AG) - block selection mode
module Org::Eclipse::Jface::Text::Source
  module SourceViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Stack
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Jface::Internal::Text, :NonDeletingPositionUpdater
      include_const ::Org::Eclipse::Jface::Internal::Text, :StickyHoverManager
      include_const ::Org::Eclipse::Jface::Text, :AbstractHoverInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :BlockTextSelection
      include_const ::Org::Eclipse::Jface::Text, :DocumentRewriteSession
      include_const ::Org::Eclipse::Jface::Text, :DocumentRewriteSessionType
      include_const ::Org::Eclipse::Jface::Text, :IBlockTextSelection
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension4
      include_const ::Org::Eclipse::Jface::Text, :IPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :IRewriteTarget
      include_const ::Org::Eclipse::Jface::Text, :ISlaveDocumentManager
      include_const ::Org::Eclipse::Jface::Text, :ISlaveDocumentManagerExtension
      include_const ::Org::Eclipse::Jface::Text, :ITextSelection
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension2
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextViewer
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistant
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistantExtension4
      include_const ::Org::Eclipse::Jface::Text::Formatter, :FormattingContext
      include_const ::Org::Eclipse::Jface::Text::Formatter, :FormattingContextProperties
      include_const ::Org::Eclipse::Jface::Text::Formatter, :IContentFormatter
      include_const ::Org::Eclipse::Jface::Text::Formatter, :IContentFormatterExtension
      include_const ::Org::Eclipse::Jface::Text::Formatter, :IFormattingContext
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :IHyperlinkDetector
      include_const ::Org::Eclipse::Jface::Text::Information, :IInformationPresenter
      include_const ::Org::Eclipse::Jface::Text::Presentation, :IPresentationReconciler
      include_const ::Org::Eclipse::Jface::Text::Projection, :ChildDocument
      include_const ::Org::Eclipse::Jface::Text::Quickassist, :IQuickAssistAssistant
      include_const ::Org::Eclipse::Jface::Text::Quickassist, :IQuickAssistInvocationContext
      include_const ::Org::Eclipse::Jface::Text::Reconciler, :IReconciler
    }
  end
  
  # SWT based implementation of
  # {@link org.eclipse.jface.text.source.ISourceViewer} and its extension
  # interfaces. The same rules apply as for
  # {@link org.eclipse.jface.text.TextViewer}. A source viewer uses an
  # <code>IVerticalRuler</code> as its annotation presentation area. The
  # vertical ruler is a small strip shown left of the viewer's text widget. A
  # source viewer uses an <code>IOverviewRuler</code> as its presentation area
  # for the annotation overview. The overview ruler is a small strip shown right
  # of the viewer's text widget.
  # <p>
  # Clients are supposed to instantiate a source viewer and subsequently to
  # communicate with it exclusively using the <code>ISourceViewer</code> and
  # its extension interfaces.</p>
  # <p>
  # Clients may subclass this class but should expect some breakage by future releases.</p>
  class SourceViewer < SourceViewerImports.const_get :TextViewer
    include_class_members SourceViewerImports
    overload_protected {
      include ISourceViewer
      include ISourceViewerExtension
      include ISourceViewerExtension2
      include ISourceViewerExtension3
      include ISourceViewerExtension4
    }
    
    class_module.module_eval {
      # Layout of a source viewer. Vertical ruler, text widget, and overview ruler are shown side by side.
      const_set_lazy(:RulerLayout) { Class.new(Layout) do
        extend LocalClass
        include_class_members SourceViewer
        
        # The gap between the text viewer and the vertical ruler.
        attr_accessor :f_gap
        alias_method :attr_f_gap, :f_gap
        undef_method :f_gap
        alias_method :attr_f_gap=, :f_gap=
        undef_method :f_gap=
        
        typesig { [::Java::Int] }
        # Creates a new ruler layout with the given gap between text viewer and vertical ruler.
        # 
        # @param gap the gap between text viewer and vertical ruler
        def initialize(gap)
          @f_gap = 0
          super()
          @f_gap = gap
        end
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        # @see Layout#computeSize(Composite, int, int, boolean)
        def compute_size(composite, w_hint, h_hint, flush_cache)
          children = composite.get_children
          s = children[children.attr_length - 1].compute_size(SWT::DEFAULT, SWT::DEFAULT, flush_cache)
          if (!(self.attr_f_vertical_ruler).nil? && self.attr_f_is_vertical_ruler_visible)
            s.attr_x += self.attr_f_vertical_ruler.get_width + @f_gap
          end
          return s
        end
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        # @see Layout#layout(Composite, boolean)
        def layout(composite, flush_cache)
          cl_area = composite.get_client_area
          trim = get_text_widget.compute_trim(0, 0, 0, 0)
          top_trim = -trim.attr_y
          scrollbar_height = trim.attr_height - top_trim # scrollbar is only under the client area
          x = cl_area.attr_x
          width = cl_area.attr_width
          if (!(self.attr_f_overview_ruler).nil? && self.attr_f_is_overview_ruler_visible)
            overview_ruler_width = self.attr_f_overview_ruler.get_width
            self.attr_f_overview_ruler.get_control.set_bounds(cl_area.attr_x + cl_area.attr_width - overview_ruler_width - 1, cl_area.attr_y + scrollbar_height, overview_ruler_width, cl_area.attr_height - 3 * scrollbar_height)
            self.attr_f_overview_ruler.get_header_control.set_bounds(cl_area.attr_x + cl_area.attr_width - overview_ruler_width - 1, cl_area.attr_y, overview_ruler_width, scrollbar_height)
            width -= overview_ruler_width + @f_gap
          end
          if (!(self.attr_f_vertical_ruler).nil? && self.attr_f_is_vertical_ruler_visible)
            vertical_ruler_width = self.attr_f_vertical_ruler.get_width
            vertical_ruler_control = self.attr_f_vertical_ruler.get_control
            old_width = vertical_ruler_control.get_bounds.attr_width
            vertical_ruler_control.set_bounds(cl_area.attr_x, cl_area.attr_y + top_trim, vertical_ruler_width, cl_area.attr_height - scrollbar_height - top_trim)
            if (flush_cache && !(get_visual_annotation_model).nil? && (old_width).equal?(vertical_ruler_width))
              vertical_ruler_control.redraw
            end
            x += vertical_ruler_width + @f_gap
            width -= vertical_ruler_width + @f_gap
          end
          get_text_widget.set_bounds(x, cl_area.attr_y, width, cl_area.attr_height)
        end
        
        private
        alias_method :initialize__ruler_layout, :initialize
      end }
      
      # The size of the gap between the vertical ruler and the text widget
      # (value <code>2</code>).
      # <p>
      # Note: As of 3.2, the text editor framework is no longer using 2 as
      # gap but 1, see {{@link #GAP_SIZE_1 }.
      # </p>
      const_set_lazy(:GAP_SIZE) { 2 }
      const_attr_reader  :GAP_SIZE
      
      # The size of the gap between the vertical ruler and the text widget
      # (value <code>1</code>).
      # @since 3.2
      const_set_lazy(:GAP_SIZE_1) { 1 }
      const_attr_reader  :GAP_SIZE_1
      
      # Partial name of the position category to manage remembered selections.
      # @since 3.0
      const_set_lazy(:_SELECTION_POSITION_CATEGORY) { "__selection_category" }
      const_attr_reader  :_SELECTION_POSITION_CATEGORY
      
      # $NON-NLS-1$
      # 
      # Key of the model annotation model inside the visual annotation model.
      # @since 3.0
      const_set_lazy(:MODEL_ANNOTATION_MODEL) { Object.new }
      const_attr_reader  :MODEL_ANNOTATION_MODEL
    }
    
    # The viewer's content assistant
    attr_accessor :f_content_assistant
    alias_method :attr_f_content_assistant, :f_content_assistant
    undef_method :f_content_assistant
    alias_method :attr_f_content_assistant=, :f_content_assistant=
    undef_method :f_content_assistant=
    
    # The viewer's facade to its content assistant.
    # @since 3.4
    attr_accessor :f_content_assistant_facade
    alias_method :attr_f_content_assistant_facade, :f_content_assistant_facade
    undef_method :f_content_assistant_facade
    alias_method :attr_f_content_assistant_facade=, :f_content_assistant_facade=
    undef_method :f_content_assistant_facade=
    
    # Flag indicating whether the viewer's content assistant is installed.
    # @since 2.0
    attr_accessor :f_content_assistant_installed
    alias_method :attr_f_content_assistant_installed, :f_content_assistant_installed
    undef_method :f_content_assistant_installed
    alias_method :attr_f_content_assistant_installed=, :f_content_assistant_installed=
    undef_method :f_content_assistant_installed=
    
    # This viewer's quick assist assistant.
    # @since 3.2
    attr_accessor :f_quick_assist_assistant
    alias_method :attr_f_quick_assist_assistant, :f_quick_assist_assistant
    undef_method :f_quick_assist_assistant
    alias_method :attr_f_quick_assist_assistant=, :f_quick_assist_assistant=
    undef_method :f_quick_assist_assistant=
    
    # Flag indicating whether this viewer's quick assist assistant is installed.
    # @since 3.2
    attr_accessor :f_quick_assist_assistant_installed
    alias_method :attr_f_quick_assist_assistant_installed, :f_quick_assist_assistant_installed
    undef_method :f_quick_assist_assistant_installed
    alias_method :attr_f_quick_assist_assistant_installed=, :f_quick_assist_assistant_installed=
    undef_method :f_quick_assist_assistant_installed=
    
    # The viewer's content formatter
    attr_accessor :f_content_formatter
    alias_method :attr_f_content_formatter, :f_content_formatter
    undef_method :f_content_formatter
    alias_method :attr_f_content_formatter=, :f_content_formatter=
    undef_method :f_content_formatter=
    
    # The viewer's model reconciler
    attr_accessor :f_reconciler
    alias_method :attr_f_reconciler, :f_reconciler
    undef_method :f_reconciler
    alias_method :attr_f_reconciler=, :f_reconciler=
    undef_method :f_reconciler=
    
    # The viewer's presentation reconciler
    attr_accessor :f_presentation_reconciler
    alias_method :attr_f_presentation_reconciler, :f_presentation_reconciler
    undef_method :f_presentation_reconciler
    alias_method :attr_f_presentation_reconciler=, :f_presentation_reconciler=
    undef_method :f_presentation_reconciler=
    
    # The viewer's annotation hover
    attr_accessor :f_annotation_hover
    alias_method :attr_f_annotation_hover, :f_annotation_hover
    undef_method :f_annotation_hover
    alias_method :attr_f_annotation_hover=, :f_annotation_hover=
    undef_method :f_annotation_hover=
    
    # Stack of saved selections in the underlying document
    # @since 3.0
    attr_accessor :f_selections
    alias_method :attr_f_selections, :f_selections
    undef_method :f_selections
    alias_method :attr_f_selections=, :f_selections=
    undef_method :f_selections=
    
    # Position updater for saved selections
    # @since 3.0
    attr_accessor :f_selection_updater
    alias_method :attr_f_selection_updater, :f_selection_updater
    undef_method :f_selection_updater
    alias_method :attr_f_selection_updater=, :f_selection_updater=
    undef_method :f_selection_updater=
    
    # Position category used by the selection updater
    # @since 3.0
    attr_accessor :f_selection_category
    alias_method :attr_f_selection_category, :f_selection_category
    undef_method :f_selection_category
    alias_method :attr_f_selection_category=, :f_selection_category=
    undef_method :f_selection_category=
    
    # The viewer's overview ruler annotation hover
    # @since 3.0
    attr_accessor :f_overview_ruler_annotation_hover
    alias_method :attr_f_overview_ruler_annotation_hover, :f_overview_ruler_annotation_hover
    undef_method :f_overview_ruler_annotation_hover
    alias_method :attr_f_overview_ruler_annotation_hover=, :f_overview_ruler_annotation_hover=
    undef_method :f_overview_ruler_annotation_hover=
    
    # The viewer's information presenter
    # @since 2.0
    attr_accessor :f_information_presenter
    alias_method :attr_f_information_presenter, :f_information_presenter
    undef_method :f_information_presenter
    alias_method :attr_f_information_presenter=, :f_information_presenter=
    undef_method :f_information_presenter=
    
    # Visual vertical ruler
    attr_accessor :f_vertical_ruler
    alias_method :attr_f_vertical_ruler, :f_vertical_ruler
    undef_method :f_vertical_ruler
    alias_method :attr_f_vertical_ruler=, :f_vertical_ruler=
    undef_method :f_vertical_ruler=
    
    # Visibility of vertical ruler
    attr_accessor :f_is_vertical_ruler_visible
    alias_method :attr_f_is_vertical_ruler_visible, :f_is_vertical_ruler_visible
    undef_method :f_is_vertical_ruler_visible
    alias_method :attr_f_is_vertical_ruler_visible=, :f_is_vertical_ruler_visible=
    undef_method :f_is_vertical_ruler_visible=
    
    # The SWT widget used when supporting a vertical ruler
    attr_accessor :f_composite
    alias_method :attr_f_composite, :f_composite
    undef_method :f_composite
    alias_method :attr_f_composite=, :f_composite=
    undef_method :f_composite=
    
    # The vertical ruler's annotation model
    attr_accessor :f_visual_annotation_model
    alias_method :attr_f_visual_annotation_model, :f_visual_annotation_model
    undef_method :f_visual_annotation_model
    alias_method :attr_f_visual_annotation_model=, :f_visual_annotation_model=
    undef_method :f_visual_annotation_model=
    
    # The viewer's range indicator to be shown in the vertical ruler
    attr_accessor :f_range_indicator
    alias_method :attr_f_range_indicator, :f_range_indicator
    undef_method :f_range_indicator
    alias_method :attr_f_range_indicator=, :f_range_indicator=
    undef_method :f_range_indicator=
    
    # The viewer's vertical ruler hovering controller
    attr_accessor :f_vertical_ruler_hovering_controller
    alias_method :attr_f_vertical_ruler_hovering_controller, :f_vertical_ruler_hovering_controller
    undef_method :f_vertical_ruler_hovering_controller
    alias_method :attr_f_vertical_ruler_hovering_controller=, :f_vertical_ruler_hovering_controller=
    undef_method :f_vertical_ruler_hovering_controller=
    
    # The viewer's overview ruler hovering controller
    # @since 2.1
    attr_accessor :f_overview_ruler_hovering_controller
    alias_method :attr_f_overview_ruler_hovering_controller, :f_overview_ruler_hovering_controller
    undef_method :f_overview_ruler_hovering_controller
    alias_method :attr_f_overview_ruler_hovering_controller=, :f_overview_ruler_hovering_controller=
    undef_method :f_overview_ruler_hovering_controller=
    
    # The overview ruler.
    # @since 2.1
    attr_accessor :f_overview_ruler
    alias_method :attr_f_overview_ruler, :f_overview_ruler
    undef_method :f_overview_ruler
    alias_method :attr_f_overview_ruler=, :f_overview_ruler=
    undef_method :f_overview_ruler=
    
    # The visibility of the overview ruler
    # @since 2.1
    attr_accessor :f_is_overview_ruler_visible
    alias_method :attr_f_is_overview_ruler_visible, :f_is_overview_ruler_visible
    undef_method :f_is_overview_ruler_visible
    alias_method :attr_f_is_overview_ruler_visible=, :f_is_overview_ruler_visible=
    undef_method :f_is_overview_ruler_visible=
    
    typesig { [Composite, IVerticalRuler, ::Java::Int] }
    # Constructs a new source viewer. The vertical ruler is initially visible.
    # The viewer has not yet been initialized with a source viewer configuration.
    # 
    # @param parent the parent of the viewer's control
    # @param ruler the vertical ruler used by this source viewer
    # @param styles the SWT style bits for the viewer's control,
    # <em>if <code>SWT.WRAP</code> is set then a custom document adapter needs to be provided, see {@link #createDocumentAdapter()}
    def initialize(parent, ruler, styles)
      initialize__source_viewer(parent, ruler, nil, false, styles)
    end
    
    typesig { [Composite, IVerticalRuler, IOverviewRuler, ::Java::Boolean, ::Java::Int] }
    # Constructs a new source viewer. The vertical ruler is initially visible.
    # The overview ruler visibility is controlled by the value of <code>showAnnotationsOverview</code>.
    # The viewer has not yet been initialized with a source viewer configuration.
    # 
    # @param parent the parent of the viewer's control
    # @param verticalRuler the vertical ruler used by this source viewer
    # @param overviewRuler the overview ruler
    # @param showAnnotationsOverview <code>true</code> if the overview ruler should be visible, <code>false</code> otherwise
    # @param styles the SWT style bits for the viewer's control,
    # <em>if <code>SWT.WRAP</code> is set then a custom document adapter needs to be provided, see {@link #createDocumentAdapter()}
    # @since 2.1
    def initialize(parent, vertical_ruler, overview_ruler, show_annotations_overview, styles)
      @f_content_assistant = nil
      @f_content_assistant_facade = nil
      @f_content_assistant_installed = false
      @f_quick_assist_assistant = nil
      @f_quick_assist_assistant_installed = false
      @f_content_formatter = nil
      @f_reconciler = nil
      @f_presentation_reconciler = nil
      @f_annotation_hover = nil
      @f_selections = nil
      @f_selection_updater = nil
      @f_selection_category = nil
      @f_overview_ruler_annotation_hover = nil
      @f_information_presenter = nil
      @f_vertical_ruler = nil
      @f_is_vertical_ruler_visible = false
      @f_composite = nil
      @f_visual_annotation_model = nil
      @f_range_indicator = nil
      @f_vertical_ruler_hovering_controller = nil
      @f_overview_ruler_hovering_controller = nil
      @f_overview_ruler = nil
      @f_is_overview_ruler_visible = false
      super()
      @f_selections = Stack.new
      @f_selection_updater = nil
      @f_vertical_ruler = vertical_ruler
      @f_is_vertical_ruler_visible = (!(vertical_ruler).nil?)
      @f_overview_ruler = overview_ruler
      @f_is_overview_ruler_visible = (show_annotations_overview && !(overview_ruler).nil?)
      create_control(parent, styles)
    end
    
    typesig { [Composite, ::Java::Int] }
    # @see TextViewer#createControl(Composite, int)
    def create_control(parent, styles)
      if (!(@f_vertical_ruler).nil? || !(@f_overview_ruler).nil?)
        styles = (styles & ~SWT::BORDER)
        @f_composite = Canvas.new(parent, SWT::NONE)
        @f_composite.set_layout(create_layout)
        parent = @f_composite
      end
      super(parent, styles)
      if (!(@f_vertical_ruler).nil?)
        @f_vertical_ruler.create_control(@f_composite, self)
      end
      if (!(@f_overview_ruler).nil?)
        @f_overview_ruler.create_control(@f_composite, self)
      end
    end
    
    typesig { [] }
    # Creates the layout used for this viewer.
    # Subclasses may override this method.
    # 
    # @return the layout used for this viewer
    # @since 3.0
    def create_layout
      return RulerLayout.new_local(self, GAP_SIZE_1)
    end
    
    typesig { [] }
    # @see TextViewer#getControl()
    def get_control
      if (!(@f_composite).nil?)
        return @f_composite
      end
      return super
    end
    
    typesig { [IAnnotationHover] }
    # @see ISourceViewer#setAnnotationHover(IAnnotationHover)
    def set_annotation_hover(annotation_hover)
      @f_annotation_hover = annotation_hover
    end
    
    typesig { [IAnnotationHover] }
    # Sets the overview ruler's annotation hover of this source viewer.
    # The annotation hover provides the information to be displayed in a hover
    # popup window if requested over the overview rulers area. The annotation
    # hover is assumed to be line oriented.
    # 
    # @param annotationHover the hover to be used, <code>null</code> is a valid argument
    # @since 3.0
    def set_overview_ruler_annotation_hover(annotation_hover)
      @f_overview_ruler_annotation_hover = annotation_hover
    end
    
    typesig { [SourceViewerConfiguration] }
    # @see ISourceViewer#configure(SourceViewerConfiguration)
    def configure(configuration)
      if ((get_text_widget).nil?)
        return
      end
      set_document_partitioning(configuration.get_configured_document_partitioning(self))
      # install content type independent plug-ins
      @f_presentation_reconciler = configuration.get_presentation_reconciler(self)
      if (!(@f_presentation_reconciler).nil?)
        @f_presentation_reconciler.install(self)
      end
      @f_reconciler = configuration.get_reconciler(self)
      if (!(@f_reconciler).nil?)
        @f_reconciler.install(self)
      end
      @f_content_assistant = configuration.get_content_assistant(self)
      if (!(@f_content_assistant).nil?)
        @f_content_assistant.install(self)
        if (@f_content_assistant.is_a?(IContentAssistantExtension4))
          @f_content_assistant_facade = ContentAssistantFacade.new(@f_content_assistant)
        end
        @f_content_assistant_installed = true
      end
      @f_quick_assist_assistant = configuration.get_quick_assist_assistant(self)
      if (!(@f_quick_assist_assistant).nil?)
        @f_quick_assist_assistant.install(self)
        @f_quick_assist_assistant_installed = true
      end
      @f_content_formatter = configuration.get_content_formatter(self)
      @f_information_presenter = configuration.get_information_presenter(self)
      if (!(@f_information_presenter).nil?)
        @f_information_presenter.install(self)
      end
      set_undo_manager(configuration.get_undo_manager(self))
      get_text_widget.set_tabs(configuration.get_tab_width(self))
      set_annotation_hover(configuration.get_annotation_hover(self))
      set_overview_ruler_annotation_hover(configuration.get_overview_ruler_annotation_hover(self))
      set_hover_control_creator(configuration.get_information_control_creator(self))
      set_hyperlink_presenter(configuration.get_hyperlink_presenter(self))
      hyperlink_detectors = configuration.get_hyperlink_detectors(self)
      event_state_mask = configuration.get_hyperlink_state_mask(self)
      set_hyperlink_detectors(hyperlink_detectors, event_state_mask)
      # install content type specific plug-ins
      types = configuration.get_configured_content_types(self)
      i = 0
      while i < types.attr_length
        t = types[i]
        set_auto_edit_strategies(configuration.get_auto_edit_strategies(self, t), t)
        set_text_double_click_strategy(configuration.get_double_click_strategy(self, t), t)
        state_masks = configuration.get_configured_text_hover_state_masks(self, t)
        if (!(state_masks).nil?)
          j = 0
          while j < state_masks.attr_length
            state_mask = state_masks[j]
            set_text_hover(configuration.get_text_hover(self, t, state_mask), t, state_mask)
            j += 1
          end
        else
          set_text_hover(configuration.get_text_hover(self, t), t, ITextViewerExtension2::DEFAULT_HOVER_STATE_MASK)
        end
        prefixes = configuration.get_indent_prefixes(self, t)
        if (!(prefixes).nil? && prefixes.attr_length > 0)
          set_indent_prefixes(prefixes, t)
        end
        prefixes = configuration.get_default_prefixes(self, t)
        if (!(prefixes).nil? && prefixes.attr_length > 0)
          set_default_prefixes(prefixes, t)
        end
        i += 1
      end
      activate_plugins
    end
    
    typesig { [] }
    # After this method has been executed the caller knows that any installed annotation hover has been installed.
    def ensure_annotation_hover_manager_installed
      if (!(@f_vertical_ruler).nil? && (!(@f_annotation_hover).nil? || !is_vertical_ruler_only_showing_annotations) && (@f_vertical_ruler_hovering_controller).nil? && !(self.attr_f_hover_control_creator).nil?)
        @f_vertical_ruler_hovering_controller = AnnotationBarHoverManager.new(@f_vertical_ruler, self, @f_annotation_hover, self.attr_f_hover_control_creator)
        @f_vertical_ruler_hovering_controller.install(@f_vertical_ruler.get_control)
        @f_vertical_ruler_hovering_controller.get_internal_accessor.set_information_control_replacer(StickyHoverManager.new(self))
      end
    end
    
    typesig { [] }
    # After this method has been executed the caller knows that any installed overview hover has been installed.
    def ensure_overview_hover_manager_installed
      if (!(@f_overview_ruler).nil? && !(@f_overview_ruler_annotation_hover).nil? && (@f_overview_ruler_hovering_controller).nil? && !(self.attr_f_hover_control_creator).nil?)
        @f_overview_ruler_hovering_controller = OverviewRulerHoverManager.new(@f_overview_ruler, self, @f_overview_ruler_annotation_hover, self.attr_f_hover_control_creator)
        @f_overview_ruler_hovering_controller.install(@f_overview_ruler.get_control)
        @f_overview_ruler_hovering_controller.get_internal_accessor.set_information_control_replacer(StickyHoverManager.new(self))
      end
    end
    
    typesig { [EnrichMode] }
    # @see org.eclipse.jface.text.TextViewer#setHoverEnrichMode(org.eclipse.jface.text.ITextViewerExtension8.EnrichMode)
    # @since 3.4
    def set_hover_enrich_mode(mode)
      super(mode)
      if (!(@f_vertical_ruler_hovering_controller).nil?)
        @f_vertical_ruler_hovering_controller.get_internal_accessor.set_hover_enrich_mode(mode)
      end
      if (!(@f_overview_ruler_hovering_controller).nil?)
        @f_overview_ruler_hovering_controller.get_internal_accessor.set_hover_enrich_mode(mode)
      end
    end
    
    typesig { [] }
    # @see TextViewer#activatePlugins()
    def activate_plugins
      ensure_annotation_hover_manager_installed
      ensure_overview_hover_manager_installed
      super
    end
    
    typesig { [IDocument] }
    # @see ISourceViewer#setDocument(IDocument, IAnnotationModel)
    def set_document(document)
      set_document(document, nil, -1, -1)
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # @see ISourceViewer#setDocument(IDocument, IAnnotationModel, int, int)
    def set_document(document, visible_region_offset, visible_region_length)
      set_document(document, nil, visible_region_offset, visible_region_length)
    end
    
    typesig { [IDocument, IAnnotationModel] }
    # @see ISourceViewer#setDocument(IDocument, IAnnotationModel)
    def set_document(document, annotation_model)
      set_document(document, annotation_model, -1, -1)
    end
    
    typesig { [IAnnotationModel] }
    # Creates the visual annotation model on top of the given annotation model.
    # 
    # @param annotationModel the wrapped annotation model
    # @return the visual annotation model on top of the given annotation model
    # @since 3.0
    def create_visual_annotation_model(annotation_model)
      model = AnnotationModel.new
      model.add_annotation_model(MODEL_ANNOTATION_MODEL, annotation_model)
      return model
    end
    
    typesig { [] }
    # Disposes the visual annotation model.
    # 
    # @since 3.1
    def dispose_visual_annotation_model
      if (!(@f_visual_annotation_model).nil?)
        if (!(get_document).nil?)
          @f_visual_annotation_model.disconnect(get_document)
        end
        if (@f_visual_annotation_model.is_a?(IAnnotationModelExtension))
          (@f_visual_annotation_model).remove_annotation_model(MODEL_ANNOTATION_MODEL)
        end
        @f_visual_annotation_model = nil
      end
    end
    
    typesig { [IDocument, IAnnotationModel, ::Java::Int, ::Java::Int] }
    # @see ISourceViewer#setDocument(IDocument, IAnnotationModel, int, int)
    def set_document(document, annotation_model, model_range_offset, model_range_length)
      dispose_visual_annotation_model
      if (!(annotation_model).nil? && !(document).nil?)
        @f_visual_annotation_model = create_visual_annotation_model(annotation_model)
        @f_visual_annotation_model.connect(document)
      end
      if ((model_range_offset).equal?(-1) && (model_range_length).equal?(-1))
        super(document)
      else
        super(document, model_range_offset, model_range_length)
      end
      if (!(@f_vertical_ruler).nil?)
        @f_vertical_ruler.set_model(@f_visual_annotation_model)
      end
      if (!(@f_overview_ruler).nil?)
        @f_overview_ruler.set_model(@f_visual_annotation_model)
      end
    end
    
    typesig { [] }
    # @see ISourceViewer#getAnnotationModel()
    def get_annotation_model
      if (@f_visual_annotation_model.is_a?(IAnnotationModelExtension))
        extension = @f_visual_annotation_model
        return extension.get_annotation_model(MODEL_ANNOTATION_MODEL)
      end
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ISourceViewerExtension3#getQuickAssistAssistant()
    # @since 3.2
    def get_quick_assist_assistant
      return @f_quick_assist_assistant
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def get_content_assistant_facade
      return @f_content_assistant_facade
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ISourceViewerExtension3#getQuickAssistInvocationContext()
    # @since 3.2
    def get_quick_assist_invocation_context
      selection = get_selected_range
      return TextInvocationContext.new(self, selection.attr_x, selection.attr_x)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ISourceViewerExtension2#getVisualAnnotationModel()
    # @since 3.0
    def get_visual_annotation_model
      return @f_visual_annotation_model
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ISourceViewerExtension2#unconfigure()
    # @since 3.0
    def unconfigure
      clear_remembered_selection
      if (!(@f_presentation_reconciler).nil?)
        @f_presentation_reconciler.uninstall
        @f_presentation_reconciler = nil
      end
      if (!(@f_reconciler).nil?)
        @f_reconciler.uninstall
        @f_reconciler = nil
      end
      if (!(@f_content_assistant).nil?)
        @f_content_assistant.uninstall
        @f_content_assistant_installed = false
        @f_content_assistant = nil
        if (!(@f_content_assistant_facade).nil?)
          @f_content_assistant_facade = nil
        end
      end
      if (!(@f_quick_assist_assistant).nil?)
        @f_quick_assist_assistant.uninstall
        @f_quick_assist_assistant_installed = false
        @f_quick_assist_assistant = nil
      end
      @f_content_formatter = nil
      if (!(@f_information_presenter).nil?)
        @f_information_presenter.uninstall
        @f_information_presenter = nil
      end
      self.attr_f_auto_indent_strategies = nil
      self.attr_f_double_click_strategies = nil
      self.attr_f_text_hovers = nil
      self.attr_f_indent_chars = nil
      self.attr_f_default_prefix_chars = nil
      if (!(@f_vertical_ruler_hovering_controller).nil?)
        @f_vertical_ruler_hovering_controller.dispose
        @f_vertical_ruler_hovering_controller = nil
      end
      if (!(@f_overview_ruler_hovering_controller).nil?)
        @f_overview_ruler_hovering_controller.dispose
        @f_overview_ruler_hovering_controller = nil
      end
      if (!(self.attr_f_undo_manager).nil?)
        self.attr_f_undo_manager.disconnect
        self.attr_f_undo_manager = nil
      end
      set_hyperlink_detectors(nil, SWT::NONE)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextViewer#handleDispose()
    def handle_dispose
      unconfigure
      dispose_visual_annotation_model
      @f_vertical_ruler = nil
      @f_overview_ruler = nil
      # http://dev.eclipse.org/bugs/show_bug.cgi?id=15300
      @f_composite = nil
      super
    end
    
    typesig { [::Java::Int] }
    # @see ITextOperationTarget#canDoOperation(int)
    def can_do_operation(operation)
      if ((get_text_widget).nil? || (!redraws && !(operation).equal?(FORMAT)))
        return false
      end
      if ((operation).equal?(CONTENTASSIST_PROPOSALS))
        return !(@f_content_assistant).nil? && @f_content_assistant_installed && is_editable
      end
      if ((operation).equal?(CONTENTASSIST_CONTEXT_INFORMATION))
        return !(@f_content_assistant).nil? && @f_content_assistant_installed && is_editable
      end
      if ((operation).equal?(QUICK_ASSIST))
        return !(@f_quick_assist_assistant).nil? && @f_quick_assist_assistant_installed && is_editable
      end
      if ((operation).equal?(INFORMATION))
        return !(@f_information_presenter).nil?
      end
      if ((operation).equal?(FORMAT))
        return !(@f_content_formatter).nil? && is_editable
      end
      return super(operation)
    end
    
    typesig { [] }
    # Creates a new formatting context for a format operation.
    # <p>
    # After the use of the context, clients are required to call
    # its <code>dispose</code> method.
    # 
    # @return The new formatting context
    # @since 3.0
    def create_formatting_context
      return FormattingContext.new
    end
    
    class_module.module_eval {
      # Position storing block selection information in order to maintain a column selection.
      # 
      # @since 3.5
      const_set_lazy(:ColumnPosition) { Class.new(Position) do
        include_class_members SourceViewer
        
        attr_accessor :f_start_column
        alias_method :attr_f_start_column, :f_start_column
        undef_method :f_start_column
        alias_method :attr_f_start_column=, :f_start_column=
        undef_method :f_start_column=
        
        attr_accessor :f_end_column
        alias_method :attr_f_end_column, :f_end_column
        undef_method :f_end_column
        alias_method :attr_f_end_column=, :f_end_column=
        undef_method :f_end_column=
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(offset, length, start_column, end_column)
          @f_start_column = 0
          @f_end_column = 0
          super(offset, length)
          @f_start_column = start_column
          @f_end_column = end_column
        end
        
        private
        alias_method :initialize__column_position, :initialize
      end }
    }
    
    typesig { [] }
    # Remembers and returns the current selection. The saved selection can be restored
    # by calling <code>restoreSelection()</code>.
    # 
    # @return the current selection
    # @see org.eclipse.jface.text.ITextViewer#getSelectedRange()
    # @since 3.0
    def remember_selection
      selection = get_selection
      document = get_document
      if (@f_selections.is_empty)
        @f_selection_category = _SELECTION_POSITION_CATEGORY + RJava.cast_to_string(hash_code)
        @f_selection_updater = NonDeletingPositionUpdater.new(@f_selection_category)
        document.add_position_category(@f_selection_category)
        document.add_position_updater(@f_selection_updater)
      end
      begin
        position = nil
        if (selection.is_a?(IBlockTextSelection))
          position = ColumnPosition.new(selection.get_offset, selection.get_length, (selection).get_start_column, (selection).get_end_column)
        else
          position = Position.new(selection.get_offset, selection.get_length)
        end
        document.add_position(@f_selection_category, position)
        @f_selections.push(position)
      rescue BadLocationException => exception
        # Should not happen
      rescue BadPositionCategoryException => exception
        # Should not happen
      end
      return Point.new(selection.get_offset, selection.get_length)
    end
    
    typesig { [] }
    # Restores a previously saved selection in the document.
    # <p>
    # If no selection was previously saved, nothing happens.
    # 
    # @since 3.0
    def restore_selection
      if (!@f_selections.is_empty)
        document = get_document
        position = @f_selections.pop
        begin
          document.remove_position(@f_selection_category, position)
          current_selection = get_selected_range
          if ((current_selection).nil? || !(current_selection.attr_x).equal?(position.get_offset) || !(current_selection.attr_y).equal?(position.get_length))
            if (position.is_a?(ColumnPosition) && get_text_widget.get_block_selection)
              set_selection(BlockTextSelection.new(document, document.get_line_of_offset(position.get_offset), (position).attr_f_start_column, document.get_line_of_offset(position.get_offset + position.get_length), (position).attr_f_end_column, get_text_widget.get_tabs))
            else
              set_selected_range(position.get_offset, position.get_length)
            end
          end
          if (@f_selections.is_empty)
            clear_remembered_selection
          end
        rescue BadPositionCategoryException => exception
          # Should not happen
        rescue BadLocationException => x
          # Should not happen
        end
      end
    end
    
    typesig { [] }
    def clear_remembered_selection
      if (!@f_selections.is_empty)
        @f_selections.clear
      end
      document = get_document
      if (!(document).nil? && !(@f_selection_updater).nil?)
        document.remove_position_updater(@f_selection_updater)
        begin
          document.remove_position_category(@f_selection_category)
        rescue BadPositionCategoryException => e
          # ignore
        end
      end
      @f_selection_updater = nil
      @f_selection_category = RJava.cast_to_string(nil)
    end
    
    typesig { [::Java::Int] }
    # @see ITextOperationTarget#doOperation(int)
    def do_operation(operation)
      if ((get_text_widget).nil? || (!redraws && !(operation).equal?(FORMAT)))
        return
      end
      case (operation)
      when CONTENTASSIST_PROPOSALS
        @f_content_assistant.show_possible_completions
        return
      when CONTENTASSIST_CONTEXT_INFORMATION
        @f_content_assistant.show_context_information
        return
      when QUICK_ASSIST
        # FIXME: must find a way to post to the status line
        # String msg=
        @f_quick_assist_assistant.show_possible_quick_assists
        # setStatusLineErrorMessage(msg);
        return
      when INFORMATION
        @f_information_presenter.show_information
        return
      when FORMAT
        selection = remember_selection
        target = get_rewrite_target
        document = get_document
        context = nil
        rewrite_session = nil
        if (document.is_a?(IDocumentExtension4))
          extension = document
          type = ((selection.attr_y).equal?(0) && document.get_length > 1000) || selection.attr_y > 1000 ? DocumentRewriteSessionType::SEQUENTIAL : DocumentRewriteSessionType::UNRESTRICTED_SMALL
          rewrite_session = extension.start_rewrite_session(type)
        else
          set_redraw(false)
          target.begin_compound_change
        end
        begin
          remembered_contents = document.get
          begin
            if (@f_content_formatter.is_a?(IContentFormatterExtension))
              extension = @f_content_formatter
              context = create_formatting_context
              if ((selection.attr_y).equal?(0))
                context.set_property(FormattingContextProperties::CONTEXT_DOCUMENT, Boolean::TRUE)
              else
                context.set_property(FormattingContextProperties::CONTEXT_DOCUMENT, Boolean::FALSE)
                context.set_property(FormattingContextProperties::CONTEXT_REGION, Region.new(selection.attr_x, selection.attr_y))
              end
              extension.format(document, context)
            else
              r = nil
              if ((selection.attr_y).equal?(0))
                coverage = get_model_coverage
                r = (coverage).nil? ? Region.new(0, 0) : coverage
              else
                r = Region.new(selection.attr_x, selection.attr_y)
              end
              @f_content_formatter.format(document, r)
            end
            update_slave_documents(document)
          rescue RuntimeException => x
            # fire wall for https://bugs.eclipse.org/bugs/show_bug.cgi?id=47472
            # if something went wrong we undo the changes we just did
            # TODO to be removed after 3.0 M8
            document.set(remembered_contents)
            raise x
          end
        ensure
          if (document.is_a?(IDocumentExtension4))
            extension = document
            extension.stop_rewrite_session(rewrite_session)
          else
            target.end_compound_change
            set_redraw(true)
          end
          restore_selection
          if (!(context).nil?)
            context.dispose
          end
        end
        return
      else
        super(operation)
      end
    end
    
    typesig { [IDocument] }
    # Updates all slave documents of the given document. This default implementation calls <code>updateSlaveDocument</code>
    # for their current visible range. Subclasses may reimplement.
    # 
    # @param masterDocument the master document
    # @since 3.0
    def update_slave_documents(master_document)
      manager = get_slave_document_manager
      if (manager.is_a?(ISlaveDocumentManagerExtension))
        extension = manager
        slaves = extension.get_slave_documents(master_document)
        if (!(slaves).nil?)
          i = 0
          while i < slaves.attr_length
            if (slaves[i].is_a?(ChildDocument))
              child = slaves[i]
              p = child.get_parent_document_range
              begin
                if (!update_slave_document(child, p.get_offset, p.get_length))
                  child.repair_line_information
                end
              rescue BadLocationException => e
                # ignore
              end
            end
            i += 1
          end
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # @see ITextOperationTargetExtension#enableOperation(int, boolean)
    # @since 2.0
    def enable_operation(operation, enable)
      case (operation)
      when CONTENTASSIST_PROPOSALS, CONTENTASSIST_CONTEXT_INFORMATION
        if ((@f_content_assistant).nil?)
          return
        end
        if (enable)
          if (!@f_content_assistant_installed)
            @f_content_assistant.install(self)
            @f_content_assistant_installed = true
          end
        else
          if (@f_content_assistant_installed)
            @f_content_assistant.uninstall
            @f_content_assistant_installed = false
          end
        end
      when QUICK_ASSIST
        if ((@f_quick_assist_assistant).nil?)
          return
        end
        if (enable)
          if (!@f_quick_assist_assistant_installed)
            @f_quick_assist_assistant.install(self)
            @f_quick_assist_assistant_installed = true
          end
        else
          if (@f_quick_assist_assistant_installed)
            @f_quick_assist_assistant.uninstall
            @f_quick_assist_assistant_installed = false
          end
        end
      end
    end
    
    typesig { [Annotation] }
    # @see ISourceViewer#setRangeIndicator(Annotation)
    def set_range_indicator(range_indicator)
      @f_range_indicator = range_indicator
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # @see ISourceViewer#setRangeIndication(int, int, boolean)
    def set_range_indication(start, length, move_cursor)
      if (move_cursor)
        set_selected_range(start, 0)
        reveal_range(start, length)
      end
      if (!(@f_range_indicator).nil? && @f_visual_annotation_model.is_a?(IAnnotationModelExtension))
        extension = @f_visual_annotation_model
        extension.modify_annotation_position(@f_range_indicator, Position.new(start, length))
      end
    end
    
    typesig { [] }
    # @see ISourceViewer#getRangeIndication()
    def get_range_indication
      if (!(@f_range_indicator).nil? && !(@f_visual_annotation_model).nil?)
        position = @f_visual_annotation_model.get_position(@f_range_indicator)
        if (!(position).nil?)
          return Region.new(position.get_offset, position.get_length)
        end
      end
      return nil
    end
    
    typesig { [] }
    # @see ISourceViewer#removeRangeIndication()
    def remove_range_indication
      if (!(@f_range_indicator).nil? && !(@f_visual_annotation_model).nil?)
        @f_visual_annotation_model.remove_annotation(@f_range_indicator)
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see ISourceViewer#showAnnotations(boolean)
    def show_annotations(show)
      old = @f_is_vertical_ruler_visible
      @f_is_vertical_ruler_visible = (!(@f_vertical_ruler).nil? && (show || !is_vertical_ruler_only_showing_annotations))
      if (!(old).equal?(@f_is_vertical_ruler_visible) && !(@f_composite).nil? && !@f_composite.is_disposed)
        @f_composite.layout
      end
      if (@f_is_vertical_ruler_visible && show)
        ensure_annotation_hover_manager_installed
      else
        if (!(@f_vertical_ruler_hovering_controller).nil?)
          @f_vertical_ruler_hovering_controller.dispose
          @f_vertical_ruler_hovering_controller = nil
        end
      end
    end
    
    typesig { [] }
    # Tells whether the vertical ruler only acts as annotation ruler.
    # 
    # @return <code>true</code> if the vertical ruler only show annotations
    # @since 3.3
    def is_vertical_ruler_only_showing_annotations
      if (@f_vertical_ruler.is_a?(VerticalRuler))
        return true
      end
      if (@f_vertical_ruler.is_a?(CompositeRuler))
        iter = (@f_vertical_ruler).get_decorator_iterator
        return iter.has_next && iter.next_.is_a?(AnnotationRulerColumn) && !iter.has_next
      end
      return false
    end
    
    typesig { [] }
    # Returns the vertical ruler of this viewer.
    # 
    # @return the vertical ruler of this viewer
    # @since 3.0
    def get_vertical_ruler
      return @f_vertical_ruler
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.source.ISourceViewerExtension#showAnnotationsOverview(boolean)
    # @since 2.1
    def show_annotations_overview(show)
      old = @f_is_overview_ruler_visible
      @f_is_overview_ruler_visible = (show && !(@f_overview_ruler).nil?)
      if (!(old).equal?(@f_is_overview_ruler_visible))
        if (!(@f_composite).nil? && !@f_composite.is_disposed)
          @f_composite.layout
        end
        if (@f_is_overview_ruler_visible)
          ensure_overview_hover_manager_installed
        else
          if (!(@f_overview_ruler_hovering_controller).nil?)
            @f_overview_ruler_hovering_controller.dispose
            @f_overview_ruler_hovering_controller = nil
          end
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ISourceViewer#getCurrentAnnotationHover()
    # @since 3.2
    def get_current_annotation_hover
      if ((@f_vertical_ruler_hovering_controller).nil?)
        return nil
      end
      return @f_vertical_ruler_hovering_controller.get_current_annotation_hover
    end
    
    private
    alias_method :initialize__source_viewer, :initialize
  end
  
end
