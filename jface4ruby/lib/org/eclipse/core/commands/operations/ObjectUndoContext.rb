require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Operations
  module ObjectUndoContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
    }
  end
  
  # <p>
  # An undo context that can be used to represent any given object. Clients
  # can add matching contexts to this context.  This class may be instantiated
  # by clients.
  # </p>
  # 
  # @since 3.1
  class ObjectUndoContext < ObjectUndoContextImports.const_get :UndoContext
    include_class_members ObjectUndoContextImports
    
    attr_accessor :object
    alias_method :attr_object, :object
    undef_method :object
    alias_method :attr_object=, :object=
    undef_method :object=
    
    attr_accessor :label
    alias_method :attr_label, :label
    undef_method :label
    alias_method :attr_label=, :label=
    undef_method :label=
    
    attr_accessor :children
    alias_method :attr_children, :children
    undef_method :children
    alias_method :attr_children=, :children=
    undef_method :children=
    
    typesig { [Object] }
    # Construct an operation context that represents the given object.
    # 
    # @param object
    # the object to be represented.
    def initialize(object)
      initialize__object_undo_context(object, nil)
    end
    
    typesig { [Object, String] }
    # Construct an operation context that represents the given object and has a
    # specialized label.
    # 
    # @param object
    # the object to be represented.
    # @param label
    # the label for the context
    def initialize(object, label)
      @object = nil
      @label = nil
      @children = nil
      super()
      @children = ArrayList.new
      @object = object
      @label = label
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoContext#getLabel()
    def get_label
      if (!(@label).nil?)
        return @label
      end
      if (!(@object).nil?)
        return @object.to_s
      end
      return super
    end
    
    typesig { [] }
    # Return the object that is represented by this context.
    # 
    # @return the object represented by this context.
    def get_object
      return @object
    end
    
    typesig { [IUndoContext] }
    # Add the specified context as a match of this context. Contexts added as
    # matches of this context will be interpreted as a match of this context
    # when the history is filtered for a particular context. Adding a match
    # allows components to create their own contexts for implementing
    # specialized behavior, yet have their operations appear in a more
    # global context.
    # 
    # @param context
    # the context to be added as a match of this context
    def add_match(context)
      @children.add(context)
    end
    
    typesig { [IUndoContext] }
    # Remove the specified context as a match of this context. The context will
    # no longer be interpreted as a match of this context when the history is
    # filtered for a particular context. This method has no effect if the
    # specified context was never previously added as a match.
    # 
    # @param context
    # the context to be removed from the list of matches for this
    # context
    def remove_match(context)
      @children.remove(context)
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoContext#matches(IUndoContext
    # context)
    def matches(context)
      # Check first for explicit matches that have been assigned.
      if (@children.contains(context))
        return true
      end
      # Contexts for equal objects are considered matching
      if (context.is_a?(ObjectUndoContext) && !(get_object).nil?)
        return (get_object == (context).get_object)
      end
      # Use the normal matching implementation
      return super(context)
    end
    
    typesig { [] }
    # The string representation of this operation.  Used for debugging purposes only.
    # This string should not be shown to an end user.
    # 
    # @return The string representation.
    def to_s
      return get_label
    end
    
    private
    alias_method :initialize__object_undo_context, :initialize
  end
  
end
