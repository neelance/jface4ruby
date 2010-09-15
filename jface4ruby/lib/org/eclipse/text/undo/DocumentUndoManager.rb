require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Undo
  module DocumentUndoManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Undo
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands::Operations, :AbstractOperation
      include_const ::Org::Eclipse::Core::Commands::Operations, :IContextReplacingOperation
      include_const ::Org::Eclipse::Core::Commands::Operations, :IOperationHistory
      include_const ::Org::Eclipse::Core::Commands::Operations, :IOperationHistoryListener
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoContext
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoableOperation
      include_const ::Org::Eclipse::Core::Commands::Operations, :ObjectUndoContext
      include_const ::Org::Eclipse::Core::Commands::Operations, :OperationHistoryEvent
      include_const ::Org::Eclipse::Core::Commands::Operations, :OperationHistoryFactory
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension4
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
    }
  end
  
  # A standard implementation of a document-based undo manager that
  # creates an undo history based on changes to its document.
  # <p>
  # Based on the 3.1 implementation of DefaultUndoManager, it was implemented
  # using the document-related manipulations defined in the original
  # DefaultUndoManager, by separating the document manipulations from the
  # viewer-specific processing.</p>
  # <p>
  # The classes representing individual text edits (formerly text commands)
  # were promoted from inner types to their own classes in order to support
  # reassignment to a different undo manager.<p>
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # 
  # @see IDocumentUndoManager
  # @see DocumentUndoManagerRegistry
  # @see IDocumentUndoListener
  # @see org.eclipse.jface.text.IDocument
  # @since 3.2
  # @noextend This class is not intended to be subclassed by clients.
  class DocumentUndoManager 
    include_class_members DocumentUndoManagerImports
    include IDocumentUndoManager
    
    class_module.module_eval {
      # Represents an undo-able text change, described as the
      # replacement of some preserved text with new text.
      # <p>
      # Based on the DefaultUndoManager.TextCommand from R3.1.
      # </p>
      const_set_lazy(:UndoableTextChange) { Class.new(AbstractOperation) do
        include_class_members DocumentUndoManager
        
        # The start index of the replaced text.
        attr_accessor :f_start
        alias_method :attr_f_start, :f_start
        undef_method :f_start
        alias_method :attr_f_start=, :f_start=
        undef_method :f_start=
        
        # The end index of the replaced text.
        attr_accessor :f_end
        alias_method :attr_f_end, :f_end
        undef_method :f_end
        alias_method :attr_f_end=, :f_end=
        undef_method :f_end=
        
        # The newly inserted text.
        attr_accessor :f_text
        alias_method :attr_f_text, :f_text
        undef_method :f_text
        alias_method :attr_f_text=, :f_text=
        undef_method :f_text=
        
        # The replaced text.
        attr_accessor :f_preserved_text
        alias_method :attr_f_preserved_text, :f_preserved_text
        undef_method :f_preserved_text
        alias_method :attr_f_preserved_text=, :f_preserved_text=
        undef_method :f_preserved_text=
        
        # The undo modification stamp.
        attr_accessor :f_undo_modification_stamp
        alias_method :attr_f_undo_modification_stamp, :f_undo_modification_stamp
        undef_method :f_undo_modification_stamp
        alias_method :attr_f_undo_modification_stamp=, :f_undo_modification_stamp=
        undef_method :f_undo_modification_stamp=
        
        # The redo modification stamp.
        attr_accessor :f_redo_modification_stamp
        alias_method :attr_f_redo_modification_stamp, :f_redo_modification_stamp
        undef_method :f_redo_modification_stamp
        alias_method :attr_f_redo_modification_stamp=, :f_redo_modification_stamp=
        undef_method :f_redo_modification_stamp=
        
        # The undo manager that generated the change.
        attr_accessor :f_document_undo_manager
        alias_method :attr_f_document_undo_manager, :f_document_undo_manager
        undef_method :f_document_undo_manager
        alias_method :attr_f_document_undo_manager=, :f_document_undo_manager=
        undef_method :f_document_undo_manager=
        
        typesig { [class_self::DocumentUndoManager] }
        # Creates a new text change.
        # 
        # @param manager the undo manager for this change
        def initialize(manager)
          @f_start = 0
          @f_end = 0
          @f_text = nil
          @f_preserved_text = nil
          @f_undo_modification_stamp = 0
          @f_redo_modification_stamp = 0
          @f_document_undo_manager = nil
          super(UndoMessages.get_string("DocumentUndoManager.operationLabel"))
          @f_start = -1
          @f_end = -1
          @f_undo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
          @f_redo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP # $NON-NLS-1$
          @f_document_undo_manager = manager
          add_context(manager.get_undo_context)
        end
        
        typesig { [] }
        # Re-initializes this text change.
        def reinitialize
          @f_start = @f_end = -1
          @f_text = RJava.cast_to_string(@f_preserved_text = RJava.cast_to_string(nil))
          @f_undo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
          @f_redo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Sets the start and the end index of this change.
        # 
        # @param start the start index
        # @param end the end index
        def set(start, end_)
          @f_start = start
          @f_end = end_
          @f_text = RJava.cast_to_string(nil)
          @f_preserved_text = RJava.cast_to_string(nil)
        end
        
        typesig { [] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#dispose()
        def dispose
          reinitialize
        end
        
        typesig { [] }
        # Undo the change described by this change.
        def undo_text_change
          begin
            if (@f_document_undo_manager.attr_f_document.is_a?(self.class::IDocumentExtension4))
              (@f_document_undo_manager.attr_f_document).replace(@f_start, @f_text.length, @f_preserved_text, @f_undo_modification_stamp)
            else
              @f_document_undo_manager.attr_f_document.replace(@f_start, @f_text.length, @f_preserved_text)
            end
          rescue self.class::BadLocationException => x
          end
        end
        
        typesig { [] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#canUndo()
        def can_undo
          if (is_valid)
            if (@f_document_undo_manager.attr_f_document.is_a?(self.class::IDocumentExtension4))
              doc_stamp = (@f_document_undo_manager.attr_f_document).get_modification_stamp
              # Normal case: an undo is valid if its redo will restore
              # document to its current modification stamp
              can_undo = (doc_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP) || (doc_stamp).equal?(get_redo_modification_stamp)
              # Special case to check if the answer is false. If the last
              # document change was empty, then the document's modification
              # stamp was incremented but nothing was committed. The
              # operation being queried has an older stamp. In this case
              # only, the comparison is different. A sequence of document
              # changes that include an empty change is handled correctly
              # when a valid commit follows the empty change, but when
              # #canUndo() is queried just after an empty change, we must
              # special case the check. The check is very specific to prevent
              # false positives. see
              # https://bugs.eclipse.org/bugs/show_bug.cgi?id=98245
              # 
              # this is the latest operation
              # there is a more current operation not on the stack
              # the current operation is not a valid document
              # modification
              # the invalid current operation has a document stamp
              if (!can_undo && (self).equal?(@f_document_undo_manager.attr_f_history.get_undo_operation(@f_document_undo_manager.attr_f_undo_context)) && !(self).equal?(@f_document_undo_manager.attr_f_current) && !@f_document_undo_manager.attr_f_current.is_valid && !(@f_document_undo_manager.attr_f_current.attr_f_undo_modification_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP))
                can_undo = (@f_document_undo_manager.attr_f_current.attr_f_redo_modification_stamp).equal?(doc_stamp)
              end
              # When the composite is the current operation, it may hold the
              # timestamp of a no-op change. We check this here rather than
              # in an override of canUndo() in UndoableCompoundTextChange simply to
              # keep all the special case checks in one place.
              # 
              # this is the latest operation
              # this is the current operation
              # the current operation text is not valid
              if (!can_undo && (self).equal?(@f_document_undo_manager.attr_f_history.get_undo_operation(@f_document_undo_manager.attr_f_undo_context)) && self.is_a?(self.class::UndoableCompoundTextChange) && (self).equal?(@f_document_undo_manager.attr_f_current) && (@f_start).equal?(-1) && !(@f_document_undo_manager.attr_f_current.attr_f_redo_modification_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP))
                # but it has a redo stamp
                can_undo = (@f_document_undo_manager.attr_f_current.attr_f_redo_modification_stamp).equal?(doc_stamp)
              end
              return can_undo
            end
            # if there is no timestamp to check, simply return true per the
            # 3.0.1 behavior
            return true
          end
          return false
        end
        
        typesig { [] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#canRedo()
        def can_redo
          if (is_valid)
            if (@f_document_undo_manager.attr_f_document.is_a?(self.class::IDocumentExtension4))
              doc_stamp = (@f_document_undo_manager.attr_f_document).get_modification_stamp
              return (doc_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP) || (doc_stamp).equal?(get_undo_modification_stamp)
            end
            # if there is no timestamp to check, simply return true per the
            # 3.0.1 behavior
            return true
          end
          return false
        end
        
        typesig { [] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#canExecute()
        def can_execute
          return @f_document_undo_manager.is_connected
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation.IUndoableOperation#execute(IProgressMonitor, IAdaptable)
        def execute(monitor, ui_info)
          # Text changes execute as they are typed, so executing one has no
          # effect.
          return Status::OK_STATUS
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # {@inheritDoc}
        # Notifies clients about the undo.
        def undo(monitor, ui_info)
          if (is_valid)
            @f_document_undo_manager.fire_document_undo(@f_start, @f_preserved_text, @f_text, ui_info, DocumentUndoEvent::ABOUT_TO_UNDO, false)
            undo_text_change
            @f_document_undo_manager.reset_process_change_state
            @f_document_undo_manager.fire_document_undo(@f_start, @f_preserved_text, @f_text, ui_info, DocumentUndoEvent::UNDONE, false)
            return Status::OK_STATUS
          end
          return IOperationHistory::OPERATION_INVALID_STATUS
        end
        
        typesig { [] }
        # Re-applies the change described by this change.
        def redo_text_change
          begin
            if (@f_document_undo_manager.attr_f_document.is_a?(self.class::IDocumentExtension4))
              (@f_document_undo_manager.attr_f_document).replace(@f_start, @f_end - @f_start, @f_text, @f_redo_modification_stamp)
            else
              @f_document_undo_manager.attr_f_document.replace(@f_start, @f_end - @f_start, @f_text)
            end
          rescue self.class::BadLocationException => x
          end
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # Re-applies the change described by this change that was previously
        # undone. Also notifies clients about the redo.
        # 
        # @param monitor the progress monitor to use if necessary
        # @param uiInfo an adaptable that can provide UI info if needed
        # @return the status
        def redo_(monitor, ui_info)
          if (is_valid)
            @f_document_undo_manager.fire_document_undo(@f_start, @f_text, @f_preserved_text, ui_info, DocumentUndoEvent::ABOUT_TO_REDO, false)
            redo_text_change
            @f_document_undo_manager.reset_process_change_state
            @f_document_undo_manager.fire_document_undo(@f_start, @f_text, @f_preserved_text, ui_info, DocumentUndoEvent::REDONE, false)
            return Status::OK_STATUS
          end
          return IOperationHistory::OPERATION_INVALID_STATUS
        end
        
        typesig { [] }
        # Update the change in response to a commit.
        def update_text_change
          @f_text = RJava.cast_to_string(@f_document_undo_manager.attr_f_text_buffer.to_s)
          @f_document_undo_manager.attr_f_text_buffer.set_length(0)
          @f_preserved_text = RJava.cast_to_string(@f_document_undo_manager.attr_f_preserved_text_buffer.to_s)
          @f_document_undo_manager.attr_f_preserved_text_buffer.set_length(0)
        end
        
        typesig { [] }
        # Creates a new uncommitted text change depending on whether a compound
        # change is currently being executed.
        # 
        # @return a new, uncommitted text change or a compound text change
        def create_current
          if (@f_document_undo_manager.attr_f_folding_into_compound_change)
            return self.class::UndoableCompoundTextChange.new(@f_document_undo_manager)
          end
          return self.class::UndoableTextChange.new(@f_document_undo_manager)
        end
        
        typesig { [] }
        # Commits the current change into this one.
        def commit
          if (@f_start < 0)
            if (@f_document_undo_manager.attr_f_folding_into_compound_change)
              @f_document_undo_manager.attr_f_current = create_current
            else
              reinitialize
            end
          else
            update_text_change
            @f_document_undo_manager.attr_f_current = create_current
          end
          @f_document_undo_manager.reset_process_change_state
        end
        
        typesig { [] }
        # Updates the text from the buffers without resetting the buffers or adding
        # anything to the stack.
        def pretend_commit
          if (@f_start > -1)
            @f_text = RJava.cast_to_string(@f_document_undo_manager.attr_f_text_buffer.to_s)
            @f_preserved_text = RJava.cast_to_string(@f_document_undo_manager.attr_f_preserved_text_buffer.to_s)
          end
        end
        
        typesig { [] }
        # Attempt a commit of this change and answer true if a new fCurrent was
        # created as a result of the commit.
        # 
        # @return <code>true</code> if the change was committed and created
        # a new <code>fCurrent</code>, <code>false</code> if not
        def attempt_commit
          pretend_commit
          if (is_valid)
            @f_document_undo_manager.commit
            return true
          end
          return false
        end
        
        typesig { [] }
        # Checks whether this text change is valid for undo or redo.
        # 
        # @return <code>true</code> if the change is valid for undo or redo
        def is_valid
          return @f_start > -1 && @f_end > -1 && !(@f_text).nil?
        end
        
        typesig { [] }
        # @see java.lang.Object#toString()
        def to_s
          delimiter = ", " # $NON-NLS-1$
          text = self.class::StringBuffer.new(super)
          text.append("\n") # $NON-NLS-1$
          text.append(self.get_class.get_name)
          text.append(" undo modification stamp: ") # $NON-NLS-1$
          text.append(@f_undo_modification_stamp)
          text.append(" redo modification stamp: ") # $NON-NLS-1$
          text.append(@f_redo_modification_stamp)
          text.append(" start: ") # $NON-NLS-1$
          text.append(@f_start)
          text.append(delimiter)
          text.append("end: ") # $NON-NLS-1$
          text.append(@f_end)
          text.append(delimiter)
          text.append("text: '") # $NON-NLS-1$
          text.append(@f_text)
          text.append(Character.new(?\'.ord))
          text.append(delimiter)
          text.append("preservedText: '") # $NON-NLS-1$
          text.append(@f_preserved_text)
          text.append(Character.new(?\'.ord))
          return text.to_s
        end
        
        typesig { [] }
        # Return the undo modification stamp
        # 
        # @return the undo modification stamp for this change
        def get_undo_modification_stamp
          return @f_undo_modification_stamp
        end
        
        typesig { [] }
        # Return the redo modification stamp
        # 
        # @return the redo modification stamp for this change
        def get_redo_modification_stamp
          return @f_redo_modification_stamp
        end
        
        private
        alias_method :initialize__undoable_text_change, :initialize
      end }
      
      # Represents an undo-able text change consisting of several individual
      # changes.
      const_set_lazy(:UndoableCompoundTextChange) { Class.new(UndoableTextChange) do
        include_class_members DocumentUndoManager
        
        # The list of individual changes
        attr_accessor :f_changes
        alias_method :attr_f_changes, :f_changes
        undef_method :f_changes
        alias_method :attr_f_changes=, :f_changes=
        undef_method :f_changes=
        
        typesig { [class_self::DocumentUndoManager] }
        # Creates a new compound text change.
        # 
        # @param manager the undo manager for this change
        def initialize(manager)
          @f_changes = nil
          super(manager)
          @f_changes = self.class::ArrayList.new
        end
        
        typesig { [class_self::UndoableTextChange] }
        # Adds a new individual change to this compound change.
        # 
        # @param change the change to be added
        def add(change)
          @f_changes.add(change)
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # @see org.eclipse.text.undo.UndoableTextChange#undo(org.eclipse.core.runtime.IProgressMonitor, org.eclipse.core.runtime.IAdaptable)
        def undo(monitor, ui_info)
          size_ = @f_changes.size
          if (size_ > 0)
            c = nil
            c = @f_changes.get(0)
            self.attr_f_document_undo_manager.fire_document_undo(c.attr_f_start, c.attr_f_preserved_text, c.attr_f_text, ui_info, DocumentUndoEvent::ABOUT_TO_UNDO, true)
            i = size_ - 1
            while i >= 0
              c = @f_changes.get(i)
              c.undo_text_change
              (i -= 1)
            end
            self.attr_f_document_undo_manager.reset_process_change_state
            self.attr_f_document_undo_manager.fire_document_undo(c.attr_f_start, c.attr_f_preserved_text, c.attr_f_text, ui_info, DocumentUndoEvent::UNDONE, true)
          end
          return Status::OK_STATUS
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # @see org.eclipse.text.undo.UndoableTextChange#redo(org.eclipse.core.runtime.IProgressMonitor, org.eclipse.core.runtime.IAdaptable)
        def redo_(monitor, ui_info)
          size_ = @f_changes.size
          if (size_ > 0)
            c = nil
            c = @f_changes.get(size_ - 1)
            self.attr_f_document_undo_manager.fire_document_undo(c.attr_f_start, c.attr_f_text, c.attr_f_preserved_text, ui_info, DocumentUndoEvent::ABOUT_TO_REDO, true)
            i = 0
            while i <= size_ - 1
              c = @f_changes.get(i)
              c.redo_text_change
              (i += 1)
            end
            self.attr_f_document_undo_manager.reset_process_change_state
            self.attr_f_document_undo_manager.fire_document_undo(c.attr_f_start, c.attr_f_text, c.attr_f_preserved_text, ui_info, DocumentUndoEvent::REDONE, true)
          end
          return Status::OK_STATUS
        end
        
        typesig { [] }
        # @see org.eclipse.text.undo.UndoableTextChange#updateTextChange()
        def update_text_change
          # first gather the data from the buffers
          super
          # the result of the update is stored as a child change
          c = self.class::UndoableTextChange.new(self.attr_f_document_undo_manager)
          c.attr_f_start = self.attr_f_start
          c.attr_f_end = self.attr_f_end
          c.attr_f_text = self.attr_f_text
          c.attr_f_preserved_text = self.attr_f_preserved_text
          c.attr_f_undo_modification_stamp = self.attr_f_undo_modification_stamp
          c.attr_f_redo_modification_stamp = self.attr_f_redo_modification_stamp
          add(c)
          # clear out all indexes now that the child is added
          reinitialize
        end
        
        typesig { [] }
        # @see org.eclipse.text.undo.UndoableTextChange#createCurrent()
        def create_current
          if (!self.attr_f_document_undo_manager.attr_f_folding_into_compound_change)
            return self.class::UndoableTextChange.new(self.attr_f_document_undo_manager)
          end
          reinitialize
          return self
        end
        
        typesig { [] }
        # @see org.eclipse.text.undo.UndoableTextChange#commit()
        def commit
          # if there is pending data, update the text change
          if (self.attr_f_start > -1)
            update_text_change
          end
          self.attr_f_document_undo_manager.attr_f_current = create_current
          self.attr_f_document_undo_manager.reset_process_change_state
        end
        
        typesig { [] }
        # @see org.eclipse.text.undo.UndoableTextChange#isValid()
        def is_valid
          return self.attr_f_start > -1 || @f_changes.size > 0
        end
        
        typesig { [] }
        # @see org.eclipse.text.undo.UndoableTextChange#getUndoModificationStamp()
        def get_undo_modification_stamp
          if (self.attr_f_start > -1)
            return super
          else
            if (@f_changes.size > 0)
              return (@f_changes.get(0)).get_undo_modification_stamp
            end
          end
          return self.attr_f_undo_modification_stamp
        end
        
        typesig { [] }
        # @see org.eclipse.text.undo.UndoableTextChange#getRedoModificationStamp()
        def get_redo_modification_stamp
          if (self.attr_f_start > -1)
            return super
          else
            if (@f_changes.size > 0)
              return (@f_changes.get(@f_changes.size - 1)).get_redo_modification_stamp
            end
          end
          return self.attr_f_redo_modification_stamp
        end
        
        private
        alias_method :initialize__undoable_compound_text_change, :initialize
      end }
      
      # Internal listener to document changes.
      const_set_lazy(:DocumentListener) { Class.new do
        local_class_in DocumentUndoManager
        include_class_members DocumentUndoManager
        include IDocumentListener
        
        attr_accessor :f_replaced_text
        alias_method :attr_f_replaced_text, :f_replaced_text
        undef_method :f_replaced_text
        alias_method :attr_f_replaced_text=, :f_replaced_text=
        undef_method :f_replaced_text=
        
        typesig { [class_self::DocumentEvent] }
        # @see org.eclipse.jface.text.IDocumentListener#documentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
        def document_about_to_be_changed(event)
          begin
            @f_replaced_text = RJava.cast_to_string(event.get_document.get(event.get_offset, event.get_length))
            self.attr_f_preserved_undo_modification_stamp = event.get_modification_stamp
          rescue self.class::BadLocationException => x
            @f_replaced_text = RJava.cast_to_string(nil)
          end
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see org.eclipse.jface.text.IDocumentListener#documentChanged(org.eclipse.jface.text.DocumentEvent)
        def document_changed(event)
          self.attr_f_preserved_redo_modification_stamp = event.get_modification_stamp
          # record the current valid state for the top operation in case it
          # remains the
          # top operation but changes state.
          op = self.attr_f_history.get_undo_operation(self.attr_f_undo_context)
          was_valid = false
          if (!(op).nil?)
            was_valid = op.can_undo
          end
          # Process the change, providing the before and after timestamps
          process_change(event.get_offset, event.get_offset + event.get_length, event.get_text, @f_replaced_text, self.attr_f_preserved_undo_modification_stamp, self.attr_f_preserved_redo_modification_stamp)
          # now update fCurrent with the latest buffers from the document
          # change.
          self.attr_f_current.pretend_commit
          if ((op).equal?(self.attr_f_current))
            # if the document change did not cause a new fCurrent to be
            # created, then we should
            # notify the history that the current operation changed if its
            # validity has changed.
            if (!(was_valid).equal?(self.attr_f_current.is_valid))
              self.attr_f_history.operation_changed(op)
            end
          else
            # if the change created a new fCurrent that we did not yet add
            # to the
            # stack, do so if it's valid and we are not in the middle of a
            # compound change.
            if (!(self.attr_f_current).equal?(self.attr_f_last_added_text_edit) && self.attr_f_current.is_valid)
              add_to_operation_history(self.attr_f_current)
            end
          end
        end
        
        typesig { [] }
        def initialize
          @f_replaced_text = nil
        end
        
        private
        alias_method :initialize__document_listener, :initialize
      end }
      
      # @see IOperationHistoryListener
      const_set_lazy(:HistoryListener) { Class.new do
        local_class_in DocumentUndoManager
        include_class_members DocumentUndoManager
        include IOperationHistoryListener
        
        attr_accessor :f_operation
        alias_method :attr_f_operation, :f_operation
        undef_method :f_operation
        alias_method :attr_f_operation=, :f_operation=
        undef_method :f_operation=
        
        typesig { [class_self::OperationHistoryEvent] }
        def history_notification(event)
          type = event.get_event_type
          case (type)
          when OperationHistoryEvent::ABOUT_TO_UNDO, OperationHistoryEvent::ABOUT_TO_REDO
            # if this is one of our operations
            if (event.get_operation.has_context(self.attr_f_undo_context))
              # if we are undoing/redoing an operation we generated, then
              # ignore
              # the document changes associated with this undo or redo.
              if (event.get_operation.is_a?(self.class::UndoableTextChange))
                listen_to_text_changes(false)
                # in the undo case only, make sure compounds are closed
                if ((type).equal?(OperationHistoryEvent::ABOUT_TO_UNDO))
                  if (self.attr_f_folding_into_compound_change)
                    end_compound_change
                  end
                end
              else
                # the undo or redo has our context, but it is not one
                # of our edits. We will listen to the changes, but will
                # reset the state that tracks the undo/redo history.
                commit
                self.attr_f_last_added_text_edit = nil
              end
              @f_operation = event.get_operation
            end
          when OperationHistoryEvent::UNDONE, OperationHistoryEvent::REDONE, OperationHistoryEvent::OPERATION_NOT_OK
            if ((event.get_operation).equal?(@f_operation))
              listen_to_text_changes(true)
              @f_operation = nil
            end
          end
        end
        
        typesig { [] }
        def initialize
          @f_operation = nil
        end
        
        private
        alias_method :initialize__history_listener, :initialize
      end }
    }
    
    # The undo context for this document undo manager.
    attr_accessor :f_undo_context
    alias_method :attr_f_undo_context, :f_undo_context
    undef_method :f_undo_context
    alias_method :attr_f_undo_context=, :f_undo_context=
    undef_method :f_undo_context=
    
    # The document whose changes are being tracked.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The currently constructed edit.
    attr_accessor :f_current
    alias_method :attr_f_current, :f_current
    undef_method :f_current
    alias_method :attr_f_current=, :f_current=
    undef_method :f_current=
    
    # The internal document listener.
    attr_accessor :f_document_listener
    alias_method :attr_f_document_listener, :f_document_listener
    undef_method :f_document_listener
    alias_method :attr_f_document_listener=, :f_document_listener=
    undef_method :f_document_listener=
    
    # Indicates whether the current change belongs to a compound change.
    attr_accessor :f_folding_into_compound_change
    alias_method :attr_f_folding_into_compound_change, :f_folding_into_compound_change
    undef_method :f_folding_into_compound_change
    alias_method :attr_f_folding_into_compound_change=, :f_folding_into_compound_change=
    undef_method :f_folding_into_compound_change=
    
    # The operation history being used to store the undo history.
    attr_accessor :f_history
    alias_method :attr_f_history, :f_history
    undef_method :f_history
    alias_method :attr_f_history=, :f_history=
    undef_method :f_history=
    
    # The operation history listener used for managing undo and redo before and
    # after the individual edits are performed.
    attr_accessor :f_history_listener
    alias_method :attr_f_history_listener, :f_history_listener
    undef_method :f_history_listener
    alias_method :attr_f_history_listener=, :f_history_listener=
    undef_method :f_history_listener=
    
    # The text edit last added to the operation history. This must be tracked
    # internally instead of asking the history, since outside parties may be
    # placing items on our undo/redo history.
    attr_accessor :f_last_added_text_edit
    alias_method :attr_f_last_added_text_edit, :f_last_added_text_edit
    undef_method :f_last_added_text_edit
    alias_method :attr_f_last_added_text_edit=, :f_last_added_text_edit=
    undef_method :f_last_added_text_edit=
    
    # The document modification stamp for redo.
    attr_accessor :f_preserved_redo_modification_stamp
    alias_method :attr_f_preserved_redo_modification_stamp, :f_preserved_redo_modification_stamp
    undef_method :f_preserved_redo_modification_stamp
    alias_method :attr_f_preserved_redo_modification_stamp=, :f_preserved_redo_modification_stamp=
    undef_method :f_preserved_redo_modification_stamp=
    
    # Text buffer to collect viewer content which has been replaced
    attr_accessor :f_preserved_text_buffer
    alias_method :attr_f_preserved_text_buffer, :f_preserved_text_buffer
    undef_method :f_preserved_text_buffer
    alias_method :attr_f_preserved_text_buffer=, :f_preserved_text_buffer=
    undef_method :f_preserved_text_buffer=
    
    # The document modification stamp for undo.
    attr_accessor :f_preserved_undo_modification_stamp
    alias_method :attr_f_preserved_undo_modification_stamp, :f_preserved_undo_modification_stamp
    undef_method :f_preserved_undo_modification_stamp
    alias_method :attr_f_preserved_undo_modification_stamp=, :f_preserved_undo_modification_stamp=
    undef_method :f_preserved_undo_modification_stamp=
    
    # The last delete text edit.
    attr_accessor :f_previous_delete
    alias_method :attr_f_previous_delete, :f_previous_delete
    undef_method :f_previous_delete
    alias_method :attr_f_previous_delete=, :f_previous_delete=
    undef_method :f_previous_delete=
    
    # Text buffer to collect text which is inserted into the viewer
    attr_accessor :f_text_buffer
    alias_method :attr_f_text_buffer, :f_text_buffer
    undef_method :f_text_buffer
    alias_method :attr_f_text_buffer=, :f_text_buffer=
    undef_method :f_text_buffer=
    
    # Indicates inserting state.
    attr_accessor :f_inserting
    alias_method :attr_f_inserting, :f_inserting
    undef_method :f_inserting
    alias_method :attr_f_inserting=, :f_inserting=
    undef_method :f_inserting=
    
    # Indicates overwriting state.
    attr_accessor :f_overwriting
    alias_method :attr_f_overwriting, :f_overwriting
    undef_method :f_overwriting
    alias_method :attr_f_overwriting=, :f_overwriting=
    undef_method :f_overwriting=
    
    # The registered document listeners.
    attr_accessor :f_document_undo_listeners
    alias_method :attr_f_document_undo_listeners, :f_document_undo_listeners
    undef_method :f_document_undo_listeners
    alias_method :attr_f_document_undo_listeners=, :f_document_undo_listeners=
    undef_method :f_document_undo_listeners=
    
    # The list of clients connected.
    attr_accessor :f_connected
    alias_method :attr_f_connected, :f_connected
    undef_method :f_connected
    alias_method :attr_f_connected=, :f_connected=
    undef_method :f_connected=
    
    typesig { [IDocument] }
    # Create a DocumentUndoManager for the given document.
    # 
    # @param document the document whose undo history is being managed.
    def initialize(document)
      @f_undo_context = nil
      @f_document = nil
      @f_current = nil
      @f_document_listener = nil
      @f_folding_into_compound_change = false
      @f_history = nil
      @f_history_listener = nil
      @f_last_added_text_edit = nil
      @f_preserved_redo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      @f_preserved_text_buffer = nil
      @f_preserved_undo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      @f_previous_delete = nil
      @f_text_buffer = nil
      @f_inserting = false
      @f_overwriting = false
      @f_document_undo_listeners = nil
      @f_connected = nil
      Assert.is_not_null(document)
      @f_document = document
      @f_history = OperationHistoryFactory.get_operation_history
      @f_undo_context = ObjectUndoContext.new(@f_document)
      @f_connected = ArrayList.new
      @f_document_undo_listeners = ListenerList.new(ListenerList::IDENTITY)
    end
    
    typesig { [IDocumentUndoListener] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#addDocumentUndoListener(org.eclipse.jface.text.IDocumentUndoListener)
    def add_document_undo_listener(listener)
      @f_document_undo_listeners.add(listener)
    end
    
    typesig { [IDocumentUndoListener] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#removeDocumentUndoListener(org.eclipse.jface.text.IDocumentUndoListener)
    def remove_document_undo_listener(listener)
      @f_document_undo_listeners.remove(listener)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#getUndoContext()
    def get_undo_context
      return @f_undo_context
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#commit()
    def commit
      # if fCurrent has never been placed on the history, do so now.
      # this can happen when there are multiple programmatically commits in a
      # single document change.
      if (!(@f_last_added_text_edit).equal?(@f_current))
        @f_current.pretend_commit
        if (@f_current.is_valid)
          add_to_operation_history(@f_current)
        end
      end
      @f_current.commit
    end
    
    typesig { [] }
    # @see org.eclipse.text.undo.IDocumentUndoManager#reset()
    def reset
      if (is_connected)
        shutdown
        initialize_
      end
    end
    
    typesig { [] }
    # @see org.eclipse.text.undo.IDocumentUndoManager#redoable()
    def redoable
      return OperationHistoryFactory.get_operation_history.can_redo(@f_undo_context)
    end
    
    typesig { [] }
    # @see org.eclipse.text.undo.IDocumentUndoManager#undoable()
    def undoable
      return OperationHistoryFactory.get_operation_history.can_undo(@f_undo_context)
    end
    
    typesig { [] }
    # @see org.eclipse.text.undo.IDocumentUndoManager#undo()
    def redo_
      if (is_connected && redoable)
        OperationHistoryFactory.get_operation_history.redo_(get_undo_context, nil, nil)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.text.undo.IDocumentUndoManager#undo()
    def undo
      if (undoable)
        OperationHistoryFactory.get_operation_history.undo(@f_undo_context, nil, nil)
      end
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#connect(java.lang.Object)
    def connect(client)
      if (!is_connected)
        initialize_
      end
      if (!@f_connected.contains(client))
        @f_connected.add(client)
      end
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#disconnect(java.lang.Object)
    def disconnect(client)
      @f_connected.remove(client)
      if (!is_connected)
        shutdown
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#beginCompoundChange()
    def begin_compound_change
      if (is_connected)
        @f_folding_into_compound_change = true
        commit
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#endCompoundChange()
    def end_compound_change
      if (is_connected)
        @f_folding_into_compound_change = false
        commit
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#setUndoLimit(int)
    def set_maximal_undo_level(undo_limit)
      @f_history.set_limit(@f_undo_context, undo_limit)
    end
    
    typesig { [::Java::Int, String, String, Object, ::Java::Int, ::Java::Boolean] }
    # Fires a document undo event to all registered document undo listeners.
    # Uses a robust iterator.
    # 
    # @param offset the document offset
    # @param text the text that was inserted
    # @param preservedText the text being replaced
    # @param source the source which triggered the event
    # @param eventType the type of event causing the change
    # @param isCompound a flag indicating whether the change is a compound change
    # @see IDocumentUndoListener
    def fire_document_undo(offset, text, preserved_text, source, event_type, is_compound)
      event_type = is_compound ? event_type | DocumentUndoEvent::COMPOUND : event_type
      event = DocumentUndoEvent.new(@f_document, offset, text, preserved_text, event_type, source)
      listeners = @f_document_undo_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        (listeners[i]).document_undo_notification(event)
        i += 1
      end
    end
    
    typesig { [] }
    # Adds any listeners needed to track the document and the operations
    # history.
    def add_listeners
      @f_history_listener = HistoryListener.new_local(self)
      @f_history.add_operation_history_listener(@f_history_listener)
      listen_to_text_changes(true)
    end
    
    typesig { [] }
    # Removes any listeners that were installed by the document.
    def remove_listeners
      listen_to_text_changes(false)
      @f_history.remove_operation_history_listener(@f_history_listener)
      @f_history_listener = nil
    end
    
    typesig { [UndoableTextChange] }
    # Adds the given text edit to the operation history if it is not part of a compound change.
    # 
    # @param edit the edit to be added
    def add_to_operation_history(edit)
      if (!@f_folding_into_compound_change || edit.is_a?(UndoableCompoundTextChange))
        @f_history.add(edit)
        @f_last_added_text_edit = edit
      end
    end
    
    typesig { [] }
    # Disposes the undo history.
    def dispose_undo_history
      @f_history.dispose(@f_undo_context, true, true, true)
    end
    
    typesig { [] }
    # Initializes the undo history.
    def initialize_undo_history
      if (!(@f_history).nil? && !(@f_undo_context).nil?)
        @f_history.dispose(@f_undo_context, true, true, false)
      end
    end
    
    typesig { [String] }
    # Checks whether the given text starts with a line delimiter and
    # subsequently contains a white space only.
    # 
    # @param text the text to check
    # @return <code>true</code> if the text is a line delimiter followed by
    # whitespace, <code>false</code> otherwise
    def is_whitespace_text(text)
      if ((text).nil? || (text.length).equal?(0))
        return false
      end
      delimiters = @f_document.get_legal_line_delimiters
      index = TextUtilities.starts_with(delimiters, text)
      if (index > -1)
        c = 0
        length_ = text.length
        i = delimiters[index].length
        while i < length_
          c = text.char_at(i)
          if (!(c).equal?(Character.new(?\s.ord)) && !(c).equal?(Character.new(?\t.ord)))
            return false
          end
          i += 1
        end
        return true
      end
      return false
    end
    
    typesig { [::Java::Boolean] }
    # Switches the state of whether there is a text listener or not.
    # 
    # @param listen the state which should be established
    def listen_to_text_changes(listen)
      if (listen)
        if ((@f_document_listener).nil? && !(@f_document).nil?)
          @f_document_listener = DocumentListener.new_local(self)
          @f_document.add_document_listener(@f_document_listener)
        end
      else
        if (!listen)
          if (!(@f_document_listener).nil? && !(@f_document).nil?)
            @f_document.remove_document_listener(@f_document_listener)
            @f_document_listener = nil
          end
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, String, String, ::Java::Long, ::Java::Long] }
    def process_change(model_start, model_end, inserted_text, replaced_text, before_change_modification_stamp, after_change_modification_stamp)
      if ((inserted_text).nil?)
        inserted_text = ""
      end # $NON-NLS-1$
      if ((replaced_text).nil?)
        replaced_text = ""
      end # $NON-NLS-1$
      length_ = inserted_text.length
      diff = model_end - model_start
      if ((@f_current.attr_f_undo_modification_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP))
        @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
      end
      # normalize
      if (diff < 0)
        tmp = model_end
        model_end = model_start
        model_start = tmp
      end
      if ((model_start).equal?(model_end))
        # text will be inserted
        if (((length_).equal?(1)) || is_whitespace_text(inserted_text))
          # by typing or whitespace
          if (!@f_inserting || (!(model_start).equal?(@f_current.attr_f_start + @f_text_buffer.length)))
            @f_current.attr_f_redo_modification_stamp = before_change_modification_stamp
            if (@f_current.attempt_commit)
              @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
            end
            @f_inserting = true
          end
          if (@f_current.attr_f_start < 0)
            @f_current.attr_f_start = @f_current.attr_f_end = model_start
          end
          if (length_ > 0)
            @f_text_buffer.append(inserted_text)
          end
        else
          if (length_ > 0)
            # by pasting or model manipulation
            @f_current.attr_f_redo_modification_stamp = before_change_modification_stamp
            if (@f_current.attempt_commit)
              @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
            end
            @f_current.attr_f_start = @f_current.attr_f_end = model_start
            @f_text_buffer.append(inserted_text)
            @f_current.attr_f_redo_modification_stamp = after_change_modification_stamp
            if (@f_current.attempt_commit)
              @f_current.attr_f_undo_modification_stamp = after_change_modification_stamp
            end
          end
        end
      else
        if ((length_).equal?(0))
          # text will be deleted by backspace or DEL key or empty
          # clipboard
          length_ = replaced_text.length
          delimiters = @f_document.get_legal_line_delimiters
          if (((length_).equal?(1)) || TextUtilities.==(delimiters, replaced_text) > -1)
            # whereby selection is empty
            if ((@f_previous_delete.attr_f_start).equal?(model_start) && (@f_previous_delete.attr_f_end).equal?(model_end))
              # repeated DEL
              # correct wrong settings of fCurrent
              if ((@f_current.attr_f_start).equal?(model_end) && (@f_current.attr_f_end).equal?(model_start))
                @f_current.attr_f_start = model_start
                @f_current.attr_f_end = model_end
              end
              # append to buffer && extend edit range
              @f_preserved_text_buffer.append(replaced_text)
              (@f_current.attr_f_end += 1)
            else
              if ((@f_previous_delete.attr_f_start).equal?(model_end))
                # repeated backspace
                # insert in buffer and extend edit range
                @f_preserved_text_buffer.insert(0, replaced_text)
                @f_current.attr_f_start = model_start
              else
                # either DEL or backspace for the first time
                @f_current.attr_f_redo_modification_stamp = before_change_modification_stamp
                if (@f_current.attempt_commit)
                  @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
                end
                # as we can not decide whether it was DEL or backspace
                # we initialize for backspace
                @f_preserved_text_buffer.append(replaced_text)
                @f_current.attr_f_start = model_start
                @f_current.attr_f_end = model_end
              end
            end
            @f_previous_delete.set(model_start, model_end)
          else
            if (length_ > 0)
              # whereby selection is not empty
              @f_current.attr_f_redo_modification_stamp = before_change_modification_stamp
              if (@f_current.attempt_commit)
                @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
              end
              @f_current.attr_f_start = model_start
              @f_current.attr_f_end = model_end
              @f_preserved_text_buffer.append(replaced_text)
            end
          end
        else
          # text will be replaced
          if ((length_).equal?(1))
            length_ = replaced_text.length
            delimiters = @f_document.get_legal_line_delimiters
            if (((length_).equal?(1)) || TextUtilities.==(delimiters, replaced_text) > -1)
              # because of overwrite mode or model manipulation
              if (!@f_overwriting || (!(model_start).equal?(@f_current.attr_f_start + @f_text_buffer.length)))
                @f_current.attr_f_redo_modification_stamp = before_change_modification_stamp
                if (@f_current.attempt_commit)
                  @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
                end
                @f_overwriting = true
              end
              if (@f_current.attr_f_start < 0)
                @f_current.attr_f_start = model_start
              end
              @f_current.attr_f_end = model_end
              @f_text_buffer.append(inserted_text)
              @f_preserved_text_buffer.append(replaced_text)
              @f_current.attr_f_redo_modification_stamp = after_change_modification_stamp
              return
            end
          end
          # because of typing or pasting whereby selection is not empty
          @f_current.attr_f_redo_modification_stamp = before_change_modification_stamp
          if (@f_current.attempt_commit)
            @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
          end
          @f_current.attr_f_start = model_start
          @f_current.attr_f_end = model_end
          @f_text_buffer.append(inserted_text)
          @f_preserved_text_buffer.append(replaced_text)
        end
      end
      # in all cases, the redo modification stamp is updated on the open
      # text edit
      @f_current.attr_f_redo_modification_stamp = after_change_modification_stamp
    end
    
    typesig { [] }
    # Initialize the receiver.
    def initialize_
      initialize_undo_history
      # open up the current text edit
      @f_current = UndoableTextChange.new(self)
      @f_previous_delete = UndoableTextChange.new(self)
      @f_text_buffer = StringBuffer.new
      @f_preserved_text_buffer = StringBuffer.new
      add_listeners
    end
    
    typesig { [] }
    # Reset processChange state.
    # 
    # @since 3.2
    def reset_process_change_state
      @f_inserting = false
      @f_overwriting = false
      @f_previous_delete.reinitialize
    end
    
    typesig { [] }
    # Shutdown the receiver.
    def shutdown
      remove_listeners
      @f_current = nil
      @f_previous_delete = nil
      @f_text_buffer = nil
      @f_preserved_text_buffer = nil
      dispose_undo_history
    end
    
    typesig { [] }
    # Return whether or not any clients are connected to the receiver.
    # 
    # @return <code>true</code> if the receiver is connected to
    # clients, <code>false</code> if it is not
    def is_connected
      if ((@f_connected).nil?)
        return false
      end
      return !@f_connected.is_empty
    end
    
    typesig { [IDocumentUndoManager] }
    # @see org.eclipse.jface.text.IDocumentUndoManager#transferUndoHistory(IDocumentUndoManager)
    def transfer_undo_history(manager)
      old_undo_context = manager.get_undo_context
      # Get the history for the old undo context.
      operations = OperationHistoryFactory.get_operation_history.get_undo_history(old_undo_context)
      i = 0
      while i < operations.attr_length
        # First replace the undo context
        op = operations[i]
        if (op.is_a?(IContextReplacingOperation))
          (op).replace_context(old_undo_context, get_undo_context)
        else
          op.add_context(get_undo_context)
          op.remove_context(old_undo_context)
        end
        # Now update the manager that owns the text edit.
        if (op.is_a?(UndoableTextChange))
          (op).attr_f_document_undo_manager = self
        end
        i += 1
      end
      op = OperationHistoryFactory.get_operation_history.get_undo_operation(get_undo_context)
      if (!(op).nil? && !(op.is_a?(UndoableTextChange)))
        return
      end
      # Record the transfer itself as an undoable change.
      # If the transfer results from some open operation, recording this change will
      # cause our undo context to be added to the outer operation.  If there is no
      # outer operation, there will be a local change to signify the transfer.
      # This also serves to synchronize the modification stamps with the documents.
      cmd = UndoableTextChange.new(self)
      cmd.attr_f_start = cmd.attr_f_end = 0
      cmd.attr_f_text = cmd.attr_f_preserved_text = "" # $NON-NLS-1$
      if (@f_document.is_a?(IDocumentExtension4))
        cmd.attr_f_redo_modification_stamp = (@f_document).get_modification_stamp
        if (!(op).nil?)
          cmd.attr_f_undo_modification_stamp = (op).attr_f_redo_modification_stamp
        end
      end
      add_to_operation_history(cmd)
    end
    
    private
    alias_method :initialize__document_undo_manager, :initialize
  end
  
end
