require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module CommandManagerEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # <p>
  # An event indicating that the set of defined command identifiers has changed.
  # </p>
  # 
  # @since 3.1
  # @see ICommandManagerListener#commandManagerChanged(CommandManagerEvent)
  class CommandManagerEvent 
    include_class_members CommandManagerEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the given category has become defined.
      # If this bit is not set and there is no category id, then no category has
      # become defined nor undefined. If this bit is not set and there is a
      # category id, then the category has become undefined.
      const_set_lazy(:CHANGED_CATEGORY_DEFINED) { 1 }
      const_attr_reader  :CHANGED_CATEGORY_DEFINED
      
      # The bit used to represent whether the given command has become defined.
      # If this bit is not set and there is no command id, then no command has
      # become defined nor undefined. If this bit is not set and there is a
      # command id, then the command has become undefined.
      const_set_lazy(:CHANGED_COMMAND_DEFINED) { 1 << 1 }
      const_attr_reader  :CHANGED_COMMAND_DEFINED
      
      # The bit used to represent whether the given command parameter type has
      # become defined. If this bit is not set and there is no parameter type id,
      # then no parameter type has become defined nor undefined. If this bit is
      # not set and there is a parameter type id, then the parameter type has
      # become undefined.
      # 
      # @since 3.2
      const_set_lazy(:CHANGED_PARAMETER_TYPE_DEFINED) { 1 << 2 }
      const_attr_reader  :CHANGED_PARAMETER_TYPE_DEFINED
    }
    
    # The category identifier that was added or removed from the list of
    # defined category identifiers. This value is <code>null</code> if the
    # list of defined category identifiers did not change.
    attr_accessor :category_id
    alias_method :attr_category_id, :category_id
    undef_method :category_id
    alias_method :attr_category_id=, :category_id=
    undef_method :category_id=
    
    # A collection of bits representing whether certain values have changed. A
    # bit is set (i.e., <code>1</code>) if the corresponding property has
    # changed.
    attr_accessor :changed_values
    alias_method :attr_changed_values, :changed_values
    undef_method :changed_values
    alias_method :attr_changed_values=, :changed_values=
    undef_method :changed_values=
    
    # The command identifier that was added or removed from the list of defined
    # command identifiers. This value is <code>null</code> if the list of
    # defined command identifiers did not change.
    attr_accessor :command_id
    alias_method :attr_command_id, :command_id
    undef_method :command_id
    alias_method :attr_command_id=, :command_id=
    undef_method :command_id=
    
    # The command parameter type identifier that was added or removed from the
    # list of defined parameter type identifiers. This value is
    # <code>null</code> if the list of defined parameter type identifiers did
    # not change.
    # 
    # @since 3.2
    attr_accessor :parameter_type_id
    alias_method :attr_parameter_type_id, :parameter_type_id
    undef_method :parameter_type_id
    alias_method :attr_parameter_type_id=, :parameter_type_id=
    undef_method :parameter_type_id=
    
    # The command manager that has changed.
    attr_accessor :command_manager
    alias_method :attr_command_manager, :command_manager
    undef_method :command_manager
    alias_method :attr_command_manager=, :command_manager=
    undef_method :command_manager=
    
    typesig { [CommandManager, String, ::Java::Boolean, ::Java::Boolean, String, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new <code>CommandManagerEvent</code> instance to describe
    # changes to commands and/or categories.
    # 
    # @param commandManager
    # the instance of the interface that changed; must not be
    # <code>null</code>.
    # @param commandId
    # The command identifier that was added or removed; must not be
    # <code>null</code> if commandIdChanged is <code>true</code>.
    # @param commandIdAdded
    # Whether the command identifier became defined (otherwise, it
    # became undefined).
    # @param commandIdChanged
    # Whether the list of defined command identifiers has changed.
    # @param categoryId
    # The category identifier that was added or removed; must not be
    # <code>null</code> if categoryIdChanged is <code>true</code>.
    # @param categoryIdAdded
    # Whether the category identifier became defined (otherwise, it
    # became undefined).
    # @param categoryIdChanged
    # Whether the list of defined category identifiers has changed.
    def initialize(command_manager, command_id, command_id_added, command_id_changed, category_id, category_id_added, category_id_changed)
      @category_id = nil
      @changed_values = 0
      @command_id = nil
      @parameter_type_id = nil
      @command_manager = nil
      if ((command_manager).nil?)
        raise NullPointerException.new("An event must refer to its command manager") # $NON-NLS-1$
      end
      if (command_id_changed && ((command_id).nil?))
        raise NullPointerException.new("If the list of defined commands changed, then the added/removed command must be mentioned") # $NON-NLS-1$
      end
      if (category_id_changed && ((category_id).nil?))
        raise NullPointerException.new("If the list of defined categories changed, then the added/removed category must be mentioned") # $NON-NLS-1$
      end
      @command_manager = command_manager
      @command_id = command_id
      @category_id = category_id
      # this constructor only works for changes to commands and categories
      @parameter_type_id = nil
      changed_values = 0
      if (category_id_changed && category_id_added)
        changed_values |= CHANGED_CATEGORY_DEFINED
      end
      if (command_id_changed && command_id_added)
        changed_values |= CHANGED_COMMAND_DEFINED
      end
      @changed_values = changed_values
    end
    
    typesig { [CommandManager, String, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new <code>CommandManagerEvent</code> instance to describe
    # changes to command parameter types.
    # 
    # @param commandManager
    # the instance of the interface that changed; must not be
    # <code>null</code>.
    # @param parameterTypeId
    # The command parameter type identifier that was added or
    # removed; must not be <code>null</code> if
    # parameterTypeIdChanged is <code>true</code>.
    # @param parameterTypeIdAdded
    # Whether the parameter type identifier became defined
    # (otherwise, it became undefined).
    # @param parameterTypeIdChanged
    # Whether the list of defined parameter type identifiers has
    # changed.
    # 
    # @since 3.2
    def initialize(command_manager, parameter_type_id, parameter_type_id_added, parameter_type_id_changed)
      @category_id = nil
      @changed_values = 0
      @command_id = nil
      @parameter_type_id = nil
      @command_manager = nil
      if ((command_manager).nil?)
        raise NullPointerException.new("An event must refer to its command manager") # $NON-NLS-1$
      end
      if (parameter_type_id_changed && ((parameter_type_id).nil?))
        raise NullPointerException.new("If the list of defined command parameter types changed, then the added/removed parameter type must be mentioned") # $NON-NLS-1$
      end
      @command_manager = command_manager
      @command_id = nil
      @category_id = nil
      @parameter_type_id = parameter_type_id
      changed_values = 0
      if (parameter_type_id_changed && parameter_type_id_added)
        changed_values |= CHANGED_PARAMETER_TYPE_DEFINED
      end
      @changed_values = changed_values
    end
    
    typesig { [] }
    # Returns the category identifier that was added or removed.
    # 
    # @return The category identifier that was added or removed; may be
    # <code>null</code>.
    def get_category_id
      return @category_id
    end
    
    typesig { [] }
    # Returns the command identifier that was added or removed.
    # 
    # @return The command identifier that was added or removed; may be
    # <code>null</code>.
    def get_command_id
      return @command_id
    end
    
    typesig { [] }
    # Returns the instance of the interface that changed.
    # 
    # @return the instance of the interface that changed. Guaranteed not to be
    # <code>null</code>.
    def get_command_manager
      return @command_manager
    end
    
    typesig { [] }
    # Returns the command parameter type identifier that was added or removed.
    # 
    # @return The command parameter type identifier that was added or removed;
    # may be <code>null</code>.
    # 
    # @since 3.2
    def get_parameter_type_id
      return @parameter_type_id
    end
    
    typesig { [] }
    # Returns whether the list of defined category identifiers has changed.
    # 
    # @return <code>true</code> if the list of category identifiers has
    # changed; <code>false</code> otherwise.
    def is_category_changed
      return (!(@category_id).nil?)
    end
    
    typesig { [] }
    # Returns whether the category identifier became defined. Otherwise, the
    # category identifier became undefined.
    # 
    # @return <code>true</code> if the category identifier became defined;
    # <code>false</code> if the category identifier became undefined.
    def is_category_defined
      return ((!((@changed_values & CHANGED_CATEGORY_DEFINED)).equal?(0)) && (!(@category_id).nil?))
    end
    
    typesig { [] }
    # Returns whether the list of defined command identifiers has changed.
    # 
    # @return <code>true</code> if the list of command identifiers has
    # changed; <code>false</code> otherwise.
    def is_command_changed
      return (!(@command_id).nil?)
    end
    
    typesig { [] }
    # Returns whether the command identifier became defined. Otherwise, the
    # command identifier became undefined.
    # 
    # @return <code>true</code> if the command identifier became defined;
    # <code>false</code> if the command identifier became undefined.
    def is_command_defined
      return ((!((@changed_values & CHANGED_COMMAND_DEFINED)).equal?(0)) && (!(@command_id).nil?))
    end
    
    typesig { [] }
    # Returns whether the list of defined command parameter type identifiers
    # has changed.
    # 
    # @return <code>true</code> if the list of command parameter type
    # identifiers has changed; <code>false</code> otherwise.
    # 
    # @since 3.2
    def is_parameter_type_changed
      return (!(@parameter_type_id).nil?)
    end
    
    typesig { [] }
    # Returns whether the command parameter type identifier became defined.
    # Otherwise, the command parameter type identifier became undefined.
    # 
    # @return <code>true</code> if the command parameter type identifier
    # became defined; <code>false</code> if the command parameter
    # type identifier became undefined.
    # 
    # @since 3.2
    def is_parameter_type_defined
      return ((!((@changed_values & CHANGED_PARAMETER_TYPE_DEFINED)).equal?(0)) && (!(@parameter_type_id).nil?))
    end
    
    private
    alias_method :initialize__command_manager_event, :initialize
  end
  
end
