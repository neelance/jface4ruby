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
  module InternalPolicyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal
    }
  end
  
  # default value is false
  # 
  # Internal class used for non-API debug flags.
  # 
  # @since 3.3
  class InternalPolicy 
    include_class_members InternalPolicyImports
    
    class_module.module_eval {
      # (NON-API) A flag to indicate whether reentrant viewer calls should always be
      # logged. If false, only the first reentrant call will cause a log entry.
      # 
      # @since 3.3
      
      def debug_log_reentrant_viewer_calls
        defined?(@@debug_log_reentrant_viewer_calls) ? @@debug_log_reentrant_viewer_calls : @@debug_log_reentrant_viewer_calls= false
      end
      alias_method :attr_debug_log_reentrant_viewer_calls, :debug_log_reentrant_viewer_calls
      
      def debug_log_reentrant_viewer_calls=(value)
        @@debug_log_reentrant_viewer_calls = value
      end
      alias_method :attr_debug_log_reentrant_viewer_calls=, :debug_log_reentrant_viewer_calls=
      
      # (NON-API) A flag to indicate whether label provider changed notifications
      # should always be logged when the underlying control has been disposed. If
      # false, only the first notification when disposed will cause a log entry.
      # 
      # @since 3.5
      
      def debug_log_label_provider_notifications_when_disposed
        defined?(@@debug_log_label_provider_notifications_when_disposed) ? @@debug_log_label_provider_notifications_when_disposed : @@debug_log_label_provider_notifications_when_disposed= false
      end
      alias_method :attr_debug_log_label_provider_notifications_when_disposed, :debug_log_label_provider_notifications_when_disposed
      
      def debug_log_label_provider_notifications_when_disposed=(value)
        @@debug_log_label_provider_notifications_when_disposed = value
      end
      alias_method :attr_debug_log_label_provider_notifications_when_disposed=, :debug_log_label_provider_notifications_when_disposed=
      
      # (NON-API) A flag to indicate whether the JFace bundle is running inside an OSGi
      # container
      # 
      # @since 3.5
      
      def osgi_available
        defined?(@@osgi_available) ? @@osgi_available : @@osgi_available= false
      end
      alias_method :attr_osgi_available, :osgi_available
      
      def osgi_available=(value)
        @@osgi_available = value
      end
      alias_method :attr_osgi_available=, :osgi_available=
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__internal_policy, :initialize
  end
  
end
