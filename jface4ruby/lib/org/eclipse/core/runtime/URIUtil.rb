require "rjava"

# Copyright (c) 2008, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module URIUtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Java::Io, :JavaFile
      include ::Java::Net
    }
  end
  
  # A utility class for manipulating URIs. This class works around some of the
  # undesirable behavior of the {@link java.net.URI} class, and provides additional
  # path manipulation methods that are not available on the URI class.
  # 
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @since org.eclipse.equinox.common 3.5
  class URIUtil 
    include_class_members URIUtilImports
    
    class_module.module_eval {
      const_set_lazy(:JAR_SUFFIX) { "!/" }
      const_attr_reader  :JAR_SUFFIX
      
      # $NON-NLS-1$
      const_set_lazy(:UNC_PREFIX) { "//" }
      const_attr_reader  :UNC_PREFIX
      
      # $NON-NLS-1$
      const_set_lazy(:SCHEME_FILE) { "file" }
      const_attr_reader  :SCHEME_FILE
      
      # $NON-NLS-1$
      const_set_lazy(:SCHEME_JAR) { "jar" }
      const_attr_reader  :SCHEME_JAR
      
      when_class_loaded do
        const_set :DecodeResolved, URI.create("foo:/a%20b/").resolve("c").get_scheme_specific_part.index_of(Character.new(?%.ord)) > 0 # $NON-NLS-1$ //$NON-NLS-2$
      end
    }
    
    typesig { [] }
    def initialize
      # prevent instantiation
    end
    
    class_module.module_eval {
      typesig { [URI, String] }
      # Returns a new URI with all the same components as the given base URI,
      # but with a path component created by appending the given extension to the
      # base URI's path.
      # <p>
      # The important difference between this method
      # and {@link java.net.URI#resolve(String)} is in the treatment of the final segment.
      # The URI resolve method drops the last segment if there is no trailing slash as
      # specified in section 5.2 of RFC 2396. This leads to unpredictable behaviour
      # when working with file: URIs, because the existence of the trailing slash
      # depends on the existence of a local file on disk. This method operates
      # like a traditional path append and always preserves all segments of the base path.
      # 
      # @param base The base URI to append to
      # @param extension The unencoded path extension to be added
      # @return The appended URI
      def append(base, extension)
        begin
          path = base.get_path
          if ((path).nil?)
            return append_opaque(base, extension)
          end
          # if the base is already a directory then resolve will just do the right thing
          result = nil
          if (path.ends_with("/"))
            # $NON-NLS-1$
            result = base.resolve(URI.new(nil, extension, nil))
            if (DecodeResolved)
              # see bug 267219 - Java 1.4 implementation of URI#resolve incorrectly encoded the ssp
              result = URI.new(to_unencoded_string(result))
            end
          else
            path = path + RJava.cast_to_string(Character.new(?/.ord)) + extension
            result = URI.new(base.get_scheme, base.get_user_info, base.get_host, base.get_port, path, base.get_query, base.get_fragment)
          end
          result = result.normalize
          # Fix UNC paths that are incorrectly normalized by URI#resolve (see Java bug 4723726)
          result_path = result.get_path
          if (is_file_uri(base) && !(path).nil? && path.starts_with(UNC_PREFIX) && ((result_path).nil? || !result_path.starts_with(UNC_PREFIX)))
            result = URI.new(result.get_scheme, ensure_uncpath(result.get_scheme_specific_part), result.get_fragment)
          end
          return result
        rescue URISyntaxException => e
          # shouldn't happen because we started from a valid URI
          raise RuntimeException.new(e)
        end
      end
      
      typesig { [URI, String] }
      # Special case of appending to an opaque URI. Since opaque URIs
      # have no path segment the best we can do is append to the scheme-specific part
      def append_opaque(base, extension)
        ssp = base.get_scheme_specific_part
        if (ssp.ends_with("/"))
          # $NON-NLS-1$
          ssp += extension
        else
          ssp = ssp + "/" + extension
        end # $NON-NLS-1$
        return URI.new(base.get_scheme, ssp, base.get_fragment)
      end
      
      typesig { [String] }
      # Ensures the given path string starts with exactly four leading slashes.
      def ensure_uncpath(path)
        len = path.length
        result = StringBuffer.new(len)
        i = 0
        while i < 4
          if (i >= len || !(path.char_at(i)).equal?(Character.new(?/.ord)))
            result.append(Character.new(?/.ord))
          end
          i += 1
        end
        result.append(path)
        return result.to_s
      end
      
      typesig { [String] }
      # Returns a URI corresponding to the given unencoded string. This method
      # will take care of encoding any characters that must be encoded according
      # to the URI specification. This method must not be called with a string that
      # already contains an encoded URI, since this will result in the URI escape character ('%')
      # being escaped itself.
      # 
      # @param uriString An unencoded URI string
      # @return A URI corresponding to the given string
      # @throws URISyntaxException If the string cannot be formed into a valid URI
      def from_string(uri_string)
        colon = uri_string.index_of(Character.new(?:.ord))
        hash = uri_string.last_index_of(Character.new(?#.ord))
        no_hash = hash < 0
        if (no_hash)
          hash = uri_string.length
        end
        scheme = colon < 0 ? nil : uri_string.substring(0, colon)
        ssp = uri_string.substring(colon + 1, hash)
        fragment = no_hash ? nil : uri_string.substring(hash + 1)
        # use java.io.File for constructing file: URIs
        if (!(scheme).nil? && (scheme == SCHEME_FILE))
          # handle relative URI string with scheme (produced by java.net.URL)
          file = JavaFile.new(ssp)
          if (file.is_absolute)
            return file.to_uri
          end
          if (!(JavaFile.attr_separator_char).equal?(Character.new(?/.ord)))
            ssp = RJava.cast_to_string(ssp.replace(JavaFile.attr_separator_char, Character.new(?/.ord)))
          end
          # relative URIs have a null scheme.
          if (!ssp.starts_with("/"))
            # $NON-NLS-1$
            scheme = RJava.cast_to_string(nil)
          end
        end
        return URI.new(scheme, ssp, fragment)
      end
      
      typesig { [URI] }
      # Returns whether the given URI refers to a local file system URI.
      # @param uri The URI to check
      # @return <code>true</code> if the URI is a local file system location, and <code>false</code> otherwise
      def is_file_uri(uri)
        return SCHEME_FILE.equals_ignore_case(uri.get_scheme)
      end
      
      typesig { [URI] }
      # Returns the last segment of the given URI. For a hierarchical URL this returns
      # the last segment of the path. For opaque URIs this treats the scheme-specific
      # part as a path and returns the last segment. Returns <code>null</code> for
      # a hierarchical URI with an empty path, and for opaque URIs whose scheme-specific
      # part cannot be interpreted as a path.
      def last_segment(location)
        path = location.get_path
        if ((path).nil?)
          return Path.new(location.get_scheme_specific_part).last_segment
        end
        return Path.new(path).last_segment
      end
      
      typesig { [URI] }
      # Returns a new URI which is the same as this URI but with the file extension removed
      # from the path part.  If this URI does not have an extension, this path is returned.
      # <p>
      # The file extension portion is defined as the string
      # following the last period (".") character in the last segment.
      # If there is no period in the last segment, the path has no
      # file extension portion. If the last segment ends in a period,
      # the file extension portion is the empty string.
      # </p>
      # 
      # @return the new URI
      def remove_file_extension(uri)
        last_segment_ = last_segment(uri)
        if ((last_segment_).nil?)
          return uri
        end
        last_index = last_segment_.last_index_of(Character.new(?..ord))
        if ((last_index).equal?(-1))
          return uri
        end
        uri_string = uri.to_s
        last_index = uri_string.last_index_of(Character.new(?..ord))
        uri_string = RJava.cast_to_string(uri_string.substring(0, last_index))
        return URI.create(uri_string)
      end
      
      typesig { [URI, URI] }
      # Returns true if the two URIs are equal. URIs are considered equal if
      # {@link URI#equals(Object)} returns true, if the string representation
      # of the URIs is equal, or if they URIs are represent the same local file.
      # @param uri1 The first URI to compare
      # @param uri2 The second URI to compare
      # @return <code>true</code> if the URIs are the same, and <code>false</code> otherwise.
      def same_uri(uri1, uri2)
        if ((uri1).equal?(uri2))
          return true
        end
        if ((uri1).nil? || (uri2).nil?)
          return false
        end
        if ((uri1 == uri2))
          return true
        end
        if (same_string(uri1.get_scheme, uri2.get_scheme) && same_string(uri1.get_scheme_specific_part, uri2.get_scheme_specific_part) && same_string(uri1.get_fragment, uri2.get_fragment))
          return true
        end
        if (!(uri1.is_absolute).equal?(uri2.is_absolute))
          return false
        end
        # check if we have two local file references that are case variants
        file1 = to_file(uri1)
        return (file1).nil? ? false : (file1 == to_file(uri2))
      end
      
      typesig { [String, String] }
      def same_string(s1, s2)
        return ((s1).equal?(s2)) || !(s1).nil? && (s1 == s2)
      end
      
      typesig { [URI] }
      # Returns the URI as a local file, or <code>null</code> if the given
      # URI does not represent a local file.
      # @param uri The URI to return the file for
      # @return The local file corresponding to the given URI, or <code>null</code>
      def to_file(uri)
        if (!is_file_uri(uri))
          return nil
        end
        # assume all illegal characters have been properly encoded, so use URI class to unencode
        return JavaFile.new(uri.get_scheme_specific_part)
      end
      
      typesig { [URI, IPath] }
      # Returns a Java ARchive (JAR) URI for an entry in a jar or zip file.  The given input URI
      # should represent a zip or jar file, but this method will not check for existence or
      # validity of a file at the given URI.
      # <p>
      # The entry path parameter can optionally be used to obtain the URI of an entry
      # in a zip or jar file. If an entry path of <code>null</code> is provided, the resulting
      # URI will represent the jar file itself.
      # </p>
      # 
      # @param uri The URI of a zip or jar file
      # @param entryPath The path of a file inside the jar, or <code>null</code> to
      # obtain the URI for the jar file itself.
      # @return A URI with the "jar" scheme for the given input URI and entry path
      # @see JarURLConnection
      def to_jar_uri(uri, entry_path)
        begin
          if ((entry_path).nil?)
            entry_path = Path::EMPTY
          end
          # must deconstruct the input URI to obtain unencoded strings, and then pass to URI constructor that will encode the entry path
          return URI.new(SCHEME_JAR, RJava.cast_to_string(uri.get_scheme + Character.new(?:.ord) + uri.get_scheme_specific_part) + JAR_SUFFIX + RJava.cast_to_string(entry_path.to_s), nil)
        rescue URISyntaxException => e
          # should never happen
          raise RuntimeException.new(e)
        end
      end
      
      typesig { [URL] }
      # Returns the URL as a URI. This method will handle URLs that are
      # not properly encoded (for example they contain unencoded space characters).
      # 
      # @param url The URL to convert into a URI
      # @return A URI representing the given URL
      def to_uri(url)
        # URL behaves differently across platforms so for file: URLs we parse from string form
        if ((SCHEME_FILE == url.get_protocol))
          path_string = url.to_external_form.substring(5)
          # ensure there is a leading slash to handle common malformed URLs such as file:c:/tmp
          if (!(path_string.index_of(Character.new(?/.ord))).equal?(0))
            path_string = RJava.cast_to_string(Character.new(?/.ord)) + path_string
          else
            if (path_string.starts_with(UNC_PREFIX) && !path_string.starts_with(UNC_PREFIX, 2))
              # URL encodes UNC path with two slashes, but URI uses four (see bug 207103)
              path_string = RJava.cast_to_string(ensure_uncpath(path_string))
            end
          end
          return URI.new(SCHEME_FILE, path_string, nil)
        end
        begin
          return URI.new(url.to_external_form)
        rescue URISyntaxException => e
          # try multi-argument URI constructor to perform encoding
          return URI.new(url.get_protocol, url.get_user_info, url.get_host, url.get_port, url.get_path, url.get_query, url.get_ref)
        end
      end
      
      typesig { [URI] }
      # Returns a URI as a URL.
      # 
      # @throws MalformedURLException
      def to_url(uri)
        return URL.new(uri.to_s)
      end
      
      typesig { [URI] }
      # Returns a string representation of the given URI that doesn't have illegal
      # characters encoded. This string is suitable for later passing to {@link #fromString(String)}.
      # @param uri The URI to convert to string format
      # @return An unencoded string representation of the URI
      def to_unencoded_string(uri)
        result = StringBuffer.new
        scheme = uri.get_scheme
        if (!(scheme).nil?)
          result.append(scheme).append(Character.new(?:.ord))
        end
        # there is always a ssp
        result.append(uri.get_scheme_specific_part)
        fragment = uri.get_fragment
        if (!(fragment).nil?)
          result.append(Character.new(?#.ord)).append(fragment)
        end
        return result.to_s
      end
      
      typesig { [URI, URI] }
      # Returns an absolute URI that is created by appending the given relative URI to
      # the given base.  If the <tt>relative</tt> URI is already absolute it is simply returned.
      # <p>
      # This method is guaranteed to be the inverse of {@link #makeRelative(URI, URI)}.
      # That is, if R = makeRelative(O, B), then makeAbsolute(R, B), will return the original
      # URI O.
      # 
      # @param relative the relative URI
      # @param baseURI the base URI
      # @return an absolute URI
      def make_absolute(relative, base_uri)
        if (relative.is_absolute)
          return relative
        end
        return append(base_uri, to_unencoded_string(relative))
      end
      
      typesig { [URI, URI] }
      # Returns a URI equivalent to the given original URI, but relative to the given base
      # URI if possible.
      # <p>
      # This method is equivalent to {@link java.net.URI#relativize}, except for its
      # handling of file URIs. For file URIs, this method handles file system path devices.
      # If the URIs are not on the same device, then the original URI is returned.
      # 
      # @param original the original URI
      # @param baseURI the base URI
      # @return a relative URI
      def make_relative(original, base_uri)
        # for non-local URIs just use the built in relativize method
        if (!(SCHEME_FILE == original.get_scheme) || !(SCHEME_FILE == base_uri.get_scheme))
          return base_uri.relativize(original)
        end
        original_path = Path.new(original.get_scheme_specific_part)
        base_path = Path.new(base_uri.get_scheme_specific_part)
        # make sure we have an absolute path to start
        if (!base_path.is_absolute)
          return original
        end
        relative_path = original_path.make_relative_to(base_path)
        # if we could not make it relative, just return the original URI
        if ((relative_path).equal?(original_path))
          return original
        end
        begin
          return URI.new(nil, relative_path.to_s, nil)
        rescue URISyntaxException => e
          # cannot make a relative path, just return the original
          return original
        end
      end
    }
    
    private
    alias_method :initialize__uriutil, :initialize
  end
  
end
