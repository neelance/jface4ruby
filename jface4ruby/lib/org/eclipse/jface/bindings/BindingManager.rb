require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module BindingManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
      include_const ::Java::Io, :BufferedWriter
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :StringWriter
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Core::Commands, :CommandManager
      include_const ::Org::Eclipse::Core::Commands, :ParameterizedCommand
      include_const ::Org::Eclipse::Core::Commands::Common, :HandleObjectManager
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
      include_const ::Org::Eclipse::Core::Commands::Contexts, :Context
      include_const ::Org::Eclipse::Core::Commands::Contexts, :ContextManager
      include_const ::Org::Eclipse::Core::Commands::Contexts, :ContextManagerEvent
      include_const ::Org::Eclipse::Core::Commands::Contexts, :IContextManagerListener
      include_const ::Org::Eclipse::Core::Commands::Util, :Tracing
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :MultiStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :IKeyLookup
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyLookupFactory
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
      include_const ::Org::Eclipse::Jface::Contexts, :IContextIds
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # A central repository for bindings -- both in the defined and undefined
  # states. Schemes and bindings can be created and retrieved using this manager.
  # It is possible to listen to changes in the collection of schemes and bindings
  # by adding a listener to the manager.
  # </p>
  # <p>
  # The binding manager is very sensitive to performance. Misusing the manager
  # can render an application unenjoyable to use. As such, each of the public
  # methods states the current run-time performance. In future releases, it is
  # guaranteed that the method will run in at least the stated time constraint --
  # though it might get faster. Where possible, we have also tried to be memory
  # efficient.
  # </p>
  # 
  # @since 3.1
  class BindingManager < BindingManagerImports.const_get :HandleObjectManager
    include_class_members BindingManagerImports
    overload_protected {
      include IContextManagerListener
      include ISchemeListener
    }
    
    class_module.module_eval {
      # This flag can be set to <code>true</code> if the binding manager should
      # print information to <code>System.out</code> when certain boundary
      # conditions occur.
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # Returned for optimized lookup.
      const_set_lazy(:EMPTY_TRIGGER_SEQUENCE) { Array.typed(TriggerSequence).new(0) { nil } }
      const_attr_reader  :EMPTY_TRIGGER_SEQUENCE
      
      # The separator character used in locales.
      const_set_lazy(:LOCALE_SEPARATOR) { "_" }
      const_attr_reader  :LOCALE_SEPARATOR
    }
    
    # $NON-NLS-1$
    attr_accessor :current_conflicts
    alias_method :attr_current_conflicts, :current_conflicts
    undef_method :current_conflicts
    alias_method :attr_current_conflicts=, :current_conflicts=
    undef_method :current_conflicts=
    
    class_module.module_eval {
      typesig { [Map, Object, Object] }
      # </p>
      # A utility method for adding entries to a map. The map is checked for
      # entries at the key. If such an entry exists, it is expected to be a
      # <code>Collection</code>. The value is then appended to the collection.
      # If no such entry exists, then a collection is created, and the value
      # added to the collection.
      # </p>
      # 
      # @param map
      # The map to modify; if this value is <code>null</code>, then
      # this method simply returns.
      # @param key
      # The key to look up in the map; may be <code>null</code>.
      # @param value
      # The value to look up in the map; may be <code>null</code>.
      def add_reverse_lookup(map, key, value)
        if ((map).nil?)
          return
        end
        current_value = map.get(key)
        if (!(current_value).nil?)
          values = current_value
          values.add(value)
        else
          # currentValue == null
          values = ArrayList.new(1)
          values.add(value)
          map.put(key, values)
        end
      end
      
      typesig { [String, String] }
      # <p>
      # Takes a fully-specified string, and converts it into an array of
      # increasingly less-specific strings. So, for example, "en_GB" would become
      # ["en_GB", "en", "", null].
      # </p>
      # <p>
      # This method runs in linear time (O(n)) over the length of the string.
      # </p>
      # 
      # @param string
      # The string to break apart into its less specific components;
      # should not be <code>null</code>.
      # @param separator
      # The separator that indicates a separation between a degrees of
      # specificity; should not be <code>null</code>.
      # @return An array of strings from the most specific (i.e.,
      # <code>string</code>) to the least specific (i.e.,
      # <code>null</code>).
      def expand(string, separator)
        # Test for boundary conditions.
        if ((string).nil? || (separator).nil?)
          return Array.typed(String).new(0) { nil }
        end
        strings = ArrayList.new
        string_buffer = StringBuffer.new
        string = RJava.cast_to_string(string.trim) # remove whitespace
        if (string.length > 0)
          string_tokenizer = StringTokenizer.new(string, separator)
          while (string_tokenizer.has_more_elements)
            if (string_buffer.length > 0)
              string_buffer.append(separator)
            end
            string_buffer.append((string_tokenizer.next_element).trim)
            strings.add(string_buffer.to_s)
          end
        end
        Collections.reverse(strings)
        strings.add(Util::ZERO_LENGTH_STRING)
        strings.add(nil)
        return strings.to_array(Array.typed(String).new(strings.size) { nil })
      end
    }
    
    # The active bindings. This is a map of triggers (
    # <code>TriggerSequence</code>) to bindings (<code>Binding</code>).
    # This value will only be <code>null</code> if the active bindings have
    # not yet been computed. Otherwise, this value may be empty.
    attr_accessor :active_bindings
    alias_method :attr_active_bindings, :active_bindings
    undef_method :active_bindings
    alias_method :attr_active_bindings=, :active_bindings=
    undef_method :active_bindings=
    
    # The active bindings indexed by fully-parameterized commands. This is a
    # map of fully-parameterized commands (<code>ParameterizedCommand</code>)
    # to triggers ( <code>TriggerSequence</code>). This value will only be
    # <code>null</code> if the active bindings have not yet been computed.
    # Otherwise, this value may be empty.
    attr_accessor :active_bindings_by_parameterized_command
    alias_method :attr_active_bindings_by_parameterized_command, :active_bindings_by_parameterized_command
    undef_method :active_bindings_by_parameterized_command
    alias_method :attr_active_bindings_by_parameterized_command=, :active_bindings_by_parameterized_command=
    undef_method :active_bindings_by_parameterized_command=
    
    attr_accessor :trigger_conflicts
    alias_method :attr_trigger_conflicts, :trigger_conflicts
    undef_method :trigger_conflicts
    alias_method :attr_trigger_conflicts=, :trigger_conflicts=
    undef_method :trigger_conflicts=
    
    # The scheme that is currently active. An active scheme is the one that is
    # currently dictating which bindings will actually work. This value may be
    # <code>null</code> if there is no active scheme. If the active scheme
    # becomes undefined, then this should automatically revert to
    # <code>null</code>.
    attr_accessor :active_scheme
    alias_method :attr_active_scheme, :active_scheme
    undef_method :active_scheme
    alias_method :attr_active_scheme=, :active_scheme=
    undef_method :active_scheme=
    
    # The array of scheme identifiers, starting with the active scheme and
    # moving up through its parents. This value may be <code>null</code> if
    # there is no active scheme.
    attr_accessor :active_scheme_ids
    alias_method :attr_active_scheme_ids, :active_scheme_ids
    undef_method :active_scheme_ids
    alias_method :attr_active_scheme_ids=, :active_scheme_ids=
    undef_method :active_scheme_ids=
    
    # The number of bindings in the <code>bindings</code> array.
    attr_accessor :binding_count
    alias_method :attr_binding_count, :binding_count
    undef_method :binding_count
    alias_method :attr_binding_count=, :binding_count=
    undef_method :binding_count=
    
    # A cache of context IDs that weren't defined.
    attr_accessor :binding_errors
    alias_method :attr_binding_errors, :binding_errors
    undef_method :binding_errors
    alias_method :attr_binding_errors=, :binding_errors=
    undef_method :binding_errors=
    
    # The array of all bindings currently handled by this manager. This array
    # is the raw list of bindings, as provided to this manager. This value may
    # be <code>null</code> if there are no bindings. The size of this array
    # is not necessarily the number of bindings.
    attr_accessor :bindings
    alias_method :attr_bindings, :bindings
    undef_method :bindings
    alias_method :attr_bindings=, :bindings=
    undef_method :bindings=
    
    # A cache of the bindings previously computed by this manager. This value
    # may be empty, but it is never <code>null</code>. This is a map of
    # <code>CachedBindingSet</code> to <code>CachedBindingSet</code>.
    attr_accessor :cached_bindings
    alias_method :attr_cached_bindings, :cached_bindings
    undef_method :cached_bindings
    alias_method :attr_cached_bindings=, :cached_bindings=
    undef_method :cached_bindings=
    
    # The command manager for this binding manager. This manager is only needed
    # for the <code>getActiveBindingsFor(String)</code> method. This value is
    # guaranteed to never be <code>null</code>.
    attr_accessor :command_manager
    alias_method :attr_command_manager, :command_manager
    undef_method :command_manager
    alias_method :attr_command_manager=, :command_manager=
    undef_method :command_manager=
    
    # The context manager for this binding manager. For a binding manager to
    # function, it needs to listen for changes to the contexts. This value is
    # guaranteed to never be <code>null</code>.
    attr_accessor :context_manager
    alias_method :attr_context_manager, :context_manager
    undef_method :context_manager
    alias_method :attr_context_manager=, :context_manager=
    undef_method :context_manager=
    
    # The locale for this manager. This defaults to the current locale. The
    # value will never be <code>null</code>.
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    # The array of locales, starting with the active locale and moving up
    # through less specific representations of the locale. For example,
    # ["en_US", "en", "", null]. This value will never be <code>null</code>.
    attr_accessor :locales
    alias_method :attr_locales, :locales
    undef_method :locales
    alias_method :attr_locales=, :locales=
    undef_method :locales=
    
    # The platform for this manager. This defaults to the current platform. The
    # value will never be <code>null</code>.
    attr_accessor :platform
    alias_method :attr_platform, :platform
    undef_method :platform
    alias_method :attr_platform=, :platform=
    undef_method :platform=
    
    # The array of platforms, starting with the active platform and moving up
    # through less specific representations of the platform. For example,
    # ["gtk", "", null]. This value will never be <code>null,/code>.
    attr_accessor :platforms
    alias_method :attr_platforms, :platforms
    undef_method :platforms
    alias_method :attr_platforms=, :platforms=
    undef_method :platforms=
    
    # A map of prefixes (<code>TriggerSequence</code>) to a map of
    # available completions (possibly <code>null</code>, which means there
    # is an exact match). The available completions is a map of trigger (<code>TriggerSequence</code>)
    # to bindings (<code>Binding</code>). This value may be
    # <code>null</code> if there is no existing solution.
    attr_accessor :prefix_table
    alias_method :attr_prefix_table, :prefix_table
    undef_method :prefix_table
    alias_method :attr_prefix_table=, :prefix_table=
    undef_method :prefix_table=
    
    typesig { [ContextManager, CommandManager] }
    # <p>
    # Constructs a new instance of <code>BindingManager</code>.
    # </p>
    # <p>
    # This method completes in amortized constant time (O(1)).
    # </p>
    # 
    # @param contextManager
    # The context manager that will support this binding manager.
    # This value must not be <code>null</code>.
    # @param commandManager
    # The command manager that will support this binding manager.
    # This value must not be <code>null</code>.
    def initialize(context_manager, command_manager)
      @current_conflicts = nil
      @active_bindings = nil
      @active_bindings_by_parameterized_command = nil
      @trigger_conflicts = nil
      @active_scheme = nil
      @active_scheme_ids = nil
      @binding_count = 0
      @binding_errors = nil
      @bindings = nil
      @cached_bindings = nil
      @command_manager = nil
      @context_manager = nil
      @locale = nil
      @locales = nil
      @platform = nil
      @platforms = nil
      @prefix_table = nil
      super()
      @current_conflicts = nil
      @active_bindings = nil
      @active_bindings_by_parameterized_command = nil
      @trigger_conflicts = HashSet.new
      @active_scheme = nil
      @active_scheme_ids = nil
      @binding_count = 0
      @binding_errors = HashSet.new
      @bindings = nil
      @cached_bindings = HashMap.new
      @locale = Locale.get_default.to_s
      @locales = expand(@locale, LOCALE_SEPARATOR)
      @platform = Util.get_ws
      @platforms = expand(@platform, Util::ZERO_LENGTH_STRING)
      @prefix_table = nil
      if ((context_manager).nil?)
        raise NullPointerException.new("A binding manager requires a context manager") # $NON-NLS-1$
      end
      if ((command_manager).nil?)
        raise NullPointerException.new("A binding manager requires a command manager") # $NON-NLS-1$
      end
      @context_manager = context_manager
      context_manager.add_context_manager_listener(self)
      @command_manager = command_manager
    end
    
    typesig { [Binding] }
    # <p>
    # Adds a single new binding to the existing array of bindings. If the array
    # is currently <code>null</code>, then a new array is created and this
    # binding is added to it. This method does not detect duplicates.
    # </p>
    # <p>
    # This method completes in amortized <code>O(1)</code>.
    # </p>
    # 
    # @param binding
    # The binding to be added; must not be <code>null</code>.
    def add_binding(binding)
      if ((binding).nil?)
        raise NullPointerException.new("Cannot add a null binding") # $NON-NLS-1$
      end
      if ((@bindings).nil?)
        @bindings = Array.typed(Binding).new(1) { nil }
      else
        if (@binding_count >= @bindings.attr_length)
          old_bindings = @bindings
          @bindings = Array.typed(Binding).new(old_bindings.attr_length * 2) { nil }
          System.arraycopy(old_bindings, 0, @bindings, 0, old_bindings.attr_length)
        end
      end
      @bindings[((@binding_count += 1) - 1)] = binding
      clear_cache
    end
    
    typesig { [IBindingManagerListener] }
    # <p>
    # Adds a listener to this binding manager. The listener will be notified
    # when the set of defined schemes or bindings changes. This can be used to
    # track the global appearance and disappearance of bindings.
    # </p>
    # <p>
    # This method completes in amortized constant time (<code>O(1)</code>).
    # </p>
    # 
    # @param listener
    # The listener to attach; must not be <code>null</code>.
    def add_binding_manager_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [Map] }
    # <p>
    # Builds a prefix table look-up for a map of active bindings.
    # </p>
    # <p>
    # This method takes <code>O(mn)</code>, where <code>m</code> is the
    # length of the trigger sequences and <code>n</code> is the number of
    # bindings.
    # </p>
    # 
    # @param activeBindings
    # The map of triggers (<code>TriggerSequence</code>) to
    # command ids (<code>String</code>) which are currently
    # active. This value may be <code>null</code> if there are no
    # active bindings, and it may be empty. It must not be
    # <code>null</code>.
    # @return A map of prefixes (<code>TriggerSequence</code>) to a map of
    # available completions (possibly <code>null</code>, which means
    # there is an exact match). The available completions is a map of
    # trigger (<code>TriggerSequence</code>) to command identifier (<code>String</code>).
    # This value will never be <code>null</code>, but may be empty.
    def build_prefix_table(active_bindings)
      prefix_table = HashMap.new
      binding_itr = active_bindings.entry_set.iterator
      while (binding_itr.has_next)
        entry = binding_itr.next_
        trigger_sequence = entry.get_key
        # Add the perfect match.
        if (!prefix_table.contains_key(trigger_sequence))
          prefix_table.put(trigger_sequence, nil)
        end
        prefixes = trigger_sequence.get_prefixes
        prefixes_length = prefixes.attr_length
        if ((prefixes_length).equal?(0))
          next
        end
        # Break apart the trigger sequence.
        binding = entry.get_value
        i = 0
        while i < prefixes_length
          prefix = prefixes[i]
          value = prefix_table.get(prefix)
          if ((prefix_table.contains_key(prefix)) && (value.is_a?(Map)))
            (value).put(trigger_sequence, binding)
          else
            map = HashMap.new
            prefix_table.put(prefix, map)
            map.put(trigger_sequence, binding)
          end
          i += 1
        end
      end
      return prefix_table
    end
    
    typesig { [] }
    # <p>
    # Clears the cache, and the existing solution. If debugging is turned on,
    # then this will also print a message to standard out.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    def clear_cache
      if (self.attr_debug)
        Tracing.print_trace("BINDINGS", "Clearing cache") # $NON-NLS-1$ //$NON-NLS-2$
      end
      @cached_bindings.clear
      clear_solution
    end
    
    typesig { [] }
    # <p>
    # Clears the existing solution.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    def clear_solution
      set_active_bindings(nil, nil, nil, nil)
    end
    
    typesig { [String, String] }
    # Compares the identifier of two schemes, and decides which scheme is the
    # youngest (i.e., the child) of the two. Both schemes should be active
    # schemes.
    # 
    # @param schemeId1
    # The identifier of the first scheme; must not be
    # <code>null</code>.
    # @param schemeId2
    # The identifier of the second scheme; must not be
    # <code>null</code>.
    # @return <code>0</code> if the two schemes are equal of if neither
    # scheme is active; <code>1</code> if the second scheme is the
    # youngest; and <code>-1</code> if the first scheme is the
    # youngest.
    # @since 3.2
    def compare_schemes(scheme_id1, scheme_id2)
      if (!(scheme_id2 == scheme_id1))
        i = 0
        while i < @active_scheme_ids.attr_length
          scheme_pointer = @active_scheme_ids[i]
          if ((scheme_id2 == scheme_pointer))
            return 1
          else
            if ((scheme_id1 == scheme_pointer))
              return -1
            end
          end
          i += 1
        end
      end
      return 0
    end
    
    typesig { [Map, Map, Map, Map] }
    # <p>
    # Computes the bindings given the context tree, and inserts them into the
    # <code>commandIdsByTrigger</code>. It is assumed that
    # <code>locales</code>,<code>platforsm</code> and
    # <code>schemeIds</code> correctly reflect the state of the application.
    # This method does not deal with caching.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @param activeContextTree
    # The map representing the tree of active contexts. The map is
    # one of child to parent, each being a context id (
    # <code>String</code>). The keys are never <code>null</code>,
    # but the values may be (i.e., no parent). This map may be
    # empty. It may be <code>null</code> if we shouldn't consider
    # contexts.
    # @param bindingsByTrigger
    # The empty of map that is intended to be filled with triggers (
    # <code>TriggerSequence</code>) to bindings (
    # <code>Binding</code>). This value must not be
    # <code>null</code> and must be empty.
    # @param triggersByCommandId
    # The empty of map that is intended to be filled with command
    # identifiers (<code>String</code>) to triggers (
    # <code>TriggerSequence</code>). This value must either be
    # <code>null</code> (indicating that these values are not
    # needed), or empty (indicating that this map should be
    # computed).
    def compute_bindings(active_context_tree, bindings_by_trigger, triggers_by_command_id, conflicts_by_trigger)
      # FIRST PASS: Remove all of the bindings that are marking deletions.
      trimmed_bindings = remove_deletions(@bindings)
      # SECOND PASS: Just throw in bindings that match the current state. If
      # there is more than one match for a binding, then create a list.
      possible_bindings = HashMap.new
      length_ = trimmed_bindings.attr_length
      i = 0
      while i < length_
        binding = trimmed_bindings[i]
        found = false
        # Check the context.
        context_id = binding.get_context_id
        if ((!(active_context_tree).nil?) && (!active_context_tree.contains_key(context_id)))
          i += 1
          next
        end
        # Check the locale.
        if (!locale_matches(binding))
          i += 1
          next
        end
        # Check the platform.
        if (!platform_matches(binding))
          i += 1
          next
        end
        # Check the scheme ids.
        scheme_id = binding.get_scheme_id
        found = false
        if (!(@active_scheme_ids).nil?)
          j = 0
          while j < @active_scheme_ids.attr_length
            if (Util.==(scheme_id, @active_scheme_ids[j]))
              found = true
              break
            end
            j += 1
          end
        end
        if (!found)
          i += 1
          next
        end
        # Insert the match into the list of possible matches.
        trigger = binding.get_trigger_sequence
        existing_match = possible_bindings.get(trigger)
        if (existing_match.is_a?(Binding))
          possible_bindings.remove(trigger)
          matches = ArrayList.new
          matches.add(existing_match)
          matches.add(binding)
          possible_bindings.put(trigger, matches)
        else
          if (existing_match.is_a?(Collection))
            matches = existing_match
            matches.add(binding)
          else
            possible_bindings.put(trigger, binding)
          end
        end
        i += 1
      end
      # $NON-NLS-1$
      # $NON-NLS-1$
      conflicts = MultiStatus.new("org.eclipse.jface", 0, "Keybinding conflicts occurred.  They may interfere with normal accelerator operation.", nil)
      # THIRD PASS: In this pass, we move any non-conflicting bindings
      # directly into the map. In the case of conflicts, we apply some
      # further logic to try to resolve them. If the conflict can't be
      # resolved, then we log the problem.
      possible_binding_itr = possible_bindings.entry_set.iterator
      while (possible_binding_itr.has_next)
        entry = possible_binding_itr.next_
        trigger = entry.get_key
        match = entry.get_value
        # What we do depends slightly on whether we are trying to build a
        # list of all possible bindings (disregarding context), or a flat
        # map given the currently active contexts.
        if ((active_context_tree).nil?)
          # We are building the list of all possible bindings.
          bindings = ArrayList.new
          if (match.is_a?(Binding))
            bindings.add(match)
            bindings_by_trigger.put(trigger, bindings)
            add_reverse_lookup(triggers_by_command_id, (match).get_parameterized_command, trigger)
          else
            if (match.is_a?(Collection))
              bindings.add_all(match)
              bindings_by_trigger.put(trigger, bindings)
              match_itr = bindings.iterator
              while (match_itr.has_next)
                add_reverse_lookup(triggers_by_command_id, (match_itr.next_).get_parameterized_command, trigger)
              end
            end
          end
        else
          # We are building the flat map of trigger to commands.
          if (match.is_a?(Binding))
            binding = match
            bindings_by_trigger.put(trigger, binding)
            add_reverse_lookup(triggers_by_command_id, binding.get_parameterized_command, trigger)
          else
            if (match.is_a?(Collection))
              winner = resolve_conflicts(match, active_context_tree)
              if ((winner).nil?)
                # warn once ... so as not to flood the logs
                conflicts_by_trigger.put(trigger, match)
                if (@trigger_conflicts.add(trigger))
                  sw = StringWriter.new
                  buffer = BufferedWriter.new(sw)
                  begin
                    buffer.write("A conflict occurred for ") # $NON-NLS-1$
                    buffer.write(trigger.to_s)
                    buffer.write(Character.new(?:.ord))
                    i_ = (match).iterator
                    while (i_.has_next)
                      buffer.new_line
                      buffer.write(i_.next_.to_s)
                    end
                    buffer.flush
                  rescue IOException => e
                    # we should not get this
                  end
                  # $NON-NLS-1$
                  conflicts.add(Status.new(IStatus::WARNING, "org.eclipse.jface", sw.to_s))
                end
                if (self.attr_debug)
                  # $NON-NLS-1$
                  Tracing.print_trace("BINDINGS", "A conflict occurred for " + RJava.cast_to_string(trigger)) # $NON-NLS-1$
                  Tracing.print_trace("BINDINGS", "    " + RJava.cast_to_string(match)) # $NON-NLS-1$ //$NON-NLS-2$
                end
              else
                bindings_by_trigger.put(trigger, winner)
                add_reverse_lookup(triggers_by_command_id, winner.get_parameterized_command, trigger)
              end
            end
          end
        end
      end
      if (!(conflicts.get_severity).equal?(IStatus::OK))
        Policy.get_log.log(conflicts)
      end
    end
    
    typesig { [ContextManagerEvent] }
    # <p>
    # Notifies this manager that the context manager has changed. This method
    # is intended for internal use only.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    def context_manager_changed(context_manager_event)
      if (context_manager_event.is_active_contexts_changed)
        # clearSolution();
        recompute_bindings
      end
    end
    
    typesig { [Array.typed(Trigger)] }
    # Returns the number of strokes in an array of triggers. It is assumed that
    # there is one natural key per trigger. The strokes are counted based on
    # the type of key. Natural keys are worth one; ctrl is worth two; shift is
    # worth four; and alt is worth eight.
    # 
    # @param triggers
    # The triggers on which to count strokes; must not be
    # <code>null</code>.
    # @return The value of the strokes in the triggers.
    # @since 3.2
    def count_strokes(triggers)
      stroke_count = triggers.attr_length
      i = 0
      while i < triggers.attr_length
        trigger = triggers[i]
        if (trigger.is_a?(KeyStroke))
          key_stroke = trigger
          modifier_keys = key_stroke.get_modifier_keys
          lookup = KeyLookupFactory.get_default
          if (!((modifier_keys & lookup.get_alt)).equal?(0))
            stroke_count += 8
          end
          if (!((modifier_keys & lookup.get_ctrl)).equal?(0))
            stroke_count += 2
          end
          if (!((modifier_keys & lookup.get_shift)).equal?(0))
            stroke_count += 4
          end
          if (!((modifier_keys & lookup.get_command)).equal?(0))
            stroke_count += 2
          end
        else
          stroke_count += 99
        end
        i += 1
      end
      return stroke_count
    end
    
    typesig { [JavaSet] }
    # <p>
    # Creates a tree of context identifiers, representing the hierarchical
    # structure of the given contexts. The tree is structured as a mapping from
    # child to parent.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the height of the context tree.
    # </p>
    # 
    # @param contextIds
    # The set of context identifiers to be converted into a tree;
    # must not be <code>null</code>.
    # @return The tree of contexts to use; may be empty, but never
    # <code>null</code>. The keys and values are both strings.
    def create_context_tree_for(context_ids)
      context_tree = HashMap.new
      context_id_itr = context_ids.iterator
      while (context_id_itr.has_next)
        child_context_id = context_id_itr.next_
        while (!(child_context_id).nil?)
          # Check if we've already got the part of the tree from here up.
          if (context_tree.contains_key(child_context_id))
            break
          end
          # Retrieve the context.
          child_context = @context_manager.get_context(child_context_id)
          # Add the child-parent pair to the tree.
          begin
            parent_context_id = child_context.get_parent_id
            context_tree.put(child_context_id, parent_context_id)
            child_context_id = parent_context_id
          rescue NotDefinedException => e
            break # stop ascending
          end
        end
      end
      return context_tree
    end
    
    typesig { [JavaSet] }
    # <p>
    # Creates a tree of context identifiers, representing the hierarchical
    # structure of the given contexts. The tree is structured as a mapping from
    # child to parent. In this tree, the key binding specific filtering of
    # contexts will have taken place.
    # </p>
    # <p>
    # This method completes in <code>O(n^2)</code>, where <code>n</code>
    # is the height of the context tree.
    # </p>
    # 
    # @param contextIds
    # The set of context identifiers to be converted into a tree;
    # must not be <code>null</code>.
    # @return The tree of contexts to use; may be empty, but never
    # <code>null</code>. The keys and values are both strings.
    def create_filtered_context_tree_for(context_ids)
      # Check to see whether a dialog or window is active.
      dialog = false
      window = false
      context_id_itr = context_ids.iterator
      while (context_id_itr.has_next)
        context_id = context_id_itr.next_
        if ((IContextIds::CONTEXT_ID_DIALOG == context_id))
          dialog = true
          next
        end
        if ((IContextIds::CONTEXT_ID_WINDOW == context_id))
          window = true
          next
        end
      end
      # Remove all context identifiers for contexts whose parents are dialog
      # or window, and the corresponding dialog or window context is not
      # active.
      context_id_itr = context_ids.iterator
      while (context_id_itr.has_next)
        context_id = context_id_itr.next_
        context = @context_manager.get_context(context_id)
        begin
          parent_id = context.get_parent_id
          while (!(parent_id).nil?)
            if ((IContextIds::CONTEXT_ID_DIALOG == parent_id))
              if (!dialog)
                context_id_itr.remove
              end
              break
            end
            if ((IContextIds::CONTEXT_ID_WINDOW == parent_id))
              if (!window)
                context_id_itr.remove
              end
              break
            end
            if ((IContextIds::CONTEXT_ID_DIALOG_AND_WINDOW == parent_id))
              if ((!window) && (!dialog))
                context_id_itr.remove
              end
              break
            end
            context = @context_manager.get_context(parent_id)
            parent_id = RJava.cast_to_string(context.get_parent_id)
          end
        rescue NotDefinedException => e
          # since this context was part of an undefined hierarchy,
          # I'm going to yank it out as a bad bet
          context_id_itr.remove
          # This is a logging optimization, only log the error once.
          if ((context).nil? || !@binding_errors.contains(context.get_id))
            if (!(context).nil?)
              @binding_errors.add(context.get_id)
            end
            # now log like you've never logged before!
            # $NON-NLS-1$
            Policy.get_log.log(Status.new(IStatus::ERROR, Policy::JFACE, IStatus::OK, "Undefined context while filtering dialog/window contexts", e))
          end
        end
      end
      return create_context_tree_for(context_ids)
    end
    
    typesig { [BindingManagerEvent] }
    # <p>
    # Notifies all of the listeners to this manager that the defined or active
    # schemes of bindings have changed.
    # </p>
    # <p>
    # The time this method takes to complete is dependent on external
    # listeners.
    # </p>
    # 
    # @param event
    # The event to send to all of the listeners; must not be
    # <code>null</code>.
    def fire_binding_manager_changed(event)
      if ((event).nil?)
        raise NullPointerException.new
      end
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.binding_manager_changed(event)
        i += 1
      end
    end
    
    typesig { [] }
    # <p>
    # Returns the active bindings. The caller must not modify the returned map.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the active bindings are
    # not yet computed, then this completes in <code>O(nn)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @return The map of triggers (<code>TriggerSequence</code>) to
    # bindings (<code>Binding</code>) which are currently active.
    # This value may be <code>null</code> if there are no active
    # bindings, and it may be empty.
    def get_active_bindings
      if ((@active_bindings).nil?)
        recompute_bindings
      end
      return @active_bindings
    end
    
    typesig { [] }
    # <p>
    # Returns the active bindings indexed by command identifier. The caller
    # must not modify the returned map.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the active bindings are
    # not yet computed, then this completes in <code>O(nn)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @return The map of fully-parameterized commands (<code>ParameterizedCommand</code>)
    # to triggers (<code>TriggerSequence</code>) which are
    # currently active. This value may be <code>null</code> if there
    # are no active bindings, and it may be empty.
    def get_active_bindings_by_parameterized_command
      if ((@active_bindings_by_parameterized_command).nil?)
        recompute_bindings
      end
      return @active_bindings_by_parameterized_command
    end
    
    typesig { [] }
    # <p>
    # Computes the bindings for the current state of the application, but
    # disregarding the current contexts. This can be useful when trying to
    # display all the possible bindings.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @return A map of trigger (<code>TriggerSequence</code>) to bindings (
    # <code>Collection</code> containing <code>Binding</code>).
    # This map may be empty, but it is never <code>null</code>.
    def get_active_bindings_disregarding_context
      if ((@bindings).nil?)
        # Not yet initialized. This is happening too early. Do nothing.
        return Collections::EMPTY_MAP
      end
      # Build a cached binding set for that state.
      binding_cache = CachedBindingSet.new(nil, @locales, @platforms, @active_scheme_ids)
      # Check if the cached binding set already exists. If so, simply set the
      # active bindings and return.
      existing_cache = @cached_bindings.get(binding_cache)
      if ((existing_cache).nil?)
        existing_cache = binding_cache
        @cached_bindings.put(existing_cache, existing_cache)
      end
      command_ids_by_trigger = existing_cache.get_bindings_by_trigger
      if (!(command_ids_by_trigger).nil?)
        if (self.attr_debug)
          Tracing.print_trace("BINDINGS", "Cache hit") # $NON-NLS-1$ //$NON-NLS-2$
        end
        return Collections.unmodifiable_map(command_ids_by_trigger)
      end
      # There is no cached entry for this.
      if (self.attr_debug)
        Tracing.print_trace("BINDINGS", "Cache miss") # $NON-NLS-1$ //$NON-NLS-2$
      end
      # Compute the active bindings.
      command_ids_by_trigger = HashMap.new
      triggers_by_parameterized_command = HashMap.new
      conflicts_by_trigger = HashMap.new
      compute_bindings(nil, command_ids_by_trigger, triggers_by_parameterized_command, conflicts_by_trigger)
      existing_cache.set_bindings_by_trigger(command_ids_by_trigger)
      existing_cache.set_triggers_by_command_id(triggers_by_parameterized_command)
      existing_cache.set_conflicts_by_trigger(conflicts_by_trigger)
      return Collections.unmodifiable_map(command_ids_by_trigger)
    end
    
    typesig { [] }
    # <p>
    # Computes the bindings for the current state of the application, but
    # disregarding the current contexts. This can be useful when trying to
    # display all the possible bindings.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @return A map of trigger (<code>TriggerSequence</code>) to bindings (
    # <code>Collection</code> containing <code>Binding</code>).
    # This map may be empty, but it is never <code>null</code>.
    # @since 3.2
    def get_active_bindings_disregarding_context_by_parameterized_command
      if ((@bindings).nil?)
        # Not yet initialized. This is happening too early. Do nothing.
        return Collections::EMPTY_MAP
      end
      # Build a cached binding set for that state.
      binding_cache = CachedBindingSet.new(nil, @locales, @platforms, @active_scheme_ids)
      # Check if the cached binding set already exists. If so, simply set the
      # active bindings and return.
      existing_cache = @cached_bindings.get(binding_cache)
      if ((existing_cache).nil?)
        existing_cache = binding_cache
        @cached_bindings.put(existing_cache, existing_cache)
      end
      triggers_by_parameterized_command = existing_cache.get_triggers_by_command_id
      if (!(triggers_by_parameterized_command).nil?)
        if (self.attr_debug)
          Tracing.print_trace("BINDINGS", "Cache hit") # $NON-NLS-1$ //$NON-NLS-2$
        end
        return Collections.unmodifiable_map(triggers_by_parameterized_command)
      end
      # There is no cached entry for this.
      if (self.attr_debug)
        Tracing.print_trace("BINDINGS", "Cache miss") # $NON-NLS-1$ //$NON-NLS-2$
      end
      # Compute the active bindings.
      command_ids_by_trigger = HashMap.new
      conflicts_by_trigger = HashMap.new
      triggers_by_parameterized_command = HashMap.new
      compute_bindings(nil, command_ids_by_trigger, triggers_by_parameterized_command, conflicts_by_trigger)
      existing_cache.set_bindings_by_trigger(command_ids_by_trigger)
      existing_cache.set_triggers_by_command_id(triggers_by_parameterized_command)
      existing_cache.set_conflicts_by_trigger(conflicts_by_trigger)
      return Collections.unmodifiable_map(triggers_by_parameterized_command)
    end
    
    typesig { [] }
    # <p>
    # Computes the bindings for the current state of the application, but
    # disregarding the current contexts. This can be useful when trying to
    # display all the possible bindings.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @return All of the active bindings (<code>Binding</code>), not sorted
    # in any fashion. This collection may be empty, but it is never
    # <code>null</code>.
    def get_active_bindings_disregarding_context_flat
      binding_collections = get_active_bindings_disregarding_context.values
      merged_bindings = ArrayList.new
      binding_collection_itr = binding_collections.iterator
      while (binding_collection_itr.has_next)
        binding_collection = binding_collection_itr.next_
        if ((!(binding_collection).nil?) && (!binding_collection.is_empty))
          merged_bindings.add_all(binding_collection)
        end
      end
      return merged_bindings
    end
    
    typesig { [ParameterizedCommand] }
    # <p>
    # Returns the active bindings for a particular command identifier, but
    # discounting the current contexts. This method operates in O(n) time over
    # the number of bindings.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the active bindings are
    # not yet computed, then this completes in <code>O(nn)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @param parameterizedCommand
    # The fully-parameterized command whose bindings are requested.
    # This argument may be <code>null</code>.
    # @return The array of active triggers (<code>TriggerSequence</code>)
    # for a particular command identifier. This value is guaranteed to
    # never be <code>null</code>, but it may be empty.
    # @since 3.2
    def get_active_bindings_disregarding_context_for(parameterized_command)
      object = get_active_bindings_disregarding_context_by_parameterized_command.get(parameterized_command)
      if (object.is_a?(Collection))
        collection = object
        return collection.to_array(Array.typed(TriggerSequence).new(collection.size) { nil })
      end
      return EMPTY_TRIGGER_SEQUENCE
    end
    
    typesig { [ParameterizedCommand] }
    # <p>
    # Returns the active bindings for a particular command identifier. This
    # method operates in O(n) time over the number of bindings.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the active bindings are
    # not yet computed, then this completes in <code>O(nn)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @param parameterizedCommand
    # The fully-parameterized command whose bindings are requested.
    # This argument may be <code>null</code>.
    # @return The array of active triggers (<code>TriggerSequence</code>)
    # for a particular command identifier. This value is guaranteed to
    # never be <code>null</code>, but it may be empty.
    def get_active_bindings_for(parameterized_command)
      object = get_active_bindings_by_parameterized_command.get(parameterized_command)
      if (object.is_a?(Collection))
        collection = object
        return collection.to_array(Array.typed(TriggerSequence).new(collection.size) { nil })
      end
      return EMPTY_TRIGGER_SEQUENCE
    end
    
    typesig { [String] }
    # <p>
    # Returns the active bindings for a particular command identifier. This
    # method operates in O(n) time over the number of bindings.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the active bindings are
    # not yet computed, then this completes in <code>O(nn)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @param commandId
    # The identifier of the command whose bindings are requested.
    # This argument may be <code>null</code>. It is assumed that
    # the command has no parameters.
    # @return The array of active triggers (<code>TriggerSequence</code>)
    # for a particular command identifier. This value is guaranteed not
    # to be <code>null</code>, but it may be empty.
    def get_active_bindings_for(command_id)
      parameterized_command = ParameterizedCommand.new(@command_manager.get_command(command_id), nil)
      return get_active_bindings_for(parameterized_command)
    end
    
    typesig { [ParameterizedCommand] }
    # A variation on {@link BindingManager#getActiveBindingsFor(String)} that
    # returns an array of bindings, rather than trigger sequences. This method
    # is needed for doing "best" calculations on the active bindings.
    # 
    # @param commandId
    # The identifier of the command for which the active bindings
    # should be retrieved; must not be <code>null</code>.
    # @return The active bindings for the given command; this value may be
    # <code>null</code> if there are no active bindings.
    # @since 3.2
    def get_active_bindings_for1(command)
      triggers = get_active_bindings_for(command)
      if ((triggers.attr_length).equal?(0))
        return nil
      end
      active_bindings = get_active_bindings
      if (!(active_bindings).nil?)
        bindings = Array.typed(Binding).new(triggers.attr_length) { nil }
        i = 0
        while i < triggers.attr_length
          trigger_sequence = triggers[i]
          object = active_bindings.get(trigger_sequence)
          binding = object
          bindings[i] = binding
          i += 1
        end
        return bindings
      end
      return nil
    end
    
    typesig { [] }
    # <p>
    # Gets the currently active scheme.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    # 
    # @return The active scheme; may be <code>null</code> if there is no
    # active scheme. If a scheme is returned, it is guaranteed to be
    # defined.
    def get_active_scheme
      return @active_scheme
    end
    
    typesig { [String] }
    # Gets the best active binding for a command. The best binding is the one
    # that would be most appropriate to show in a menu. Bindings which belong
    # to a child scheme are given preference over those in a parent scheme.
    # Bindings which belong to a particular locale or platform are given
    # preference over those that do not. The rest of the calculaton is based
    # most on various concepts of "length", as well as giving some modifier
    # keys preference (e.g., <code>Alt</code> is less likely to appear than
    # <code>Ctrl</code>).
    # 
    # @param commandId
    # The identifier of the command for which the best active
    # binding should be retrieved; must not be <code>null</code>.
    # @return The trigger sequence for the best binding; may be
    # <code>null</code> if no bindings are active for the given
    # command.
    # @since 3.2
    def get_best_active_binding_for(command_id)
      return get_best_active_binding_for(ParameterizedCommand.new(@command_manager.get_command(command_id), nil))
    end
    
    typesig { [ParameterizedCommand] }
    # @param command
    # @return
    # a trigger sequence, or <code>null</code>
    # @since 3.4
    def get_best_active_binding_for(command)
      bindings = get_active_bindings_for1(command)
      if (((bindings).nil?) || ((bindings.attr_length).equal?(0)))
        return nil
      end
      best_binding = bindings[0]
      compare_to = 0
      i = 1
      while i < bindings.attr_length
        current_binding = bindings[i]
        # Bindings in a child scheme are always given preference.
        best_scheme_id = best_binding.get_scheme_id
        current_scheme_id = current_binding.get_scheme_id
        compare_to = compare_schemes(best_scheme_id, current_scheme_id)
        if (compare_to > 0)
          best_binding = current_binding
        end
        if (!(compare_to).equal?(0))
          i += 1
          next
        end
        # Bindings with a locale are given preference over those that do
        # not.
        best_locale = best_binding.get_locale
        current_locale = current_binding.get_locale
        if (((best_locale).nil?) && (!(current_locale).nil?))
          best_binding = current_binding
        end
        if (!(Util.==(best_locale, current_locale)))
          i += 1
          next
        end
        # Bindings with a platform are given preference over those that do
        # not.
        best_platform = best_binding.get_platform
        current_platform = current_binding.get_platform
        if (((best_platform).nil?) && (!(current_platform).nil?))
          best_binding = current_binding
        end
        if (!(Util.==(best_platform, current_platform)))
          i += 1
          next
        end
        # Check to see which has the least number of triggers in the
        # trigger sequence.
        best_trigger_sequence = best_binding.get_trigger_sequence
        current_trigger_sequence = current_binding.get_trigger_sequence
        best_triggers = best_trigger_sequence.get_triggers
        current_triggers = current_trigger_sequence.get_triggers
        compare_to = best_triggers.attr_length - current_triggers.attr_length
        if (compare_to > 0)
          best_binding = current_binding
        end
        if (!(compare_to).equal?(0))
          i += 1
          next
        end
        # Compare the number of keys pressed in each trigger sequence. Some
        # types of keys count less than others (i.e., some types of
        # modifiers keys are less likely to be chosen).
        compare_to = count_strokes(best_triggers) - count_strokes(current_triggers)
        if (compare_to > 0)
          best_binding = current_binding
        end
        if (!(compare_to).equal?(0))
          i += 1
          next
        end
        # If this is still a tie, then just chose the shortest text.
        compare_to = best_trigger_sequence.format.length - current_trigger_sequence.format.length
        if (compare_to > 0)
          best_binding = current_binding
        end
        i += 1
      end
      return best_binding.get_trigger_sequence
    end
    
    typesig { [String] }
    # Gets the formatted string representing the best active binding for a
    # command. The best binding is the one that would be most appropriate to
    # show in a menu. Bindings which belong to a child scheme are given
    # preference over those in a parent scheme. The rest of the calculaton is
    # based most on various concepts of "length", as well as giving some
    # modifier keys preference (e.g., <code>Alt</code> is less likely to
    # appear than <code>Ctrl</code>).
    # 
    # @param commandId
    # The identifier of the command for which the best active
    # binding should be retrieved; must not be <code>null</code>.
    # @return The formatted string for the best binding; may be
    # <code>null</code> if no bindings are active for the given
    # command.
    # @since 3.2
    def get_best_active_binding_formatted_for(command_id)
      binding = get_best_active_binding_for(command_id)
      if (!(binding).nil?)
        return binding.format
      end
      return nil
    end
    
    typesig { [] }
    # <p>
    # Returns the set of all bindings managed by this class.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    # 
    # @return The array of all bindings. This value may be <code>null</code>
    # and it may be empty.
    def get_bindings
      if ((@bindings).nil?)
        return nil
      end
      return_value = Array.typed(Binding).new(@binding_count) { nil }
      System.arraycopy(@bindings, 0, return_value, 0, @binding_count)
      return return_value
    end
    
    typesig { [] }
    # <p>
    # Returns the array of schemes that are defined.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    # 
    # @return The array of defined schemes; this value may be empty or
    # <code>null</code>.
    def get_defined_schemes
      return self.attr_defined_handle_objects.to_array(Array.typed(Scheme).new(self.attr_defined_handle_objects.size) { nil })
    end
    
    typesig { [] }
    # <p>
    # Returns the active locale for this binding manager. The locale is in the
    # same format as <code>Locale.getDefault().toString()</code>.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    # 
    # @return The active locale; never <code>null</code>.
    def get_locale
      return @locale
    end
    
    typesig { [TriggerSequence] }
    # <p>
    # Returns all of the possible bindings that start with the given trigger
    # (but are not equal to the given trigger).
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the bindings aren't
    # currently computed, then this completes in <code>O(n)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @param trigger
    # The prefix to look for; must not be <code>null</code>.
    # @return A map of triggers (<code>TriggerSequence</code>) to bindings (<code>Binding</code>).
    # This map may be empty, but it is never <code>null</code>.
    def get_partial_matches(trigger)
      partial_matches = get_prefix_table.get(trigger)
      if ((partial_matches).nil?)
        return Collections::EMPTY_MAP
      end
      return partial_matches
    end
    
    typesig { [TriggerSequence] }
    # <p>
    # Returns the command identifier for the active binding matching this
    # trigger, if any.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the bindings aren't
    # currently computed, then this completes in <code>O(n)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @param trigger
    # The trigger to match; may be <code>null</code>.
    # @return The binding that matches, if any; <code>null</code> otherwise.
    def get_perfect_match(trigger)
      return get_active_bindings.get(trigger)
    end
    
    typesig { [] }
    # <p>
    # Returns the active platform for this binding manager. The platform is in
    # the same format as <code>SWT.getPlatform()</code>.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    # 
    # @return The active platform; never <code>null</code>.
    def get_platform
      return @platform
    end
    
    typesig { [] }
    # <p>
    # Returns the prefix table. The caller must not modify the returned map.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the active bindings are
    # not yet computed, then this completes in <code>O(n)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @return A map of prefixes (<code>TriggerSequence</code>) to a map of
    # available completions (possibly <code>null</code>, which means
    # there is an exact match). The available completions is a map of
    # trigger (<code>TriggerSequence</code>) to binding (<code>Binding</code>).
    # This value will never be <code>null</code> but may be empty.
    def get_prefix_table
      if ((@prefix_table).nil?)
        recompute_bindings
      end
      return @prefix_table
    end
    
    typesig { [String] }
    # <p>
    # Gets the scheme with the given identifier. If the scheme does not already
    # exist, then a new (undefined) scheme is created with that identifier.
    # This guarantees that schemes will remain unique.
    # </p>
    # <p>
    # This method completes in amortized <code>O(1)</code>.
    # </p>
    # 
    # @param schemeId
    # The identifier for the scheme to retrieve; must not be
    # <code>null</code>.
    # @return A scheme with the given identifier.
    def get_scheme(scheme_id)
      check_id(scheme_id)
      scheme = self.attr_handle_objects_by_id.get(scheme_id)
      if ((scheme).nil?)
        scheme = Scheme.new(scheme_id)
        self.attr_handle_objects_by_id.put(scheme_id, scheme)
        scheme.add_scheme_listener(self)
      end
      return scheme
    end
    
    typesig { [String] }
    # <p>
    # Ascends all of the parents of the scheme until no more parents are found.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the height of the context tree.
    # </p>
    # 
    # @param schemeId
    # The id of the scheme for which the parents should be found;
    # may be <code>null</code>.
    # @return The array of scheme ids (<code>String</code>) starting with
    # <code>schemeId</code> and then ascending through its ancestors.
    def get_scheme_ids(scheme_id)
      strings = ArrayList.new
      while (!(scheme_id).nil?)
        strings.add(scheme_id)
        begin
          scheme_id = RJava.cast_to_string(get_scheme(scheme_id).get_parent_id)
        rescue NotDefinedException => e
          # $NON-NLS-1$
          Policy.get_log.log(Status.new(IStatus::ERROR, Policy::JFACE, IStatus::OK, "Failed ascending scheme parents", e))
          return Array.typed(String).new(0) { nil }
        end
      end
      return strings.to_array(Array.typed(String).new(strings.size) { nil })
    end
    
    typesig { [TriggerSequence] }
    # <p>
    # Returns whether the given trigger sequence is a partial match for the
    # given sequence.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the bindings aren't
    # currently computed, then this completes in <code>O(n)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @param trigger
    # The sequence which should be the prefix for some binding;
    # should not be <code>null</code>.
    # @return <code>true</code> if the trigger can be found in the active
    # bindings; <code>false</code> otherwise.
    def is_partial_match(trigger)
      return (!(get_prefix_table.get(trigger)).nil?)
    end
    
    typesig { [TriggerSequence] }
    # <p>
    # Returns whether the given trigger sequence is a perfect match for the
    # given sequence.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>. If the bindings aren't
    # currently computed, then this completes in <code>O(n)</code>, where
    # <code>n</code> is the number of bindings.
    # </p>
    # 
    # @param trigger
    # The sequence which should match exactly; should not be
    # <code>null</code>.
    # @return <code>true</code> if the trigger can be found in the active
    # bindings; <code>false</code> otherwise.
    def is_perfect_match(trigger)
      return get_active_bindings.contains_key(trigger)
    end
    
    typesig { [Binding] }
    # <p>
    # Tests whether the locale for the binding matches one of the active
    # locales.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of active locales.
    # </p>
    # 
    # @param binding
    # The binding with which to test; must not be <code>null</code>.
    # @return <code>true</code> if the binding's locale matches;
    # <code>false</code> otherwise.
    def locale_matches(binding)
      matches = false
      locale = binding.get_locale
      if ((locale).nil?)
        return true # shortcut a common case
      end
      i = 0
      while i < @locales.attr_length
        if (Util.==(@locales[i], locale))
          matches = true
          break
        end
        i += 1
      end
      return matches
    end
    
    typesig { [Binding] }
    # <p>
    # Tests whether the platform for the binding matches one of the active
    # platforms.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of active platforms.
    # </p>
    # 
    # @param binding
    # The binding with which to test; must not be <code>null</code>.
    # @return <code>true</code> if the binding's platform matches;
    # <code>false</code> otherwise.
    def platform_matches(binding)
      matches = false
      platform = binding.get_platform
      if ((platform).nil?)
        return true # shortcut a common case
      end
      i = 0
      while i < @platforms.attr_length
        if (Util.==(@platforms[i], platform))
          matches = true
          break
        end
        i += 1
      end
      return matches
    end
    
    typesig { [] }
    # <p>
    # This recomputes the bindings based on changes to the state of the world.
    # This computation can be triggered by changes to contexts, the active
    # scheme, the locale, or the platform. This method tries to use the cache
    # of pre-computed bindings, if possible. When this method completes,
    # <code>activeBindings</code> will be set to the current set of bindings
    # and <code>cachedBindings</code> will contain an instance of
    # <code>CachedBindingSet</code> representing these bindings.
    # </p>
    # <p>
    # This method completes in <code>O(n+pn)</code>, where <code>n</code>
    # is the number of bindings, and <code>p</code> is the average number of
    # triggers in a trigger sequence.
    # </p>
    def recompute_bindings
      if ((@bindings).nil?)
        # Not yet initialized. This is happening too early. Do nothing.
        set_active_bindings(Collections::EMPTY_MAP, Collections::EMPTY_MAP, Collections::EMPTY_MAP, Collections::EMPTY_MAP)
        return
      end
      # Figure out the current state.
      active_context_ids = HashSet.new(@context_manager.get_active_context_ids)
      active_context_tree = create_filtered_context_tree_for(active_context_ids)
      # Build a cached binding set for that state.
      binding_cache = CachedBindingSet.new(active_context_tree, @locales, @platforms, @active_scheme_ids)
      # Check if the cached binding set already exists. If so, simply set the
      # active bindings and return.
      existing_cache = @cached_bindings.get(binding_cache)
      if ((existing_cache).nil?)
        existing_cache = binding_cache
        @cached_bindings.put(existing_cache, existing_cache)
      end
      command_ids_by_trigger = existing_cache.get_bindings_by_trigger
      if (!(command_ids_by_trigger).nil?)
        if (self.attr_debug)
          Tracing.print_trace("BINDINGS", "Cache hit") # $NON-NLS-1$ //$NON-NLS-2$
        end
        set_active_bindings(command_ids_by_trigger, existing_cache.get_triggers_by_command_id, existing_cache.get_prefix_table, existing_cache.get_conflicts_by_trigger)
        return
      end
      # There is no cached entry for this.
      if (self.attr_debug)
        Tracing.print_trace("BINDINGS", "Cache miss") # $NON-NLS-1$ //$NON-NLS-2$
      end
      # Compute the active bindings.
      command_ids_by_trigger = HashMap.new
      triggers_by_parameterized_command = HashMap.new
      conflicts_by_trigger = HashMap.new
      compute_bindings(active_context_tree, command_ids_by_trigger, triggers_by_parameterized_command, conflicts_by_trigger)
      existing_cache.set_bindings_by_trigger(command_ids_by_trigger)
      existing_cache.set_triggers_by_command_id(triggers_by_parameterized_command)
      existing_cache.set_conflicts_by_trigger(conflicts_by_trigger)
      set_active_bindings(command_ids_by_trigger, triggers_by_parameterized_command, build_prefix_table(command_ids_by_trigger), conflicts_by_trigger)
      existing_cache.set_prefix_table(@prefix_table)
    end
    
    typesig { [Binding] }
    # <p>
    # Remove the specific binding by identity. Does nothing if the binding is
    # not in the manager.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @param binding
    # The binding to be removed; must not be <code>null</code>.
    # @since 3.2
    def remove_binding(binding)
      if ((@bindings).nil? || @bindings.attr_length < 1)
        return
      end
      new_bindings = Array.typed(Binding).new(@bindings.attr_length) { nil }
      bindings_changed = false
      index = 0
      i = 0
      while i < @binding_count
        b = @bindings[i]
        if ((b).equal?(binding))
          bindings_changed = true
        else
          new_bindings[((index += 1) - 1)] = b
        end
        i += 1
      end
      if (bindings_changed)
        @bindings = new_bindings
        @binding_count = index
        clear_cache
      end
    end
    
    typesig { [IBindingManagerListener] }
    # <p>
    # Removes a listener from this binding manager.
    # </p>
    # <p>
    # This method completes in amortized <code>O(1)</code>.
    # </p>
    # 
    # @param listener
    # The listener to be removed; must not be <code>null</code>.
    def remove_binding_manager_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [TriggerSequence, String, String, String, String, String, ::Java::Int] }
    # <p>
    # Removes any binding that matches the given values -- regardless of
    # command identifier.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @param sequence
    # The sequence to match; may be <code>null</code>.
    # @param schemeId
    # The scheme id to match; may be <code>null</code>.
    # @param contextId
    # The context id to match; may be <code>null</code>.
    # @param locale
    # The locale to match; may be <code>null</code>.
    # @param platform
    # The platform to match; may be <code>null</code>.
    # @param windowManager
    # The window manager to match; may be <code>null</code>. TODO
    # Currently ignored.
    # @param type
    # The type to look for.
    def remove_bindings(sequence, scheme_id, context_id, locale, platform, window_manager, type)
      if (((@bindings).nil?) || (@binding_count < 1))
        return
      end
      new_bindings = Array.typed(Binding).new(@bindings.attr_length) { nil }
      bindings_changed = false
      index = 0
      i = 0
      while i < @binding_count
        binding = @bindings[i]
        equals = true
        equals &= Util.==(sequence, binding.get_trigger_sequence)
        equals &= Util.==(scheme_id, binding.get_scheme_id)
        equals &= Util.==(context_id, binding.get_context_id)
        equals &= Util.==(locale, binding.get_locale)
        equals &= Util.==(platform, binding.get_platform)
        equals &= ((type).equal?(binding.get_type))
        if (equals)
          bindings_changed = true
        else
          new_bindings[((index += 1) - 1)] = binding
        end
        i += 1
      end
      if (bindings_changed)
        @bindings = new_bindings
        @binding_count = index
        clear_cache
      end
    end
    
    typesig { [Array.typed(Binding)] }
    # <p>
    # Attempts to remove deletion markers from the collection of bindings.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @param bindings
    # The bindings from which the deleted items should be removed.
    # This array should not be <code>null</code>, but may be
    # empty.
    # @return The array of bindings with the deletions removed; never
    # <code>null</code>, but may be empty. Contains only instances
    # of <code>Binding</code>.
    def remove_deletions(bindings)
      deletions = HashMap.new
      bindings_copy = Array.typed(Binding).new(@binding_count) { nil }
      System.arraycopy(bindings, 0, bindings_copy, 0, @binding_count)
      deleted_count = 0
      # Extract the deletions.
      i = 0
      while i < @binding_count
        binding = bindings_copy[i]
        if (((binding.get_parameterized_command).nil?) && (locale_matches(binding)) && (platform_matches(binding)))
          sequence = binding.get_trigger_sequence
          current_value = deletions.get(sequence)
          if (current_value.is_a?(Binding))
            collection = ArrayList.new(2)
            collection.add(current_value)
            collection.add(binding)
            deletions.put(sequence, collection)
          else
            if (current_value.is_a?(Collection))
              collection = current_value
              collection.add(binding)
            else
              deletions.put(sequence, binding)
            end
          end
          bindings_copy[i] = nil
          deleted_count += 1
        end
        i += 1
      end
      if (self.attr_debug)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("BINDINGS", "There are " + RJava.cast_to_string(deletions.size) + " deletion markers") # $NON-NLS-1$
      end
      # Remove the deleted items.
      i_ = 0
      while i_ < @binding_count
        binding = bindings_copy[i_]
        if (!(binding).nil?)
          deletion = deletions.get(binding.get_trigger_sequence)
          if (deletion.is_a?(Binding))
            if ((deletion).deletes(binding))
              bindings_copy[i_] = nil
              deleted_count += 1
            end
          else
            if (deletion.is_a?(Collection))
              collection = deletion
              iterator_ = collection.iterator
              while (iterator_.has_next)
                deletion_binding = iterator_.next_
                if (deletion_binding.is_a?(Binding))
                  if ((deletion_binding).deletes(binding))
                    bindings_copy[i_] = nil
                    deleted_count += 1
                    break
                  end
                end
              end
            end
          end
        end
        i_ += 1
      end
      # Compact the array.
      return_value = Array.typed(Binding).new(@binding_count - deleted_count) { nil }
      index = 0
      i__ = 0
      while i__ < @binding_count
        binding = bindings_copy[i__]
        if (!(binding).nil?)
          return_value[((index += 1) - 1)] = binding
        end
        i__ += 1
      end
      return return_value
    end
    
    typesig { [Collection, Map] }
    # <p>
    # Attempts to resolve the conflicts for the given bindings.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @param bindings
    # The bindings which all match the same trigger sequence; must
    # not be <code>null</code>, and should contain at least two
    # items. This collection should only contain instances of
    # <code>Binding</code> (i.e., no <code>null</code> values).
    # @param activeContextTree
    # The tree of contexts to be used for all of the comparison. All
    # of the keys should be active context identifiers (i.e., never
    # <code>null</code>). The values will be their parents (i.e.,
    # possibly <code>null</code>). Both keys and values are
    # context identifiers (<code>String</code>). This map should
    # never be empty, and must never be <code>null</code>.
    # @return The binding which best matches the current state. If there is a
    # tie, then return <code>null</code>.
    def resolve_conflicts(bindings, active_context_tree)
      # This flag is used to indicate when the bestMatch binding conflicts
      # with another binding. We keep the best match binding so that we know
      # if we find a better binding. However, if we don't find a better
      # binding, then we known to return null.
      conflict = false
      binding_itr = bindings.iterator
      best_match = binding_itr.next_
      # Iterate over each binding and compare it with the best match. If a
      # better match is found, then replace the best match and set the
      # conflict flag to false. If a conflict is found, then leave the best
      # match and set the conflict flag. Otherwise, just continue.
      while (binding_itr.has_next)
        current = binding_itr.next_
        # SCHEME: Test whether the current is in a child scheme. Bindings
        # defined in a child scheme will always take priority over bindings
        # defined in a parent scheme.
        current_scheme_id = current.get_scheme_id
        best_scheme_id = best_match.get_scheme_id
        compare_to = compare_schemes(best_scheme_id, current_scheme_id)
        if (compare_to > 0)
          best_match = current
          conflict = false
        end
        if (!(compare_to).equal?(0))
          next
        end
        # CONTEXTS: Check for context superiority. Bindings defined in a
        # child context will take priority over bindings defined in a
        # parent context -- assuming that the schemes lead to a conflict.
        current_context = current.get_context_id
        best_context = best_match.get_context_id
        if (!(current_context == best_context))
          go_to_next_binding = false
          # Ascend the current's context tree.
          context_pointer = current_context
          while (!(context_pointer).nil?)
            if ((context_pointer == best_context))
              # the current wins
              best_match = current
              conflict = false
              go_to_next_binding = true
              break
            end
            context_pointer = RJava.cast_to_string(active_context_tree.get(context_pointer))
          end
          # Ascend the best match's context tree.
          context_pointer = best_context
          while (!(context_pointer).nil?)
            if ((context_pointer == current_context))
              # the best wins
              go_to_next_binding = true
              break
            end
            context_pointer = RJava.cast_to_string(active_context_tree.get(context_pointer))
          end
          if (go_to_next_binding)
            next
          end
        end
        # TYPE: Test for type superiority.
        if (current.get_type > best_match.get_type)
          best_match = current
          conflict = false
          next
        else
          if (best_match.get_type > current.get_type)
            next
          end
        end
        # We could not resolve the conflict between these two.
        conflict = true
      end
      # If the best match represents a conflict, then return null.
      if (conflict)
        return nil
      end
      # Otherwise, we have a winner....
      return best_match
    end
    
    typesig { [SchemeEvent] }
    # <p>
    # Notifies this manager that a scheme has changed. This method is intended
    # for internal use only.
    # </p>
    # <p>
    # This method calls out to listeners, and so the time it takes to complete
    # is dependent on third-party code.
    # </p>
    # 
    # @param schemeEvent
    # An event describing the change in the scheme.
    def scheme_changed(scheme_event)
      if (scheme_event.is_defined_changed)
        scheme = scheme_event.get_scheme
        scheme_id_added = scheme.is_defined
        active_scheme_changed = false
        if (scheme_id_added)
          self.attr_defined_handle_objects.add(scheme)
        else
          self.attr_defined_handle_objects.remove(scheme)
          if ((@active_scheme).equal?(scheme))
            @active_scheme = nil
            @active_scheme_ids = nil
            active_scheme_changed = true
            # Clear the binding solution.
            clear_solution
          end
        end
        if (is_listener_attached)
          fire_binding_manager_changed(BindingManagerEvent.new(self, false, nil, active_scheme_changed, scheme, scheme_id_added, false, false))
        end
      end
    end
    
    typesig { [Map, Map, Map, Map] }
    # Sets the active bindings and the prefix table. This ensures that the two
    # values change at the same time, and that any listeners are notified
    # appropriately.
    # 
    # @param activeBindings
    # This is a map of triggers ( <code>TriggerSequence</code>)
    # to bindings (<code>Binding</code>). This value will only
    # be <code>null</code> if the active bindings have not yet
    # been computed. Otherwise, this value may be empty.
    # @param activeBindingsByCommandId
    # This is a map of fully-parameterized commands (<code>ParameterizedCommand</code>)
    # to triggers ( <code>TriggerSequence</code>). This value
    # will only be <code>null</code> if the active bindings have
    # not yet been computed. Otherwise, this value may be empty.
    # @param prefixTable
    # A map of prefixes (<code>TriggerSequence</code>) to a map
    # of available completions (possibly <code>null</code>, which
    # means there is an exact match). The available completions is a
    # map of trigger (<code>TriggerSequence</code>) to binding (<code>Binding</code>).
    # This value may be <code>null</code> if there is no existing
    # solution.
    def set_active_bindings(active_bindings, active_bindings_by_command_id, prefix_table, conflicts)
      @active_bindings = active_bindings
      previous_bindings_by_parameterized_command = @active_bindings_by_parameterized_command
      @active_bindings_by_parameterized_command = active_bindings_by_command_id
      @prefix_table = prefix_table
      @current_conflicts = conflicts
      fire_binding_manager_changed(BindingManagerEvent.new(self, true, previous_bindings_by_parameterized_command, false, nil, false, false, false))
    end
    
    typesig { [] }
    # Provides the current conflicts in the bindings as a Map The key will
    # be {@link TriggerSequence} and the value will be the {@link Collection} of
    # {@link Binding}
    # 
    # @return Read-only {@link Map} of the current conflicts. If no conflicts,
    # then return an empty map. Never <code>null</code>
    # @since 3.5
    def get_current_conflicts
      if ((@current_conflicts).nil?)
        return Collections::EMPTY_MAP
      end
      return Collections.unmodifiable_map(@current_conflicts)
    end
    
    typesig { [TriggerSequence] }
    # Provides the current conflicts in the keybindings for the given
    # TriggerSequence as a {@link Collection} of {@link Binding}
    # 
    # @param sequence The sequence for which conflict info is required
    # 
    # @return Collection of KeyBinding. If no conflicts,
    # then returns a <code>null</code>
    # @since 3.5
    def get_conflicts_for(sequence)
      return get_current_conflicts.get(sequence)
    end
    
    typesig { [Scheme] }
    # <p>
    # Selects one of the schemes as the active scheme. This scheme must be
    # defined.
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the height of the context tree.
    # </p>
    # 
    # @param scheme
    # The scheme to become active; must not be <code>null</code>.
    # @throws NotDefinedException
    # If the given scheme is currently undefined.
    def set_active_scheme(scheme)
      if ((scheme).nil?)
        raise NullPointerException.new("Cannot activate a null scheme") # $NON-NLS-1$
      end
      if (((scheme).nil?) || (!scheme.is_defined))
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot activate an undefined scheme. " + RJava.cast_to_string(scheme.get_id))
      end
      if (Util.==(@active_scheme, scheme))
        return
      end
      @active_scheme = scheme
      @active_scheme_ids = get_scheme_ids(@active_scheme.get_id)
      clear_solution
      fire_binding_manager_changed(BindingManagerEvent.new(self, false, nil, true, nil, false, false, false))
    end
    
    typesig { [Array.typed(Binding)] }
    # <p>
    # Changes the set of bindings for this binding manager. Changing the set of
    # bindings all at once ensures that: (1) duplicates are removed; and (2)
    # avoids unnecessary intermediate computations. This method clears the
    # existing bindings, but does not trigger a recomputation (other method
    # calls are required to do that).
    # </p>
    # <p>
    # This method completes in <code>O(n)</code>, where <code>n</code> is
    # the number of bindings.
    # </p>
    # 
    # @param bindings
    # The new array of bindings; may be <code>null</code>. This
    # set is copied into a local data structure.
    def set_bindings(bindings)
      if (Arrays.==(@bindings, bindings))
        return # nothing has changed
      end
      if (((bindings).nil?) || ((bindings.attr_length).equal?(0)))
        @bindings = nil
        @binding_count = 0
      else
        bindings_length = bindings.attr_length
        @bindings = Array.typed(Binding).new(bindings_length) { nil }
        System.arraycopy(bindings, 0, @bindings, 0, bindings_length)
        @binding_count = bindings_length
      end
      clear_cache
    end
    
    typesig { [String] }
    # <p>
    # Changes the locale for this binding manager. The locale can be used to
    # provide locale-specific bindings. If the locale is different than the
    # current locale, this will force a recomputation of the bindings. The
    # locale is in the same format as
    # <code>Locale.getDefault().toString()</code>.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    # 
    # @param locale
    # The new locale; must not be <code>null</code>.
    # @see Locale#getDefault()
    def set_locale(locale)
      if ((locale).nil?)
        raise NullPointerException.new("The locale cannot be null") # $NON-NLS-1$
      end
      if (!Util.==(@locale, locale))
        @locale = locale
        @locales = expand(locale, LOCALE_SEPARATOR)
        clear_solution
        fire_binding_manager_changed(BindingManagerEvent.new(self, false, nil, false, nil, false, true, false))
      end
    end
    
    typesig { [String] }
    # <p>
    # Changes the platform for this binding manager. The platform can be used
    # to provide platform-specific bindings. If the platform is different than
    # the current platform, then this will force a recomputation of the
    # bindings. The locale is in the same format as
    # <code>SWT.getPlatform()</code>.
    # </p>
    # <p>
    # This method completes in <code>O(1)</code>.
    # </p>
    # 
    # @param platform
    # The new platform; must not be <code>null</code>.
    # @see org.eclipse.swt.SWT#getPlatform()
    # @see Util#getWS()
    def set_platform(platform)
      if ((platform).nil?)
        raise NullPointerException.new("The platform cannot be null") # $NON-NLS-1$
      end
      if (!Util.==(@platform, platform))
        @platform = platform
        @platforms = expand(platform, Util::ZERO_LENGTH_STRING)
        clear_solution
        fire_binding_manager_changed(BindingManagerEvent.new(self, false, nil, false, nil, false, false, true))
      end
    end
    
    private
    alias_method :initialize__binding_manager, :initialize
  end
  
end
