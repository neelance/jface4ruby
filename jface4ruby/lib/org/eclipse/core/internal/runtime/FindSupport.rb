require "rjava"

# Copyright (c) 2003, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module FindSupportImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Net, :URL
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Map
      include ::Org::Eclipse::Core::Runtime
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  # This class provides implements the find* methods exposed on Platform.
  # It does the lookup in bundles and fragments and does the variable replacement.
  # Can only be used if OSGi is available.
  class FindSupport 
    include_class_members FindSupportImports
    
    class_module.module_eval {
      # OSGI system properties
      const_set_lazy(:PROP_NL) { "osgi.nl" }
      const_attr_reader  :PROP_NL
      
      # $NON-NLS-1$
      const_set_lazy(:PROP_OS) { "osgi.os" }
      const_attr_reader  :PROP_OS
      
      # $NON-NLS-1$
      const_set_lazy(:PROP_WS) { "osgi.ws" }
      const_attr_reader  :PROP_WS
      
      # $NON-NLS-1$
      const_set_lazy(:PROP_ARCH) { "osgi.arch" }
      const_attr_reader  :PROP_ARCH
      
      # $NON-NLS-1$
      
      def nl_jar_variants
        defined?(@@nl_jar_variants) ? @@nl_jar_variants : @@nl_jar_variants= build_nlvariants((Activator.get_context).nil? ? System.get_property(PROP_NL) : Activator.get_context.get_property(PROP_NL))
      end
      alias_method :attr_nl_jar_variants, :nl_jar_variants
      
      def nl_jar_variants=(value)
        @@nl_jar_variants = value
      end
      alias_method :attr_nl_jar_variants=, :nl_jar_variants=
      
      typesig { [String] }
      def build_nlvariants(nl)
        result = ArrayList.new
        base = Path.new("nl") # $NON-NLS-1$
        path = Path.new(nl.replace(Character.new(?_.ord), Character.new(?/.ord)))
        while (path.segment_count > 0)
          result.add(base.append(path).to_s)
          # for backwards compatibility only, don't replace the slashes
          if (path.segment_count > 1)
            result.add(base.append(path.to_s.replace(Character.new(?/.ord), Character.new(?_.ord))).to_s)
          end
          path = path.remove_last_segments(1)
        end
        return result.to_array(Array.typed(String).new(result.size) { nil })
      end
      
      typesig { [Bundle, IPath] }
      # See doc on {@link FileLocator#find(Bundle, IPath, Map)}
      def find(bundle, path)
        return find(bundle, path, nil)
      end
      
      typesig { [Bundle, IPath, Map] }
      # See doc on {@link FileLocator#find(Bundle, IPath, Map)}
      def find(b, path, override)
        return find(b, path, override, nil)
      end
      
      typesig { [Bundle, IPath] }
      # See doc on {@link FileLocator#findEntries(Bundle, IPath)}
      def find_entries(bundle, path)
        return find_entries(bundle, path, nil)
      end
      
      typesig { [Bundle, IPath, Map] }
      # See doc on {@link FileLocator#findEntries(Bundle, IPath, Map)}
      def find_entries(bundle, path, override)
        results = ArrayList.new(1)
        find(bundle, path, override, results)
        return results.to_array(Array.typed(URL).new(results.size) { nil })
      end
      
      typesig { [Bundle, IPath, Map, ArrayList] }
      def find(b, path, override, multiple)
        if ((path).nil?)
          return nil
        end
        result = nil
        # Check for the empty or root case first
        if (path.is_empty || path.is_root)
          # Watch for the root case.  It will produce a new
          # URL which is only the root directory (and not the
          # root of this plugin).
          result = find_in_plugin(b, Path::EMPTY, multiple)
          if ((result).nil? || !(multiple).nil?)
            result = find_in_fragments(b, Path::EMPTY, multiple)
          end
          return result
        end
        # Now check for paths without variable substitution
        first = path.segment(0)
        if (!(first.char_at(0)).equal?(Character.new(?$.ord)))
          result = find_in_plugin(b, path, multiple)
          if ((result).nil? || !(multiple).nil?)
            result = find_in_fragments(b, path, multiple)
          end
          return result
        end
        # Worry about variable substitution
        rest = path.remove_first_segments(1)
        if (first.equals_ignore_case("$nl$"))
          # $NON-NLS-1$
          return find_nl(b, rest, override, multiple)
        end
        if (first.equals_ignore_case("$os$"))
          # $NON-NLS-1$
          return find_os(b, rest, override, multiple)
        end
        if (first.equals_ignore_case("$ws$"))
          # $NON-NLS-1$
          return find_ws(b, rest, override, multiple)
        end
        if (first.equals_ignore_case("$files$"))
          # $NON-NLS-1$
          return nil
        end
        return nil
      end
      
      typesig { [Bundle, IPath, Map, ArrayList] }
      def find_os(b, path, override, multiple)
        os = nil
        if (!(override).nil?)
          begin
            # check for override
            os = RJava.cast_to_string(override.get("$os$")) # $NON-NLS-1$
          rescue ClassCastException => e
            # just in case
          end
        end
        if ((os).nil?)
          # use default
          os = RJava.cast_to_string(Activator.get_context.get_property(PROP_OS))
        end
        if ((os.length).equal?(0))
          return nil
        end
        # Now do the same for osarch
        os_arch = nil
        if (!(override).nil?)
          begin
            # check for override
            os_arch = RJava.cast_to_string(override.get("$arch$")) # $NON-NLS-1$
          rescue ClassCastException => e
            # just in case
          end
        end
        if ((os_arch).nil?)
          # use default
          os_arch = RJava.cast_to_string(Activator.get_context.get_property(PROP_ARCH))
        end
        if ((os_arch.length).equal?(0))
          return nil
        end
        result = nil
        base = Path.new("os").append(os).append(os_arch) # $NON-NLS-1$
        # Keep doing this until all you have left is "os" as a path
        while (!(base.segment_count).equal?(1))
          file_path = base.append(path)
          result = find_in_plugin(b, file_path, multiple)
          if (!(result).nil? && (multiple).nil?)
            return result
          end
          result = find_in_fragments(b, file_path, multiple)
          if (!(result).nil? && (multiple).nil?)
            return result
          end
          base = base.remove_last_segments(1)
        end
        # If we get to this point, we haven't found it yet.
        # Look in the plugin and fragment root directories
        result = find_in_plugin(b, path, multiple)
        if (!(result).nil? && (multiple).nil?)
          return result
        end
        return find_in_fragments(b, path, multiple)
      end
      
      typesig { [Bundle, IPath, Map, ArrayList] }
      def find_ws(b, path, override, multiple)
        ws = nil
        if (!(override).nil?)
          begin
            # check for override
            ws = RJava.cast_to_string(override.get("$ws$")) # $NON-NLS-1$
          rescue ClassCastException => e
            # just in case
          end
        end
        if ((ws).nil?)
          # use default
          ws = RJava.cast_to_string(Activator.get_context.get_property(PROP_WS))
        end
        file_path = Path.new("ws").append(ws).append(path) # $NON-NLS-1$
        # We know that there is only one segment to the ws path
        # e.g. ws/win32
        result = find_in_plugin(b, file_path, multiple)
        if (!(result).nil? && (multiple).nil?)
          return result
        end
        result = find_in_fragments(b, file_path, multiple)
        if (!(result).nil? && (multiple).nil?)
          return result
        end
        # If we get to this point, we haven't found it yet.
        # Look in the plugin and fragment root directories
        result = find_in_plugin(b, path, multiple)
        if (!(result).nil? && (multiple).nil?)
          return result
        end
        return find_in_fragments(b, path, multiple)
      end
      
      typesig { [Bundle, IPath, Map, ArrayList] }
      def find_nl(b, path, override, multiple)
        nl = nil
        nl_variants = nil
        if (!(override).nil?)
          begin
            # check for override
            nl = RJava.cast_to_string(override.get("$nl$")) # $NON-NLS-1$
          rescue ClassCastException => e
            # just in case
          end
        end
        nl_variants = (nl).nil? ? self.attr_nl_jar_variants : build_nlvariants(nl)
        if (!(nl).nil? && (nl.length).equal?(0))
          return nil
        end
        result = nil
        i = 0
        while i < nl_variants.attr_length
          file_path = Path.new(nl_variants[i]).append(path)
          result = find_in_plugin(b, file_path, multiple)
          if (!(result).nil? && (multiple).nil?)
            return result
          end
          result = find_in_fragments(b, file_path, multiple)
          if (!(result).nil? && (multiple).nil?)
            return result
          end
          i += 1
        end
        # If we get to this point, we haven't found it yet.
        # Look in the plugin and fragment root directories
        result = find_in_plugin(b, path, multiple)
        if (!(result).nil? && (multiple).nil?)
          return result
        end
        return find_in_fragments(b, path, multiple)
      end
      
      typesig { [Bundle, IPath, ArrayList] }
      def find_in_plugin(b, file_path, multiple)
        result = b.get_entry(file_path.to_s)
        if (!(result).nil? && !(multiple).nil?)
          multiple.add(result)
        end
        return result
      end
      
      typesig { [Bundle, IPath, ArrayList] }
      def find_in_fragments(b, file_path, multiple)
        activator = Activator.get_default
        if ((activator).nil?)
          return nil
        end
        fragments = activator.get_fragments(b)
        if ((fragments).nil?)
          return nil
        end
        if (!(multiple).nil?)
          multiple.ensure_capacity(fragments.attr_length + 1)
        end
        i = 0
        while i < fragments.attr_length
          file_url = fragments[i].get_entry(file_path.to_s)
          if (!(file_url).nil?)
            if ((multiple).nil?)
              return file_url
            end
            multiple.add(file_url)
          end
          i += 1
        end
        return nil
      end
      
      typesig { [Bundle, IPath, ::Java::Boolean] }
      # See doc on {@link FileLocator#openStream(Bundle, IPath, boolean)}
      def open_stream(bundle, file, substitute_args)
        url = nil
        if (!substitute_args)
          url = find_in_plugin(bundle, file, nil)
          if ((url).nil?)
            url = find_in_fragments(bundle, file, nil)
          end
        else
          url = FindSupport.find(bundle, file)
        end
        if (!(url).nil?)
          return url.open_stream
        end
        raise IOException.new("Cannot find " + RJava.cast_to_string(file.to_s)) # $NON-NLS-1$
      end
      
      typesig { [URL] }
      # See doc on {@link FileLocator#find(URL)}
      def find(url)
        # if !platform/plugin | fragment URL return
        if (!"platform".equals_ignore_case(url.get_protocol))
          # $NON-NLS-1$
          return nil
        end
        # call a helper method to get the bundle object and rest of the path
        spec = url.get_file.trim
        obj = nil
        begin
          obj = PlatformURLPluginConnection.parse(spec, url)
        rescue IOException => e
          RuntimeLog.log(Status.new(IStatus::ERROR, IRuntimeConstants::PI_RUNTIME, "Invalid input url:" + RJava.cast_to_string(url), e)) # $NON-NLS-1$
          return nil
        end
        bundle = obj[0]
        path = obj[1]
        # use FileLocator.find(bundle, path, null) to look for the file
        if (("/" == path))
          # $NON-NLS-1$
          return bundle.get_entry(path)
        end
        return find(bundle, Path.new(path), nil)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__find_support, :initialize
  end
  
end
