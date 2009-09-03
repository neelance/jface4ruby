require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module SourceViewerConfigurationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :Arrays
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
      include_const ::Org::Eclipse::Jface::Text, :DefaultTextDoubleClickStrategy
      include_const ::Org::Eclipse::Jface::Text, :IAutoEditStrategy
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :ITextDoubleClickStrategy
      include_const ::Org::Eclipse::Jface::Text, :ITextHover
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension2
      include_const ::Org::Eclipse::Jface::Text, :IUndoManager
      include_const ::Org::Eclipse::Jface::Text, :TextViewerUndoManager
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistant
      include_const ::Org::Eclipse::Jface::Text::Formatter, :IContentFormatter
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :DefaultHyperlinkPresenter
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :IHyperlinkDetector
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :IHyperlinkPresenter
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :URLHyperlinkDetector
      include_const ::Org::Eclipse::Jface::Text::Information, :IInformationPresenter
      include_const ::Org::Eclipse::Jface::Text::Presentation, :IPresentationReconciler
      include_const ::Org::Eclipse::Jface::Text::Presentation, :PresentationReconciler
      include_const ::Org::Eclipse::Jface::Text::Quickassist, :IQuickAssistAssistant
      include_const ::Org::Eclipse::Jface::Text::Reconciler, :IReconciler
    }
  end
  
  # This class bundles the configuration space of a source viewer. Instances of
  # this class are passed to the <code>configure</code> method of
  # <code>ISourceViewer</code>.
  # <p>
  # Each method in this class get as argument the source viewer for which it
  # should provide a particular configuration setting such as a presentation
  # reconciler. Based on its specific knowledge about the returned object, the
  # configuration might share such objects or compute them according to some
  # rules.</p>
  # <p>
  # Clients should subclass and override just those methods which must be
  # specific to their needs.</p>
  # 
  # @see org.eclipse.jface.text.source.ISourceViewer
  class SourceViewerConfiguration 
    include_class_members SourceViewerConfigurationImports
    
    typesig { [] }
    # Creates a new source viewer configuration that behaves according to
    # specification of this class' methods.
    def initialize
    end
    
    typesig { [ISourceViewer] }
    # Returns the visual width of the tab character. This implementation always
    # returns 4.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return the tab width
    def get_tab_width(source_viewer)
      return 4
    end
    
    typesig { [ISourceViewer] }
    # Returns the undo manager for the given source viewer. This implementation
    # always returns a new instance of <code>DefaultUndoManager</code> whose
    # history length is set to 25.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return an undo manager or <code>null</code> if no undo/redo should not be supported
    def get_undo_manager(source_viewer)
      return TextViewerUndoManager.new(25)
    end
    
    typesig { [ISourceViewer] }
    # Returns the reconciler ready to be used with the given source viewer.
    # This implementation always returns <code>null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return a reconciler or <code>null</code> if reconciling should not be supported
    def get_reconciler(source_viewer)
      return nil
    end
    
    typesig { [ISourceViewer] }
    # Returns the presentation reconciler ready to be used with the given source viewer.
    # 
    # @param sourceViewer the source viewer
    # @return the presentation reconciler or <code>null</code> if presentation reconciling should not be supported
    def get_presentation_reconciler(source_viewer)
      reconciler = PresentationReconciler.new
      reconciler.set_document_partitioning(get_configured_document_partitioning(source_viewer))
      return reconciler
    end
    
    typesig { [ISourceViewer] }
    # Returns the content formatter ready to be used with the given source viewer.
    # This implementation always returns <code>null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return a content formatter or <code>null</code> if formatting should not be supported
    def get_content_formatter(source_viewer)
      return nil
    end
    
    typesig { [ISourceViewer] }
    # Returns the content assistant ready to be used with the given source viewer.
    # This implementation always returns <code>null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return a content assistant or <code>null</code> if content assist should not be supported
    def get_content_assistant(source_viewer)
      return nil
    end
    
    typesig { [ISourceViewer] }
    # Returns the quick assist assistant ready to be used with the given
    # source viewer.
    # This implementation always returns <code>null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return a quick assist assistant or <code>null</code> if quick assist should not be supported
    # @since 3.2
    def get_quick_assist_assistant(source_viewer)
      return nil
    end
    
    typesig { [ISourceViewer, String] }
    # Returns the auto indentation strategy ready to be used with the given source viewer
    # when manipulating text of the given content type. This implementation always
    # returns an new instance of <code>DefaultAutoIndentStrategy</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type for which the strategy is applicable
    # @return the auto indent strategy or <code>null</code> if automatic indentation is not to be enabled
    # @deprecated since 3.1 use {@link #getAutoEditStrategies(ISourceViewer, String)} instead
    def get_auto_indent_strategy(source_viewer, content_type)
      return Org::Eclipse::Jface::Text::DefaultAutoIndentStrategy.new
    end
    
    typesig { [ISourceViewer, String] }
    # Returns the auto edit strategies ready to be used with the given source viewer
    # when manipulating text of the given content type. For backward compatibility, this implementation always
    # returns an array containing the result of {@link #getAutoIndentStrategy(ISourceViewer, String)}.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type for which the strategies are applicable
    # @return the auto edit strategies or <code>null</code> if automatic editing is not to be enabled
    # @since 3.1
    def get_auto_edit_strategies(source_viewer, content_type)
      return Array.typed(IAutoEditStrategy).new([get_auto_indent_strategy(source_viewer, content_type)])
    end
    
    typesig { [ISourceViewer, String] }
    # Returns the default prefixes to be used by the line-prefix operation
    # in the given source viewer for text of the given content type. This implementation always
    # returns <code>null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type for which the prefix is applicable
    # @return the default prefixes or <code>null</code> if the prefix operation should not be supported
    # @since 2.0
    def get_default_prefixes(source_viewer, content_type)
      return nil
    end
    
    typesig { [ISourceViewer, String] }
    # Returns the double-click strategy ready to be used in this viewer when double clicking
    # onto text of the given content type. This implementation always returns a new instance of
    # <code>DefaultTextDoubleClickStrategy</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type for which the strategy is applicable
    # @return a double-click strategy or <code>null</code> if double clicking should not be supported
    def get_double_click_strategy(source_viewer, content_type)
      return DefaultTextDoubleClickStrategy.new
    end
    
    typesig { [ISourceViewer, String] }
    # Returns the prefixes to be used by the line-shift operation. This implementation
    # always returns <code>new String[] { "\t", "    ", "" }</code>.
    # <p>
    # <strong>Note:</strong> <em>This default is incorrect but cannot be changed in order not
    # to break any existing clients. Subclasses should overwrite this method and
    # use {@link #getIndentPrefixesForTab(int)} if applicable.</em>
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type for which the prefix is applicable
    # @return the prefixes or <code>null</code> if the prefix operation should not be supported
    def get_indent_prefixes(source_viewer, content_type)
      return Array.typed(String).new(["\t", "    ", ""]) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    end
    
    typesig { [::Java::Int] }
    # Computes and returns the indent prefixes for tab indentation
    # which is represented as <code>tabSizeInSpaces</code>.
    # 
    # @param tabWidth the display tab width
    # @return the indent prefixes
    # @see #getIndentPrefixes(ISourceViewer, String)
    # @since 3.3
    def get_indent_prefixes_for_tab(tab_width)
      indent_prefixes = Array.typed(String).new(tab_width + 2) { nil }
      i = 0
      while i <= tab_width
        space_chars = CharArray.new(i)
        Arrays.fill(space_chars, Character.new(?\s.ord))
        spaces = String.new(space_chars)
        if (i < tab_width)
          indent_prefixes[i] = spaces + RJava.cast_to_string(Character.new(?\t.ord))
        else
          indent_prefixes[i] = String.new(spaces)
        end
        i += 1
      end
      indent_prefixes[tab_width + 1] = "" # $NON-NLS-1$
      return indent_prefixes
    end
    
    typesig { [ISourceViewer] }
    # Returns the annotation hover which will provide the information to be
    # shown in a hover popup window when requested for the given
    # source viewer. This implementation always returns <code>null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return an annotation hover or <code>null</code> if no hover support should be installed
    def get_annotation_hover(source_viewer)
      return nil
    end
    
    typesig { [ISourceViewer] }
    # Returns the annotation hover which will provide the information to be
    # shown in a hover popup window when requested for the overview ruler
    # of the given source viewer.This implementation always returns the general
    # annotation hover returned by <code>getAnnotationHover</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return an annotation hover or <code>null</code> if no hover support should be installed
    # @since 3.0
    def get_overview_ruler_annotation_hover(source_viewer)
      return get_annotation_hover(source_viewer)
    end
    
    typesig { [ISourceViewer, String] }
    # Returns the SWT event state masks for which text hover are configured for
    # the given content type.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type
    # @return an <code>int</code> array with the configured SWT event state masks
    # or <code>null</code> if text hovers are not supported for the given content type
    # @since 2.1
    def get_configured_text_hover_state_masks(source_viewer, content_type)
      return nil
    end
    
    typesig { [ISourceViewer, String, ::Java::Int] }
    # Returns the text hover which will provide the information to be shown
    # in a text hover popup window when requested for the given source viewer and
    # the given content type. This implementation always returns <code>
    # null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type
    # @param stateMask the SWT event state mask
    # @return a text hover or <code>null</code> if no hover support should be installed
    # @since 2.1
    def get_text_hover(source_viewer, content_type, state_mask)
      if ((state_mask).equal?(ITextViewerExtension2::DEFAULT_HOVER_STATE_MASK))
        return get_text_hover(source_viewer, content_type)
      end
      return nil
    end
    
    typesig { [ISourceViewer, String] }
    # Returns the text hover which will provide the information to be shown
    # in a text hover popup window when requested for the given source viewer and
    # the given content type. This implementation always returns <code>
    # null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @param contentType the content type
    # @return a text hover or <code>null</code> if no hover support should be installed
    def get_text_hover(source_viewer, content_type)
      return nil
    end
    
    typesig { [ISourceViewer] }
    # Returns the information control creator. The creator is a factory creating information
    # controls for the given source viewer. This implementation always returns a creator for
    # <code>DefaultInformationControl</code> instances.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return the information control creator or <code>null</code> if no information support should be installed
    # @since 2.0
    def get_information_control_creator(source_viewer)
      return Class.new(IInformationControlCreator.class == Class ? IInformationControlCreator : Object) do
        extend LocalClass
        include_class_members SourceViewerConfiguration
        include IInformationControlCreator if IInformationControlCreator.class == Module
        
        typesig { [Shell] }
        define_method :create_information_control do |parent|
          return self.class::DefaultInformationControl.new(parent)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [ISourceViewer] }
    # Returns the information presenter which will determine and shown
    # information requested for the current cursor position. This implementation
    # always returns <code>null</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return an information presenter <code>null</code> if  no information presenter should be installed
    # @since 2.0
    def get_information_presenter(source_viewer)
      return nil
    end
    
    typesig { [ISourceViewer] }
    # Returns all configured content types for the given source viewer. This list
    # tells the caller which content types must be configured for the given source
    # viewer, i.e. for which content types the given source viewer's functionalities
    # must be specified. This implementation always returns <code>
    # new String[] { IDocument.DEFAULT_CONTENT_TYPE }</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return the configured content types for the given viewer
    def get_configured_content_types(source_viewer)
      return Array.typed(String).new([IDocument::DEFAULT_CONTENT_TYPE])
    end
    
    typesig { [ISourceViewer] }
    # Returns the configured partitioning for the given source viewer. The partitioning is
    # used when the querying content types from the source viewer's input document.  This
    # implementation always returns <code>IDocumentExtension3.DEFAULT_PARTITIONING</code>.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return the configured partitioning
    # @see #getConfiguredContentTypes(ISourceViewer)
    # @since 3.0
    def get_configured_document_partitioning(source_viewer)
      return IDocumentExtension3::DEFAULT_PARTITIONING
    end
    
    typesig { [ISourceViewer] }
    # Returns the hyperlink detectors which be used to detect hyperlinks
    # in the given source viewer. This
    # implementation always returns an array with an URL hyperlink detector.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return an array with hyperlink detectors or <code>null</code> if no hyperlink support should be installed
    # @since 3.1
    def get_hyperlink_detectors(source_viewer)
      if ((source_viewer).nil?)
        return nil
      end
      return Array.typed(IHyperlinkDetector).new([URLHyperlinkDetector.new])
    end
    
    typesig { [ISourceViewer] }
    # Returns the hyperlink presenter for the given source viewer.
    # This implementation always returns the {@link DefaultHyperlinkPresenter}.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return the hyperlink presenter or <code>null</code> if no hyperlink support should be installed
    # @since 3.1
    def get_hyperlink_presenter(source_viewer)
      return DefaultHyperlinkPresenter.new(RGB.new(0, 0, 255))
    end
    
    typesig { [ISourceViewer] }
    # Returns the SWT event state mask which in combination
    # with the left mouse button activates hyperlinking.
    # This implementation always returns the {@link SWT#MOD1}.
    # 
    # @param sourceViewer the source viewer to be configured by this configuration
    # @return the SWT event state mask to activate hyperlink mode
    # @since 3.1
    def get_hyperlink_state_mask(source_viewer)
      return SWT::MOD1
    end
    
    private
    alias_method :initialize__source_viewer_configuration, :initialize
  end
  
end
