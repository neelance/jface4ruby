require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Quickassist
  module IQuickFixableAnnotationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Quickassist
      include_const ::Org::Eclipse::Core::Runtime, :AssertionFailedException
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
    }
  end
  
  # Allows an annotation to tell whether there are quick fixes
  # for it and to cache that state.
  # <p>
  # Caching the state is important to improve overall performance as calling
  # {@link org.eclipse.jface.text.quickassist.IQuickAssistAssistant#canFix(Annotation)}
  # can be expensive.
  # </p>
  # <p>
  # This interface can be implemented by clients.</p>
  # 
  # @since 3.2
  module IQuickFixableAnnotation
    include_class_members IQuickFixableAnnotationImports
    
    typesig { [::Java::Boolean] }
    # Sets whether there are quick fixes available for
    # this annotation.
    # 
    # @param state <code>true</code> if there are quick fixes available, false otherwise
    def set_quick_fixable(state)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether the quick fixable state has been set.
    # <p>
    # Normally this means {@link #setQuickFixable(boolean)} has been
    # called at least once but it can also be hard-coded, e.g. always
    # return <code>true</code>.
    # </p>
    # 
    # @return <code>true</code> if the state has been set
    def is_quick_fixable_state_set
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether there are quick fixes for this annotation.
    # <p>
    # <strong>Note:</strong> This method must only be called
    # if {@link #isQuickFixableStateSet()} returns <code>true</code>.</p>
    # 
    # @return <code>true</code> if this annotation offers quick fixes
    # @throws AssertionFailedException if called when {@link #isQuickFixableStateSet()} is <code>false</code>
    def is_quick_fixable
      raise NotImplementedError
    end
  end
  
end
