require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module PluginVersionIdentifierImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Org::Eclipse::Core::Internal::Runtime, :CommonMessages
      include_const ::Org::Eclipse::Core::Internal::Runtime, :IRuntimeConstants
      include_const ::Org::Eclipse::Osgi::Util, :NLS
      include_const ::Org::Osgi::Framework, :Version
    }
  end
  
  # <p>
  # Version identifier for a plug-in. In its string representation,
  # it consists of up to 4 tokens separated by a decimal point.
  # The first 3 tokens are positive integer numbers, the last token
  # is an uninterpreted string (no whitespace characters allowed).
  # For example, the following are valid version identifiers
  # (as strings):
  # <ul>
  # <li><code>0.0.0</code></li>
  # <li><code>1.0.127564</code></li>
  # <li><code>3.7.2.build-127J</code></li>
  # <li><code>1.9</code> (interpreted as <code>1.9.0</code>)</li>
  # <li><code>3</code> (interpreted as <code>3.0.0</code>)</li>
  # </ul>
  # </p>
  # <p>
  # The version identifier can be decomposed into a major, minor,
  # service level component and qualifier components. A difference
  # in the major component is interpreted as an incompatible version
  # change. A difference in the minor (and not the major) component
  # is interpreted as a compatible version change. The service
  # level component is interpreted as a cumulative and compatible
  # service update of the minor version component. The qualifier is
  # not interpreted, other than in version comparisons. The
  # qualifiers are compared using lexicographical string comparison.
  # </p>
  # <p>
  # Version identifiers can be matched as perfectly equal, equivalent,
  # compatible or greaterOrEqual.
  # </p><p>
  # This class can be used without OSGi running.
  # </p><p>
  # Clients may instantiate; not intended to be subclassed by clients.
  # </p>
  # @see java.lang.String#compareTo(java.lang.String)
  # @deprecated clients should use {@link org.osgi.framework.Version} instead
  class PluginVersionIdentifier 
    include_class_members PluginVersionIdentifierImports
    
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    class_module.module_eval {
      const_set_lazy(:SEPARATOR) { "." }
      const_attr_reader  :SEPARATOR
    }
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # $NON-NLS-1$
    # 
    # Creates a plug-in version identifier from its components.
    # 
    # @param major major component of the version identifier
    # @param minor minor component of the version identifier
    # @param service service update component of the version identifier
    def initialize(major, minor, service)
      initialize__plugin_version_identifier(major, minor, service, nil)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, String] }
    # Creates a plug-in version identifier from its components.
    # 
    # @param major major component of the version identifier
    # @param minor minor component of the version identifier
    # @param service service update component of the version identifier
    # @param qualifier qualifier component of the version identifier.
    # Qualifier characters that are not a letter or a digit are replaced.
    def initialize(major, minor, service, qualifier)
      @version = nil
      # Do the test outside of the assert so that they 'Policy.bind'
      # will not be evaluated each time (including cases when we would
      # have passed by the assert).
      if (major < 0)
        Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_postive_major, RJava.cast_to_string(major) + SEPARATOR + RJava.cast_to_string(minor) + SEPARATOR + RJava.cast_to_string(service) + SEPARATOR + qualifier))
      end
      if (minor < 0)
        Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_postive_minor, RJava.cast_to_string(major) + SEPARATOR + RJava.cast_to_string(minor) + SEPARATOR + RJava.cast_to_string(service) + SEPARATOR + qualifier))
      end
      if (service < 0)
        Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_postive_service, RJava.cast_to_string(major) + SEPARATOR + RJava.cast_to_string(minor) + SEPARATOR + RJava.cast_to_string(service) + SEPARATOR + qualifier))
      end
      @version = Version.new(major, minor, service, qualifier)
    end
    
    typesig { [String] }
    # Creates a plug-in version identifier from the given string.
    # The string representation consists of up to 4 tokens
    # separated by decimal point.
    # For example, the following are valid version identifiers
    # (as strings):
    # <ul>
    # <li><code>0.0.0</code></li>
    # <li><code>1.0.127564</code></li>
    # <li><code>3.7.2.build-127J</code></li>
    # <li><code>1.9</code> (interpreted as <code>1.9.0</code>)</li>
    # <li><code>3</code> (interpreted as <code>3.0.0</code>)</li>
    # </ul>
    # </p>
    # 
    # @param versionId string representation of the version identifier.
    # Qualifier characters that are not a letter or a digit are replaced.
    def initialize(version_id)
      @version = nil
      parts = parse_version(version_id)
      @version = Version.new((parts[0]).int_value, (parts[1]).int_value, (parts[2]).int_value, parts[3])
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Validates the given string as a plug-in version identifier.
      # 
      # @param version the string to validate
      # @return a status object with code <code>IStatus.OK</code> if
      # the given string is valid as a plug-in version identifier, otherwise a status
      # object indicating what is wrong with the string
      # @since 2.0
      def validate_version(version)
        begin
          parse_version(version)
        rescue RuntimeException => e
          return Status.new(IStatus::ERROR, IRuntimeConstants::PI_RUNTIME, IStatus::ERROR, e.get_message, e)
        end
        return Status::OK_STATUS
      end
      
      typesig { [String] }
      def parse_version(version_id)
        # Do the test outside of the assert so that they 'Policy.bind'
        # will not be evaluated each time (including cases when we would
        # have passed by the assert).
        if ((version_id).nil?)
          Assert.is_not_null(nil, CommonMessages.attr_parse_empty_plugin_version)
        end
        s = version_id.trim
        if ((s == ""))
          # $NON-NLS-1$
          Assert.is_true(false, CommonMessages.attr_parse_empty_plugin_version)
        end
        if (s.starts_with(SEPARATOR))
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_separator_start_version, s))
        end
        if (s.ends_with(SEPARATOR))
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_separator_end_version, s))
        end
        if (!(s.index_of(SEPARATOR + SEPARATOR)).equal?(-1))
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_double_separator_version, s))
        end
        st = StringTokenizer.new(s, SEPARATOR)
        elements = Vector.new(4)
        while (st.has_more_tokens)
          elements.add_element(st.next_token)
        end
        element_size = elements.size
        if (element_size <= 0)
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_one_element_plugin_version, s))
        end
        if (element_size > 4)
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_four_element_plugin_version, s))
        end
        numbers = Array.typed(::Java::Int).new(3) { 0 }
        begin
          numbers[0] = JavaInteger.parse_int(elements.element_at(0))
          if (numbers[0] < 0)
            Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_postive_major, s))
          end
        rescue NumberFormatException => nfe
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_numeric_major_component, s))
        end
        begin
          if (element_size >= 2)
            numbers[1] = JavaInteger.parse_int(elements.element_at(1))
            if (numbers[1] < 0)
              Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_postive_minor, s))
            end
          else
            numbers[1] = 0
          end
        rescue NumberFormatException => nfe
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_numeric_minor_component, s))
        end
        begin
          if (element_size >= 3)
            numbers[2] = JavaInteger.parse_int(elements.element_at(2))
            if (numbers[2] < 0)
              Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_postive_service, s))
            end
          else
            numbers[2] = 0
          end
        rescue NumberFormatException => nfe
          Assert.is_true(false, NLS.bind(CommonMessages.attr_parse_numeric_service_component, s))
        end
        # "result" is a 4-element array with the major, minor, service, and qualifier
        result = Array.typed(Object).new(4) { nil }
        result[0] = numbers[0]
        result[1] = numbers[1]
        result[2] = numbers[2]
        if (element_size >= 4)
          result[3] = elements.element_at(3)
        else
          result[3] = ""
        end # $NON-NLS-1$
        return result
      end
    }
    
    typesig { [Object] }
    # Compare version identifiers for equality. Identifiers are
    # equal if all of their components are equal.
    # 
    # @param object an object to compare
    # @return whether or not the two objects are equal
    def ==(object)
      if (!(object.is_a?(PluginVersionIdentifier)))
        return false
      end
      v = object
      return (@version == v.attr_version)
    end
    
    typesig { [] }
    # Returns a hash code value for the object.
    # 
    # @return an integer which is a hash code value for this object.
    def hash_code
      return @version.hash_code
    end
    
    typesig { [] }
    # Returns the major (incompatible) component of this
    # version identifier.
    # 
    # @return the major version
    def get_major_component
      return @version.get_major
    end
    
    typesig { [] }
    # Returns the minor (compatible) component of this
    # version identifier.
    # 
    # @return the minor version
    def get_minor_component
      return @version.get_minor
    end
    
    typesig { [] }
    # Returns the service level component of this
    # version identifier.
    # 
    # @return the service level
    def get_service_component
      return @version.get_micro
    end
    
    typesig { [] }
    # Returns the qualifier component of this
    # version identifier.
    # 
    # @return the qualifier
    def get_qualifier_component
      return @version.get_qualifier
    end
    
    typesig { [PluginVersionIdentifier] }
    # Compares two version identifiers to see if this one is
    # greater than or equal to the argument.
    # <p>
    # A version identifier is considered to be greater than or equal
    # if its major component is greater than the argument major
    # component, or the major components are equal and its minor component
    # is greater than the argument minor component, or the
    # major and minor components are equal and its service component is
    # greater than the argument service component, or the major, minor and
    # service components are equal and the qualifier component is
    # greater than the argument qualifier component (using lexicographic
    # string comparison), or all components are equal.
    # </p>
    # 
    # @param id the other version identifier
    # @return <code>true</code> is this version identifier
    # is compatible with the given version identifier, and
    # <code>false</code> otherwise
    # @since 2.0
    def is_greater_or_equal_to(id)
      if ((id).nil?)
        return false
      end
      if (get_major_component > id.get_major_component)
        return true
      end
      if (((get_major_component).equal?(id.get_major_component)) && (get_minor_component > id.get_minor_component))
        return true
      end
      if (((get_major_component).equal?(id.get_major_component)) && ((get_minor_component).equal?(id.get_minor_component)) && (get_service_component > id.get_service_component))
        return true
      end
      if (((get_major_component).equal?(id.get_major_component)) && ((get_minor_component).equal?(id.get_minor_component)) && ((get_service_component).equal?(id.get_service_component)) && ((get_qualifier_component <=> id.get_qualifier_component) >= 0))
        return true
      else
        return false
      end
    end
    
    typesig { [PluginVersionIdentifier] }
    # Compares two version identifiers for compatibility.
    # <p>
    # A version identifier is considered to be compatible if its major
    # component equals to the argument major component, and its minor component
    # is greater than or equal to the argument minor component.
    # If the minor components are equal, than the service level of the
    # version identifier must be greater than or equal to the service level
    # of the argument identifier. If the service levels are equal, the two
    # version identifiers are considered to be equivalent if this qualifier is
    # greater or equal to the qualifier of the argument (using lexicographic
    # string comparison).
    # </p>
    # 
    # @param id the other version identifier
    # @return <code>true</code> is this version identifier
    # is compatible with the given version identifier, and
    # <code>false</code> otherwise
    def is_compatible_with(id)
      if ((id).nil?)
        return false
      end
      if (!(get_major_component).equal?(id.get_major_component))
        return false
      end
      if (get_minor_component > id.get_minor_component)
        return true
      end
      if (get_minor_component < id.get_minor_component)
        return false
      end
      if (get_service_component > id.get_service_component)
        return true
      end
      if (get_service_component < id.get_service_component)
        return false
      end
      if ((get_qualifier_component <=> id.get_qualifier_component) >= 0)
        return true
      else
        return false
      end
    end
    
    typesig { [PluginVersionIdentifier] }
    # Compares two version identifiers for equivalency.
    # <p>
    # Two version identifiers are considered to be equivalent if their major
    # and minor component equal and are at least at the same service level
    # as the argument. If the service levels are equal, the two version
    # identifiers are considered to be equivalent if this qualifier is
    # greater or equal to the qualifier of the argument (using lexicographic
    # string comparison).
    # 
    # </p>
    # 
    # @param id the other version identifier
    # @return <code>true</code> is this version identifier
    # is equivalent to the given version identifier, and
    # <code>false</code> otherwise
    def is_equivalent_to(id)
      if ((id).nil?)
        return false
      end
      if (!(get_major_component).equal?(id.get_major_component))
        return false
      end
      if (!(get_minor_component).equal?(id.get_minor_component))
        return false
      end
      if (get_service_component > id.get_service_component)
        return true
      end
      if (get_service_component < id.get_service_component)
        return false
      end
      if ((get_qualifier_component <=> id.get_qualifier_component) >= 0)
        return true
      else
        return false
      end
    end
    
    typesig { [PluginVersionIdentifier] }
    # Compares two version identifiers for perfect equality.
    # <p>
    # Two version identifiers are considered to be perfectly equal if their
    # major, minor, service and qualifier components are equal
    # </p>
    # 
    # @param id the other version identifier
    # @return <code>true</code> is this version identifier
    # is perfectly equal to the given version identifier, and
    # <code>false</code> otherwise
    # @since 2.0
    def is_perfect(id)
      if ((id).nil?)
        return false
      end
      if ((!(get_major_component).equal?(id.get_major_component)) || (!(get_minor_component).equal?(id.get_minor_component)) || (!(get_service_component).equal?(id.get_service_component)) || (!(get_qualifier_component == id.get_qualifier_component)))
        return false
      else
        return true
      end
    end
    
    typesig { [PluginVersionIdentifier] }
    # Compares two version identifiers for order using multi-decimal
    # comparison.
    # 
    # @param id the other version identifier
    # @return <code>true</code> is this version identifier
    # is greater than the given version identifier, and
    # <code>false</code> otherwise
    def is_greater_than(id)
      if ((id).nil?)
        if ((get_major_component).equal?(0) && (get_minor_component).equal?(0) && (get_service_component).equal?(0) && (get_qualifier_component == ""))
          # $NON-NLS-1$
          return false
        else
          return true
        end
      end
      if (get_major_component > id.get_major_component)
        return true
      end
      if (get_major_component < id.get_major_component)
        return false
      end
      if (get_minor_component > id.get_minor_component)
        return true
      end
      if (get_minor_component < id.get_minor_component)
        return false
      end
      if (get_service_component > id.get_service_component)
        return true
      end
      if (get_service_component < id.get_service_component)
        return false
      end
      if ((get_qualifier_component <=> id.get_qualifier_component) > 0)
        return true
      else
        return false
      end
    end
    
    typesig { [] }
    # Returns the string representation of this version identifier.
    # The result satisfies
    # <code>vi.equals(new PluginVersionIdentifier(vi.toString()))</code>.
    # 
    # @return the string representation of this plug-in version identifier
    def to_s
      return @version.to_s
    end
    
    private
    alias_method :initialize__plugin_version_identifier, :initialize
  end
  
end
