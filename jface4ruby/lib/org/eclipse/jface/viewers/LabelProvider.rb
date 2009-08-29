require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module LabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # A label provider implementation which, by default, uses an element's
  # <code>toString</code> value for its text and <code>null</code> for its
  # image.
  # <p>
  # This class may be used as is, or subclassed to provide richer labels.
  # Subclasses may override any of the following methods:
  # <ul>
  # <li><code>isLabelProperty</code></li>
  # <li><code>getImage</code></li>
  # <li><code>getText</code></li>
  # <li><code>dispose</code></li>
  # </ul>
  # </p>
  class LabelProvider < LabelProviderImports.const_get :BaseLabelProvider
    include_class_members LabelProviderImports
    overload_protected {
      include ILabelProvider
    }
    
    typesig { [] }
    # Creates a new label provider.
    def initialize
      super()
    end
    
    typesig { [Object] }
    # The <code>LabelProvider</code> implementation of this
    # <code>ILabelProvider</code> method returns <code>null</code>.
    # Subclasses may override.
    def get_image(element)
      return nil
    end
    
    typesig { [Object] }
    # The <code>LabelProvider</code> implementation of this
    # <code>ILabelProvider</code> method returns the element's
    # <code>toString</code> string. Subclasses may override.
    def get_text(element)
      return (element).nil? ? "" : element.to_s # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__label_provider, :initialize
  end
  
end
