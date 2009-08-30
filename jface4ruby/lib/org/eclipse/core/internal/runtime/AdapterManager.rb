require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# David Green - fix factories with non-standard class loading (bug 200068)
module Org::Eclipse::Core::Internal::Runtime
  module AdapterManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include ::Java::Util
      include_const ::Org::Eclipse::Core::Runtime, :IAdapterFactory
      include_const ::Org::Eclipse::Core::Runtime, :IAdapterManager
    }
  end
  
  # This class is the standard implementation of <code>IAdapterManager</code>. It provides
  # fast lookup of property values with the following semantics:
  # <ul>
  # <li>At most one factory will be invoked per property lookup
  # <li>If multiple installed factories provide the same adapter, only the first found in
  # the search order will be invoked.
  # <li>The search order from a class with the definition <br>
  # <code>class X extends Y implements A, B</code><br> is as follows: <il>
  # <li>the target's class: X
  # <li>X's superclasses in order to <code>Object</code>
  # <li>a breadth-first traversal of each class's interfaces in the
  # order returned by <code>getInterfaces</code> (in the example, X's
  # superinterfaces then Y's superinterfaces) </li>
  # </ul>
  # 
  # @see IAdapterFactory
  # @see IAdapterManager
  class AdapterManager 
    include_class_members AdapterManagerImports
    include IAdapterManager
    
    # Cache of adapters for a given adaptable class. Maps String  -> Map
    # (adaptable class name -> (adapter class name -> factory instance))
    # Thread safety note: The outer map is synchronized using a synchronized
    # map wrapper class.  The inner map is not synchronized, but it is immutable
    # so synchronization is not necessary.
    attr_accessor :adapter_lookup
    alias_method :attr_adapter_lookup, :adapter_lookup
    undef_method :adapter_lookup
    alias_method :attr_adapter_lookup=, :adapter_lookup=
    undef_method :adapter_lookup=
    
    # Cache of classes for a given type name. Avoids too many loadClass calls.
    # (factory -> (type name -> Class)).
    # Thread safety note: Since this structure is a nested hash map, and both
    # the inner and outer maps are mutable, access to this entire structure is
    # controlled by the classLookupLock field.  Note the field can still be
    # nulled concurrently without holding the lock.
    attr_accessor :class_lookup
    alias_method :attr_class_lookup, :class_lookup
    undef_method :class_lookup
    alias_method :attr_class_lookup=, :class_lookup=
    undef_method :class_lookup=
    
    # The lock object controlling access to the classLookup data structure.
    attr_accessor :class_lookup_lock
    alias_method :attr_class_lookup_lock, :class_lookup_lock
    undef_method :class_lookup_lock
    alias_method :attr_class_lookup_lock=, :class_lookup_lock=
    undef_method :class_lookup_lock=
    
    # Cache of class lookup order (Class -> Class[]). This avoids having to compute often, and
    # provides clients with quick lookup for instanceOf checks based on type name.
    # Thread safety note: The map is synchronized using a synchronized
    # map wrapper class.  The arrays within the map are immutable.
    attr_accessor :class_search_order_lookup
    alias_method :attr_class_search_order_lookup, :class_search_order_lookup
    undef_method :class_search_order_lookup
    alias_method :attr_class_search_order_lookup=, :class_search_order_lookup=
    undef_method :class_search_order_lookup=
    
    # Map of factories, keyed by <code>String</code>, fully qualified class name of
    # the adaptable class that the factory provides adapters for. Value is a <code>List</code>
    # of <code>IAdapterFactory</code>.
    attr_accessor :factories
    alias_method :attr_factories, :factories
    undef_method :factories
    alias_method :attr_factories=, :factories=
    undef_method :factories=
    
    attr_accessor :lazy_factory_providers
    alias_method :attr_lazy_factory_providers, :lazy_factory_providers
    undef_method :lazy_factory_providers
    alias_method :attr_lazy_factory_providers=, :lazy_factory_providers=
    undef_method :lazy_factory_providers=
    
    class_module.module_eval {
      const_set_lazy(:Singleton) { AdapterManager.new }
      const_attr_reader  :Singleton
      
      typesig { [] }
      def get_default
        return Singleton
      end
    }
    
    typesig { [] }
    # Private constructor to block instance creation.
    def initialize
      @adapter_lookup = nil
      @class_lookup = nil
      @class_lookup_lock = Object.new
      @class_search_order_lookup = nil
      @factories = nil
      @lazy_factory_providers = nil
      @factories = HashMap.new(5)
      @lazy_factory_providers = ArrayList.new(1)
    end
    
    typesig { [String, Map] }
    # Given a type name, add all of the factories that respond to those types into
    # the given table. Each entry will be keyed by the adapter class name (supplied in
    # IAdapterFactory.getAdapterList).
    def add_factories_for(type_name, table)
      factory_list = get_factories.get(type_name)
      if ((factory_list).nil?)
        return
      end
      i = 0
      imax = factory_list.size
      while i < imax
        factory = factory_list.get(i)
        if (factory.is_a?(IAdapterFactoryExt))
          adapters = (factory).get_adapter_names
          j = 0
          while j < adapters.attr_length
            if ((table.get(adapters[j])).nil?)
              table.put(adapters[j], factory)
            end
            j += 1
          end
        else
          adapters = factory.get_adapter_list
          j = 0
          while j < adapters.attr_length
            adapter_name = adapters[j].get_name
            if ((table.get(adapter_name)).nil?)
              table.put(adapter_name, factory)
            end
            j += 1
          end
        end
        i += 1
      end
    end
    
    typesig { [IAdapterFactory, Class] }
    def cache_class_lookup(factory, clazz)
      synchronized((@class_lookup_lock)) do
        # cache reference to lookup to protect against concurrent flush
        lookup = @class_lookup
        if ((lookup).nil?)
          @class_lookup = lookup = HashMap.new(4)
        end
        classes = lookup.get(factory)
        if ((classes).nil?)
          classes = HashMap.new(4)
          lookup.put(factory, classes)
        end
        classes.put(clazz.get_name, clazz)
      end
    end
    
    typesig { [IAdapterFactory, String] }
    def cached_class_for_name(factory, type_name)
      synchronized((@class_lookup_lock)) do
        clazz = nil
        # cache reference to lookup to protect against concurrent flush
        lookup = @class_lookup
        if (!(lookup).nil?)
          classes = lookup.get(factory)
          if (!(classes).nil?)
            clazz = classes.get(type_name)
          end
        end
        return clazz
      end
    end
    
    typesig { [IAdapterFactory, String] }
    # Returns the class with the given fully qualified name, or null
    # if that class does not exist or belongs to a plug-in that has not
    # yet been loaded.
    def class_for_name(factory, type_name)
      clazz = cached_class_for_name(factory, type_name)
      if ((clazz).nil?)
        if (factory.is_a?(IAdapterFactoryExt))
          factory = (factory).load_factory(false)
        end
        if (!(factory).nil?)
          begin
            clazz = factory.get_class.get_class_loader.load_class(type_name)
          rescue ClassNotFoundException => e
            # it is possible that the default bundle classloader is unaware of this class
            # but the adaptor factory can load it in some other way. See bug 200068.
            if ((type_name).nil?)
              return nil
            end
            adapter_list = factory.get_adapter_list
            clazz = nil
            i = 0
            while i < adapter_list.attr_length
              if ((type_name == adapter_list[i].get_name))
                clazz = adapter_list[i]
                break
              end
              i += 1
            end
            if ((clazz).nil?)
              return nil
            end # class not yet loaded
          end
          cache_class_lookup(factory, clazz)
        end
      end
      return clazz
    end
    
    typesig { [Class] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IAdapterManager#getAdapterTypes(java.lang.Class)
    def compute_adapter_types(adaptable)
      types = get_factories(adaptable).key_set
      return types.to_array(Array.typed(String).new(types.size) { nil })
    end
    
    typesig { [Class] }
    # Computes the adapters that the provided class can adapt to, along
    # with the factory object that can perform that transformation. Returns
    # a table of adapter class name to factory object.
    # @param adaptable
    def get_factories(adaptable)
      # cache reference to lookup to protect against concurrent flush
      lookup = @adapter_lookup
      if ((lookup).nil?)
        @adapter_lookup = lookup = Collections.synchronized_map(HashMap.new(30))
      end
      table = lookup.get(adaptable.get_name)
      if ((table).nil?)
        # calculate adapters for the class
        table = HashMap.new(4)
        classes = compute_class_order(adaptable)
        i = 0
        while i < classes.attr_length
          add_factories_for(classes[i].get_name, table)
          i += 1
        end
        # cache the table
        lookup.put(adaptable.get_name, table)
      end
      return table
    end
    
    typesig { [Class] }
    # Returns the super-type search order starting with <code>adaptable</code>.
    # The search order is defined in this class' comment.
    def compute_class_order(adaptable)
      classes = nil
      # cache reference to lookup to protect against concurrent flush
      lookup = @class_search_order_lookup
      if ((lookup).nil?)
        @class_search_order_lookup = lookup = Collections.synchronized_map(HashMap.new)
      else
        classes = lookup.get(adaptable)
      end
      # compute class order only if it hasn't been cached before
      if ((classes).nil?)
        classes = do_compute_class_order(adaptable)
        lookup.put(adaptable, classes)
      end
      return classes
    end
    
    typesig { [Class] }
    # Computes the super-type search order starting with <code>adaptable</code>.
    # The search order is defined in this class' comment.
    def do_compute_class_order(adaptable)
      classes = ArrayList.new
      clazz = adaptable
      seen = HashSet.new(4)
      # first traverse class hierarchy
      while (!(clazz).nil?)
        classes.add(clazz)
        clazz = clazz.get_superclass
      end
      # now traverse interface hierarchy for each class
      class_hierarchy = classes.to_array(Array.typed(Class).new(classes.size) { nil })
      i = 0
      while i < class_hierarchy.attr_length
        compute_interface_order(class_hierarchy[i].get_interfaces, classes, seen)
        i += 1
      end
      return classes.to_array(Array.typed(Class).new(classes.size) { nil })
    end
    
    typesig { [Array.typed(Class), Collection, JavaSet] }
    def compute_interface_order(interfaces, classes, seen)
      new_interfaces = ArrayList.new(interfaces.attr_length)
      i = 0
      while i < interfaces.attr_length
        interfac = interfaces[i]
        if (seen.add(interfac))
          # note we cannot recurse here without changing the resulting interface order
          classes.add(interfac)
          new_interfaces.add(interfac)
        end
        i += 1
      end
      it = new_interfaces.iterator
      while it.has_next
        compute_interface_order((it.next_).get_interfaces, classes, seen)
      end
    end
    
    typesig { [] }
    # Flushes the cache of adapter search paths. This is generally required whenever an
    # adapter is added or removed.
    # <p>
    # It is likely easier to just toss the whole cache rather than trying to be smart
    # and remove only those entries affected.
    # </p>
    def flush_lookup
      synchronized(self) do
        @adapter_lookup = nil
        @class_lookup = nil
        @class_search_order_lookup = nil
      end
    end
    
    typesig { [Object, Class] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IAdapterManager#getAdapter(java.lang.Object, java.lang.Class)
    def get_adapter(adaptable, adapter_type)
      factory = get_factories(adaptable.get_class).get(adapter_type.get_name)
      result = nil
      if (!(factory).nil?)
        result = factory.get_adapter(adaptable, adapter_type)
      end
      if ((result).nil? && adapter_type.is_instance(adaptable))
        return adaptable
      end
      return result
    end
    
    typesig { [Object, String] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IAdapterManager#getAdapter(java.lang.Object, java.lang.Class)
    def get_adapter(adaptable, adapter_type)
      return get_adapter(adaptable, adapter_type, false)
    end
    
    typesig { [Object, String, ::Java::Boolean] }
    # Returns an adapter of the given type for the provided adapter.
    # @param adaptable the object to adapt
    # @param adapterType the type to adapt the object to
    # @param force <code>true</code> if the plug-in providing the
    # factory should be activated if necessary. <code>false</code>
    # if no plugin activations are desired.
    def get_adapter(adaptable, adapter_type, force)
      factory = get_factories(adaptable.get_class).get(adapter_type)
      if (force && factory.is_a?(IAdapterFactoryExt))
        factory = (factory).load_factory(true)
      end
      result = nil
      if (!(factory).nil?)
        clazz = class_for_name(factory, adapter_type)
        if (!(clazz).nil?)
          result = factory.get_adapter(adaptable, clazz)
        end
      end
      if ((result).nil? && (adaptable.get_class.get_name == adapter_type))
        return adaptable
      end
      return result
    end
    
    typesig { [Object, String] }
    def has_adapter(adaptable, adapter_type_name)
      return !(get_factories(adaptable.get_class).get(adapter_type_name)).nil?
    end
    
    typesig { [Object, String] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IAdapterManager#queryAdapter(java.lang.Object, java.lang.String)
    def query_adapter(adaptable, adapter_type_name)
      factory = get_factories(adaptable.get_class).get(adapter_type_name)
      if ((factory).nil?)
        return NONE
      end
      if (factory.is_a?(IAdapterFactoryExt))
        factory = (factory).load_factory(false) # don't force loading
        if ((factory).nil?)
          return NOT_LOADED
        end
      end
      return LOADED
    end
    
    typesig { [Object, String] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IAdapterManager#loadAdapter(java.lang.Object, java.lang.String)
    def load_adapter(adaptable, adapter_type_name)
      return get_adapter(adaptable, adapter_type_name, true)
    end
    
    typesig { [IAdapterFactory, Class] }
    # @see IAdapterManager#registerAdapters
    def register_adapters(factory, adaptable)
      synchronized(self) do
        register_factory(factory, adaptable.get_name)
        flush_lookup
      end
    end
    
    typesig { [IAdapterFactory, String] }
    # @see IAdapterManager#registerAdapters
    def register_factory(factory, adaptable_type)
      list = @factories.get(adaptable_type)
      if ((list).nil?)
        list = ArrayList.new(5)
        @factories.put(adaptable_type, list)
      end
      list.add(factory)
    end
    
    typesig { [IAdapterFactory] }
    # @see IAdapterManager#unregisterAdapters
    def unregister_adapters(factory)
      synchronized(self) do
        it = @factories.values.iterator
        while it.has_next
          (it.next_).remove(factory)
        end
        flush_lookup
      end
    end
    
    typesig { [IAdapterFactory, Class] }
    # @see IAdapterManager#unregisterAdapters
    def unregister_adapters(factory, adaptable)
      synchronized(self) do
        factory_list = @factories.get(adaptable.get_name)
        if ((factory_list).nil?)
          return
        end
        factory_list.remove(factory)
        flush_lookup
      end
    end
    
    typesig { [] }
    # Shuts down the adapter manager by removing all factories
    # and removing the registry change listener. Should only be
    # invoked during platform shutdown.
    def unregister_all_adapters
      synchronized(self) do
        @factories.clear
        flush_lookup
      end
    end
    
    typesig { [IAdapterManagerProvider] }
    def register_lazy_factory_provider(factory_provider)
      synchronized((@lazy_factory_providers)) do
        @lazy_factory_providers.add(factory_provider)
      end
    end
    
    typesig { [IAdapterManagerProvider] }
    def unregister_lazy_factory_provider(factory_provider)
      synchronized((@lazy_factory_providers)) do
        return @lazy_factory_providers.remove(factory_provider)
      end
    end
    
    typesig { [] }
    def get_factories
      # avoid the synchronize if we don't have to call it
      if ((@lazy_factory_providers.size).equal?(0))
        return @factories
      end
      synchronized((@lazy_factory_providers)) do
        while (@lazy_factory_providers.size > 0)
          provider = @lazy_factory_providers.remove(0)
          if (provider.add_factories(self))
            flush_lookup
          end
        end
      end
      return @factories
    end
    
    private
    alias_method :initialize__adapter_manager, :initialize
  end
  
end
