require "rjava"

# Copyright (c) 2007, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal
  module JFaceActivatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal
      include ::Org::Osgi::Framework
    }
  end
  
  # JFaceActivator is the activator class for the JFace plug-in when it is being used
  # within a full Eclipse install.
  # @since 3.3
  class JFaceActivator 
    include_class_members JFaceActivatorImports
    include BundleActivator
    
    class_module.module_eval {
      
      def bundle_context
        defined?(@@bundle_context) ? @@bundle_context : @@bundle_context= nil
      end
      alias_method :attr_bundle_context, :bundle_context
      
      def bundle_context=(value)
        @@bundle_context = value
      end
      alias_method :attr_bundle_context=, :bundle_context=
    }
    
    typesig { [BundleContext] }
    # (non-Javadoc)
    # @see org.osgi.framework.BundleActivator#start(org.osgi.framework.BundleContext)
    def start(context)
      self.attr_bundle_context = context
      InternalPolicy::OSGI_AVAILABLE = true
    end
    
    typesig { [BundleContext] }
    # (non-Javadoc)
    # @see org.osgi.framework.BundleActivator#stop(org.osgi.framework.BundleContext)
    def stop(context)
      InternalPolicy::OSGI_AVAILABLE = false
      self.attr_bundle_context = nil
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return the bundle context for this bundle, or <code>null</code> if
      # there is not one. (for instance if the bundle is not activated or we aren't
      # running OSGi.
      # 
      # @return the bundle context or <code>null</code>
      def get_bundle_context
        return self.attr_bundle_context
      end
      
      typesig { [] }
      # Return the Bundle object for JFace. Returns <code>null</code> if it is not
      # available.
      # 
      # @return the bundle or <code>null</code>
      def get_bundle
        return (self.attr_bundle_context).nil? ? nil : self.attr_bundle_context.get_bundle
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__jface_activator, :initialize
  end
  
end
