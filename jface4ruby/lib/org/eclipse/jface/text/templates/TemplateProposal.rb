require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TemplateProposalImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Dialogs, :MessageDialog
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension2
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension3
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
      include_const ::Org::Eclipse::Jface::Text::Link, :ILinkedModeListener
      include_const ::Org::Eclipse::Jface::Text::Link, :LinkedModeModel
      include_const ::Org::Eclipse::Jface::Text::Link, :LinkedModeUI
      include_const ::Org::Eclipse::Jface::Text::Link, :LinkedPosition
      include_const ::Org::Eclipse::Jface::Text::Link, :LinkedPositionGroup
      include_const ::Org::Eclipse::Jface::Text::Link, :ProposalPosition
    }
  end
  
  # A template completion proposal.
  # <p>
  # Clients may subclass.</p>
  # 
  # @since 3.0
  class TemplateProposal 
    include_class_members TemplateProposalImports
    include ICompletionProposal
    include ICompletionProposalExtension
    include ICompletionProposalExtension2
    include ICompletionProposalExtension3
    
    attr_accessor :f_template
    alias_method :attr_f_template, :f_template
    undef_method :f_template
    alias_method :attr_f_template=, :f_template=
    undef_method :f_template=
    
    attr_accessor :f_context
    alias_method :attr_f_context, :f_context
    undef_method :f_context
    alias_method :attr_f_context=, :f_context=
    undef_method :f_context=
    
    attr_accessor :f_image
    alias_method :attr_f_image, :f_image
    undef_method :f_image
    alias_method :attr_f_image=, :f_image=
    undef_method :f_image=
    
    attr_accessor :f_region
    alias_method :attr_f_region, :f_region
    undef_method :f_region
    alias_method :attr_f_region=, :f_region=
    undef_method :f_region=
    
    attr_accessor :f_relevance
    alias_method :attr_f_relevance, :f_relevance
    undef_method :f_relevance
    alias_method :attr_f_relevance=, :f_relevance=
    undef_method :f_relevance=
    
    attr_accessor :f_selected_region
    alias_method :attr_f_selected_region, :f_selected_region
    undef_method :f_selected_region
    alias_method :attr_f_selected_region=, :f_selected_region=
    undef_method :f_selected_region=
    
    # initialized by apply()
    attr_accessor :f_display_string
    alias_method :attr_f_display_string, :f_display_string
    undef_method :f_display_string
    alias_method :attr_f_display_string=, :f_display_string=
    undef_method :f_display_string=
    
    attr_accessor :f_updater
    alias_method :attr_f_updater, :f_updater
    undef_method :f_updater
    alias_method :attr_f_updater=, :f_updater=
    undef_method :f_updater=
    
    attr_accessor :f_information_control_creator
    alias_method :attr_f_information_control_creator, :f_information_control_creator
    undef_method :f_information_control_creator
    alias_method :attr_f_information_control_creator=, :f_information_control_creator=
    undef_method :f_information_control_creator=
    
    typesig { [Template, TemplateContext, IRegion, Image] }
    # Creates a template proposal with a template and its context.
    # 
    # @param template  the template
    # @param context   the context in which the template was requested.
    # @param region	the region this proposal is applied to
    # @param image     the icon of the proposal.
    def initialize(template, context, region, image)
      initialize__template_proposal(template, context, region, image, 0)
    end
    
    typesig { [Template, TemplateContext, IRegion, Image, ::Java::Int] }
    # Creates a template proposal with a template and its context.
    # 
    # @param template  the template
    # @param context   the context in which the template was requested.
    # @param image     the icon of the proposal.
    # @param region	the region this proposal is applied to
    # @param relevance the relevance of the proposal
    def initialize(template, context, region, image, relevance)
      @f_template = nil
      @f_context = nil
      @f_image = nil
      @f_region = nil
      @f_relevance = 0
      @f_selected_region = nil
      @f_display_string = nil
      @f_updater = nil
      @f_information_control_creator = nil
      Assert.is_not_null(template)
      Assert.is_not_null(context)
      Assert.is_not_null(region)
      @f_template = template
      @f_context = context
      @f_image = image
      @f_region = region
      @f_display_string = RJava.cast_to_string(nil)
      @f_relevance = relevance
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the information control creator for this completion proposal.
    # 
    # @param informationControlCreator the information control creator
    # @since 3.1
    def set_information_control_creator(information_control_creator)
      @f_information_control_creator = information_control_creator
    end
    
    typesig { [] }
    # Returns the template of this proposal.
    # 
    # @return the template of this proposal
    # @since 3.1
    def get_template
      return @f_template
    end
    
    typesig { [] }
    # Returns the context in which the template was requested.
    # 
    # @return the context in which the template was requested
    # @since 3.1
    def get_context
      return @f_context
    end
    
    typesig { [IDocument] }
    # {@inheritDoc}
    # 
    # @deprecated This method is no longer called by the framework and clients should overwrite
    # {@link #apply(ITextViewer, char, int, int)} instead
    def apply(document)
      # not called anymore
    end
    
    typesig { [ITextViewer, ::Java::Char, ::Java::Int, ::Java::Int] }
    # Inserts the template offered by this proposal into the viewer's document
    # and sets up a <code>LinkedModeUI</code> on the viewer to edit any of
    # the template's unresolved variables.
    # 
    # @param viewer {@inheritDoc}
    # @param trigger {@inheritDoc}
    # @param stateMask {@inheritDoc}
    # @param offset {@inheritDoc}
    def apply(viewer, trigger, state_mask, offset)
      document = viewer.get_document
      begin
        @f_context.set_read_only(false)
        start = 0
        template_buffer = nil
        old_replace_offset = get_replace_offset
        begin
          # this may already modify the document (e.g. add imports)
          template_buffer = @f_context.evaluate(@f_template)
        rescue TemplateException => e1
          @f_selected_region = @f_region
          return
        end
        start = get_replace_offset
        shift = start - old_replace_offset
        end_ = Math.max(get_replace_end_offset, offset + shift)
        # insert template string
        template_string = template_buffer.get_string
        document.replace(start, end_ - start, template_string)
        # translate positions
        model = LinkedModeModel.new
        variables = template_buffer.get_variables
        has_positions = false
        i = 0
        while !(i).equal?(variables.attr_length)
          variable = variables[i]
          if (variable.is_unambiguous)
            i += 1
            next
          end
          group = LinkedPositionGroup.new
          offsets = variable.get_offsets
          length = variable.get_length
          first = nil
          values = variable.get_values
          proposals = Array.typed(ICompletionProposal).new(values.attr_length) { nil }
          j = 0
          while j < values.attr_length
            ensure_position_category_installed(document, model)
            pos = Position.new(offsets[0] + start, length)
            document.add_position(get_category, pos)
            proposals[j] = PositionBasedCompletionProposal.new(values[j], pos, length)
            j += 1
          end
          if (proposals.attr_length > 1)
            first = ProposalPosition.new(document, offsets[0] + start, length, proposals)
          else
            first = LinkedPosition.new(document, offsets[0] + start, length)
          end
          j = 0
          while !(j).equal?(offsets.attr_length)
            if ((j).equal?(0))
              group.add_position(first)
            else
              group.add_position(LinkedPosition.new(document, offsets[j] + start, length))
            end
            j += 1
          end
          model.add_group(group)
          has_positions = true
          i += 1
        end
        if (has_positions)
          model.force_install
          ui = LinkedModeUI.new(model, viewer)
          ui.set_exit_position(viewer, get_caret_offset(template_buffer) + start, 0, JavaInteger::MAX_VALUE)
          ui.enter
          @f_selected_region = ui.get_selected_region
        else
          ensure_position_category_removed(document)
          @f_selected_region = Region.new(get_caret_offset(template_buffer) + start, 0)
        end
      rescue BadLocationException => e
        open_error_dialog(viewer.get_text_widget.get_shell, e)
        ensure_position_category_removed(document)
        @f_selected_region = @f_region
      rescue BadPositionCategoryException => e
        open_error_dialog(viewer.get_text_widget.get_shell, e)
        @f_selected_region = @f_region
      end
    end
    
    typesig { [IDocument, LinkedModeModel] }
    def ensure_position_category_installed(document, model)
      if (!document.contains_position_category(get_category))
        document.add_position_category(get_category)
        @f_updater = InclusivePositionUpdater.new(get_category)
        document.add_position_updater(@f_updater)
        model.add_linking_listener(Class.new(ILinkedModeListener.class == Class ? ILinkedModeListener : Object) do
          extend LocalClass
          include_class_members TemplateProposal
          include ILinkedModeListener if ILinkedModeListener.class == Module
          
          typesig { [LinkedModeModel, ::Java::Int] }
          # @see org.eclipse.jface.text.link.ILinkedModeListener#left(org.eclipse.jface.text.link.LinkedModeModel, int)
          define_method :left do |environment, flags|
            ensure_position_category_removed(document)
          end
          
          typesig { [LinkedModeModel] }
          define_method :suspend do |environment|
          end
          
          typesig { [LinkedModeModel, ::Java::Int] }
          define_method :resume do |environment, flags|
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
    
    typesig { [IDocument] }
    def ensure_position_category_removed(document)
      if (document.contains_position_category(get_category))
        begin
          document.remove_position_category(get_category)
        rescue BadPositionCategoryException => e
          # ignore
        end
        document.remove_position_updater(@f_updater)
      end
    end
    
    typesig { [] }
    def get_category
      return "TemplateProposalCategory_" + RJava.cast_to_string(to_s) # $NON-NLS-1$
    end
    
    typesig { [TemplateBuffer] }
    def get_caret_offset(buffer)
      variables = buffer.get_variables
      i = 0
      while !(i).equal?(variables.attr_length)
        variable = variables[i]
        if ((variable.get_type == GlobalTemplateVariables::Cursor::NAME))
          return variable.get_offsets[0]
        end
        i += 1
      end
      return buffer.get_string.length
    end
    
    typesig { [] }
    # Returns the offset of the range in the document that will be replaced by
    # applying this template.
    # 
    # @return the offset of the range in the document that will be replaced by
    # applying this template
    # @since 3.1
    def get_replace_offset
      start = 0
      if (@f_context.is_a?(DocumentTemplateContext))
        doc_context = @f_context
        start = doc_context.get_start
      else
        start = @f_region.get_offset
      end
      return start
    end
    
    typesig { [] }
    # Returns the end offset of the range in the document that will be replaced
    # by applying this template.
    # 
    # @return the end offset of the range in the document that will be replaced
    # by applying this template
    # @since 3.1
    def get_replace_end_offset
      end_ = 0
      if (@f_context.is_a?(DocumentTemplateContext))
        doc_context = @f_context
        end_ = doc_context.get_end
      else
        end_ = @f_region.get_offset + @f_region.get_length
      end
      return end_
    end
    
    typesig { [IDocument] }
    # @see ICompletionProposal#getSelection(IDocument)
    def get_selection(document)
      return Point.new(@f_selected_region.get_offset, @f_selected_region.get_length)
    end
    
    typesig { [] }
    # @see ICompletionProposal#getAdditionalProposalInfo()
    def get_additional_proposal_info
      begin
        @f_context.set_read_only(true)
        template_buffer = nil
        begin
          template_buffer = @f_context.evaluate(@f_template)
        rescue TemplateException => e
          return nil
        end
        return template_buffer.get_string
      rescue BadLocationException => e
        return nil
      end
    end
    
    typesig { [] }
    # @see ICompletionProposal#getDisplayString()
    def get_display_string
      if ((@f_display_string).nil?)
        arguments = Array.typed(String).new([@f_template.get_name, @f_template.get_description])
        @f_display_string = RJava.cast_to_string(JFaceTextTemplateMessages.get_formatted_string("TemplateProposal.displayString", arguments)) # $NON-NLS-1$
      end
      return @f_display_string
    end
    
    typesig { [] }
    # @see ICompletionProposal#getImage()
    def get_image
      return @f_image
    end
    
    typesig { [] }
    # @see ICompletionProposal#getContextInformation()
    def get_context_information
      return nil
    end
    
    typesig { [Shell, JavaException] }
    def open_error_dialog(shell, e)
      MessageDialog.open_error(shell, JFaceTextTemplateMessages.get_string("TemplateProposal.errorDialog.title"), e.get_message) # $NON-NLS-1$
    end
    
    typesig { [] }
    # Returns the relevance.
    # 
    # @return the relevance
    def get_relevance
      return @f_relevance
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension3#getInformationControlCreator()
    def get_information_control_creator
      return @f_information_control_creator
    end
    
    typesig { [ITextViewer, ::Java::Boolean] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension2#selected(org.eclipse.jface.text.ITextViewer, boolean)
    def selected(viewer, smart_toggle)
    end
    
    typesig { [ITextViewer] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension2#unselected(org.eclipse.jface.text.ITextViewer)
    def unselected(viewer)
    end
    
    typesig { [IDocument, ::Java::Int, DocumentEvent] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension2#validate(org.eclipse.jface.text.IDocument, int, org.eclipse.jface.text.DocumentEvent)
    def validate(document, offset, event)
      begin
        replace_offset = get_replace_offset
        if (offset >= replace_offset)
          content = document.get(replace_offset, offset - replace_offset)
          return @f_template.get_name.to_lower_case.starts_with(content.to_lower_case)
        end
      rescue BadLocationException => e
        # concurrent modification - ignore
      end
      return false
    end
    
    typesig { [IDocument, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension3#getPrefixCompletionText(org.eclipse.jface.text.IDocument, int)
    def get_prefix_completion_text(document, completion_offset)
      return @f_template.get_name
    end
    
    typesig { [IDocument, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension3#getPrefixCompletionStart(org.eclipse.jface.text.IDocument, int)
    def get_prefix_completion_start(document, completion_offset)
      return get_replace_offset
    end
    
    typesig { [IDocument, ::Java::Char, ::Java::Int] }
    # {@inheritDoc}
    # 
    # @deprecated This method is no longer called by the framework and clients should overwrite
    # {@link #apply(ITextViewer, char, int, int)} instead
    def apply(document, trigger, offset)
      # not called any longer
    end
    
    typesig { [IDocument, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension#isValidFor(org.eclipse.jface.text.IDocument, int)
    def is_valid_for(document, offset)
      # not called any longer
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension#getTriggerCharacters()
    def get_trigger_characters
      # no triggers
      return CharArray.new(0)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension#getContextInformationPosition()
    def get_context_information_position
      return @f_region.get_offset
    end
    
    private
    alias_method :initialize__template_proposal, :initialize
  end
  
end
