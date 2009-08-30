require "rjava"

# Copyright (c) 2006, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module FileLocatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include ::Java::Io
      include_const ::Java::Net, :URL
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Internal::Runtime, :Activator
      include_const ::Org::Eclipse::Core::Internal::Runtime, :FindSupport
      include_const ::Org::Eclipse::Osgi::Service::Urlconversion, :URLConverter
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  # This class contains a collection of helper methods for finding files in bundles.
  # This class can only be used if the OSGi plugin is available.
  # 
  # @since org.eclipse.equinox.common 3.2
  # @noinstantiate This class is not intended to be instantiated by clients.
  class FileLocator 
    include_class_members FileLocatorImports
    
    typesig { [] }
    def initialize
      # prevent instantiation
    end
    
    class_module.module_eval {
      typesig { [Bundle, IPath, Map] }
      # Returns a URL for the given path in the given bundle.  Returns <code>null</code> if the URL
      # could not be computed or created.
      # <p>
      # This method looks for the path in the given bundle and any attached fragments.
      # <code>null</code> is returned if no such entry is found.  Note that
      # there is no specific order to the fragments.
      # </p><p>
      # The following variables may also be used as entries in the provided path:
      # <ul>
      # <li>$nl$ - for language specific information</li>
      # <li>$os$ - for operating system specific information</li>
      # <li>$ws$ - for windowing system specific information</li>
      # </ul>
      # </p><p>
      # A path of "$nl$/about.properties" in an environment with a default
      # locale of en_CA will return a URL corresponding to the first location
      # about.properties is found according to the following order:
      # <pre>
      # plugin root/nl/en/CA/about.properties
      # fragment1 root/nl/en/CA/about.properties
      # fragment2 root/nl/en/CA/about.properties
      # ...
      # plugin root/nl/en/about.properties
      # fragment1 root/nl/en/about.properties
      # fragment2 root/nl/en/about.properties
      # ...
      # plugin root/about.properties
      # fragment1 root/about.properties
      # fragment2 root/about.properties
      # ...
      # </pre>
      # </p><p>
      # The current environment variable values can be overridden using
      # the override map argument or <code>null</code> can be specified
      # if this is not desired.
      # </p>
      # 
      # @param bundle the bundle in which to search
      # @param path file path relative to plug-in installation location
      # @param override map of override substitution arguments to be used for
      # any $arg$ path elements. The map keys correspond to the substitution
      # arguments (eg. "$nl$" or "$os$"). The resulting
      # values must be of type java.lang.String. If the map is <code>null</code>,
      # or does not contain the required substitution argument, the default
      # is used.
      # @return a URL for the given path or <code>null</code>.  The actual form
      # of the returned URL is not specified.
      def find(bundle, path, override)
        return FindSupport.find(bundle, path, override)
      end
      
      typesig { [Bundle, IPath, Map] }
      # This method is the same as {@link #find(Bundle, IPath, Map)} except multiple entries
      # can be returned if more than one entry matches the path in the host and
      # any of its fragments.
      # 
      # @param bundle the bundle in which to search
      # @param path file path relative to plug-in installation location
      # @param override map of override substitution arguments to be used for
      # any $arg$ path elements. The map keys correspond to the substitution
      # arguments (eg. "$nl$" or "$os$"). The resulting
      # values must be of type java.lang.String. If the map is <code>null</code>,
      # or does not contain the required substitution argument, the default
      # is used.
      # @return an array of entries which match the given path.  An empty
      # array is returned if no matches are found.
      # 
      # @since org.eclipse.equinox.common 3.3
      def find_entries(bundle, path, override)
        return FindSupport.find_entries(bundle, path, override)
      end
      
      typesig { [URL] }
      # Returns the URL of a resource inside a bundle corresponding to the given URL.
      # Returns <code>null</code> if the URL could not be computed or created.
      # <p>
      # This method looks for a bundle resource described by the given input URL,
      # and returns the URL of the first resource found in the bundle or any attached
      # fragments.  <code>null</code> is returned if no such entry is found.  Note that
      # there is no specific order to the fragments.
      # </p><p>
      # The following variables may also be used as segments in the path of the provided URL:
      # <ul>
      # <li>$nl$ - for language specific information</li>
      # <li>$os$ - for operating system specific information</li>
      # <li>$ws$ - for windowing system specific information</li>
      # </ul>
      # </p><p>
      # For example, a URL of "platform:/plugin/org.eclipse.core.runtime/$nl$/about.properties" in an
      # environment with a default locale of en_CA will return a URL corresponding to
      # the first location about.properties is found according to the following order:
      # <pre>
      # plugin root/nl/en/CA/about.properties
      # fragment1 root/nl/en/CA/about.properties
      # fragment2 root/nl/en/CA/about.properties
      # ...
      # plugin root/nl/en/about.properties
      # fragment1 root/nl/en/about.properties
      # fragment2 root/nl/en/about.properties
      # ...
      # plugin root/about.properties
      # fragment1 root/about.properties
      # fragment2 root/about.properties
      # ...
      # </pre>
      # </p>
      # 
      # @param url The location of a bundle entry that potentially includes the above
      # environment variables
      # @return The URL of the bundle entry matching the input URL, or <code>null</code>
      # if no matching entry could be found. The actual form of the returned URL is not specified.
      # @since org.eclipse.equinox.common 3.5
      def find(url)
        return FindSupport.find(url)
      end
      
      typesig { [Bundle, IPath] }
      # This is a convenience method, fully equivalent to {@link #findEntries(Bundle, IPath, Map)},
      # with a value of <code>null</code> for the map argument.
      # 
      # @param bundle the bundle in which to search
      # @param path file path relative to plug-in installation location
      # @return an array of entries which match the given path.  An empty
      # array is returned if no matches are found.
      # 
      # @since org.eclipse.equinox.common 3.3
      def find_entries(bundle, path)
        return FindSupport.find_entries(bundle, path)
      end
      
      typesig { [Bundle, IPath, ::Java::Boolean] }
      # Returns an input stream for the specified file. The file path
      # must be specified relative to this plug-in's installation location.
      # Optionally, the path specified may contain $arg$ path elements that can
      # be used as substitution arguments.  If this option is used then the $arg$
      # path elements are processed in the same way as {@link #find(Bundle, IPath, Map)}.
      # <p>
      # The caller must close the returned stream when done.
      # </p>
      # 
      # @param bundle the bundle in which to search
      # @param file path relative to plug-in installation location
      # @param substituteArgs <code>true</code> to process substitution arguments,
      # and <code>false</code> for the file exactly as specified without processing any
      # substitution arguments.
      # @return an input stream
      # @exception IOException if the given path cannot be found in this plug-in
      def open_stream(bundle, file, substitute_args)
        return FindSupport.open_stream(bundle, file, substitute_args)
      end
      
      typesig { [URL] }
      # Converts a URL that uses a user-defined protocol into a URL that uses the file
      # protocol. The contents of the URL may be extracted into a cache on the file-system
      # in order to get a file URL.
      # <p>
      # If the protocol for the given URL is not recognized by this converter, the original
      # URL is returned as-is.
      # </p>
      # @param url the original URL
      # @return the converted file URL or the original URL passed in if it is
      # not recognized by this converter
      # @throws IOException if an error occurs during the conversion
      def to_file_url(url)
        converter = Activator.get_urlconverter(url)
        return (converter).nil? ? url : converter.to_file_url(url)
      end
      
      typesig { [URL] }
      # Converts a URL that uses a client-defined protocol into a URL that uses a
      # protocol which is native to the Java class library (file, jar, http, etc).
      # <p>
      # Note however that users of this API should not assume too much about the
      # results of this method.  While it may consistently return a file: URL in certain
      # installation configurations, others may result in jar: or http: URLs.
      # </p>
      # <p>
      # If the protocol is not recognized by this converter, then the original URL is
      # returned as-is.
      # </p>
      # @param url the original URL
      # @return the resolved URL or the original if the protocol is unknown to this converter
      # @exception IOException if unable to resolve URL
      # @throws IOException if an error occurs during the resolution
      def resolve(url)
        converter = Activator.get_urlconverter(url)
        return (converter).nil? ? url : converter.resolve(url)
      end
      
      typesig { [Bundle] }
      # Returns a file for the contents of the specified bundle.  Depending
      # on how the bundle is installed the returned file may be a directory or a jar file
      # containing the bundle content.
      # 
      # @param bundle the bundle
      # @return a file with the contents of the bundle
      # @throws IOException if an error occurs during the resolution
      # 
      # @since org.eclipse.equinox.common 3.4
      def get_bundle_file(bundle)
        root_entry = bundle.get_entry("/") # $NON-NLS-1$
        root_entry = resolve(root_entry)
        if (("file" == root_entry.get_protocol))
          # $NON-NLS-1$
          return JavaFile.new(root_entry.get_path)
        end
        if (("jar" == root_entry.get_protocol))
          # $NON-NLS-1$
          path = root_entry.get_path
          if (path.starts_with("file:"))
            # strip off the file: and the !/
            path = RJava.cast_to_string(path.substring(5, path.length - 2))
            return JavaFile.new(path)
          end
        end
        raise IOException.new("Unknown protocol") # $NON-NLS-1$
      end
    }
    
    private
    alias_method :initialize__file_locator, :initialize
  end
  
end
