require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module SchemeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Commands::Common, :NamedHandleObject
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # An instance of <code>IScheme</code> is a handle representing a binding
  # scheme as defined by the extension point <code>org.eclipse.ui.bindings</code>.
  # The identifier of the handle is the identifier of the scheme being represented.
  # </p>
  # <p>
  # An instance of <code>IScheme</code> can be obtained from an instance of
  # <code>ICommandManager</code> for any identifier, whether or not a scheme
  # with that identifier is defined in the plugin registry.
  # </p>
  # <p>
  # The handle-based nature of this API allows it to work well with runtime
  # plugin activation and deactivation. If a scheme is defined, that means that
  # its corresponding plug-in is active. If the plug-in is then deactivated, the
  # scheme will still exist but it will be undefined. An attempt to use an
  # undefined scheme will result in a <code>NotDefinedException</code>
  # being thrown.
  # </p>
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @see ISchemeListener
  # @see org.eclipse.core.commands.CommandManager
  class Scheme < SchemeImports.const_get :NamedHandleObject
    include_class_members SchemeImports
    overload_protected {
      include JavaComparable
    }
    
    # The collection of all objects listening to changes on this scheme. This
    # value is <code>null</code> if there are no listeners.
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    # The parent identifier for this scheme. This is the identifier of the
    # scheme from which this scheme inherits some of its bindings. This value
    # can be <code>null</code> if the scheme has no parent.
    attr_accessor :parent_id
    alias_method :attr_parent_id, :parent_id
    undef_method :parent_id
    alias_method :attr_parent_id=, :parent_id=
    undef_method :parent_id=
    
    typesig { [String] }
    # Constructs a new instance of <code>Scheme</code> with an identifier.
    # 
    # @param id
    # The identifier to create; must not be <code>null</code>.
    def initialize(id)
      @listeners = nil
      @parent_id = nil
      super(id)
      @listeners = nil
      @parent_id = nil
    end
    
    typesig { [ISchemeListener] }
    # Registers an instance of <code>ISchemeListener</code> to listen for
    # changes to attributes of this instance.
    # 
    # @param schemeListener
    # the instance of <code>ISchemeListener</code> to register.
    # Must not be <code>null</code>. If an attempt is made to
    # register an instance of <code>ISchemeListener</code> which
    # is already registered with this instance, no operation is
    # performed.
    def add_scheme_listener(scheme_listener)
      if ((scheme_listener).nil?)
        raise NullPointerException.new("Can't add a null scheme listener.") # $NON-NLS-1$
      end
      if ((@listeners).nil?)
        @listeners = HashSet.new
      end
      @listeners.add(scheme_listener)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Comparable#compareTo(java.lang.Object)
    def compare_to(object)
      scheme = object
      compare_to = Util.compare(self.attr_id, scheme.attr_id)
      if ((compare_to).equal?(0))
        compare_to = Util.compare(self.attr_name, scheme.attr_name)
        if ((compare_to).equal?(0))
          compare_to = Util.compare(@parent_id, scheme.attr_parent_id)
          if ((compare_to).equal?(0))
            compare_to = Util.compare(self.attr_description, scheme.attr_description)
            if ((compare_to).equal?(0))
              compare_to = Util.compare(self.attr_defined, scheme.attr_defined)
            end
          end
        end
      end
      return compare_to
    end
    
    typesig { [String, String, String] }
    # <p>
    # Defines this scheme by giving it a name, and possibly a description and a
    # parent identifier as well. The defined property for the scheme automatically
    # becomes <code>true</code>.
    # </p>
    # <p>
    # Notification is sent to all listeners that something has changed.
    # </p>
    # 
    # @param name
    # The name of this scheme; must not be <code>null</code>.
    # @param description
    # The description for this scheme; may be <code>null</code>.
    # @param parentId
    # The parent identifier for this scheme; may be
    # <code>null</code>.
    def define(name, description, parent_id)
      if ((name).nil?)
        raise NullPointerException.new("The name of a scheme cannot be null") # $NON-NLS-1$
      end
      defined_changed = !self.attr_defined
      self.attr_defined = true
      name_changed = !(Util == self.attr_name)
      self.attr_name = name
      description_changed = !(Util == self.attr_description)
      self.attr_description = description
      parent_id_changed = !(Util == @parent_id)
      @parent_id = parent_id
      fire_scheme_changed(SchemeEvent.new(self, defined_changed, name_changed, description_changed, parent_id_changed))
    end
    
    typesig { [SchemeEvent] }
    # Notifies all listeners that this scheme has changed. This sends the given
    # event to all of the listeners, if any.
    # 
    # @param event
    # The event to send to the listeners; must not be
    # <code>null</code>.
    def fire_scheme_changed(event)
      if ((event).nil?)
        raise NullPointerException.new("Cannot send a null event to listeners.") # $NON-NLS-1$
      end
      if ((@listeners).nil?)
        return
      end
      listener_itr = @listeners.iterator
      while (listener_itr.has_next)
        listener = listener_itr.next_
        listener.scheme_changed(event)
      end
    end
    
    typesig { [] }
    # <p>
    # Returns the identifier of the parent of the scheme represented by this
    # handle.
    # </p>
    # <p>
    # Notification is sent to all registered listeners if this attribute
    # changes.
    # </p>
    # 
    # @return the identifier of the parent of the scheme represented by this
    # handle. May be <code>null</code>.
    # @throws NotDefinedException
    # if the scheme represented by this handle is not defined.
    def get_parent_id
      if (!self.attr_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot get the parent identifier from an undefined scheme. " + RJava.cast_to_string(self.attr_id))
      end
      return @parent_id
    end
    
    typesig { [ISchemeListener] }
    # Unregisters an instance of <code>ISchemeListener</code> listening for
    # changes to attributes of this instance.
    # 
    # @param schemeListener
    # the instance of <code>ISchemeListener</code> to unregister.
    # Must not be <code>null</code>. If an attempt is made to
    # unregister an instance of <code>ISchemeListener</code> which
    # is not already registered with this instance, no operation is
    # performed.
    def remove_scheme_listener(scheme_listener)
      if ((scheme_listener).nil?)
        raise NullPointerException.new("Cannot remove a null listener.") # $NON-NLS-1$
      end
      if ((@listeners).nil?)
        return
      end
      @listeners.remove(scheme_listener)
      if (@listeners.is_empty)
        @listeners = nil
      end
    end
    
    typesig { [] }
    # The string representation of this command -- for debugging purposes only.
    # This string should not be shown to an end user.
    # 
    # @return The string representation; never <code>null</code>.
    def to_s
      if ((self.attr_string).nil?)
        string_buffer = StringBuffer.new
        string_buffer.append("Scheme(") # $NON-NLS-1$
        string_buffer.append(self.attr_id)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(self.attr_name)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(self.attr_description)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(@parent_id)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(self.attr_defined)
        string_buffer.append(Character.new(?).ord))
        self.attr_string = string_buffer.to_s
      end
      return self.attr_string
    end
    
    typesig { [] }
    # Makes this scheme become undefined. This has the side effect of changing
    # the name, description and parent identifier to <code>null</code>.
    # Notification is sent to all listeners.
    def undefine
      self.attr_string = nil
      defined_changed = self.attr_defined
      self.attr_defined = false
      name_changed = !(self.attr_name).nil?
      self.attr_name = nil
      description_changed = !(self.attr_description).nil?
      self.attr_description = nil
      parent_id_changed = !(@parent_id).nil?
      @parent_id = RJava.cast_to_string(nil)
      fire_scheme_changed(SchemeEvent.new(self, defined_changed, name_changed, description_changed, parent_id_changed))
    end
    
    private
    alias_method :initialize__scheme, :initialize
  end
  
end
