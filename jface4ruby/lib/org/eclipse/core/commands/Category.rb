require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module CategoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Core::Commands::Common, :NamedHandleObject
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # <p>
  # A logical group for a set of commands. A command belongs to exactly one
  # category. The category has no functional effect, but may be used in graphical
  # tools that want to group the set of commands somehow.
  # </p>
  # 
  # @since 3.1
  class Category < CategoryImports.const_get :NamedHandleObject
    include_class_members CategoryImports
    
    # A collection of objects listening to changes to this category. This
    # collection is <code>null</code> if there are no listeners.
    attr_accessor :category_listeners
    alias_method :attr_category_listeners, :category_listeners
    undef_method :category_listeners
    alias_method :attr_category_listeners=, :category_listeners=
    undef_method :category_listeners=
    
    typesig { [String] }
    # Constructs a new instance of <code>Category</code> based on the given
    # identifier. When a category is first constructed, it is undefined.
    # Category should only be constructed by the <code>CommandManager</code>
    # to ensure that identifier remain unique.
    # 
    # @param id
    # The identifier for the category. This value must not be
    # <code>null</code>, and must be unique amongst all
    # categories.
    def initialize(id)
      @category_listeners = nil
      super(id)
    end
    
    typesig { [ICategoryListener] }
    # Adds a listener to this category that will be notified when this
    # category's state changes.
    # 
    # @param categoryListener
    # The listener to be added; must not be <code>null</code>.
    def add_category_listener(category_listener)
      if ((category_listener).nil?)
        raise NullPointerException.new
      end
      if ((@category_listeners).nil?)
        @category_listeners = ArrayList.new
      end
      if (!@category_listeners.contains(category_listener))
        @category_listeners.add(category_listener)
      end
    end
    
    typesig { [String, String] }
    # <p>
    # Defines this category by giving it a name, and possibly a description as
    # well. The defined property automatically becomes <code>true</code>.
    # </p>
    # <p>
    # Notification is sent to all listeners that something has changed.
    # </p>
    # 
    # @param name
    # The name of this command; must not be <code>null</code>.
    # @param description
    # The description for this command; may be <code>null</code>.
    def define(name, description)
      if ((name).nil?)
        raise NullPointerException.new("The name of a command cannot be null") # $NON-NLS-1$
      end
      defined_changed = !self.attr_defined
      self.attr_defined = true
      name_changed = !(Util == self.attr_name)
      self.attr_name = name
      description_changed = !(Util == self.attr_description)
      self.attr_description = description
      fire_category_changed(CategoryEvent.new(self, defined_changed, description_changed, name_changed))
    end
    
    typesig { [CategoryEvent] }
    # Notifies the listeners for this category that it has changed in some way.
    # 
    # @param categoryEvent
    # The event to send to all of the listener; must not be
    # <code>null</code>.
    def fire_category_changed(category_event)
      if ((category_event).nil?)
        raise NullPointerException.new
      end
      if (!(@category_listeners).nil?)
        listener_itr = @category_listeners.iterator
        while (listener_itr.has_next)
          listener = listener_itr.next_
          listener.category_changed(category_event)
        end
      end
    end
    
    typesig { [ICategoryListener] }
    # Removes a listener from this category.
    # 
    # @param categoryListener
    # The listener to be removed; must not be <code>null</code>.
    def remove_category_listener(category_listener)
      if ((category_listener).nil?)
        raise NullPointerException.new
      end
      if (!(@category_listeners).nil?)
        @category_listeners.remove(category_listener)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.common.HandleObject#toString()
    def to_s
      if ((self.attr_string).nil?)
        string_buffer = StringBuffer.new
        string_buffer.append("Category(") # $NON-NLS-1$
        string_buffer.append(self.attr_id)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(self.attr_name)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(self.attr_description)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(self.attr_defined)
        string_buffer.append(Character.new(?).ord))
        self.attr_string = string_buffer.to_s
      end
      return self.attr_string
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.common.HandleObject#undefine()
    def undefine
      self.attr_string = nil
      defined_changed = self.attr_defined
      self.attr_defined = false
      name_changed = !(self.attr_name).nil?
      self.attr_name = nil
      description_changed = !(self.attr_description).nil?
      self.attr_description = nil
      fire_category_changed(CategoryEvent.new(self, defined_changed, description_changed, name_changed))
    end
    
    private
    alias_method :initialize__category, :initialize
  end
  
end
