require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module AnnotationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Annotation managed by an
  # {@link org.eclipse.jface.text.source.IAnnotationModel}.
  # <p>
  # Annotations are typed, can have an associated text and can be marked as persistent and
  # deleted. Annotations which are not explicitly initialized with an annotation
  # type are of type <code>"org.eclipse.text.annotation.unknown"</code>.
  class Annotation 
    include_class_members AnnotationImports
    
    class_module.module_eval {
      # Constant for unknown annotation types.<p>
      # Value: <code>"org.eclipse.text.annotation.unknown"</code>
      # @since 3.0
      const_set_lazy(:TYPE_UNKNOWN) { "org.eclipse.text.annotation.unknown" }
      const_attr_reader  :TYPE_UNKNOWN
    }
    
    # $NON-NLS-1$
    # 
    # The type of this annotation.
    # @since 3.0
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    # Indicates whether this annotation is persistent or not.
    # @since 3.0
    attr_accessor :f_is_persistent
    alias_method :attr_f_is_persistent, :f_is_persistent
    undef_method :f_is_persistent
    alias_method :attr_f_is_persistent=, :f_is_persistent=
    undef_method :f_is_persistent=
    
    # Indicates whether this annotation is marked as deleted or not.
    # @since 3.0
    attr_accessor :f_marked_as_deleted
    alias_method :attr_f_marked_as_deleted, :f_marked_as_deleted
    undef_method :f_marked_as_deleted
    alias_method :attr_f_marked_as_deleted=, :f_marked_as_deleted=
    undef_method :f_marked_as_deleted=
    
    # The text associated with this annotation.
    # @since 3.0
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    typesig { [] }
    # Creates a new annotation that is not persistent and type less.
    def initialize
      initialize__annotation(nil, false, nil)
    end
    
    typesig { [String, ::Java::Boolean, String] }
    # Creates a new annotation with the given properties.
    # 
    # @param type the unique name of this annotation type
    # @param isPersistent <code>true</code> if this annotation is
    # persistent, <code>false</code> otherwise
    # @param text the text associated with this annotation
    # @since 3.0
    def initialize(type, is_persistent, text)
      @f_type = nil
      @f_is_persistent = false
      @f_marked_as_deleted = false
      @f_text = nil
      @f_type = type
      @f_is_persistent = is_persistent
      @f_text = text
    end
    
    typesig { [::Java::Boolean] }
    # Creates a new annotation with the given persistence state.
    # 
    # @param isPersistent <code>true</code> if persistent, <code>false</code> otherwise
    # @since 3.0
    def initialize(is_persistent)
      initialize__annotation(nil, is_persistent, nil)
    end
    
    typesig { [] }
    # Returns whether this annotation is persistent.
    # 
    # @return <code>true</code> if this annotation is persistent, <code>false</code>
    # otherwise
    # @since 3.0
    def is_persistent
      return @f_is_persistent
    end
    
    typesig { [String] }
    # Sets the type of this annotation.
    # 
    # @param type the annotation type
    # @since 3.0
    def set_type(type)
      @f_type = type
    end
    
    typesig { [] }
    # Returns the type of the annotation.
    # 
    # @return the type of the annotation
    # @since 3.0
    def get_type
      return (@f_type).nil? ? TYPE_UNKNOWN : @f_type
    end
    
    typesig { [::Java::Boolean] }
    # Marks this annotation deleted according to the value of the
    # <code>deleted</code> parameter.
    # 
    # @param deleted <code>true</code> if annotation should be marked as deleted
    # @since 3.0
    def mark_deleted(deleted)
      @f_marked_as_deleted = deleted
    end
    
    typesig { [] }
    # Returns whether this annotation is marked as deleted.
    # 
    # @return <code>true</code> if annotation is marked as deleted, <code>false</code>
    # otherwise
    # @since 3.0
    def is_marked_deleted
      return @f_marked_as_deleted
    end
    
    typesig { [String] }
    # Sets the text associated with this annotation.
    # 
    # @param text the text associated with this annotation
    # @since 3.0
    def set_text(text)
      @f_text = text
    end
    
    typesig { [] }
    # Returns the text associated with this annotation.
    # 
    # @return the text associated with this annotation or <code>null</code>
    # @since 3.0
    def get_text
      return @f_text
    end
    
    private
    alias_method :initialize__annotation, :initialize
  end
  
end
