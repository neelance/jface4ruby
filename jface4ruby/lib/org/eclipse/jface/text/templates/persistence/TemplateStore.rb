require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates::Persistence
  module TemplateStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates::Persistence
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Reader
      include_const ::Java::Io, :StringReader
      include_const ::Java::Io, :StringWriter
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Preference, :IPersistentPreferenceStore
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Text::Templates, :ContextTypeRegistry
      include_const ::Org::Eclipse::Jface::Text::Templates, :Template
      include_const ::Org::Eclipse::Jface::Text::Templates, :TemplateException
    }
  end
  
  # A collection of templates. Clients may instantiate this class. In order to
  # load templates contributed using the <code>org.eclipse.ui.editors.templates</code>
  # extension point, use a <code>ContributionTemplateStore</code>.
  # 
  # @since 3.0
  class TemplateStore 
    include_class_members TemplateStoreImports
    
    # The stored templates.
    attr_accessor :f_templates
    alias_method :attr_f_templates, :f_templates
    undef_method :f_templates
    alias_method :attr_f_templates=, :f_templates=
    undef_method :f_templates=
    
    # The preference store.
    attr_accessor :f_preference_store
    alias_method :attr_f_preference_store, :f_preference_store
    undef_method :f_preference_store
    alias_method :attr_f_preference_store=, :f_preference_store=
    undef_method :f_preference_store=
    
    # The key into <code>fPreferenceStore</code> the value of which holds custom templates
    # encoded as XML.
    attr_accessor :f_key
    alias_method :attr_f_key, :f_key
    undef_method :f_key
    alias_method :attr_f_key=, :f_key=
    undef_method :f_key=
    
    # The context type registry, or <code>null</code> if all templates regardless
    # of context type should be loaded.
    attr_accessor :f_registry
    alias_method :attr_f_registry, :f_registry
    undef_method :f_registry
    alias_method :attr_f_registry=, :f_registry=
    undef_method :f_registry=
    
    # Set to <code>true</code> if property change events should be ignored (e.g. during writing
    # to the preference store).
    # 
    # @since 3.2
    attr_accessor :f_ignore_preference_store_changes
    alias_method :attr_f_ignore_preference_store_changes, :f_ignore_preference_store_changes
    undef_method :f_ignore_preference_store_changes
    alias_method :attr_f_ignore_preference_store_changes=, :f_ignore_preference_store_changes=
    undef_method :f_ignore_preference_store_changes=
    
    # The property listener, if any is registered, <code>null</code> otherwise.
    # 
    # @since 3.2
    attr_accessor :f_property_listener
    alias_method :attr_f_property_listener, :f_property_listener
    undef_method :f_property_listener
    alias_method :attr_f_property_listener=, :f_property_listener=
    undef_method :f_property_listener=
    
    typesig { [IPreferenceStore, String] }
    # Creates a new template store.
    # 
    # @param store the preference store in which to store custom templates
    # under <code>key</code>
    # @param key the key into <code>store</code> where to store custom
    # templates
    def initialize(store, key)
      @f_templates = ArrayList.new
      @f_preference_store = nil
      @f_key = nil
      @f_registry = nil
      @f_ignore_preference_store_changes = false
      @f_property_listener = nil
      Assert.is_not_null(store)
      Assert.is_not_null(key)
      @f_preference_store = store
      @f_key = key
    end
    
    typesig { [ContextTypeRegistry, IPreferenceStore, String] }
    # Creates a new template store with a context type registry. Only templates
    # that specify a context type contained in the registry will be loaded by
    # this store if the registry is not <code>null</code>.
    # 
    # @param registry a context type registry, or <code>null</code> if all
    # templates should be loaded
    # @param store the preference store in which to store custom templates
    # under <code>key</code>
    # @param key the key into <code>store</code> where to store custom
    # templates
    def initialize(registry, store, key)
      initialize__template_store(store, key)
      @f_registry = registry
    end
    
    typesig { [] }
    # Loads the templates from contributions and preferences.
    # 
    # @throws IOException if loading fails.
    def load
      @f_templates.clear
      load_contributed_templates
      load_custom_templates
    end
    
    typesig { [] }
    # Starts listening for property changes on the preference store. If the configured preference
    # key changes, the template store is {@link #load() reloaded}. Call
    # {@link #stopListeningForPreferenceChanges()} to remove any listener and stop the
    # auto-updating behavior.
    # 
    # @since 3.2
    def start_listening_for_preference_changes
      if ((@f_property_listener).nil?)
        @f_property_listener = Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
          extend LocalClass
          include_class_members TemplateStore
          include IPropertyChangeListener if IPropertyChangeListener.class == Module
          
          typesig { [PropertyChangeEvent] }
          define_method :property_change do |event|
            # Don't load if we are in the process of saving ourselves. We are in sync anyway after the
            # save operation, and clients may trigger reloading by listening to preference store
            # updates.
            if (!self.attr_f_ignore_preference_store_changes && (self.attr_f_key == event.get_property))
              begin
                load
              rescue self.class::IOException => x
                handle_exception(x)
              end
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        @f_preference_store.add_property_change_listener(@f_property_listener)
      end
    end
    
    typesig { [] }
    # Stops the auto-updating behavior started by calling
    # {@link #startListeningForPreferenceChanges()}.
    # 
    # @since 3.2
    def stop_listening_for_preference_changes
      if (!(@f_property_listener).nil?)
        @f_preference_store.remove_property_change_listener(@f_property_listener)
        @f_property_listener = nil
      end
    end
    
    typesig { [IOException] }
    # Handles an {@link IOException} thrown during reloading the preferences due to a preference
    # store update. The default is to write to stderr.
    # 
    # @param x the exception
    # @since 3.2
    def handle_exception(x)
      x.print_stack_trace
    end
    
    typesig { [] }
    # Hook method to load contributed templates. Contributed templates are superseded
    # by customized versions of user added templates stored in the preferences.
    # <p>
    # The default implementation does nothing.</p>
    # 
    # @throws IOException if loading fails
    def load_contributed_templates
    end
    
    typesig { [TemplatePersistenceData] }
    # Adds a template to the internal store. The added templates must have
    # a unique id.
    # 
    # @param data the template data to add
    def internal_add(data)
      if (!data.is_custom)
        # check if the added template is not a duplicate id
        id = data.get_id
        it = @f_templates.iterator
        while it.has_next
          d2 = it.next_
          if (!(d2.get_id).nil? && (d2.get_id == id))
            return
          end
        end
        @f_templates.add(data)
      end
    end
    
    typesig { [] }
    # Saves the templates to the preferences.
    # 
    # @throws IOException if the templates cannot be written
    def save
      custom = ArrayList.new
      it = @f_templates.iterator
      while it.has_next
        data = it.next_
        if (data.is_custom && !(data.is_user_added && data.is_deleted))
          # don't save deleted user-added templates
          custom.add(data)
        end
      end
      output = StringWriter.new
      writer = TemplateReaderWriter.new
      writer.save(custom.to_array(Array.typed(TemplatePersistenceData).new(custom.size) { nil }), output)
      @f_ignore_preference_store_changes = true
      begin
        @f_preference_store.set_value(@f_key, output.to_s)
        if (@f_preference_store.is_a?(IPersistentPreferenceStore))
          (@f_preference_store).save
        end
      ensure
        @f_ignore_preference_store_changes = false
      end
    end
    
    typesig { [TemplatePersistenceData] }
    # Adds a template encapsulated in its persistent form.
    # 
    # @param data the template to add
    def add(data)
      if (!validate_template(data.get_template))
        return
      end
      if (data.is_user_added)
        @f_templates.add(data)
      else
        it = @f_templates.iterator
        while it.has_next
          d2 = it.next_
          if (!(d2.get_id).nil? && (d2.get_id == data.get_id))
            d2.set_template(data.get_template)
            d2.set_deleted(data.is_deleted)
            d2.set_enabled(data.is_enabled)
            return
          end
        end
        # add an id which is not contributed as add-on
        if (!(data.get_template).nil?)
          new_data = TemplatePersistenceData.new(data.get_template, data.is_enabled)
          @f_templates.add(new_data)
        end
      end
    end
    
    typesig { [TemplatePersistenceData] }
    # Removes a template from the store.
    # 
    # @param data the template to remove
    def delete(data)
      if (data.is_user_added)
        @f_templates.remove(data)
      else
        data.set_deleted(true)
      end
    end
    
    typesig { [] }
    # Restores all contributed templates that have been deleted.
    def restore_deleted
      it = @f_templates.iterator
      while it.has_next
        data = it.next_
        if (data.is_deleted)
          data.set_deleted(false)
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Deletes all user-added templates and reverts all contributed templates.
    # 
    # @param doSave <code>true</code> if the store should be saved after restoring
    # @since 3.5
    def restore_defaults(do_save)
      old_value = nil
      if (!do_save)
        old_value = RJava.cast_to_string(@f_preference_store.get_string(@f_key))
      end
      begin
        @f_ignore_preference_store_changes = true
        @f_preference_store.set_to_default(@f_key)
      ensure
        @f_ignore_preference_store_changes = false
      end
      begin
        load
      rescue IOException => x
        # can't log from jface-text
        x.print_stack_trace
      end
      if (!(old_value).nil?)
        begin
          @f_ignore_preference_store_changes = true
          @f_preference_store.put_value(@f_key, old_value)
        ensure
          @f_ignore_preference_store_changes = false
        end
      end
    end
    
    typesig { [] }
    # Deletes all user-added templates and reverts all contributed templates.
    # <p>
    # <strong>Note:</strong> the store will be saved after restoring.
    # </p>
    def restore_defaults
      restore_defaults(true)
    end
    
    typesig { [] }
    # Returns all enabled templates.
    # 
    # @return all enabled templates
    def get_templates
      return get_templates(nil)
    end
    
    typesig { [String] }
    # Returns all enabled templates for the given context type.
    # 
    # @param contextTypeId the id of the context type of the requested templates, or <code>null</code> if all templates should be returned
    # @return all enabled templates for the given context type
    def get_templates(context_type_id)
      templates = ArrayList.new
      it = @f_templates.iterator
      while it.has_next
        data = it.next_
        if (data.is_enabled && !data.is_deleted && ((context_type_id).nil? || (context_type_id == data.get_template.get_context_type_id)))
          templates.add(data.get_template)
        end
      end
      return templates.to_array(Array.typed(Template).new(templates.size) { nil })
    end
    
    typesig { [String] }
    # Returns the first enabled template that matches the name.
    # 
    # @param name the name of the template searched for
    # @return the first enabled template that matches both name and context type id, or <code>null</code> if none is found
    def find_template(name)
      return find_template(name, nil)
    end
    
    typesig { [String, String] }
    # Returns the first enabled template that matches both name and context type id.
    # 
    # @param name the name of the template searched for
    # @param contextTypeId the context type id to clip unwanted templates, or <code>null</code> if any context type is OK
    # @return the first enabled template that matches both name and context type id, or <code>null</code> if none is found
    def find_template(name, context_type_id)
      Assert.is_not_null(name)
      it = @f_templates.iterator
      while it.has_next
        data = it.next_
        template = data.get_template
        if (data.is_enabled && !data.is_deleted && ((context_type_id).nil? || (context_type_id == template.get_context_type_id)) && (name == template.get_name))
          return template
        end
      end
      return nil
    end
    
    typesig { [String] }
    # Returns the first enabled template that matches the given template id.
    # 
    # @param id the id of the template searched for
    # @return the first enabled template that matches id, or <code>null</code> if none is found
    # @since 3.1
    def find_template_by_id(id)
      data = get_template_data(id)
      if (!(data).nil? && !data.is_deleted)
        return data.get_template
      end
      return nil
    end
    
    typesig { [::Java::Boolean] }
    # Returns all template data.
    # 
    # @param includeDeleted whether to include deleted data
    # @return all template data, whether enabled or not
    def get_template_data(include_deleted)
      datas = ArrayList.new
      it = @f_templates.iterator
      while it.has_next
        data = it.next_
        if (include_deleted || !data.is_deleted)
          datas.add(data)
        end
      end
      return datas.to_array(Array.typed(TemplatePersistenceData).new(datas.size) { nil })
    end
    
    typesig { [String] }
    # Returns the template data of the template with id <code>id</code> or
    # <code>null</code> if no such template can be found.
    # 
    # @param id the id of the template data
    # @return the template data of the template with id <code>id</code> or <code>null</code>
    # @since 3.1
    def get_template_data(id)
      Assert.is_not_null(id)
      it = @f_templates.iterator
      while it.has_next
        data = it.next_
        if ((id == data.get_id))
          return data
        end
      end
      return nil
    end
    
    typesig { [] }
    def load_custom_templates
      pref = @f_preference_store.get_string(@f_key)
      if (!(pref).nil? && pref.trim.length > 0)
        input = StringReader.new(pref)
        reader = TemplateReaderWriter.new
        datas = reader.read(input)
        i = 0
        while i < datas.attr_length
          data = datas[i]
          add(data)
          i += 1
        end
      end
    end
    
    typesig { [Template] }
    # Validates a template against the context type registered in the context
    # type registry. Returns always <code>true</code> if no registry is
    # present.
    # 
    # @param template the template to validate
    # @return <code>true</code> if validation is successful or no context
    # type registry is specified, <code>false</code> if validation
    # fails
    def validate_template(template)
      context_type_id = template.get_context_type_id
      if (context_exists(context_type_id))
        if (!(@f_registry).nil?)
          begin
            @f_registry.get_context_type(context_type_id).validate(template.get_pattern)
          rescue TemplateException => e
            return false
          end
        end
        return true
      end
      return false
    end
    
    typesig { [String] }
    # Returns <code>true</code> if a context type id specifies a valid context type
    # or if no context type registry is present.
    # 
    # @param contextTypeId the context type id to look for
    # @return <code>true</code> if the context type specified by the id
    # is present in the context type registry, or if no registry is
    # specified
    def context_exists(context_type_id)
      return !(context_type_id).nil? && ((@f_registry).nil? || !(@f_registry.get_context_type(context_type_id)).nil?)
    end
    
    typesig { [] }
    # Returns the registry.
    # 
    # @return Returns the registry
    def get_registry
      return @f_registry
    end
    
    private
    alias_method :initialize__template_store, :initialize
  end
  
end
