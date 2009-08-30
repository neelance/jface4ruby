require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Boot
  module PlatformURLConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Boot
      include ::Java::Io
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Properties
      include_const ::Org::Eclipse::Core::Internal::Runtime, :Activator
      include_const ::Org::Eclipse::Core::Internal::Runtime, :CommonMessages
      include_const ::Org::Eclipse::Osgi::Service::Debug, :DebugOptions
      include_const ::Org::Eclipse::Osgi::Util, :NLS
      include_const ::Org::Osgi::Framework, :Version
    }
  end
  
  # Platform URL support
  class PlatformURLConnection < PlatformURLConnectionImports.const_get :URLConnection
    include_class_members PlatformURLConnectionImports
    
    # URL access
    attr_accessor :is_in_cache
    alias_method :attr_is_in_cache, :is_in_cache
    undef_method :is_in_cache
    alias_method :attr_is_in_cache=, :is_in_cache=
    undef_method :is_in_cache=
    
    attr_accessor :is_jar
    alias_method :attr_is_jar, :is_jar
    undef_method :is_jar
    alias_method :attr_is_jar=, :is_jar=
    undef_method :is_jar=
    
    # protected URL url;				// declared in super (platform: URL)
    attr_accessor :resolved_url
    alias_method :attr_resolved_url, :resolved_url
    undef_method :resolved_url
    alias_method :attr_resolved_url=, :resolved_url=
    undef_method :resolved_url=
    
    # resolved file URL (e.g. http: URL)
    attr_accessor :cached_url
    alias_method :attr_cached_url, :cached_url
    undef_method :cached_url
    alias_method :attr_cached_url=, :cached_url=
    undef_method :cached_url=
    
    # file URL in cache (file: URL)
    attr_accessor :connection
    alias_method :attr_connection, :connection
    undef_method :connection
    alias_method :attr_connection=, :connection=
    undef_method :connection=
    
    class_module.module_eval {
      # actual connection
      # local cache
      
      def cache_index
        defined?(@@cache_index) ? @@cache_index : @@cache_index= Properties.new
      end
      alias_method :attr_cache_index, :cache_index
      
      def cache_index=(value)
        @@cache_index = value
      end
      alias_method :attr_cache_index=, :cache_index=
      
      
      def cache_location
        defined?(@@cache_location) ? @@cache_location : @@cache_location= nil
      end
      alias_method :attr_cache_location, :cache_location
      
      def cache_location=(value)
        @@cache_location = value
      end
      alias_method :attr_cache_location=, :cache_location=
      
      
      def index_name
        defined?(@@index_name) ? @@index_name : @@index_name= nil
      end
      alias_method :attr_index_name, :index_name
      
      def index_name=(value)
        @@index_name = value
      end
      alias_method :attr_index_name=, :index_name=
      
      
      def file_prefix
        defined?(@@file_prefix) ? @@file_prefix : @@file_prefix= nil
      end
      alias_method :attr_file_prefix, :file_prefix
      
      def file_prefix=(value)
        @@file_prefix = value
      end
      alias_method :attr_file_prefix=, :file_prefix=
      
      # constants
      const_set_lazy(:BUF_SIZE) { 32768 }
      const_attr_reader  :BUF_SIZE
      
      const_set_lazy(:NOT_FOUND) { Object.new }
      const_attr_reader  :NOT_FOUND
      
      # marker
      const_set_lazy(:CACHE_PROP) { ".cache.properties" }
      const_attr_reader  :CACHE_PROP
      
      # $NON-NLS-1$
      const_set_lazy(:CACHE_LOCATION_PROP) { "location" }
      const_attr_reader  :CACHE_LOCATION_PROP
      
      # $NON-NLS-1$
      const_set_lazy(:CACHE_INDEX_PROP) { "index" }
      const_attr_reader  :CACHE_INDEX_PROP
      
      # $NON-NLS-1$
      const_set_lazy(:CACHE_PREFIX_PROP) { "prefix" }
      const_attr_reader  :CACHE_PREFIX_PROP
      
      # $NON-NLS-1$
      const_set_lazy(:CACHE_INDEX) { ".index.properties" }
      const_attr_reader  :CACHE_INDEX
      
      # $NON-NLS-1$
      const_set_lazy(:CACHE_DIR) { ".eclipse-" + RJava.cast_to_string(PlatformURLHandler::PROTOCOL) + RJava.cast_to_string(JavaFile.attr_separator) }
      const_attr_reader  :CACHE_DIR
      
      # $NON-NLS-1$
      # debug tracing
      const_set_lazy(:OPTION_DEBUG) { "org.eclipse.core.runtime/url/debug" }
      const_attr_reader  :OPTION_DEBUG
      
      # $NON-NLS-1$;
      const_set_lazy(:OPTION_DEBUG_CONNECT) { OPTION_DEBUG + "/connect" }
      const_attr_reader  :OPTION_DEBUG_CONNECT
      
      # $NON-NLS-1$;
      const_set_lazy(:OPTION_DEBUG_CACHE_LOOKUP) { OPTION_DEBUG + "/cachelookup" }
      const_attr_reader  :OPTION_DEBUG_CACHE_LOOKUP
      
      # $NON-NLS-1$;
      const_set_lazy(:OPTION_DEBUG_CACHE_COPY) { OPTION_DEBUG + "/cachecopy" }
      const_attr_reader  :OPTION_DEBUG_CACHE_COPY
      
      when_class_loaded do
        activator = Activator.get_default
        if ((activator).nil?)
          const_set :DEBUG, const_set :DEBUG_CONNECT, const_set :DEBUG_CACHE_LOOKUP, const_set :DEBUG_CACHE_COPY, false
        else
          debug_options = activator.get_debug_options
          if (!(debug_options).nil?)
            const_set :DEBUG, debug_options.get_boolean_option(OPTION_DEBUG, false)
            const_set :DEBUG_CONNECT, debug_options.get_boolean_option(OPTION_DEBUG_CONNECT, true)
            const_set :DEBUG_CACHE_LOOKUP, debug_options.get_boolean_option(OPTION_DEBUG_CACHE_LOOKUP, true)
            const_set :DEBUG_CACHE_COPY, debug_options.get_boolean_option(OPTION_DEBUG_CACHE_COPY, true)
          else
            const_set :DEBUG, const_set :DEBUG_CONNECT, const_set :DEBUG_CACHE_LOOKUP, const_set :DEBUG_CACHE_COPY, false
          end
        end
      end
    }
    
    typesig { [URL] }
    def initialize(url)
      @is_in_cache = false
      @is_jar = false
      @resolved_url = nil
      @cached_url = nil
      @connection = nil
      super(url)
      @is_in_cache = false
      @is_jar = false
      @resolved_url = nil
      @cached_url = nil
      @connection = nil
    end
    
    typesig { [] }
    def allow_caching
      return false
    end
    
    typesig { [] }
    def connect
      connect(false)
    end
    
    typesig { [::Java::Boolean] }
    def connect(as_local)
      synchronized(self) do
        if (self.attr_connected)
          return
        end
        if (should_cache(as_local))
          begin
            in_cache = get_urlin_cache
            if (!(in_cache).nil?)
              @connection = in_cache.open_connection
            end
          rescue IOException => e
            # failed to cache ... will use resolved URL instead
          end
        end
        # use resolved URL
        if ((@connection).nil?)
          @connection = @resolved_url.open_connection
        end
        self.attr_connected = true
        if (DEBUG && DEBUG_CONNECT)
          debug("Connected as " + RJava.cast_to_string(@connection.get_url))
        end
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    # TODO consider refactoring this method... it is too long
    # TODO avoid cryptic identifiers such as ix, tgt, tmp, srcis, tgtos...
    def copy_to_cache
      if (@is_in_cache | (@cached_url).nil?)
        return
      end
      tmp = nil
      ix = 0
      # cache entry key
      key = nil
      if (@is_jar)
        tmp = RJava.cast_to_string(self.attr_url.get_file)
        ix = tmp.last_index_of(PlatformURLHandler::JAR_SEPARATOR)
        if (!(ix).equal?(-1))
          tmp = RJava.cast_to_string(tmp.substring(0, ix))
        end
        key = tmp
      else
        key = RJava.cast_to_string(self.attr_url.get_file)
      end
      # source url
      src = nil
      if (@is_jar)
        tmp = RJava.cast_to_string(@resolved_url.get_file)
        ix = tmp.last_index_of(PlatformURLHandler::JAR_SEPARATOR)
        if (!(ix).equal?(-1))
          tmp = RJava.cast_to_string(tmp.substring(0, ix))
        end
        src = URL.new(tmp)
      else
        src = @resolved_url
      end
      srcis = nil
      # cache target
      tgt = nil
      if (@is_jar)
        tmp = RJava.cast_to_string(@cached_url.get_file)
        ix = tmp.index_of(PlatformURLHandler::PROTOCOL_SEPARATOR)
        if (!(ix).equal?(-1))
          tmp = RJava.cast_to_string(tmp.substring(ix + 1))
        end
        ix = tmp.last_index_of(PlatformURLHandler::JAR_SEPARATOR)
        if (!(ix).equal?(-1))
          tmp = RJava.cast_to_string(tmp.substring(0, ix))
        end
        tgt = tmp
      else
        tgt = RJava.cast_to_string(@cached_url.get_file)
      end
      tgt_file = nil
      tgtos = nil
      error = false
      total = 0
      begin
        if (DEBUG && DEBUG_CACHE_COPY)
          if (@is_jar)
            debug("Caching jar as " + tgt)
             # $NON-NLS-1$
          else
            debug("Caching as " + tgt)
          end # $NON-NLS-1$
        end
        srcis = src.open_stream
        buf = Array.typed(::Java::Byte).new(BUF_SIZE) { 0 }
        count = srcis.read(buf)
        tgt_file = JavaFile.new(tgt)
        tgtos = FileOutputStream.new(tgt_file)
        while (!(count).equal?(-1))
          total += count
          tgtos.write(buf, 0, count)
          count = srcis.read(buf)
        end
        srcis.close
        srcis = nil
        tgtos.flush
        tgtos.get_fd.sync
        tgtos.close
        tgtos = nil
        # add cache entry
        self.attr_cache_index.put(key, tgt)
        @is_in_cache = true
      rescue IOException => e
        error = true
        self.attr_cache_index.put(key, NOT_FOUND)
        # mark cache entry for this execution
        if (DEBUG && DEBUG_CACHE_COPY)
          debug("Failed to cache due to " + RJava.cast_to_string(e))
        end # $NON-NLS-1$
        raise e
      ensure
        if (!error && DEBUG && DEBUG_CACHE_COPY)
          debug(RJava.cast_to_string(total) + " bytes copied")
        end # $NON-NLS-1$
        if (!(srcis).nil?)
          srcis.close
        end
        if (!(tgtos).nil?)
          tgtos.close
        end
      end
    end
    
    typesig { [String] }
    def debug(s)
      System.out.println("URL " + RJava.cast_to_string(get_url.to_s) + "^" + RJava.cast_to_string(JavaInteger.to_hex_string(JavaThread.current_thread.hash_code)) + " " + s) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    end
    
    class_module.module_eval {
      typesig { [String] }
      def debug_startup(s)
        System.out.println("URL " + s) # $NON-NLS-1$
      end
    }
    
    typesig { [] }
    def get_auxillary_urls
      return nil
    end
    
    typesig { [] }
    def get_input_stream
      synchronized(self) do
        if (!self.attr_connected)
          connect
        end
        return @connection.get_input_stream
      end
    end
    
    typesig { [] }
    def get_resolved_url
      return @resolved_url
    end
    
    typesig { [] }
    def get_urlas_local
      connect(true) # connect and force caching if necessary
      u = @connection.get_url
      up = u.get_protocol
      if (!(up == PlatformURLHandler::FILE) && !(up == PlatformURLHandler::JAR) && !up.starts_with(PlatformURLHandler::BUNDLE))
        raise IOException.new(NLS.bind(CommonMessages.attr_url_noaccess, up))
      end
      return u
    end
    
    typesig { [] }
    # TODO consider refactoring this method... it is too long
    def get_urlin_cache
      if (!allow_caching)
        return nil
      end # target should not be cached
      if (@is_in_cache)
        return @cached_url
      end
      if ((self.attr_cache_location).nil? | (self.attr_cache_index).nil?)
        return nil
      end # not caching
      # check if we are dealing with a .jar/ .zip
      file = "" # $NON-NLS-1$
      jar_entry = nil
      if (@is_jar)
        file = RJava.cast_to_string(self.attr_url.get_file)
        ix = file.last_index_of(PlatformURLHandler::JAR_SEPARATOR)
        if (!(ix).equal?(-1))
          jar_entry = RJava.cast_to_string(file.substring(ix + PlatformURLHandler::JAR_SEPARATOR.length))
          file = RJava.cast_to_string(file.substring(0, ix))
        end
      else
        file = RJava.cast_to_string(self.attr_url.get_file)
      end
      # check for cached entry
      tmp = self.attr_cache_index.get(file)
      # check for "not found" marker
      if (!(tmp).nil? && (tmp).equal?(NOT_FOUND))
        raise IOException.new
      end
      # validate cache entry
      if (!(tmp).nil? && !(JavaFile.new(tmp)).exists)
        tmp = RJava.cast_to_string(nil)
        self.attr_cache_index.remove(self.attr_url.get_file)
      end
      # found in cache
      if (!(tmp).nil?)
        if (@is_jar)
          if (DEBUG && DEBUG_CACHE_LOOKUP)
            debug("Jar located in cache as " + tmp)
          end # $NON-NLS-1$
          tmp = RJava.cast_to_string(PlatformURLHandler::FILE + PlatformURLHandler::PROTOCOL_SEPARATOR) + tmp + RJava.cast_to_string(PlatformURLHandler::JAR_SEPARATOR) + jar_entry
          @cached_url = URL.new(PlatformURLHandler::JAR, nil, -1, tmp)
        else
          if (DEBUG && DEBUG_CACHE_LOOKUP)
            debug("Located in cache as " + tmp)
          end # $NON-NLS-1$
          @cached_url = URL.new(PlatformURLHandler::FILE, nil, -1, tmp)
        end
        @is_in_cache = true
      else
        # attempt to cache
        ix = file.last_index_of("/") # $NON-NLS-1$
        tmp = RJava.cast_to_string(file.substring(ix + 1))
        tmp = self.attr_cache_location + self.attr_file_prefix + RJava.cast_to_string(Long.to_s((Java::Util::JavaDate.new).get_time)) + "_" + tmp # $NON-NLS-1$
        tmp = RJava.cast_to_string(tmp.replace(JavaFile.attr_separator_char, Character.new(?/.ord)))
        if (@is_jar)
          tmp = RJava.cast_to_string(PlatformURLHandler::FILE + PlatformURLHandler::PROTOCOL_SEPARATOR) + tmp + RJava.cast_to_string(PlatformURLHandler::JAR_SEPARATOR) + jar_entry
          @cached_url = URL.new(PlatformURLHandler::JAR, nil, -1, tmp)
        else
          @cached_url = URL.new(PlatformURLHandler::FILE, nil, -1, tmp)
        end
        copy_to_cache
      end
      return @cached_url
    end
    
    typesig { [] }
    # to be implemented by subclass
    # @return URL resolved URL
    def resolve
      # TODO throw UnsupportedOperationException instead - this is a bug in subclass, not an actual failure
      raise IOException.new
    end
    
    class_module.module_eval {
      typesig { [String] }
      def get_id(spec)
        id = parse(spec)[0]
        return (id).nil? ? spec : id
      end
      
      typesig { [String] }
      def get_version(spec)
        version = parse(spec)[1]
        return (version).nil? ? "" : version.to_s # $NON-NLS-1$
      end
      
      typesig { [String] }
      def parse(spec)
        bsn = nil
        version = nil
        under_score = spec.index_of(Character.new(?_.ord))
        while (under_score >= 0)
          bsn = RJava.cast_to_string(spec.substring(0, under_score))
          begin
            version = Version.parse_version(spec.substring(under_score + 1))
          rescue IllegalArgumentException => iae
            # continue to next underscore
            under_score = spec.index_of(Character.new(?_.ord), under_score + 1)
            next
          end
          break
        end
        return Array.typed(Object).new([bsn, version])
      end
    }
    
    typesig { [URL] }
    def set_resolved_url(url)
      if ((url).nil?)
        raise IOException.new
      end
      if (!(@resolved_url).nil?)
        return
      end
      ix = url.get_file.last_index_of(PlatformURLHandler::JAR_SEPARATOR)
      @is_jar = !(-1).equal?(ix)
      # Resolved URLs containing !/ separator are assumed to be jar URLs.
      # If the resolved protocol is not jar, new jar URL is created.
      if (@is_jar && !(url.get_protocol == PlatformURLHandler::JAR))
        url = URL.new(PlatformURLHandler::JAR, "", -1, url.to_external_form)
      end # $NON-NLS-1$
      @resolved_url = url
    end
    
    typesig { [::Java::Boolean] }
    def should_cache(as_local)
      # don't cache files that are known to be local
      rp = @resolved_url.get_protocol
      rf = @resolved_url.get_file
      if ((rp == PlatformURLHandler::FILE))
        return false
      end
      if ((rp == PlatformURLHandler::JAR) && (rf.starts_with(PlatformURLHandler::FILE)))
        return false
      end
      # for other files force caching if local connection was requested
      if (as_local)
        return true
      end
      # for now cache all files
      # XXX: add cache policy support
      return true
    end
    
    class_module.module_eval {
      typesig { [] }
      def shutdown
        if (!(self.attr_index_name).nil? && !(self.attr_cache_location).nil?)
          # weed out "not found" entries
          keys_ = self.attr_cache_index.keys
          key = nil
          value = nil
          while (keys_.has_more_elements)
            key = RJava.cast_to_string(keys_.next_element)
            value = self.attr_cache_index.get(key)
            if ((value).equal?(NOT_FOUND))
              self.attr_cache_index.remove(key)
            end
          end
          # if the cache index is empty we don't need to save it
          if ((self.attr_cache_index.size).equal?(0))
            return
          end
          begin
            # try to save cache index
            fos = nil
            fos = FileOutputStream.new(self.attr_cache_location + self.attr_index_name)
            begin
              self.attr_cache_index.store(fos, nil)
              fos.flush
              fos.get_fd.sync
            ensure
              fos.close
            end
          rescue IOException => e
            # failed to store cache index ... ignore
          end
        end
      end
      
      typesig { [String, String, String, String] }
      # TODO consider splitting this method into two or more steps - it is too long
      def startup(location, os, ws, nl)
        verify_location(location) # check for platform location, ignore errors
        cache_props = location.trim
        if (!cache_props.ends_with(JavaFile.attr_separator))
          cache_props += RJava.cast_to_string(JavaFile.attr_separator)
        end
        cache_props += CACHE_PROP
        cache_prop_file = JavaFile.new(cache_props)
        props = nil
        fis = nil
        if (cache_prop_file.exists)
          # load existing properties
          begin
            props = Properties.new
            fis = FileInputStream.new(cache_prop_file)
            begin
              props.load(fis)
            ensure
              fis.close
            end
          rescue IOException => e
            props = nil
          end
        end
        if ((props).nil?)
          # first time up, or failed to load previous settings
          props = Properties.new
          tmp = System.get_property("user.home") # $NON-NLS-1$
          if (!tmp.ends_with(JavaFile.attr_separator))
            tmp += RJava.cast_to_string(JavaFile.attr_separator)
          end
          tmp += CACHE_DIR
          props.put(CACHE_LOCATION_PROP, tmp)
          tmp = RJava.cast_to_string(Long.to_s((Java::Util::JavaDate.new).get_time))
          props.put(CACHE_PREFIX_PROP, tmp)
          tmp += CACHE_INDEX
          props.put(CACHE_INDEX_PROP, tmp)
          # save for next time around
          fos = nil
          begin
            fos = FileOutputStream.new(cache_prop_file)
            begin
              props.store(fos, nil)
              fos.flush
              fos.get_fd.sync
            ensure
              fos.close
            end
          rescue IOException => e
            # failed to store cache location metadata ... ignore
          end
        end
        # remember settings for shutdown processing
        self.attr_file_prefix = RJava.cast_to_string(props.get(CACHE_PREFIX_PROP))
        self.attr_index_name = RJava.cast_to_string(props.get(CACHE_INDEX_PROP))
        self.attr_cache_location = RJava.cast_to_string(props.get(CACHE_LOCATION_PROP))
        if (DEBUG)
          debug_startup("Cache location: " + self.attr_cache_location) # $NON-NLS-1$
          debug_startup("Cache index: " + self.attr_index_name) # $NON-NLS-1$
          debug_startup("Cache file prefix: " + self.attr_file_prefix) # $NON-NLS-1$
        end
        # create cache directory structure if needed
        if (!verify_location(self.attr_cache_location))
          self.attr_index_name = RJava.cast_to_string(nil)
          self.attr_cache_location = RJava.cast_to_string(nil)
          if (DEBUG)
            debug_startup("Failed to create cache directory structure. Caching suspended")
          end # $NON-NLS-1$
          return
        end
        # attempt to initialize cache index
        if (!(self.attr_cache_location).nil? && !(self.attr_index_name).nil?)
          begin
            fis = FileInputStream.new(self.attr_cache_location + self.attr_index_name)
            begin
              self.attr_cache_index.load(fis)
            ensure
              fis.close
            end
          rescue IOException => e
            if (DEBUG)
              debug_startup("Failed to initialize cache")
            end # $NON-NLS-1$
          end
        end
      end
      
      typesig { [String] }
      def verify_location(location)
        # verify cache directory exists. Create if needed
        cache_dir = JavaFile.new(location)
        if (cache_dir.exists)
          return true
        end
        return cache_dir.mkdirs
      end
    }
    
    private
    alias_method :initialize__platform_urlconnection, :initialize
  end
  
end
