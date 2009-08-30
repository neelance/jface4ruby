require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Operations
  module AbstractOperationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
    }
  end
  
  # <p>
  # Abstract implementation for an undoable operation. At a minimum, subclasses
  # should implement behavior for
  # {@link IUndoableOperation#execute(org.eclipse.core.runtime.IProgressMonitor, org.eclipse.core.runtime.IAdaptable)},
  # {@link IUndoableOperation#redo(org.eclipse.core.runtime.IProgressMonitor, org.eclipse.core.runtime.IAdaptable)},
  # and
  # {@link IUndoableOperation#undo(org.eclipse.core.runtime.IProgressMonitor, org.eclipse.core.runtime.IAdaptable)}.
  # </p>
  # 
  # @see org.eclipse.core.commands.operations.IUndoableOperation
  # 
  # @since 3.1
  class AbstractOperation 
    include_class_members AbstractOperationImports
    include IUndoableOperation
    
    attr_accessor :contexts
    alias_method :attr_contexts, :contexts
    undef_method :contexts
    alias_method :attr_contexts=, :contexts=
    undef_method :contexts=
    
    attr_accessor :label
    alias_method :attr_label, :label
    undef_method :label
    alias_method :attr_label=, :label=
    undef_method :label=
    
    typesig { [String] }
    # $NON-NLS-1$
    # 
    # Construct an operation that has the specified label.
    # 
    # @param label
    # the label to be used for the operation. Should never be
    # <code>null</code>.
    def initialize(label)
      @contexts = ArrayList.new
      @label = ""
      Assert.is_not_null(label)
      @label = label
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#addContext(org.eclipse.core.commands.operations.IUndoContext)
    # 
    # <p> Subclasses may override this method. </p>
    def add_context(context)
      if (!@contexts.contains(context))
        @contexts.add(context)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#canExecute()
    # <p> Default implementation. Subclasses may override this method.
    # </p>
    def can_execute
      return true
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#canRedo()
    # <p> Default implementation. Subclasses may override this method.
    # </p>
    def can_redo
      return true
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#canUndo()
    # <p> Default implementation. Subclasses may override this method.
    # </p>
    def can_undo
      return true
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#dispose()
    # <p> Default implementation. Subclasses may override this method.
    # </p>
    def dispose
      # nothing to dispose.
    end
    
    typesig { [IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#execute(org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def execute(monitor, info)
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_contexts
      return @contexts.to_array(Array.typed(IUndoContext).new(@contexts.size) { nil })
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#getLabel()
    # <p> Default implementation. Subclasses may override this method.
    # </p>
    def get_label
      return @label
    end
    
    typesig { [String] }
    # Set the label of the operation to the specified name.
    # 
    # @param name
    # the string to be used for the label. Should never be
    # <code>null</code>.
    def set_label(name)
      @label = name
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#hasContext(org.eclipse.core.commands.operations.IUndoContext)
    def has_context(context)
      Assert.is_not_null(context)
      i = 0
      while i < @contexts.size
        other_context = @contexts.get(i)
        # have to check both ways because one context may be more general
        # in
        # its matching rules than another.
        if (context.matches(other_context) || other_context.matches(context))
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#redo(org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def redo_(monitor, info)
      raise NotImplementedError
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#removeContext(org.eclipse.core.commands.operations.IUndoContext)
    # <p> Default implementation. Subclasses may override this method.
    # </p>
    def remove_context(context)
      @contexts.remove(context)
    end
    
    typesig { [IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#undo(org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def undo(monitor, info)
      raise NotImplementedError
    end
    
    typesig { [] }
    # The string representation of this operation. Used for debugging purposes
    # only. This string should not be shown to an end user.
    # 
    # @return The string representation.
    def to_s
      string_buffer = StringBuffer.new
      string_buffer.append(get_label)
      string_buffer.append("(") # $NON-NLS-1$
      contexts = get_contexts
      i = 0
      while i < contexts.attr_length
        string_buffer.append(contexts[i].to_s)
        if (!(i).equal?(contexts.attr_length - 1))
          string_buffer.append(Character.new(?,.ord))
        end
        i += 1
      end
      string_buffer.append(Character.new(?).ord))
      return string_buffer.to_s
    end
    
    private
    alias_method :initialize__abstract_operation, :initialize
  end
  
end
