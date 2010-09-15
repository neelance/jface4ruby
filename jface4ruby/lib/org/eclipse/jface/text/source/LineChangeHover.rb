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
  module LineChangeHoverImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Jface::Action, :ToolBarManager
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text::Information, :IInformationProviderExtension2
    }
  end
  
  # A hover for line oriented diffs. It determines the text to show as hover for a certain line in the
  # document.
  # 
  # @since 3.0
  class LineChangeHover 
    include_class_members LineChangeHoverImports
    include IAnnotationHover
    include IAnnotationHoverExtension
    include IInformationProviderExtension2
    
    typesig { [ISourceViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IAnnotationHover#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, int)
    def get_hover_info(source_viewer, line_number)
      return nil
    end
    
    typesig { [String] }
    # Formats the source w/ syntax coloring etc. This implementation replaces tabs with spaces.
    # May be overridden by subclasses.
    # 
    # @param content the hover content
    # @return <code>content</code> reformatted
    def format_source(content)
      if (!(content).nil?)
        sb = StringBuffer.new(content)
        tab_replacement = get_tab_replacement
        pos = 0
        while pos < sb.length
          if ((sb.char_at(pos)).equal?(Character.new(?\t.ord)))
            sb.replace(pos, pos + 1, tab_replacement)
          end
          pos += 1
        end
        return sb.to_s
      end
      return content
    end
    
    typesig { [] }
    # Returns a replacement for the tab character. The default implementation
    # returns a tabulator character, but subclasses may override to specify a
    # number of spaces.
    # 
    # @return a whitespace String that will be substituted for the tabulator
    # character
    def get_tab_replacement
      return "\t" # $NON-NLS-1$
    end
    
    typesig { [ISourceViewer, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Computes the content of the hover for the document contained in <code>viewer</code> on
    # line <code>line</code>.
    # 
    # @param viewer the connected viewer
    # @param first the first line in <code>viewer</code>'s document to consider
    # @param last the last line in <code>viewer</code>'s document to consider
    # @param maxLines the max number of lines
    # @return The hover content corresponding to the parameters
    # @see #getHoverInfo(ISourceViewer, int)
    # @see #getHoverInfo(ISourceViewer, ILineRange, int)
    def compute_content(viewer, first, last, max_lines)
      differ = get_differ(viewer)
      if ((differ).nil?)
        return nil
      end
      lines = LinkedList.new
      l = first
      while l <= last
        info = differ.get_line_info(l)
        if (!(info).nil?)
          lines.add(info)
        end
        l += 1
      end
      return decorate_text(lines, max_lines)
    end
    
    typesig { [JavaList, ::Java::Int] }
    # Takes a list of <code>ILineDiffInfo</code>s and computes a hover of at most <code>maxLines</code>.
    # Added lines are prefixed with a <code>'+'</code>, changed lines with <code>'>'</code> and
    # deleted lines with <code>'-'</code>.
    # <p>Deleted and added lines can even each other out, so that a number of deleted lines get
    # displayed where - in the current document - the added lines are.
    # 
    # @param diffInfos a <code>List</code> of <code>ILineDiffInfo</code>
    # @param maxLines the maximum number of lines. Note that adding up all annotations might give
    # more than that due to deleted lines.
    # @return a <code>String</code> suitable for hover display
    def decorate_text(diff_infos, max_lines)
      # maxLines controls the size of the hover (not more than what fits into the display are of
      # the viewer).
      # added controls how many lines are added - added lines are
      text = "" # $NON-NLS-1$
      added = 0
      it = diff_infos.iterator
      while it.has_next
        info = it.next_
        original = info.get_original_text
        type = info.get_change_type
        i = 0
        if ((type).equal?(ILineDiffInfo::ADDED))
          added += 1
        else
          if ((type).equal?(ILineDiffInfo::CHANGED))
            text += "> " + RJava.cast_to_string((original.attr_length > 0 ? original[((i += 1) - 1)] : "")) # $NON-NLS-1$ //$NON-NLS-2$
            max_lines -= 1
          else
            if ((type).equal?(ILineDiffInfo::UNCHANGED))
              max_lines += 1
            end
          end
        end
        if ((max_lines).equal?(0))
          return trim_trailing(text)
        end
        while i < original.attr_length
          text += "- " + RJava.cast_to_string(original[i]) # $NON-NLS-1$
          added -= 1
          if (((max_lines -= 1)).equal?(0))
            return trim_trailing(text)
          end
          i += 1
        end
      end
      text = RJava.cast_to_string(text.trim)
      if ((text.length).equal?(0) && ((added -= 1) + 1) > 0 && ((max_lines -= 1) + 1) > 0)
        text += "+ "
      end # $NON-NLS-1$
      while (((added -= 1) + 1) > 0 && ((max_lines -= 1) + 1) > 0)
        text += "\n+ "
      end # $NON-NLS-1$
      return text
    end
    
    typesig { [String] }
    # Trims trailing spaces
    # 
    # @param text a <code>String</code>
    # @return a copy of <code>text</code> with trailing spaces removed
    def trim_trailing(text)
      pos = text.length - 1
      while (pos >= 0 && Character.is_whitespace(text.char_at(pos)))
        pos -= 1
      end
      return text.substring(0, pos + 1)
    end
    
    typesig { [ISourceViewer] }
    # Extracts the line differ - if any - from the viewer's document's annotation model.
    # @param viewer the viewer
    # @return a line differ for the document displayed in viewer, or <code>null</code>.
    def get_differ(viewer)
      model = viewer.get_annotation_model
      if ((model).nil?)
        return nil
      end
      if (model.is_a?(IAnnotationModelExtension))
        diff_model = (model).get_annotation_model(IChangeRulerColumn::QUICK_DIFF_MODEL_ID)
        if (!(diff_model).nil?)
          model = diff_model
        end
      end
      if (model.is_a?(ILineDiffer))
        if (model.is_a?(ILineDifferExtension2) && (model).is_suspended)
          return nil
        end
        return model
      end
      return nil
    end
    
    typesig { [ISourceViewer, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Computes the block of lines which form a contiguous block of changes covering <code>line</code>.
    # 
    # @param viewer the source viewer showing
    # @param line the line which a hover is displayed for
    # @param min the first line in <code>viewer</code>'s document to consider
    # @param max the last line in <code>viewer</code>'s document to consider
    # @return the selection in the document displayed in <code>viewer</code> containing <code>line</code>
    # that is covered by the hover information returned by the receiver.
    def compute_line_range(viewer, line, min, max)
      # Algorithm:
      # All lines that have changes to themselves (added, changed) are taken that form a
      # contiguous block of lines that includes <code>line</code>.
      # 
      # If <code>line</code> is itself unchanged, if there is a deleted line either above or
      # below, or both, the lines +/- 1 from <code>line</code> are included in the search as well,
      # without applying this last rule to them, though. (I.e., if <code>line</code> is unchanged,
      # but has a deleted line above, this one is taken in. If the line above has changes, the block
      # is extended from there. If the line has no changes itself, the search stops).
      # 
      # The block never extends the visible line range of the viewer.
      differ = get_differ(viewer)
      if ((differ).nil?)
        return Point.new(-1, -1)
      end
      # backward search
      l = line
      info = differ.get_line_info(l)
      # search backwards until a line has no changes to itself
      while (l >= min && !(info).nil? && ((info.get_change_type).equal?(ILineDiffInfo::CHANGED) || (info.get_change_type).equal?(ILineDiffInfo::ADDED)))
        info = differ.get_line_info((l -= 1))
      end
      first = Math.min(l + 1, line)
      # forward search
      l = line
      info = differ.get_line_info(l)
      # search forward until a line has no changes to itself
      while (l <= max && !(info).nil? && ((info.get_change_type).equal?(ILineDiffInfo::CHANGED) || (info.get_change_type).equal?(ILineDiffInfo::ADDED)))
        info = differ.get_line_info((l += 1))
      end
      last = Math.max(l - 1, line)
      return Point.new(first, last)
    end
    
    typesig { [ISourceViewer, ILineRange, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, org.eclipse.jface.text.source.ILineRange, int)
    def get_hover_info(source_viewer, line_range, visible_lines)
      first = adapt_first_line(source_viewer, line_range.get_start_line)
      last = adapt_last_line(source_viewer, line_range.get_start_line + line_range.get_number_of_lines - 1)
      content = compute_content(source_viewer, first, last, visible_lines)
      return format_source(content)
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    # Adapts the start line to the implementation of <code>ILineDiffInfo</code>.
    # 
    # @param viewer the source viewer
    # @param startLine the line to adapt
    # @return <code>startLine - 1</code> if that line exists and is an
    # unchanged line followed by deletions, <code>startLine</code>
    # otherwise
    def adapt_first_line(viewer, start_line)
      differ = get_differ(viewer)
      if (!(differ).nil? && start_line > 0)
        l = start_line - 1
        info = differ.get_line_info(l)
        if (!(info).nil? && (info.get_change_type).equal?(ILineDiffInfo::UNCHANGED) && info.get_removed_lines_below > 0)
          return l
        end
      end
      return start_line
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    # Adapts the last line to the implementation of <code>ILineDiffInfo</code>.
    # 
    # @param viewer the source viewer
    # @param lastLine the line to adapt
    # @return <code>lastLine - 1</code> if that line exists and is an
    # unchanged line followed by deletions, <code>startLine</code>
    # otherwise
    def adapt_last_line(viewer, last_line)
      differ = get_differ(viewer)
      if (!(differ).nil? && last_line > 0)
        info = differ.get_line_info(last_line)
        if (!(info).nil? && (info.get_change_type).equal?(ILineDiffInfo::UNCHANGED))
          return last_line - 1
        end
      end
      return last_line
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverLineRange(org.eclipse.jface.text.source.ISourceViewer, int)
    def get_hover_line_range(viewer, line_number)
      document = viewer.get_document
      if (!(document).nil?)
        range = compute_line_range(viewer, line_number, 0, Math.max(0, document.get_number_of_lines - 1))
        if (!(range.attr_x).equal?(-1) && !(range.attr_y).equal?(-1))
          return LineRange.new(range.attr_x, range.attr_y - range.attr_x + 1)
        end
      end
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#canHandleMouseCursor()
    def can_handle_mouse_cursor
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverControlCreator()
    def get_hover_control_creator
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.information.IInformationProviderExtension2#getInformationPresenterControlCreator()
    # @since 3.2
    def get_information_presenter_control_creator
      return Class.new(IInformationControlCreator.class == Class ? IInformationControlCreator : Object) do
        local_class_in LineChangeHover
        include_class_members LineChangeHover
        include IInformationControlCreator if IInformationControlCreator.class == Module
        
        typesig { [Shell] }
        define_method :create_information_control do |parent|
          return self.class::DefaultInformationControl.new(parent, nil, nil)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__line_change_hover, :initialize
  end
  
end
