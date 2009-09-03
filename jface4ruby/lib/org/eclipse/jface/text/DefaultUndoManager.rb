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
  module DefaultUndoManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands::Operations, :AbstractOperation
      include_const ::Org::Eclipse::Core::Commands::Operations, :IOperationHistory
      include_const ::Org::Eclipse::Core::Commands::Operations, :IOperationHistoryListener
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoContext
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoableOperation
      include_const ::Org::Eclipse::Core::Commands::Operations, :ObjectUndoContext
      include_const ::Org::Eclipse::Core::Commands::Operations, :OperationHistoryEvent
      include_const ::Org::Eclipse::Core::Commands::Operations, :OperationHistoryFactory
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Dialogs, :MessageDialog
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.IUndoManager}.
  # <p>
  # It registers with the connected text viewer as text input listener and
  # document listener and logs all changes. It also monitors mouse and keyboard
  # activities in order to partition the stream of text changes into undo-able
  # edit commands.
  # </p>
  # <p>
  # Since 3.1 this undo manager is a facade to the global operation history.
  # </p>
  # <p>
  # The usage of {@link org.eclipse.core.runtime.IAdaptable} in the JFace
  # layer has been approved by Platform UI, see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=87669#c9
  # </p>
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # 
  # @see org.eclipse.jface.text.ITextViewer
  # @see org.eclipse.jface.text.ITextInputListener
  # @see org.eclipse.jface.text.IDocumentListener
  # @see org.eclipse.core.commands.operations.IUndoableOperation
  # @see org.eclipse.core.commands.operations.IOperationHistory
  # @see MouseListener
  # @see KeyListener
  # @deprecated As of 3.2, replaced by {@link TextViewerUndoManager}
  # @noextend This class is not intended to be subclassed by clients.
  class DefaultUndoManager 
    include_class_members DefaultUndoManagerImports
    include IUndoManager
    include IUndoManagerExtension
    
    class_module.module_eval {
      # Represents an undo-able edit command.
      # <p>
      # Since 3.1 this implements the interface for IUndoableOperation.
      # </p>
      const_set_lazy(:TextCommand) { Class.new(AbstractOperation) do
        extend LocalClass
        include_class_members DefaultUndoManager
        
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
        
        typesig { [class_self::IUndoContext] }
        # Creates a new text command.
        # 
        # @param context the undo context for this command
        # @since 3.1
        def initialize(context)
          @f_start = 0
          @f_end = 0
          @f_text = nil
          @f_preserved_text = nil
          @f_undo_modification_stamp = 0
          @f_redo_modification_stamp = 0
          super(JFaceTextMessages.get_string("DefaultUndoManager.operationLabel"))
          @f_start = -1
          @f_end = -1
          @f_undo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
          @f_redo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP # $NON-NLS-1$
          add_context(context)
        end
        
        typesig { [] }
        # Re-initializes this text command.
        def reinitialize
          @f_start = @f_end = -1
          @f_text = RJava.cast_to_string(@f_preserved_text = RJava.cast_to_string(nil))
          @f_undo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
          @f_redo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Sets the start and the end index of this command.
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
        # @since 3.1
        def dispose
          reinitialize
        end
        
        typesig { [] }
        # Undo the change described by this command.
        # 
        # @since 2.0
        def undo_text_change
          begin
            document = self.attr_f_text_viewer.get_document
            if (document.is_a?(self.class::IDocumentExtension4))
              (document).replace(@f_start, @f_text.length, @f_preserved_text, @f_undo_modification_stamp)
            else
              document.replace(@f_start, @f_text.length, @f_preserved_text)
            end
          rescue self.class::BadLocationException => x
          end
        end
        
        typesig { [] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#canUndo()
        # @since 3.1
        def can_undo
          if (is_connected && is_valid)
            doc = self.attr_f_text_viewer.get_document
            if (doc.is_a?(self.class::IDocumentExtension4))
              doc_stamp = (doc).get_modification_stamp
              # Normal case: an undo is valid if its redo will restore document
              # to its current modification stamp
              can_undo = (doc_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP) || (doc_stamp).equal?(get_redo_modification_stamp)
              # Special case to check if the answer is false.
              # If the last document change was empty, then the document's
              # modification stamp was incremented but nothing was committed.
              # The operation being queried has an older stamp.  In this case only,
              # the comparison is different.  A sequence of document changes that
              # include an empty change is handled correctly when a valid commit
              # follows the empty change, but when #canUndo() is queried just after
              # an empty change, we must special case the check.  The check is very
              # specific to prevent false positives.
              # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=98245
              # 
              # this is the latest operation
              # there is a more current operation not on the stack
              # the current operation is not a valid document modification
              # the invalid current operation has a document stamp
              if (!can_undo && (self).equal?(self.attr_f_history.get_undo_operation(self.attr_f_undo_context)) && !(self).equal?(self.attr_f_current) && !self.attr_f_current.is_valid && !(self.attr_f_current.attr_f_undo_modification_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP))
                can_undo = (self.attr_f_current.attr_f_redo_modification_stamp).equal?(doc_stamp)
              end
              # When the composite is the current command, it may hold the timestamp
              # of a no-op change.  We check this here rather than in an override of
              # canUndo() in CompoundTextCommand simply to keep all the special case checks
              # in one place.
              # 
              # this is the latest operation
              # this is the current operation
              # the current operation text is not valid
              if (!can_undo && (self).equal?(self.attr_f_history.get_undo_operation(self.attr_f_undo_context)) && self.is_a?(self.class::CompoundTextCommand) && (self).equal?(self.attr_f_current) && (@f_start).equal?(-1) && !(self.attr_f_current.attr_f_redo_modification_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP))
                # but it has a redo stamp
                can_undo = (self.attr_f_current.attr_f_redo_modification_stamp).equal?(doc_stamp)
              end
            end
            # if there is no timestamp to check, simply return true per the 3.0.1 behavior
            return true
          end
          return false
        end
        
        typesig { [] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#canRedo()
        # @since 3.1
        def can_redo
          if (is_connected && is_valid)
            doc = self.attr_f_text_viewer.get_document
            if (doc.is_a?(self.class::IDocumentExtension4))
              doc_stamp = (doc).get_modification_stamp
              return (doc_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP) || (doc_stamp).equal?(get_undo_modification_stamp)
            end
            # if there is no timestamp to check, simply return true per the 3.0.1 behavior
            return true
          end
          return false
        end
        
        typesig { [] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#canExecute()
        # @since 3.1
        def can_execute
          return is_connected
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # @see org.eclipse.core.commands.operations.IUndoableOperation#execute(org.eclipse.core.runtime.IProgressMonitor, org.eclipse.core.runtime.IAdaptable)
        # @since 3.1
        def execute(monitor, ui_info)
          # Text commands execute as they are typed, so executing one has no effect.
          return Status::OK_STATUS
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # Undo the change described by this command. Also selects and
        # reveals the change.
        # 
        # 
        # Undo the change described by this command. Also selects and
        # reveals the change.
        # 
        # @param monitor	the progress monitor to use if necessary
        # @param uiInfo	an adaptable that can provide UI info if needed
        # @return the status
        def undo(monitor, ui_info)
          if (is_valid)
            undo_text_change
            select_and_reveal(@f_start, (@f_preserved_text).nil? ? 0 : @f_preserved_text.length)
            reset_process_change_sate
            return Status::OK_STATUS
          end
          return IOperationHistory::OPERATION_INVALID_STATUS
        end
        
        typesig { [] }
        # Re-applies the change described by this command.
        # 
        # @since 2.0
        def redo_text_change
          begin
            document = self.attr_f_text_viewer.get_document
            if (document.is_a?(self.class::IDocumentExtension4))
              (document).replace(@f_start, @f_end - @f_start, @f_text, @f_redo_modification_stamp)
            else
              self.attr_f_text_viewer.get_document.replace(@f_start, @f_end - @f_start, @f_text)
            end
          rescue self.class::BadLocationException => x
          end
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # Re-applies the change described by this command that previously been
        # rolled back. Also selects and reveals the change.
        # 
        # @param monitor	the progress monitor to use if necessary
        # @param uiInfo	an adaptable that can provide UI info if needed
        # @return the status
        def redo_(monitor, ui_info)
          if (is_valid)
            redo_text_change
            reset_process_change_sate
            select_and_reveal(@f_start, (@f_text).nil? ? 0 : @f_text.length)
            return Status::OK_STATUS
          end
          return IOperationHistory::OPERATION_INVALID_STATUS
        end
        
        typesig { [] }
        # Update the command in response to a commit.
        # 
        # @since 3.1
        def update_command
          @f_text = RJava.cast_to_string(self.attr_f_text_buffer.to_s)
          self.attr_f_text_buffer.set_length(0)
          @f_preserved_text = RJava.cast_to_string(self.attr_f_preserved_text_buffer.to_s)
          self.attr_f_preserved_text_buffer.set_length(0)
        end
        
        typesig { [] }
        # Creates a new uncommitted text command depending on whether
        # a compound change is currently being executed.
        # 
        # @return a new, uncommitted text command or a compound text command
        def create_current
          return self.attr_f_folding_into_compound_change ? self.class::CompoundTextCommand.new(self.attr_f_undo_context) : self.class::TextCommand.new(self.attr_f_undo_context)
        end
        
        typesig { [] }
        # Commits the current change into this command.
        def commit
          if (@f_start < 0)
            if (self.attr_f_folding_into_compound_change)
              self.attr_f_current = create_current
            else
              reinitialize
            end
          else
            update_command
            self.attr_f_current = create_current
          end
          reset_process_change_sate
        end
        
        typesig { [] }
        # Updates the text from the buffers without resetting
        # the buffers or adding anything to the stack.
        # 
        # @since 3.1
        def pretend_commit
          if (@f_start > -1)
            @f_text = RJava.cast_to_string(self.attr_f_text_buffer.to_s)
            @f_preserved_text = RJava.cast_to_string(self.attr_f_preserved_text_buffer.to_s)
          end
        end
        
        typesig { [] }
        # Attempt a commit of this command and answer true if a new
        # fCurrent was created as a result of the commit.
        # 
        # @return true if the command was committed and created a
        # new fCurrent, false if not.
        # @since 3.1
        def attempt_commit
          pretend_commit
          if (is_valid)
            @local_class_parent.commit
            return true
          end
          return false
        end
        
        typesig { [] }
        # Checks whether this text command is valid for undo or redo.
        # 
        # @return <code>true</code> if the command is valid for undo or redo
        # @since 3.1
        def is_valid
          return @f_start > -1 && @f_end > -1 && !(@f_text).nil?
        end
        
        typesig { [] }
        # @see java.lang.Object#toString()
        # @since 3.1
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
        # @return the undo modification stamp for this command
        # @since 3.1
        def get_undo_modification_stamp
          return @f_undo_modification_stamp
        end
        
        typesig { [] }
        # Return the redo modification stamp
        # 
        # @return the redo modification stamp for this command
        # @since 3.1
        def get_redo_modification_stamp
          return @f_redo_modification_stamp
        end
        
        private
        alias_method :initialize__text_command, :initialize
      end }
      
      # Represents an undo-able edit command consisting of several
      # individual edit commands.
      const_set_lazy(:CompoundTextCommand) { Class.new(TextCommand) do
        extend LocalClass
        include_class_members DefaultUndoManager
        
        # The list of individual commands
        attr_accessor :f_commands
        alias_method :attr_f_commands, :f_commands
        undef_method :f_commands
        alias_method :attr_f_commands=, :f_commands=
        undef_method :f_commands=
        
        typesig { [class_self::IUndoContext] }
        # Creates a new compound text command.
        # 
        # @param context the undo context for this command
        # @since 3.1
        def initialize(context)
          @f_commands = nil
          super(context)
          @f_commands = self.class::ArrayList.new
        end
        
        typesig { [class_self::TextCommand] }
        # Adds a new individual command to this compound command.
        # 
        # @param command the command to be added
        def add(command)
          @f_commands.add(command)
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # @see org.eclipse.jface.text.DefaultUndoManager.TextCommand#undo()
        def undo(monitor, ui_info)
          reset_process_change_sate
          size_ = @f_commands.size
          if (size_ > 0)
            c = nil
            i = size_ - 1
            while i > 0
              c = @f_commands.get(i)
              c.undo_text_change
              (i -= 1)
            end
            c = @f_commands.get(0)
            c.undo(monitor, ui_info)
          end
          return Status::OK_STATUS
        end
        
        typesig { [class_self::IProgressMonitor, class_self::IAdaptable] }
        # @see org.eclipse.jface.text.DefaultUndoManager.TextCommand#redo()
        def redo_(monitor, ui_info)
          reset_process_change_sate
          size_ = @f_commands.size
          if (size_ > 0)
            c = nil
            i = 0
            while i < size_ - 1
              c = @f_commands.get(i)
              c.redo_text_change
              (i += 1)
            end
            c = @f_commands.get(size_ - 1)
            c.redo_(monitor, ui_info)
          end
          return Status::OK_STATUS
        end
        
        typesig { [] }
        # @see TextCommand#updateCommand
        def update_command
          # first gather the data from the buffers
          super
          # the result of the command update is stored as a child command
          c = self.class::TextCommand.new(self.attr_f_undo_context)
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
        # @see TextCommand#createCurrent
        def create_current
          if (!self.attr_f_folding_into_compound_change)
            return self.class::TextCommand.new(self.attr_f_undo_context)
          end
          reinitialize
          return self
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.DefaultUndoManager.TextCommand#commit()
        def commit
          # if there is pending data, update the command
          if (self.attr_f_start > -1)
            update_command
          end
          self.attr_f_current = create_current
          reset_process_change_sate
        end
        
        typesig { [] }
        # Checks whether the command is valid for undo or redo.
        # 
        # @return true if the command is valid.
        # @since 3.1
        def is_valid
          if (is_connected)
            return (self.attr_f_start > -1 || @f_commands.size > 0)
          end
          return false
        end
        
        typesig { [] }
        # Returns the undo modification stamp.
        # 
        # @return the undo modification stamp
        # @since 3.1
        def get_undo_modification_stamp
          if (self.attr_f_start > -1)
            return super
          else
            if (@f_commands.size > 0)
              return (@f_commands.get(0)).get_undo_modification_stamp
            end
          end
          return self.attr_f_undo_modification_stamp
        end
        
        typesig { [] }
        # Returns the redo modification stamp.
        # 
        # @return the redo modification stamp
        # @since 3.1
        def get_redo_modification_stamp
          if (self.attr_f_start > -1)
            return super
          else
            if (@f_commands.size > 0)
              return (@f_commands.get(@f_commands.size - 1)).get_redo_modification_stamp
            end
          end
          return self.attr_f_redo_modification_stamp
        end
        
        private
        alias_method :initialize__compound_text_command, :initialize
      end }
      
      # Internal listener to mouse and key events.
      const_set_lazy(:KeyAndMouseListener) { Class.new do
        extend LocalClass
        include_class_members DefaultUndoManager
        include MouseListener
        include KeyListener
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick
        def mouse_double_click(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # If the right mouse button is pressed, the current editing command is closed
        # @see MouseListener#mouseDown
        def mouse_down(e)
          if ((e.attr_button).equal?(1))
            commit
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseUp
        def mouse_up(e)
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed
        def key_released(e)
        end
        
        typesig { [class_self::KeyEvent] }
        # On cursor keys, the current editing command is closed
        # @see KeyListener#keyPressed
        def key_pressed(e)
          case (e.attr_key_code)
          when SWT::ARROW_UP, SWT::ARROW_DOWN, SWT::ARROW_LEFT, SWT::ARROW_RIGHT
            commit
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__key_and_mouse_listener, :initialize
      end }
      
      # Internal listener to document changes.
      const_set_lazy(:DocumentListener) { Class.new do
        extend LocalClass
        include_class_members DefaultUndoManager
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
          # record the current valid state for the top operation in case it remains the
          # top operation but changes state.
          op = self.attr_f_history.get_undo_operation(self.attr_f_undo_context)
          was_valid = false
          if (!(op).nil?)
            was_valid = op.can_undo
          end
          # Process the change, providing the before and after timestamps
          process_change(event.get_offset, event.get_offset + event.get_length, event.get_text, @f_replaced_text, self.attr_f_preserved_undo_modification_stamp, self.attr_f_preserved_redo_modification_stamp)
          # now update fCurrent with the latest buffers from the document change.
          self.attr_f_current.pretend_commit
          if ((op).equal?(self.attr_f_current))
            # if the document change did not cause a new fCurrent to be created, then we should
            # notify the history that the current operation changed if its validity has changed.
            if (!(was_valid).equal?(self.attr_f_current.is_valid))
              self.attr_f_history.operation_changed(op)
            end
          else
            # if the change created a new fCurrent that we did not yet add to the
            # stack, do so if it's valid and we are not in the middle of a compound change.
            if (!(self.attr_f_current).equal?(self.attr_f_last_added_command) && self.attr_f_current.is_valid)
              add_to_command_stack(self.attr_f_current)
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
      
      # Internal text input listener.
      const_set_lazy(:TextInputListener) { Class.new do
        extend LocalClass
        include_class_members DefaultUndoManager
        include ITextInputListener
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
        def input_document_about_to_be_changed(old_input, new_input)
          if (!(old_input).nil? && !(self.attr_f_document_listener).nil?)
            old_input.remove_document_listener(self.attr_f_document_listener)
            commit
          end
        end
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
        def input_document_changed(old_input, new_input)
          if (!(new_input).nil?)
            if ((self.attr_f_document_listener).nil?)
              self.attr_f_document_listener = self.class::DocumentListener.new
            end
            new_input.add_document_listener(self.attr_f_document_listener)
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__text_input_listener, :initialize
      end }
      
      # @see IOperationHistoryListener
      # @since 3.1
      const_set_lazy(:HistoryListener) { Class.new do
        extend LocalClass
        include_class_members DefaultUndoManager
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
              self.attr_f_text_viewer.get_text_widget.get_display.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                extend LocalClass
                include_class_members HistoryListener
                include class_self::Runnable if class_self::Runnable.class == Module
                
                typesig { [] }
                define_method :run do
                  # if we are undoing/redoing a command we generated, then ignore
                  # the document changes associated with this undo or redo.
                  if (event.get_operation.is_a?(self.class::TextCommand))
                    if (self.attr_f_text_viewer.is_a?(self.class::TextViewer))
                      (self.attr_f_text_viewer).ignore_auto_edit_strategies(true)
                    end
                    listen_to_text_changes(false)
                    # in the undo case only, make sure compounds are closed
                    if ((type).equal?(OperationHistoryEvent::ABOUT_TO_UNDO))
                      if (self.attr_f_folding_into_compound_change)
                        end_compound_change
                      end
                    end
                  else
                    # the undo or redo has our context, but it is not one of
                    # our commands.  We will listen to the changes, but will
                    # reset the state that tracks the undo/redo history.
                    commit
                    self.attr_f_last_added_command = nil
                  end
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
              @f_operation = event.get_operation
            end
          when OperationHistoryEvent::UNDONE, OperationHistoryEvent::REDONE, OperationHistoryEvent::OPERATION_NOT_OK
            if ((event.get_operation).equal?(@f_operation))
              self.attr_f_text_viewer.get_text_widget.get_display.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                extend LocalClass
                include_class_members HistoryListener
                include class_self::Runnable if class_self::Runnable.class == Module
                
                typesig { [] }
                define_method :run do
                  listen_to_text_changes(true)
                  self.attr_f_operation = nil
                  if (self.attr_f_text_viewer.is_a?(self.class::TextViewer))
                    (self.attr_f_text_viewer).ignore_auto_edit_strategies(false)
                  end
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
        
        typesig { [] }
        def initialize
          @f_operation = nil
        end
        
        private
        alias_method :initialize__history_listener, :initialize
      end }
    }
    
    # Text buffer to collect text which is inserted into the viewer
    attr_accessor :f_text_buffer
    alias_method :attr_f_text_buffer, :f_text_buffer
    undef_method :f_text_buffer
    alias_method :attr_f_text_buffer=, :f_text_buffer=
    undef_method :f_text_buffer=
    
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
    
    # The document modification stamp for redo.
    attr_accessor :f_preserved_redo_modification_stamp
    alias_method :attr_f_preserved_redo_modification_stamp, :f_preserved_redo_modification_stamp
    undef_method :f_preserved_redo_modification_stamp
    alias_method :attr_f_preserved_redo_modification_stamp=, :f_preserved_redo_modification_stamp=
    undef_method :f_preserved_redo_modification_stamp=
    
    # The internal key and mouse event listener
    attr_accessor :f_key_and_mouse_listener
    alias_method :attr_f_key_and_mouse_listener, :f_key_and_mouse_listener
    undef_method :f_key_and_mouse_listener
    alias_method :attr_f_key_and_mouse_listener=, :f_key_and_mouse_listener=
    undef_method :f_key_and_mouse_listener=
    
    # The internal document listener
    attr_accessor :f_document_listener
    alias_method :attr_f_document_listener, :f_document_listener
    undef_method :f_document_listener
    alias_method :attr_f_document_listener=, :f_document_listener=
    undef_method :f_document_listener=
    
    # The internal text input listener
    attr_accessor :f_text_input_listener
    alias_method :attr_f_text_input_listener, :f_text_input_listener
    undef_method :f_text_input_listener
    alias_method :attr_f_text_input_listener=, :f_text_input_listener=
    undef_method :f_text_input_listener=
    
    # Indicates inserting state
    attr_accessor :f_inserting
    alias_method :attr_f_inserting, :f_inserting
    undef_method :f_inserting
    alias_method :attr_f_inserting=, :f_inserting=
    undef_method :f_inserting=
    
    # Indicates overwriting state
    attr_accessor :f_overwriting
    alias_method :attr_f_overwriting, :f_overwriting
    undef_method :f_overwriting
    alias_method :attr_f_overwriting=, :f_overwriting=
    undef_method :f_overwriting=
    
    # Indicates whether the current change belongs to a compound change
    attr_accessor :f_folding_into_compound_change
    alias_method :attr_f_folding_into_compound_change, :f_folding_into_compound_change
    undef_method :f_folding_into_compound_change
    alias_method :attr_f_folding_into_compound_change=, :f_folding_into_compound_change=
    undef_method :f_folding_into_compound_change=
    
    # The text viewer the undo manager is connected to
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # Supported undo level
    attr_accessor :f_undo_level
    alias_method :attr_f_undo_level, :f_undo_level
    undef_method :f_undo_level
    alias_method :attr_f_undo_level=, :f_undo_level=
    undef_method :f_undo_level=
    
    # The currently constructed edit command
    attr_accessor :f_current
    alias_method :attr_f_current, :f_current
    undef_method :f_current
    alias_method :attr_f_current=, :f_current=
    undef_method :f_current=
    
    # The last delete edit command
    attr_accessor :f_previous_delete
    alias_method :attr_f_previous_delete, :f_previous_delete
    undef_method :f_previous_delete
    alias_method :attr_f_previous_delete=, :f_previous_delete=
    undef_method :f_previous_delete=
    
    # The undo context.
    # @since 3.1
    attr_accessor :f_history
    alias_method :attr_f_history, :f_history
    undef_method :f_history
    alias_method :attr_f_history=, :f_history=
    undef_method :f_history=
    
    # The operation history.
    # @since 3.1
    attr_accessor :f_undo_context
    alias_method :attr_f_undo_context, :f_undo_context
    undef_method :f_undo_context
    alias_method :attr_f_undo_context=, :f_undo_context=
    undef_method :f_undo_context=
    
    # The operation history listener used for managing undo and redo before
    # and after the individual commands are performed.
    # @since 3.1
    attr_accessor :f_history_listener
    alias_method :attr_f_history_listener, :f_history_listener
    undef_method :f_history_listener
    alias_method :attr_f_history_listener=, :f_history_listener=
    undef_method :f_history_listener=
    
    # The command last added to the operation history.  This must be tracked
    # internally instead of asking the history, since outside parties may be placing
    # items on our undo/redo history.
    attr_accessor :f_last_added_command
    alias_method :attr_f_last_added_command, :f_last_added_command
    undef_method :f_last_added_command
    alias_method :attr_f_last_added_command=, :f_last_added_command=
    undef_method :f_last_added_command=
    
    typesig { [::Java::Int] }
    # Creates a new undo manager who remembers the specified number of edit commands.
    # 
    # @param undoLevel the length of this manager's history
    def initialize(undo_level)
      @f_text_buffer = StringBuffer.new
      @f_preserved_text_buffer = StringBuffer.new
      @f_preserved_undo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      @f_preserved_redo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      @f_key_and_mouse_listener = nil
      @f_document_listener = nil
      @f_text_input_listener = nil
      @f_inserting = false
      @f_overwriting = false
      @f_folding_into_compound_change = false
      @f_text_viewer = nil
      @f_undo_level = 0
      @f_current = nil
      @f_previous_delete = nil
      @f_history = nil
      @f_undo_context = nil
      @f_history_listener = HistoryListener.new_local(self)
      @f_last_added_command = nil
      @f_history = OperationHistoryFactory.get_operation_history
      set_maximal_undo_level(undo_level)
    end
    
    typesig { [] }
    # Returns whether this undo manager is connected to a text viewer.
    # 
    # @return <code>true</code> if connected, <code>false</code> otherwise
    # @since 3.1
    def is_connected
      return !(@f_text_viewer).nil?
    end
    
    typesig { [] }
    # @see IUndoManager#beginCompoundChange
    def begin_compound_change
      if (is_connected)
        @f_folding_into_compound_change = true
        commit
      end
    end
    
    typesig { [] }
    # @see IUndoManager#endCompoundChange
    def end_compound_change
      if (is_connected)
        @f_folding_into_compound_change = false
        commit
      end
    end
    
    typesig { [] }
    # Registers all necessary listeners with the text viewer.
    def add_listeners
      text = @f_text_viewer.get_text_widget
      if (!(text).nil?)
        @f_key_and_mouse_listener = KeyAndMouseListener.new_local(self)
        text.add_mouse_listener(@f_key_and_mouse_listener)
        text.add_key_listener(@f_key_and_mouse_listener)
        @f_text_input_listener = TextInputListener.new_local(self)
        @f_text_viewer.add_text_input_listener(@f_text_input_listener)
        @f_history.add_operation_history_listener(@f_history_listener)
        listen_to_text_changes(true)
      end
    end
    
    typesig { [] }
    # Unregister all previously installed listeners from the text viewer.
    def remove_listeners
      text = @f_text_viewer.get_text_widget
      if (!(text).nil?)
        if (!(@f_key_and_mouse_listener).nil?)
          text.remove_mouse_listener(@f_key_and_mouse_listener)
          text.remove_key_listener(@f_key_and_mouse_listener)
          @f_key_and_mouse_listener = nil
        end
        if (!(@f_text_input_listener).nil?)
          @f_text_viewer.remove_text_input_listener(@f_text_input_listener)
          @f_text_input_listener = nil
        end
        listen_to_text_changes(false)
        @f_history.remove_operation_history_listener(@f_history_listener)
      end
    end
    
    typesig { [TextCommand] }
    # Adds the given command to the operation history if it is not part of
    # a compound change.
    # 
    # @param command the command to be added
    # @since 3.1
    def add_to_command_stack(command)
      if (!@f_folding_into_compound_change || command.is_a?(CompoundTextCommand))
        @f_history.add(command)
        @f_last_added_command = command
      end
    end
    
    typesig { [] }
    # Disposes the command stack.
    # 
    # @since 3.1
    def dispose_command_stack
      @f_history.dispose(@f_undo_context, true, true, true)
    end
    
    typesig { [] }
    # Initializes the command stack.
    # 
    # @since 3.1
    def initialize_command_stack
      if (!(@f_history).nil? && !(@f_undo_context).nil?)
        @f_history.dispose(@f_undo_context, true, true, false)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Switches the state of whether there is a text listener or not.
    # 
    # @param listen the state which should be established
    def listen_to_text_changes(listen)
      if (listen)
        if ((@f_document_listener).nil? && !(@f_text_viewer.get_document).nil?)
          @f_document_listener = DocumentListener.new_local(self)
          @f_text_viewer.get_document.add_document_listener(@f_document_listener)
        end
      else
        if (!listen)
          if (!(@f_document_listener).nil? && !(@f_text_viewer.get_document).nil?)
            @f_text_viewer.get_document.remove_document_listener(@f_document_listener)
            @f_document_listener = nil
          end
        end
      end
    end
    
    typesig { [] }
    # Closes the current editing command and opens a new one.
    def commit
      # if fCurrent has never been placed on the command stack, do so now.
      # this can happen when there are multiple programmatically commits in a single
      # document change.
      if (!(@f_last_added_command).equal?(@f_current))
        @f_current.pretend_commit
        if (@f_current.is_valid)
          add_to_command_stack(@f_current)
        end
      end
      @f_current.commit
    end
    
    typesig { [] }
    # Reset processChange state.
    # 
    # @since 3.2
    def reset_process_change_sate
      @f_inserting = false
      @f_overwriting = false
      @f_previous_delete.reinitialize
    end
    
    typesig { [String] }
    # Checks whether the given text starts with a line delimiter and
    # subsequently contains a white space only.
    # 
    # @param text the text to check
    # @return <code>true</code> if the text is a line delimiter followed by whitespace, <code>false</code> otherwise
    def is_whitespace_text(text)
      if ((text).nil? || (text.length).equal?(0))
        return false
      end
      delimiters = @f_text_viewer.get_document.get_legal_line_delimiters
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
          if (length_ >= 0)
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
          # text will be deleted by backspace or DEL key or empty clipboard
          length_ = replaced_text.length
          delimiters = @f_text_viewer.get_document.get_legal_line_delimiters
          if (((length_).equal?(1)) || (TextUtilities == delimiters) > -1)
            # whereby selection is empty
            if ((@f_previous_delete.attr_f_start).equal?(model_start) && (@f_previous_delete.attr_f_end).equal?(model_end))
              # repeated DEL
              # correct wrong settings of fCurrent
              if ((@f_current.attr_f_start).equal?(model_end) && (@f_current.attr_f_end).equal?(model_start))
                @f_current.attr_f_start = model_start
                @f_current.attr_f_end = model_end
              end
              # append to buffer && extend command range
              @f_preserved_text_buffer.append(replaced_text)
              (@f_current.attr_f_end += 1)
            else
              if ((@f_previous_delete.attr_f_start).equal?(model_end))
                # repeated backspace
                # insert in buffer and extend command range
                @f_preserved_text_buffer.insert(0, replaced_text)
                @f_current.attr_f_start = model_start
              else
                # either DEL or backspace for the first time
                @f_current.attr_f_redo_modification_stamp = before_change_modification_stamp
                if (@f_current.attempt_commit)
                  @f_current.attr_f_undo_modification_stamp = before_change_modification_stamp
                end
                # as we can not decide whether it was DEL or backspace we initialize for backspace
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
            delimiters = @f_text_viewer.get_document.get_legal_line_delimiters
            if (((length_).equal?(1)) || (TextUtilities == delimiters) > -1)
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
      # in all cases, the redo modification stamp is updated on the open command
      @f_current.attr_f_redo_modification_stamp = after_change_modification_stamp
    end
    
    typesig { [String, JavaException] }
    # Shows the given exception in an error dialog.
    # 
    # @param title the dialog title
    # @param ex the exception
    # @since 3.1
    def open_error_dialog(title, ex)
      shell = nil
      if (is_connected)
        st = @f_text_viewer.get_text_widget
        if (!(st).nil? && !st.is_disposed)
          shell = st.get_shell
        end
      end
      if (!(Display.get_current).nil?)
        MessageDialog.open_error(shell, title, ex.get_localized_message)
      else
        display = nil
        final_shell = shell
        if (!(final_shell).nil?)
          display = final_shell.get_display
        else
          display = Display.get_default
        end
        display.sync_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members DefaultUndoManager
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            MessageDialog.open_error(final_shell, title, ex.get_localized_message)
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
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IUndoManager#setMaximalUndoLevel(int)
    def set_maximal_undo_level(undo_level)
      @f_undo_level = Math.max(0, undo_level)
      if (is_connected)
        @f_history.set_limit(@f_undo_context, @f_undo_level)
      end
    end
    
    typesig { [ITextViewer] }
    # @see org.eclipse.jface.text.IUndoManager#connect(org.eclipse.jface.text.ITextViewer)
    def connect(text_viewer)
      if (!is_connected && !(text_viewer).nil?)
        @f_text_viewer = text_viewer
        if ((@f_undo_context).nil?)
          @f_undo_context = ObjectUndoContext.new(self)
        end
        @f_history.set_limit(@f_undo_context, @f_undo_level)
        initialize_command_stack
        # open up the current command
        @f_current = TextCommand.new_local(self, @f_undo_context)
        @f_previous_delete = TextCommand.new_local(self, @f_undo_context)
        add_listeners
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#disconnect()
    def disconnect
      if (is_connected)
        remove_listeners
        @f_current = nil
        @f_text_viewer = nil
        dispose_command_stack
        @f_text_buffer = nil
        @f_preserved_text_buffer = nil
        @f_undo_context = nil
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#reset()
    def reset
      if (is_connected)
        initialize_command_stack
        @f_current = TextCommand.new_local(self, @f_undo_context)
        @f_folding_into_compound_change = false
        @f_inserting = false
        @f_overwriting = false
        @f_text_buffer.set_length(0)
        @f_preserved_text_buffer.set_length(0)
        @f_preserved_undo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
        @f_preserved_redo_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#redoable()
    def redoable
      return @f_history.can_redo(@f_undo_context)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#undoable()
    def undoable
      return @f_history.can_undo(@f_undo_context)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#redo()
    def redo_
      if (is_connected && redoable)
        begin
          @f_history.redo_(@f_undo_context, nil, nil)
        rescue ExecutionException => ex
          open_error_dialog(JFaceTextMessages.get_string("DefaultUndoManager.error.redoFailed.title"), ex) # $NON-NLS-1$
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#undo()
    def undo
      if (is_connected && undoable)
        begin
          @f_history.undo(@f_undo_context, nil, nil)
        rescue ExecutionException => ex
          open_error_dialog(JFaceTextMessages.get_string("DefaultUndoManager.error.undoFailed.title"), ex) # $NON-NLS-1$
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Selects and reveals the specified range.
    # 
    # @param offset the offset of the range
    # @param length the length of the range
    # @since 3.0
    def select_and_reveal(offset, length_)
      if (@f_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_text_viewer
        extension.expose_model_range(Region.new(offset, length_))
      else
        if (!@f_text_viewer.overlaps_with_visible_region(offset, length_))
          @f_text_viewer.reset_visible_region
        end
      end
      @f_text_viewer.set_selected_range(offset, length_)
      @f_text_viewer.reveal_range(offset, length_)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManagerExtension#getUndoContext()
    # @since 3.1
    def get_undo_context
      return @f_undo_context
    end
    
    private
    alias_method :initialize__default_undo_manager, :initialize
  end
  
end
