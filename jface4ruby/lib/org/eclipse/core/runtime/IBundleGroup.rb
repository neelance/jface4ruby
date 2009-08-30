require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module IBundleGroupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  # Bundle groups represent a logical collection of plug-ins (aka bundles).  Bundle
  # groups do not contain their constituents but rather collect them together under
  # a common label.  The main role of a bundle group is to report to the system
  # (e.g., the About dialog) what bundles have been installed.  They are not intended
  # for use in managing the set of bundles they represent.
  # <p>
  # Since the bulk of the branding related information is specific to the consumer,
  # bundle groups also carry an arbitrary set of properties.  The valid set of
  # key-value pairs and their interpretation defined by the consumer in the
  # target environment.
  # </p><p>
  # The Eclipse UI is the typical consumer of bundle groups and defines various
  # property keys that it will use, for example, to display About information.  See
  # <code>org.eclipse.ui.branding.IBundleGroupConstants</code>.
  # </p>
  # @see IBundleGroupProvider
  # @since 3.0
  module IBundleGroup
    include_class_members IBundleGroupImports
    
    typesig { [] }
    # Returns the identifier of this bundle group.  Bundle groups are uniquely identified by the combination of
    # their identifier and their version.
    # 
    # @see #getVersion()
    # @return the identifier for this bundle group
    def get_identifier
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the human-readable name of this bundle group.
    # 
    # @return the human-readable name
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the version of this bundle group. Bundle group version strings have the same format as
    # bundle versions (i.e., major.minor.service.qualifier).  Bundle groups are uniquely identified
    # by the combination of their identifier and their version.
    # 
    # @see #getIdentifier()
    # @return the string form of this bundle group's version
    def get_version
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a text description of this bundle group.
    # 
    # @return text description of this bundle group
    def get_description
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the name of the provider of this bundle group.
    # 
    # @return the name of the provider or <code>null</code> if none
    def get_provider_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a list of all bundles supplied by this bundle group.
    # 
    # @return the bundles supplied by this bundle group
    def get_bundles
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the property of this bundle group with the given key.
    # <code>null</code> is returned if there is no such key/value pair.
    # 
    # @param key the name of the property to return
    # @return the value associated with the given key or <code>null</code> if none
    def get_property(key)
      raise NotImplementedError
    end
  end
  
end
