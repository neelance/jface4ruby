require "rjava"

# Copyright (c) 2003, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module PreferenceLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Viewers, :LabelProvider
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # Provides labels for <code>IPreferenceNode</code> objects.
  # 
  # @since 3.0
  class PreferenceLabelProvider < PreferenceLabelProviderImports.const_get :LabelProvider
    include_class_members PreferenceLabelProviderImports
    
    typesig { [Object] }
    # @param element must be an instance of <code>IPreferenceNode</code>.
    # @see org.eclipse.jface.viewers.ILabelProvider#getText(java.lang.Object)
    def get_text(element)
      return (element).get_label_text
    end
    
    typesig { [Object] }
    # @param element must be an instance of <code>IPreferenceNode</code>.
    # @see org.eclipse.jface.viewers.ILabelProvider#getImage(java.lang.Object)
    def get_image(element)
      return (element).get_label_image
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__preference_label_provider, :initialize
  end
  
end
