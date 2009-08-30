require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module PlatformURLFragmentConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLConnection
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLHandler
      include_const ::Org::Eclipse::Osgi::Util, :NLS
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  # Platform URL support
  # platform:/fragment/fragmentId/		maps to fragmentDescriptor.getInstallURLInternal()
  class PlatformURLFragmentConnection < PlatformURLFragmentConnectionImports.const_get :PlatformURLConnection
    include_class_members PlatformURLFragmentConnectionImports
    
    attr_accessor :target
    alias_method :attr_target, :target
    undef_method :target
    alias_method :attr_target=, :target=
    undef_method :target=
    
    class_module.module_eval {
      
      def is_registered
        defined?(@@is_registered) ? @@is_registered : @@is_registered= false
      end
      alias_method :attr_is_registered, :is_registered
      
      def is_registered=(value)
        @@is_registered = value
      end
      alias_method :attr_is_registered=, :is_registered=
      
      const_set_lazy(:FRAGMENT) { "fragment" }
      const_attr_reader  :FRAGMENT
    }
    
    typesig { [URL] }
    # $NON-NLS-1$
    # 
    # Constructor for the class.
    def initialize(url)
      @target = nil
      super(url)
      @target = nil
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.equinox.internal.url.PlatformURLConnection#allowCaching()
    def allow_caching
      return true
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.equinox.internal.url.PlatformURLConnection#resolve()
    def resolve
      spec = self.attr_url.get_file.trim
      if (spec.starts_with("/"))
        # $NON-NLS-1$
        spec = RJava.cast_to_string(spec.substring(1))
      end
      if (!spec.starts_with(FRAGMENT))
        raise IOException.new(NLS.bind(CommonMessages.attr_url_bad_variant, self.attr_url))
      end
      ix = spec.index_of("/", FRAGMENT.length + 1) # $NON-NLS-1$
      ref = (ix).equal?(-1) ? spec.substring(FRAGMENT.length + 1) : spec.substring(FRAGMENT.length + 1, ix)
      id = get_id(ref)
      activator = Activator.get_default
      if ((activator).nil?)
        raise IOException.new(CommonMessages.attr_activator_not_available)
      end
      @target = activator.get_bundle(id)
      if ((@target).nil?)
        raise IOException.new(NLS.bind(CommonMessages.attr_url_resolve_fragment, self.attr_url))
      end
      result = @target.get_entry("/") # $NON-NLS-1$
      if ((ix).equal?(-1) || (ix + 1) >= spec.length)
        return result
      end
      return URL.new(result, spec.substring(ix + 1))
    end
    
    class_module.module_eval {
      typesig { [] }
      def startup
        # register connection type for platform:/fragment handling
        if (self.attr_is_registered)
          return
        end
        PlatformURLHandler.register(FRAGMENT, PlatformURLFragmentConnection)
        self.attr_is_registered = true
      end
    }
    
    private
    alias_method :initialize__platform_urlfragment_connection, :initialize
  end
  
end
