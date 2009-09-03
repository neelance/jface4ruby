require "rjava"

# Copyright (c) 2009 Avaloq Evolution AG and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Eicher (Avaloq Evolution AG) - initial API and implementation
module Org::Eclipse::Jface::Internal::Text
  module SelectionProcessorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text
      include_const ::Java::Util, :Arrays
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Text::Edits, :DeleteEdit
      include_const ::Org::Eclipse::Text::Edits, :InsertEdit
      include_const ::Org::Eclipse::Text::Edits, :MalformedTreeException
      include_const ::Org::Eclipse::Text::Edits, :MultiTextEdit
      include_const ::Org::Eclipse::Text::Edits, :ReplaceEdit
      include_const ::Org::Eclipse::Text::Edits, :TextEdit
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionProvider
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BlockTextSelection
      include_const ::Org::Eclipse::Jface::Text, :IBlockTextSelection
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :IRewriteTarget
      include_const ::Org::Eclipse::Jface::Text, :ITextSelection
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextSelection
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
    }
  end
  
  # Processes {@link ITextSelection}s.
  # 
  # @since 3.5
  class SelectionProcessor 
    include_class_members SelectionProcessorImports
    
    class_module.module_eval {
      const_set_lazy(:Implementation) { Class.new do
        include_class_members SelectionProcessor
        
        typesig { [class_self::ISelection, String] }
        # Returns a text edit describing the text modification that would be executed if the given
        # selection was replaced by <code>replacement</code>.
        # 
        # @param selection the selection to replace
        # @param replacement the replacement text
        # @return a text edit describing the operation needed to replace <code>selection</code>
        # @throws BadLocationException if computing the edit failed
        def replace(selection, replacement)
          return self.class::MultiTextEdit.new
        end
        
        typesig { [class_self::ISelection] }
        # Returns the text covered by <code>selection</code>
        # 
        # @param selection the selection
        # @return the text covered by <code>selection</code>
        # @throws BadLocationException if computing the edit failed
        def get_text(selection)
          return "" # $NON-NLS-1$
        end
        
        typesig { [class_self::ISelection] }
        # Returns <code>true</code> if the text covered by <code>selection</code> does not contain any
        # characters. Note the difference to {@link ITextSelection#isEmpty()}, which returns
        # <code>true</code> only for invalid selections.
        # 
        # @param selection the selection
        # @return <code>true</code> if <code>selection</code> does not contain any text,
        # <code>false</code> otherwise
        # @throws BadLocationException if accessing the document failed
        def is_empty(selection)
          return selection.is_empty
        end
        
        typesig { [class_self::ISelection] }
        # Returns <code>true</code> if <code>selection</code> covers text on two or more lines,
        # <code>false</code> otherwise.
        # 
        # @param selection the selection
        # @return <code>true</code> if <code>selection</code> covers text on two or more lines,
        # <code>false</code> otherwise
        # @throws BadLocationException if selection is not a valid selection on the target document
        def is_multiline(selection)
          if ((selection).nil?)
            raise self.class::NullPointerException.new
          end
          return false
        end
        
        typesig { [class_self::ISelection] }
        def delete(selection)
          return replace(selection, "") # $NON-NLS-1$
        end
        
        typesig { [class_self::ISelection] }
        def backspace(selection)
          return replace(selection, "") # $NON-NLS-1$
        end
        
        typesig { [class_self::ISelection, ::Java::Boolean] }
        # Returns a selection similar to <code>selection</code> but {@linkplain #isEmpty(ISelection)
        # empty}. Typically, the selection is reduced to its left-most offset.
        # 
        # @param selection the selection
        # @param beginning <code>true</code> to collapse the selection to its smallest position
        # (i.e. its left-most offset), <code>false</code> to collapse it to its greatest
        # position (e.g its right-most offset)
        # @return an empty variant of <code>selection</code>
        # @throws BadLocationException if accessing the document failed
        def make_empty(selection, beginning)
          return selection
        end
        
        typesig { [class_self::ISelection] }
        # Returns the text regions covered by the given selection.
        # 
        # @param selection the selection
        # @return the text regions corresponding to <code>selection</code>
        # @throws BadLocationException if accessing the document failed
        def get_ranges(selection)
          return Array.typed(self.class::IRegion).new(0) { nil }
        end
        
        typesig { [class_self::ISelection] }
        # Returns the number of lines touched by <code>selection</code>.
        # 
        # @param selection the selection
        # @return the number of lines touched by <code>selection</code>
        # @throws BadLocationException if accessing the document failed
        def get_covered_lines(selection)
          return 0
        end
        
        typesig { [class_self::ISelection, String] }
        # Returns the selection after replacing <code>selection</code> by <code>replacement</code>.
        # 
        # @param selection the selection to be replaced
        # @param replacement the replacement text
        # @return the selection that the user expects after the specified replacement operation
        # @throws BadLocationException if accessing the document failed
        def make_replace_selection(selection, replacement)
          return make_empty(selection, false)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__implementation, :initialize
      end }
    }
    
    attr_accessor :null_implementation
    alias_method :attr_null_implementation, :null_implementation
    undef_method :null_implementation
    alias_method :attr_null_implementation=, :null_implementation=
    undef_method :null_implementation=
    
    attr_accessor :range_implementation
    alias_method :attr_range_implementation, :range_implementation
    undef_method :range_implementation
    alias_method :attr_range_implementation=, :range_implementation=
    undef_method :range_implementation=
    
    attr_accessor :column_implementation
    alias_method :attr_column_implementation, :column_implementation
    undef_method :column_implementation
    alias_method :attr_column_implementation=, :column_implementation=
    undef_method :column_implementation=
    
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    attr_accessor :f_tab_width
    alias_method :attr_f_tab_width, :f_tab_width
    undef_method :f_tab_width
    alias_method :attr_f_tab_width=, :f_tab_width=
    undef_method :f_tab_width=
    
    attr_accessor :f_rewrite_target
    alias_method :attr_f_rewrite_target, :f_rewrite_target
    undef_method :f_rewrite_target
    alias_method :attr_f_rewrite_target=, :f_rewrite_target=
    undef_method :f_rewrite_target=
    
    attr_accessor :f_selection_provider
    alias_method :attr_f_selection_provider, :f_selection_provider
    undef_method :f_selection_provider
    alias_method :attr_f_selection_provider=, :f_selection_provider=
    undef_method :f_selection_provider=
    
    typesig { [ITextViewer] }
    # Creates a new processor on the given viewer.
    # 
    # @param viewer the viewer
    def initialize(viewer)
      initialize__selection_processor(viewer.get_document, viewer.get_text_widget.get_tabs)
      if (viewer.is_a?(ITextViewerExtension))
        ext = viewer
        @f_rewrite_target = ext.get_rewrite_target
      end
      @f_selection_provider = viewer.get_selection_provider
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Creates a new processor on the given document and using the given tab width.
    # 
    # @param document the document
    # @param tabWidth the tabulator width in space equivalents
    def initialize(document, tab_width)
      @null_implementation = Implementation.new
      @range_implementation = Class.new(Implementation.class == Class ? Implementation : Object) do
        extend LocalClass
        include_class_members SelectionProcessor
        include Implementation if Implementation.class == Module
        
        typesig { [ISelection, String] }
        define_method :replace do |selection, replacement|
          ts = selection
          return self.class::ReplaceEdit.new(ts.get_offset, ts.get_length, replacement)
        end
        
        typesig { [ISelection] }
        define_method :get_text do |selection|
          ts = selection
          return ts.get_text
        end
        
        typesig { [ISelection] }
        define_method :is_empty do |selection|
          ts = selection
          return ts.get_length <= 0
        end
        
        typesig { [ISelection] }
        define_method :is_multiline do |selection|
          ts = selection
          return self.attr_f_document.get_line_of_offset(ts.get_offset) < self.attr_f_document.get_line_of_offset(ts.get_offset + ts.get_length)
        end
        
        typesig { [ISelection] }
        define_method :delete do |selection|
          ts = selection
          if (is_empty(selection))
            return self.class::DeleteEdit.new(ts.get_offset, 1)
          end
          return self.class::DeleteEdit.new(ts.get_offset, ts.get_length)
        end
        
        typesig { [ISelection] }
        define_method :backspace do |selection|
          ts = selection
          if (is_empty(selection))
            return self.class::DeleteEdit.new(ts.get_offset - 1, 1)
          end
          return self.class::DeleteEdit.new(ts.get_offset, ts.get_length)
        end
        
        typesig { [ISelection, ::Java::Boolean] }
        define_method :make_empty do |selection, beginning|
          ts = selection
          return beginning ? self.class::TextSelection.new(self.attr_f_document, ts.get_offset, 0) : self.class::TextSelection.new(self.attr_f_document, ts.get_offset + ts.get_length, 0)
        end
        
        typesig { [ISelection] }
        define_method :get_ranges do |selection|
          ts = selection
          return Array.typed(self.class::IRegion).new([self.class::Region.new(ts.get_offset, ts.get_length)])
        end
        
        typesig { [ISelection] }
        define_method :get_covered_lines do |selection|
          ts = selection
          return ts.get_end_line - ts.get_start_line + 1
        end
        
        typesig { [ISelection, String] }
        define_method :make_replace_selection do |selection, replacement|
          ts = selection
          return self.class::TextSelection.new(self.attr_f_document, ts.get_offset + replacement.length, 0)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @column_implementation = Class.new(Implementation.class == Class ? Implementation : Object) do
        extend LocalClass
        include_class_members SelectionProcessor
        include Implementation if Implementation.class == Module
        
        typesig { [ISelection, String] }
        define_method :replace do |selection, replacement|
          begin
            root = nil
            cts = selection
            start_line = cts.get_start_line
            end_line = cts.get_end_line
            start_column = cts.get_start_column
            end_column = cts.get_end_column
            visual_start_column = compute_visual_column(start_line, start_column)
            visual_end_column = compute_visual_column(end_line, end_column)
            root = self.class::MultiTextEdit.new
            delimiters = self.attr_f_document.get_legal_line_delimiters
            last_delim = 0
            line = start_line
            while line <= end_line
              string = nil
              if ((last_delim).equal?(-1))
                string = "" # $NON-NLS-1$
              else
                index = TextUtilities.index_of(delimiters, replacement, last_delim)
                if ((index[0]).equal?(-1))
                  string = RJava.cast_to_string(replacement.substring(last_delim))
                  last_delim = -1
                else
                  string = RJava.cast_to_string(replacement.substring(last_delim, index[0]))
                  last_delim = index[0] + delimiters[index[1]].length
                end
              end
              replace = create_replace_edit(line, visual_start_column, visual_end_column, string)
              root.add_child(replace)
              line += 1
            end
            while (!(last_delim).equal?(-1))
              # more stuff to insert
              string = nil
              index = TextUtilities.index_of(delimiters, replacement, last_delim)
              if ((index[0]).equal?(-1))
                string = RJava.cast_to_string(replacement.substring(last_delim))
                last_delim = -1
              else
                string = RJava.cast_to_string(replacement.substring(last_delim, index[0]))
                last_delim = index[0] + delimiters[index[1]].length
              end
              end_line += 1
              edit = nil
              if (end_line < self.attr_f_document.get_number_of_lines)
                edit = create_replace_edit(end_line, visual_start_column, visual_end_column, string)
              else
                # insertion reaches beyond the last line
                insert_location = root.get_exclusive_end
                spaces = visual_start_column
                array = CharArray.new(spaces)
                Arrays.fill(array, Character.new(?\s.ord))
                string = RJava.cast_to_string(self.attr_f_document.get_legal_line_delimiters[0] + String.value_of(array)) + string
                edit = self.class::InsertEdit.new(insert_location, string)
                insert_location += string.length
              end
              root.add_child(edit)
            end
            return root
          rescue self.class::MalformedTreeException => x
            Assert.is_true(false)
            return nil
          end
        end
        
        typesig { [ISelection] }
        define_method :get_text do |selection|
          cts = selection
          buf = self.class::StringBuffer.new(cts.get_length)
          start_line = cts.get_start_line
          end_line = cts.get_end_line
          start_column = cts.get_start_column
          end_column = cts.get_end_column
          visual_start_column = compute_visual_column(start_line, start_column)
          visual_end_column = compute_visual_column(end_line, end_column)
          line = start_line
          while line <= end_line
            append_column_range(buf, line, visual_start_column, visual_end_column)
            if (!(line).equal?(end_line))
              buf.append(self.attr_f_document.get_line_delimiter(line))
            end
            line += 1
          end
          return buf.to_s
        end
        
        typesig { [ISelection] }
        define_method :is_empty do |selection|
          cts = selection
          start_line = cts.get_start_line
          end_line = cts.get_end_line
          start_column = cts.get_start_column
          end_column = cts.get_end_column
          visual_start_column = compute_visual_column(start_line, start_column)
          visual_end_column = compute_visual_column(end_line, end_column)
          return (visual_end_column).equal?(visual_start_column)
        end
        
        typesig { [ISelection] }
        define_method :is_multiline do |selection|
          ts = selection
          return ts.get_end_line > ts.get_start_line
        end
        
        typesig { [ISelection] }
        define_method :delete do |selection|
          if (is_empty(selection))
            cts = selection
            selection = self.class::BlockTextSelection.new(self.attr_f_document, cts.get_start_line, cts.get_start_column, cts.get_end_line, cts.get_end_column + 1, self.attr_f_tab_width)
          end
          return replace(selection, "") # $NON-NLS-1$
        end
        
        typesig { [ISelection] }
        define_method :backspace do |selection|
          cts = selection
          if (is_empty(selection) && cts.get_start_column > 0)
            selection = self.class::BlockTextSelection.new(self.attr_f_document, cts.get_start_line, cts.get_start_column - 1, cts.get_end_line, cts.get_end_column, self.attr_f_tab_width)
          end
          return replace(selection, "") # $NON-NLS-1$
        end
        
        typesig { [ISelection, ::Java::Boolean] }
        define_method :make_empty do |selection, beginning|
          cts = selection
          start_line = 0
          start_column = 0
          end_line = 0
          end_column = 0
          if (beginning)
            start_line = cts.get_start_line
            start_column = cts.get_start_column
            end_line = cts.get_end_line
            end_column = compute_character_column(end_line, compute_visual_column(start_line, start_column))
          else
            end_line = cts.get_end_line
            end_column = cts.get_end_column
            start_line = cts.get_start_line
            start_column = compute_character_column(start_line, compute_visual_column(end_line, end_column))
          end
          return self.class::BlockTextSelection.new(self.attr_f_document, start_line, start_column, end_line, end_column, self.attr_f_tab_width)
        end
        
        typesig { [ISelection, String] }
        define_method :make_replace_selection do |selection, replacement|
          bts = selection
          delimiters = self.attr_f_document.get_legal_line_delimiters
          index = TextUtilities.index_of(delimiters, replacement, 0)
          length_ = 0
          if ((index[0]).equal?(-1))
            length_ = replacement.length
          else
            length_ = index[0]
          end
          start_line = bts.get_start_line
          column = bts.get_start_column + length_
          end_line = bts.get_end_line
          end_column = compute_character_column(end_line, compute_visual_column(start_line, column))
          return self.class::BlockTextSelection.new(self.attr_f_document, start_line, column, end_line, end_column, self.attr_f_tab_width)
        end
        
        typesig { [ISelection] }
        define_method :get_ranges do |selection|
          cts = selection
          start_line = cts.get_start_line
          end_line = cts.get_end_line
          visual_start_column = compute_visual_column(start_line, cts.get_start_column)
          visual_end_column = compute_visual_column(end_line, cts.get_end_column)
          ranges = Array.typed(self.class::IRegion).new(end_line - start_line + 1) { nil }
          line = start_line
          while line <= end_line
            start_column = compute_character_column(line, visual_start_column)
            end_column = compute_character_column(line, visual_end_column)
            line_info = self.attr_f_document.get_line_information(line)
            line_end = line_info.get_length
            start_column = Math.min(start_column, line_end)
            end_column = Math.min(end_column, line_end)
            ranges[line - start_line] = self.class::Region.new(line_info.get_offset + start_column, end_column - start_column)
            line += 1
          end
          return ranges
        end
        
        typesig { [ISelection] }
        define_method :get_covered_lines do |selection|
          ts = selection
          return ts.get_end_line - ts.get_start_line + 1
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int, String] }
        define_method :create_replace_edit do |line, visual_start_column, visual_end_column, replacement|
          info = self.attr_f_document.get_line_information(line)
          line_length = info.get_length
          content = self.attr_f_document.get(info.get_offset, line_length)
          start_column = -1
          end_column = -1
          visual = 0
          offset = 0
          while offset < line_length
            if ((start_column).equal?(-1) && visual >= visual_start_column)
              start_column = offset
            end
            if ((visual).equal?(visual_end_column))
              end_column = offset
              break
            end
            if ((content.char_at(offset)).equal?(Character.new(?\t.ord)))
              visual += self.attr_f_tab_width - visual % self.attr_f_tab_width
            else
              visual += 1
            end
            offset += 1
          end
          if ((start_column).equal?(-1))
            materialize_virtual_space = !(replacement.length).equal?(0)
            if (materialize_virtual_space)
              spaces = Math.max(0, visual_start_column - visual)
              array = CharArray.new(spaces)
              Arrays.fill(array, Character.new(?\s.ord))
              return self.class::InsertEdit.new(info.get_offset + line_length, RJava.cast_to_string(String.value_of(array)) + replacement)
            end
            return self.class::MultiTextEdit.new
          end
          if ((end_column).equal?(-1))
            end_column = line_length
          end
          if ((replacement.length).equal?(0))
            return self.class::DeleteEdit.new(info.get_offset + start_column, end_column - start_column)
          end
          return self.class::ReplaceEdit.new(info.get_offset + start_column, end_column - start_column, replacement)
        end
        
        typesig { [StringBuffer, ::Java::Int, ::Java::Int, ::Java::Int] }
        define_method :append_column_range do |buf, line, visual_start_column, visual_end_column|
          info = self.attr_f_document.get_line_information(line)
          line_length = info.get_length
          content = self.attr_f_document.get(info.get_offset, line_length)
          start_column = -1
          end_column = -1
          visual = 0
          offset = 0
          while offset < line_length
            if ((start_column).equal?(-1) && visual >= visual_start_column)
              start_column = offset
            end
            if (visual >= visual_end_column)
              end_column = offset
              break
            end
            if ((content.char_at(offset)).equal?(Character.new(?\t.ord)))
              visual += self.attr_f_tab_width - visual % self.attr_f_tab_width
            else
              visual += 1
            end
            offset += 1
          end
          if (!(start_column).equal?(-1))
            buf.append(content.substring(start_column, (end_column).equal?(-1) ? line_length : end_column))
          end
          if ((end_column).equal?(-1))
            spaces = Math.max(0, visual_end_column - Math.max(visual, visual_start_column))
            i = 0
            while i < spaces
              buf.append(Character.new(?\s.ord))
              i += 1
            end
          end
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        define_method :compute_visual_column do |line, column|
          info = self.attr_f_document.get_line_information(line)
          line_length = info.get_length
          to = Math.min(line_length, column)
          content = self.attr_f_document.get(info.get_offset, line_length)
          visual = 0
          offset = 0
          while offset < to
            if ((content.char_at(offset)).equal?(Character.new(?\t.ord)))
              visual += self.attr_f_tab_width - visual % self.attr_f_tab_width
            else
              visual += 1
            end
            offset += 1
          end
          if (column > line_length)
            visual += column - line_length # virtual spaces
          end
          return visual
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        define_method :compute_character_column do |line, visual_column|
          info = self.attr_f_document.get_line_information(line)
          line_length = info.get_length
          content = self.attr_f_document.get(info.get_offset, line_length)
          visual = 0
          offset = 0
          while offset < line_length
            if (visual >= visual_column)
              return offset
            end
            if ((content.char_at(offset)).equal?(Character.new(?\t.ord)))
              visual += self.attr_f_tab_width - visual % self.attr_f_tab_width
            else
              visual += 1
            end
            offset += 1
          end
          return line_length + Math.max(0, visual_column - visual)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_document = nil
      @f_tab_width = 0
      @f_rewrite_target = nil
      @f_selection_provider = nil
      Assert.is_not_null(document)
      Assert.is_true(tab_width > 0)
      @f_document = document
      @f_tab_width = tab_width
    end
    
    typesig { [ISelection] }
    # Returns a text edit describing the text modification that would be executed if the delete key
    # was pressed on the given selection.
    # 
    # @param selection the selection to delete
    # @return a text edit describing the operation needed to delete <code>selection</code>
    # @throws BadLocationException if computing the edit failed
    def delete(selection)
      return get_implementation(selection).delete(selection)
    end
    
    typesig { [ISelection] }
    # Returns a text edit describing the text modification that would be executed if the backspace
    # key was pressed on the given selection.
    # 
    # @param selection the selection to delete
    # @return a text edit describing the operation needed to delete <code>selection</code>
    # @throws BadLocationException if computing the edit failed
    def backspace(selection)
      return get_implementation(selection).backspace(selection)
    end
    
    typesig { [ISelection, String] }
    # Returns a text edit describing the text modification that would be executed if the given
    # selection was replaced by <code>replacement</code>.
    # 
    # @param selection the selection to replace
    # @param replacement the replacement text
    # @return a text edit describing the operation needed to replace <code>selection</code>
    # @throws BadLocationException if computing the edit failed
    def replace(selection, replacement)
      return get_implementation(selection).replace(selection, replacement)
    end
    
    typesig { [ISelection] }
    # Returns the text covered by <code>selection</code>
    # 
    # @param selection the selection
    # @return the text covered by <code>selection</code>
    # @throws BadLocationException if computing the edit failed
    def get_text(selection)
      return get_implementation(selection).get_text(selection)
    end
    
    typesig { [ISelection] }
    # Returns <code>true</code> if the text covered by <code>selection</code> does not contain any
    # characters. Note the difference to {@link ITextSelection#isEmpty()}, which returns
    # <code>true</code> only for invalid selections.
    # 
    # @param selection the selection
    # @return <code>true</code> if <code>selection</code> does not contain any text,
    # <code>false</code> otherwise
    # @throws BadLocationException if accessing the document failed
    def is_empty(selection)
      return get_implementation(selection).is_empty(selection)
    end
    
    typesig { [ISelection] }
    # Returns <code>true</code> if <code>selection</code> extends to two or more lines,
    # <code>false</code> otherwise.
    # 
    # @param selection the selection
    # @return <code>true</code> if <code>selection</code> extends to two or more lines,
    # <code>false</code> otherwise
    # @throws BadLocationException if <code>selection</code> is not valid regarding the target
    # document
    def is_multiline(selection)
      return get_implementation(selection).is_multiline(selection)
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    # Returns a selection similar to <code>selection</code> but {@linkplain #isEmpty(ISelection)
    # empty}. Typically, the selection is reduced to its extreme offsets.
    # 
    # @param selection the selection
    # @param beginning <code>true</code> to collapse the selection to its smallest position (i.e.
    # its left-most offset), <code>false</code> to collapse it to its greatest position
    # (e.g its right-most offset)
    # @return an empty variant of <code>selection</code>
    # @throws BadLocationException if accessing the document failed
    def make_empty(selection, beginning)
      return get_implementation(selection).make_empty(selection, beginning)
    end
    
    typesig { [ISelection, String] }
    def make_replace_selection(selection, replacement)
      return get_implementation(selection).make_replace_selection(selection, replacement)
    end
    
    typesig { [ISelection] }
    # Convenience method that applies the edit returned from {@link #delete(ISelection)} to the
    # underlying document.
    # 
    # @param selection the selection to delete
    # @throws BadLocationException if accessing the document failed
    def do_delete(selection)
      edit = delete(selection)
      complex = edit.has_children
      if (complex && !(@f_rewrite_target).nil?)
        @f_rewrite_target.begin_compound_change
      end
      begin
        edit.apply(@f_document, TextEdit::UPDATE_REGIONS)
        if (!(@f_selection_provider).nil?)
          empty = make_empty(selection, true)
          @f_selection_provider.set_selection(empty)
        end
      ensure
        if (complex && !(@f_rewrite_target).nil?)
          @f_rewrite_target.end_compound_change
        end
      end
    end
    
    typesig { [ISelection, String] }
    # Convenience method that applies the edit returned from {@link #replace(ISelection, String)}
    # to the underlying document and adapts the selection accordingly.
    # 
    # @param selection the selection to replace
    # @param replacement the replacement text
    # @throws BadLocationException if accessing the document failed
    def do_replace(selection, replacement)
      edit = replace(selection, replacement)
      complex = edit.has_children
      if (complex && !(@f_rewrite_target).nil?)
        @f_rewrite_target.begin_compound_change
      end
      begin
        edit.apply(@f_document, TextEdit::UPDATE_REGIONS)
        if (!(@f_selection_provider).nil?)
          empty = make_replace_selection(selection, replacement)
          @f_selection_provider.set_selection(empty)
        end
      ensure
        if (complex && !(@f_rewrite_target).nil?)
          @f_rewrite_target.end_compound_change
        end
      end
    end
    
    typesig { [ISelection] }
    # Returns the text regions covered by the given selection.
    # 
    # @param selection the selection
    # @return the text regions corresponding to <code>selection</code>
    # @throws BadLocationException if accessing the document failed
    def get_ranges(selection)
      return get_implementation(selection).get_ranges(selection)
    end
    
    typesig { [ISelection] }
    # Returns the number of lines touched by <code>selection</code>. Note that for linear
    # selections, this is the number of contained delimiters plus 1.
    # 
    # @param selection the selection
    # @return the number of lines touched by <code>selection</code>
    # @throws BadLocationException if accessing the document failed
    def get_covered_lines(selection)
      return get_implementation(selection).get_covered_lines(selection)
    end
    
    typesig { [ISelection] }
    # Returns the implementation.
    # 
    # @param selection the selection
    # @return the corresponding processor implementation
    def get_implementation(selection)
      if (selection.is_a?(IBlockTextSelection))
        return @column_implementation
      else
        if (selection.is_a?(ITextSelection))
          return @range_implementation
        else
          return @null_implementation
        end
      end
    end
    
    private
    alias_method :initialize__selection_processor, :initialize
  end
  
end
