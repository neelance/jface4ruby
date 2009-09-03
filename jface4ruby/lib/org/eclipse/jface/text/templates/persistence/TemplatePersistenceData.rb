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
  module TemplatePersistenceDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates::Persistence
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text::Templates, :Template
    }
  end
  
  # TemplatePersistenceData stores information about a template. It uniquely
  # references contributed templates via their id. Contributed templates may be
  # deleted or modified. All template may be enabled or not.
  # <p>
  # Clients may use this class, although this is not usually needed except when
  # implementing a custom template preference page or template store. This class
  # is not intended to be subclassed.
  # </p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class TemplatePersistenceData 
    include_class_members TemplatePersistenceDataImports
    
    attr_accessor :f_original_template
    alias_method :attr_f_original_template, :f_original_template
    undef_method :f_original_template
    alias_method :attr_f_original_template=, :f_original_template=
    undef_method :f_original_template=
    
    attr_accessor :f_id
    alias_method :attr_f_id, :f_id
    undef_method :f_id
    alias_method :attr_f_id=, :f_id=
    undef_method :f_id=
    
    attr_accessor :f_original_is_enabled
    alias_method :attr_f_original_is_enabled, :f_original_is_enabled
    undef_method :f_original_is_enabled
    alias_method :attr_f_original_is_enabled=, :f_original_is_enabled=
    undef_method :f_original_is_enabled=
    
    attr_accessor :f_custom_template
    alias_method :attr_f_custom_template, :f_custom_template
    undef_method :f_custom_template
    alias_method :attr_f_custom_template=, :f_custom_template=
    undef_method :f_custom_template=
    
    attr_accessor :f_is_deleted
    alias_method :attr_f_is_deleted, :f_is_deleted
    undef_method :f_is_deleted
    alias_method :attr_f_is_deleted=, :f_is_deleted=
    undef_method :f_is_deleted=
    
    attr_accessor :f_custom_is_enabled
    alias_method :attr_f_custom_is_enabled, :f_custom_is_enabled
    undef_method :f_custom_is_enabled
    alias_method :attr_f_custom_is_enabled=, :f_custom_is_enabled=
    undef_method :f_custom_is_enabled=
    
    typesig { [Template, ::Java::Boolean] }
    # Creates a new, user-added instance that is not linked to a contributed
    # template.
    # 
    # @param template the template which is stored by the new instance
    # @param enabled whether the template is enabled
    def initialize(template, enabled)
      initialize__template_persistence_data(template, enabled, nil)
    end
    
    typesig { [Template, ::Java::Boolean, String] }
    # Creates a new instance. If <code>id</code> is not <code>null</code>,
    # the instance is represents a template that is contributed and can be
    # identified via its id.
    # 
    # @param template the template which is stored by the new instance
    # @param enabled whether the template is enabled
    # @param id the id of the template, or <code>null</code> if a user-added
    # instance should be created
    def initialize(template, enabled, id)
      @f_original_template = nil
      @f_id = nil
      @f_original_is_enabled = false
      @f_custom_template = nil
      @f_is_deleted = false
      @f_custom_is_enabled = true
      Assert.is_not_null(template)
      @f_original_template = template
      @f_custom_template = template
      @f_original_is_enabled = enabled
      @f_custom_is_enabled = enabled
      @f_id = id
    end
    
    typesig { [] }
    # Returns the id of this template store, or <code>null</code> if there is none.
    # 
    # @return the id of this template store
    def get_id
      return @f_id
    end
    
    typesig { [] }
    # Returns the deletion state of the stored template. This is only relevant
    # of contributed templates.
    # 
    # @return the deletion state of the stored template
    def is_deleted
      return @f_is_deleted
    end
    
    typesig { [::Java::Boolean] }
    # Sets the deletion state of the stored template.
    # 
    # @param isDeleted the deletion state of the stored template
    def set_deleted(is_deleted)
      @f_is_deleted = is_deleted
    end
    
    typesig { [] }
    # Returns the template encapsulated by the receiver.
    # 
    # @return the template encapsulated by the receiver
    def get_template
      return @f_custom_template
    end
    
    typesig { [Template] }
    # Sets the template encapsulated by the receiver.
    # 
    # @param template the new template
    def set_template(template)
      @f_custom_template = template
    end
    
    typesig { [] }
    # Returns whether the receiver represents a custom template, i.e. is either
    # a user-added template or a contributed template that has been modified.
    # 
    # @return <code>true</code> if the contained template is a custom
    # template and cannot be reconstructed from the contributed
    # templates
    def is_custom
      return (@f_id).nil? || @f_is_deleted || !(@f_original_is_enabled).equal?(@f_custom_is_enabled) || !(@f_original_template == @f_custom_template)
    end
    
    typesig { [] }
    # Returns whether the receiver represents a modified template, i.e. a
    # contributed template that has been changed.
    # 
    # @return <code>true</code> if the contained template is contributed but has been modified, <code>false</code> otherwise
    def is_modified
      return is_custom && !is_user_added
    end
    
    typesig { [] }
    # Returns <code>true</code> if the contained template was added by a
    # user, i.e. does not reference a contributed template.
    # 
    # @return <code>true</code> if the contained template was added by a user, <code>false</code> otherwise
    def is_user_added
      return (@f_id).nil?
    end
    
    typesig { [] }
    # Reverts the template to its original setting.
    def revert
      @f_custom_template = @f_original_template
      @f_custom_is_enabled = @f_original_is_enabled
      @f_is_deleted = false
    end
    
    typesig { [] }
    # Returns the enablement state of the contained template.
    # 
    # @return the enablement state of the contained template
    def is_enabled
      return @f_custom_is_enabled
    end
    
    typesig { [::Java::Boolean] }
    # Sets the enablement state of the contained template.
    # 
    # @param isEnabled the new enablement state of the contained template
    def set_enabled(is_enabled)
      @f_custom_is_enabled = is_enabled
    end
    
    private
    alias_method :initialize__template_persistence_data, :initialize
  end
  
end
