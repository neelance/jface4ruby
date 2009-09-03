require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DocumentCommandImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Represents a text modification as a document replace command. The text
  # modification is given as a {@link org.eclipse.swt.events.VerifyEvent} and
  # translated into a document replace command relative to a given offset. A
  # document command can also be used to initialize a given
  # <code>VerifyEvent</code>.
  # <p>
  # A document command can also represent a list of related changes.</p>
  class DocumentCommand 
    include_class_members DocumentCommandImports
    
    class_module.module_eval {
      # A command which is added to document commands.
      # @since 2.1
      const_set_lazy(:Command) { Class.new do
        include_class_members DocumentCommand
        include JavaComparable
        
        # The offset of the range to be replaced
        attr_accessor :f_offset
        alias_method :attr_f_offset, :f_offset
        undef_method :f_offset
        alias_method :attr_f_offset=, :f_offset=
        undef_method :f_offset=
        
        # The length of the range to be replaced.
        attr_accessor :f_length
        alias_method :attr_f_length, :f_length
        undef_method :f_length
        alias_method :attr_f_length=, :f_length=
        undef_method :f_length=
        
        # The replacement text
        attr_accessor :f_text
        alias_method :attr_f_text, :f_text
        undef_method :f_text
        alias_method :attr_f_text=, :f_text=
        undef_method :f_text=
        
        # The listener who owns this command
        attr_accessor :f_owner
        alias_method :attr_f_owner, :f_owner
        undef_method :f_owner
        alias_method :attr_f_owner=, :f_owner=
        undef_method :f_owner=
        
        typesig { [::Java::Int, ::Java::Int, String, class_self::IDocumentListener] }
        # Creates a new command with the given specification.
        # 
        # @param offset the offset of the replace command
        # @param length the length of the replace command
        # @param text the text to replace with, may be <code>null</code>
        # @param owner the document command owner, may be <code>null</code>
        # @since 3.0
        def initialize(offset, length, text, owner)
          @f_offset = 0
          @f_length = 0
          @f_text = nil
          @f_owner = nil
          if (offset < 0 || length < 0)
            raise self.class::IllegalArgumentException.new
          end
          @f_offset = offset
          @f_length = length
          @f_text = text
          @f_owner = owner
        end
        
        typesig { [class_self::IDocument] }
        # Executes the document command on the specified document.
        # 
        # @param document the document on which to execute the command.
        # @throws BadLocationException in case this commands cannot be executed
        def execute(document)
          if ((@f_length).equal?(0) && (@f_text).nil?)
            return
          end
          if (!(@f_owner).nil?)
            document.remove_document_listener(@f_owner)
          end
          document.replace(@f_offset, @f_length, @f_text)
          if (!(@f_owner).nil?)
            document.add_document_listener(@f_owner)
          end
        end
        
        typesig { [Object] }
        # @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
        def compare_to(object)
          if (is_equal(object))
            return 0
          end
          command = object
          # diff middle points if not intersecting
          if (@f_offset + @f_length <= command.attr_f_offset || command.attr_f_offset + command.attr_f_length <= @f_offset)
            value = (2 * @f_offset + @f_length) - (2 * command.attr_f_offset + command.attr_f_length)
            if (!(value).equal?(0))
              return value
            end
          end
          # the answer
          return 42
        end
        
        typesig { [Object] }
        def is_equal(object)
          if ((object).equal?(self))
            return true
          end
          if (!(object.is_a?(self.class::Command)))
            return false
          end
          command = object
          return (command.attr_f_offset).equal?(@f_offset) && (command.attr_f_length).equal?(@f_length)
        end
        
        private
        alias_method :initialize__command, :initialize
      end }
      
      # An iterator, which iterates in reverse over a list.
      const_set_lazy(:ReverseListIterator) { Class.new do
        include_class_members DocumentCommand
        include Iterator
        
        # The list iterator.
        attr_accessor :f_list_iterator
        alias_method :attr_f_list_iterator, :f_list_iterator
        undef_method :f_list_iterator
        alias_method :attr_f_list_iterator=, :f_list_iterator=
        undef_method :f_list_iterator=
        
        typesig { [class_self::ListIterator] }
        # Creates a reverse list iterator.
        # @param listIterator the iterator that this reverse iterator is based upon
        def initialize(list_iterator)
          @f_list_iterator = nil
          if ((list_iterator).nil?)
            raise self.class::IllegalArgumentException.new
          end
          @f_list_iterator = list_iterator
        end
        
        typesig { [] }
        # @see java.util.Iterator#hasNext()
        def has_next
          return @f_list_iterator.has_previous
        end
        
        typesig { [] }
        # @see java.util.Iterator#next()
        def next_
          return @f_list_iterator.previous
        end
        
        typesig { [] }
        # @see java.util.Iterator#remove()
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__reverse_list_iterator, :initialize
      end }
      
      # A command iterator.
      const_set_lazy(:CommandIterator) { Class.new do
        include_class_members DocumentCommand
        include Iterator
        
        # The command iterator.
        attr_accessor :f_iterator
        alias_method :attr_f_iterator, :f_iterator
        undef_method :f_iterator
        alias_method :attr_f_iterator=, :f_iterator=
        undef_method :f_iterator=
        
        # The original command.
        attr_accessor :f_command
        alias_method :attr_f_command, :f_command
        undef_method :f_command
        alias_method :attr_f_command=, :f_command=
        undef_method :f_command=
        
        # A flag indicating the direction of iteration.
        attr_accessor :f_forward
        alias_method :attr_f_forward, :f_forward
        undef_method :f_forward
        alias_method :attr_f_forward=, :f_forward=
        undef_method :f_forward=
        
        typesig { [class_self::JavaList, class_self::Command, ::Java::Boolean] }
        # Creates a command iterator.
        # 
        # @param commands an ascending ordered list of commands
        # @param command the original command
        # @param forward the direction
        def initialize(commands, command, forward)
          @f_iterator = nil
          @f_command = nil
          @f_forward = false
          if ((commands).nil? || (command).nil?)
            raise self.class::IllegalArgumentException.new
          end
          @f_iterator = forward ? commands.iterator : self.class::ReverseListIterator.new(commands.list_iterator(commands.size))
          @f_command = command
          @f_forward = forward
        end
        
        typesig { [] }
        # @see java.util.Iterator#hasNext()
        def has_next
          return !(@f_command).nil? || @f_iterator.has_next
        end
        
        typesig { [] }
        # @see java.util.Iterator#next()
        def next_
          if (!has_next)
            raise self.class::NoSuchElementException.new
          end
          if ((@f_command).nil?)
            return @f_iterator.next_
          end
          if (!@f_iterator.has_next)
            temp_command = @f_command
            @f_command = nil
            return temp_command
          end
          command = @f_iterator.next_
          compare_value = (command <=> @f_command)
          if ((compare_value < 0) ^ !@f_forward)
            return command
          else
            if ((compare_value > 0) ^ !@f_forward)
              temp_command = @f_command
              @f_command = command
              return temp_command
            else
              raise self.class::IllegalArgumentException.new
            end
          end
        end
        
        typesig { [] }
        # @see java.util.Iterator#remove()
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__command_iterator, :initialize
      end }
    }
    
    # Must the command be updated
    attr_accessor :doit
    alias_method :attr_doit, :doit
    undef_method :doit
    alias_method :attr_doit=, :doit=
    undef_method :doit=
    
    # The offset of the command.
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    # The length of the command
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    # The text to be inserted
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    # The owner of the document command which will not be notified.
    # @since 2.1
    attr_accessor :owner
    alias_method :attr_owner, :owner
    undef_method :owner
    alias_method :attr_owner=, :owner=
    undef_method :owner=
    
    # The caret offset with respect to the document before the document command is executed.
    # @since 2.1
    attr_accessor :caret_offset
    alias_method :attr_caret_offset, :caret_offset
    undef_method :caret_offset
    alias_method :attr_caret_offset=, :caret_offset=
    undef_method :caret_offset=
    
    # Additional document commands.
    # @since 2.1
    attr_accessor :f_commands
    alias_method :attr_f_commands, :f_commands
    undef_method :f_commands
    alias_method :attr_f_commands=, :f_commands=
    undef_method :f_commands=
    
    # Indicates whether the caret should be shifted by this command.
    # @since 3.0
    attr_accessor :shifts_caret
    alias_method :attr_shifts_caret, :shifts_caret
    undef_method :shifts_caret
    alias_method :attr_shifts_caret=, :shifts_caret=
    undef_method :shifts_caret=
    
    typesig { [] }
    # Creates a new document command.
    def initialize
      @doit = false
      @offset = 0
      @length = 0
      @text = nil
      @owner = nil
      @caret_offset = 0
      @f_commands = ArrayList.new
      @shifts_caret = false
    end
    
    typesig { [VerifyEvent, IRegion] }
    # Translates a verify event into a document replace command using the given offset.
    # 
    # @param event the event to be translated
    # @param modelRange the event range as model range
    def set_event(event, model_range)
      @doit = true
      @text = RJava.cast_to_string(event.attr_text)
      @offset = model_range.get_offset
      @length = model_range.get_length
      @owner = nil
      @caret_offset = -1
      @shifts_caret = true
      @f_commands.clear
    end
    
    typesig { [VerifyEvent, IRegion] }
    # Fills the given verify event with the replace text and the <code>doit</code>
    # flag of this document command. Returns whether the document command
    # covers the same range as the verify event considering the given offset.
    # 
    # @param event the event to be changed
    # @param modelRange to be considered for range comparison
    # @return <code>true</code> if this command and the event cover the same range
    def fill_event(event, model_range)
      event.attr_text = @text
      event.attr_doit = ((@offset).equal?(model_range.get_offset) && (@length).equal?(model_range.get_length) && @doit && (@caret_offset).equal?(-1))
      return event.attr_doit
    end
    
    typesig { [::Java::Int, ::Java::Int, String, IDocumentListener] }
    # Adds an additional replace command. The added replace command must not overlap
    # with existing ones. If the document command owner is not <code>null</code>, it will not
    # get document change notifications for the particular command.
    # 
    # @param commandOffset the offset of the region to replace
    # @param commandLength the length of the region to replace
    # @param commandText the text to replace with, may be <code>null</code>
    # @param commandOwner the command owner, may be <code>null</code>
    # @throws BadLocationException if the added command intersects with an existing one
    # @since 2.1
    def add_command(command_offset, command_length, command_text, command_owner)
      command = Command.new(command_offset, command_length, command_text, command_owner)
      if (intersects(command))
        raise BadLocationException.new
      end
      index = Collections.binary_search(@f_commands, command)
      # a command with exactly the same ranges exists already
      if (index >= 0)
        raise BadLocationException.new
      end
      # binary search result is defined as (-(insertionIndex) - 1)
      insertion_index = -(index + 1)
      # overlaps to the right?
      if (!(insertion_index).equal?(@f_commands.size) && intersects(@f_commands.get(insertion_index), command))
        raise BadLocationException.new
      end
      # overlaps to the left?
      if (!(insertion_index).equal?(0) && intersects(@f_commands.get(insertion_index - 1), command))
        raise BadLocationException.new
      end
      @f_commands.add(insertion_index, command)
    end
    
    typesig { [] }
    # Returns an iterator over the commands in ascending position order.
    # The iterator includes the original document command.
    # Commands cannot be removed.
    # 
    # @return returns the command iterator
    def get_command_iterator
      command = Command.new(@offset, @length, @text, @owner)
      return CommandIterator.new(@f_commands, command, true)
    end
    
    typesig { [] }
    # Returns the number of commands including the original document command.
    # 
    # @return returns the number of commands
    # @since 2.1
    def get_command_count
      return 1 + @f_commands.size
    end
    
    typesig { [Command, Command] }
    # Returns whether the two given commands intersect.
    # 
    # @param command0 the first command
    # @param command1 the second command
    # @return <code>true</code> if the commands intersect
    # @since 2.1
    def intersects(command0, command1)
      # diff middle points if not intersecting
      if (command0.attr_f_offset + command0.attr_f_length <= command1.attr_f_offset || command1.attr_f_offset + command1.attr_f_length <= command0.attr_f_offset)
        return ((2 * command0.attr_f_offset + command0.attr_f_length) - (2 * command1.attr_f_offset + command1.attr_f_length)).equal?(0)
      end
      return true
    end
    
    typesig { [Command] }
    # Returns whether the given command intersects with this command.
    # 
    # @param command the command
    # @return <code>true</code> if the command intersects with this command
    # @since 2.1
    def intersects(command)
      # diff middle points if not intersecting
      if (@offset + @length <= command.attr_f_offset || command.attr_f_offset + command.attr_f_length <= @offset)
        return ((2 * @offset + @length) - (2 * command.attr_f_offset + command.attr_f_length)).equal?(0)
      end
      return true
    end
    
    typesig { [IDocument] }
    # Executes the document commands on a document.
    # 
    # @param document the document on which to execute the commands
    # @throws BadLocationException in case access to the given document fails
    # @since 2.1
    def execute(document)
      if ((@length).equal?(0) && (@text).nil? && (@f_commands.size).equal?(0))
        return
      end
      updater = DefaultPositionUpdater.new(get_category)
      caret_position = nil
      begin
        if (update_caret)
          document.add_position_category(get_category)
          document.add_position_updater(updater)
          caret_position = Position.new(@caret_offset)
          document.add_position(get_category, caret_position)
        end
        original_command = Command.new(@offset, @length, @text, @owner)
        iterator = CommandIterator.new(@f_commands, original_command, false)
        while iterator.has_next
          (iterator.next_).execute(document)
        end
      rescue BadLocationException => e
        # ignore
      rescue BadPositionCategoryException => e
        # ignore
      ensure
        if (update_caret)
          document.remove_position_updater(updater)
          begin
            document.remove_position_category(get_category)
          rescue BadPositionCategoryException => e
            Assert.is_true(false)
          end
          @caret_offset = caret_position.get_offset
        end
      end
    end
    
    typesig { [] }
    # Returns <code>true</code> if the caret offset should be updated, <code>false</code> otherwise.
    # 
    # @return <code>true</code> if the caret offset should be updated, <code>false</code> otherwise
    # @since 3.0
    def update_caret
      return @shifts_caret && !(@caret_offset).equal?(-1)
    end
    
    typesig { [] }
    # Returns the position category for the caret offset position.
    # 
    # @return the position category for the caret offset position
    # @since 3.0
    def get_category
      return to_s
    end
    
    private
    alias_method :initialize__document_command, :initialize
  end
  
end
