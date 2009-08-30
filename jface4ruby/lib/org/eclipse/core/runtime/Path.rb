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
  module PathImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Util, :Arrays
    }
  end
  
  # The standard implementation of the <code>IPath</code> interface.
  # Paths are always maintained in canonicalized form.  That is, parent
  # references (i.e., <code>../../</code>) and duplicate separators are
  # resolved.  For example,
  # <pre>     new Path("/a/b").append("../foo/bar")</pre>
  # will yield the path
  # <pre>     /a/foo/bar</pre>
  # <p>
  # This class can be used without OSGi running.
  # </p><p>
  # This class is not intended to be subclassed by clients but
  # may be instantiated.
  # </p>
  # @see IPath
  # @noextend This class is not intended to be subclassed by clients.
  class Path 
    include_class_members PathImports
    include IPath
    include Cloneable
    
    class_module.module_eval {
      # masks for separator values
      const_set_lazy(:HAS_LEADING) { 1 }
      const_attr_reader  :HAS_LEADING
      
      const_set_lazy(:IS_UNC) { 2 }
      const_attr_reader  :IS_UNC
      
      const_set_lazy(:HAS_TRAILING) { 4 }
      const_attr_reader  :HAS_TRAILING
      
      const_set_lazy(:ALL_SEPARATORS) { HAS_LEADING | IS_UNC | HAS_TRAILING }
      const_attr_reader  :ALL_SEPARATORS
      
      # Constant empty string value.
      const_set_lazy(:EMPTY_STRING) { "" }
      const_attr_reader  :EMPTY_STRING
      
      # $NON-NLS-1$
      # Constant value indicating no segments
      const_set_lazy(:NO_SEGMENTS) { Array.typed(String).new(0) { nil } }
      const_attr_reader  :NO_SEGMENTS
      
      # Constant value containing the empty path with no device.
      const_set_lazy(:EMPTY) { Path.new(EMPTY_STRING) }
      const_attr_reader  :EMPTY
      
      # Mask for all bits that are involved in the hash code
      const_set_lazy(:HASH_MASK) { ~HAS_TRAILING }
      const_attr_reader  :HASH_MASK
      
      # Constant root path string (<code>"/"</code>).
      const_set_lazy(:ROOT_STRING) { "/" }
      const_attr_reader  :ROOT_STRING
      
      # $NON-NLS-1$
      # Constant value containing the root path with no device.
      const_set_lazy(:ROOT) { Path.new(ROOT_STRING) }
      const_attr_reader  :ROOT
      
      # Constant value indicating if the current platform is Windows
      const_set_lazy(:WINDOWS) { (Java::Io::JavaFile.attr_separator_char).equal?(Character.new(?\\.ord)) }
      const_attr_reader  :WINDOWS
    }
    
    # The device id string. May be null if there is no device.
    attr_accessor :device
    alias_method :attr_device, :device
    undef_method :device
    alias_method :attr_device=, :device=
    undef_method :device=
    
    # Private implementation note: the segments and separators
    # arrays are never modified, so that they can be shared between
    # path instances
    # The path segments
    attr_accessor :segments
    alias_method :attr_segments, :segments
    undef_method :segments
    alias_method :attr_segments=, :segments=
    undef_method :segments=
    
    # flags indicating separators (has leading, is UNC, has trailing)
    attr_accessor :separators
    alias_method :attr_separators, :separators
    undef_method :separators
    alias_method :attr_separators=, :separators=
    undef_method :separators=
    
    class_module.module_eval {
      typesig { [String] }
      # Constructs a new path from the given string path.
      # The string path must represent a valid file system path
      # on the local file system.
      # The path is canonicalized and double slashes are removed
      # except at the beginning. (to handle UNC paths). All forward
      # slashes ('/') are treated as segment delimiters, and any
      # segment and device delimiters for the local file system are
      # also respected.
      # 
      # @param pathString the portable string path
      # @see IPath#toPortableString()
      # @since 3.1
      def from_osstring(path_string)
        return Path.new(path_string)
      end
      
      typesig { [String] }
      # Constructs a new path from the given path string.
      # The path string must have been produced by a previous
      # call to <code>IPath.toPortableString</code>.
      # 
      # @param pathString the portable path string
      # @see IPath#toPortableString()
      # @since 3.1
      def from_portable_string(path_string)
        first_match = path_string.index_of(DEVICE_SEPARATOR) + 1
        # no extra work required if no device characters
        if (first_match <= 0)
          return Path.new.initialize_(nil, path_string)
        end
        # if we find a single colon, then the path has a device
        device_part = nil
        path_length = path_string.length
        if ((first_match).equal?(path_length) || !(path_string.char_at(first_match)).equal?(DEVICE_SEPARATOR))
          device_part = RJava.cast_to_string(path_string.substring(0, first_match))
          path_string = RJava.cast_to_string(path_string.substring(first_match, path_length))
        end
        # optimize for no colon literals
        if ((path_string.index_of(DEVICE_SEPARATOR)).equal?(-1))
          return Path.new.initialize_(device_part, path_string)
        end
        # contract colon literals
        chars = path_string.to_char_array
        read_offset = 0
        write_offset = 0
        length_ = chars.attr_length
        while (read_offset < length_)
          if ((chars[read_offset]).equal?(DEVICE_SEPARATOR))
            if ((read_offset += 1) >= length_)
              break
            end
          end
          chars[((write_offset += 1) - 1)] = chars[((read_offset += 1) - 1)]
        end
        return Path.new.initialize_(device_part, String.new(chars, 0, write_offset))
      end
    }
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # Private constructor.
    def initialize
      @device = nil
      @segments = nil
      @separators = 0
      # not allowed
    end
    
    typesig { [String] }
    # Constructs a new path from the given string path.
    # The string path must represent a valid file system path
    # on the local file system.
    # The path is canonicalized and double slashes are removed
    # except at the beginning. (to handle UNC paths). All forward
    # slashes ('/') are treated as segment delimiters, and any
    # segment and device delimiters for the local file system are
    # also respected (such as colon (':') and backslash ('\') on some file systems).
    # 
    # @param fullPath the string path
    # @see #isValidPath(String)
    def initialize(full_path)
      @device = nil
      @segments = nil
      @separators = 0
      device_part = nil
      if (WINDOWS)
        # convert backslash to forward slash
        full_path = RJava.cast_to_string((full_path.index_of(Character.new(?\\.ord))).equal?(-1) ? full_path : full_path.replace(Character.new(?\\.ord), SEPARATOR))
        # extract device
        i = full_path.index_of(DEVICE_SEPARATOR)
        if (!(i).equal?(-1))
          # remove leading slash from device part to handle output of URL.getFile()
          start = (full_path.char_at(0)).equal?(SEPARATOR) ? 1 : 0
          device_part = RJava.cast_to_string(full_path.substring(start, i + 1))
          full_path = RJava.cast_to_string(full_path.substring(i + 1, full_path.length))
        end
      end
      initialize_(device_part, full_path)
    end
    
    typesig { [String, String] }
    # Constructs a new path from the given device id and string path.
    # The given string path must be valid.
    # The path is canonicalized and double slashes are removed except
    # at the beginning (to handle UNC paths). All forward
    # slashes ('/') are treated as segment delimiters, and any
    # segment delimiters for the local file system are
    # also respected (such as backslash ('\') on some file systems).
    # 
    # @param device the device id
    # @param path the string path
    # @see #isValidPath(String)
    # @see #setDevice(String)
    def initialize(device, path)
      @device = nil
      @segments = nil
      @separators = 0
      if (WINDOWS)
        # convert backslash to forward slash
        path = RJava.cast_to_string((path.index_of(Character.new(?\\.ord))).equal?(-1) ? path : path.replace(Character.new(?\\.ord), SEPARATOR))
      end
      initialize_(device, path)
    end
    
    typesig { [String, Array.typed(String), ::Java::Int] }
    # (Intentionally not included in javadoc)
    # Private constructor.
    def initialize(device, segments, _separators)
      @device = nil
      @segments = nil
      @separators = 0
      # no segment validations are done for performance reasons
      @segments = segments
      @device = device
      # hash code is cached in all but the bottom three bits of the separators field
      @separators = (compute_hash_code << 3) | (_separators & ALL_SEPARATORS)
    end
    
    typesig { [String] }
    # (Intentionally not included in javadoc)
    # @see IPath#addFileExtension
    def add_file_extension(extension)
      if (is_root || is_empty || has_trailing_separator)
        return self
      end
      len = @segments.attr_length
      new_segments = Array.typed(String).new(len) { nil }
      System.arraycopy(@segments, 0, new_segments, 0, len - 1)
      new_segments[len - 1] = RJava.cast_to_string(@segments[len - 1] + Character.new(?..ord)) + extension
      return Path.new(@device, new_segments, @separators)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#addTrailingSeparator
    def add_trailing_separator
      if (has_trailing_separator || is_root)
        return self
      end
      # XXX workaround, see 1GIGQ9V
      if (is_empty)
        return Path.new(@device, @segments, HAS_LEADING)
      end
      return Path.new(@device, @segments, @separators | HAS_TRAILING)
    end
    
    typesig { [IPath] }
    # (Intentionally not included in javadoc)
    # @see IPath#append(IPath)
    def append(tail)
      # optimize some easy cases
      if ((tail).nil? || (tail.segment_count).equal?(0))
        return self
      end
      # these call chains look expensive, but in most cases they are no-ops
      if (self.is_empty)
        return tail.set_device(@device).make_relative.make_unc(is_unc)
      end
      if (self.is_root)
        return tail.set_device(@device).make_absolute.make_unc(is_unc)
      end
      # concatenate the two segment arrays
      my_len = @segments.attr_length
      tail_len = tail.segment_count
      new_segments = Array.typed(String).new(my_len + tail_len) { nil }
      System.arraycopy(@segments, 0, new_segments, 0, my_len)
      i = 0
      while i < tail_len
        new_segments[my_len + i] = tail.segment(i)
        i += 1
      end
      # use my leading separators and the tail's trailing separator
      result = Path.new(@device, new_segments, (@separators & (HAS_LEADING | IS_UNC)) | (tail.has_trailing_separator ? HAS_TRAILING : 0))
      tail_first_segment = new_segments[my_len]
      if ((tail_first_segment == "..") || (tail_first_segment == "."))
        # $NON-NLS-1$ //$NON-NLS-2$
        result.canonicalize
      end
      return result
    end
    
    typesig { [String] }
    # (Intentionally not included in javadoc)
    # @see IPath#append(java.lang.String)
    def append(tail)
      # optimize addition of a single segment
      if ((tail.index_of(SEPARATOR)).equal?(-1) && (tail.index_of("\\")).equal?(-1) && (tail.index_of(DEVICE_SEPARATOR)).equal?(-1))
        # $NON-NLS-1$
        tail_length = tail.length
        if (tail_length < 3)
          # some special cases
          if ((tail_length).equal?(0) || ("." == tail))
            # $NON-NLS-1$
            return self
          end
          if ((".." == tail))
            # $NON-NLS-1$
            return remove_last_segments(1)
          end
        end
        # just add the segment
        my_len = @segments.attr_length
        new_segments = Array.typed(String).new(my_len + 1) { nil }
        System.arraycopy(@segments, 0, new_segments, 0, my_len)
        new_segments[my_len] = tail
        return Path.new(@device, new_segments, @separators & ~HAS_TRAILING)
      end
      # go with easy implementation
      return append(Path.new(tail))
    end
    
    typesig { [] }
    # Destructively converts this path to its canonical form.
    # <p>
    # In its canonical form, a path does not have any
    # "." segments, and parent references ("..") are collapsed
    # where possible.
    # </p>
    # @return true if the path was modified, and false otherwise.
    def canonicalize
      # look for segments that need canonicalizing
      i = 0
      max = @segments.attr_length
      while i < max
        segment_ = @segments[i]
        if ((segment_.char_at(0)).equal?(Character.new(?..ord)) && ((segment_ == "..") || (segment_ == ".")))
          # $NON-NLS-1$ //$NON-NLS-2$
          # path needs to be canonicalized
          collapse_parent_references
          # paths of length 0 have no trailing separator
          if ((@segments.attr_length).equal?(0))
            @separators &= (HAS_LEADING | IS_UNC)
          end
          # recompute hash because canonicalize affects hash
          @separators = (@separators & ALL_SEPARATORS) | (compute_hash_code << 3)
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # Clones this object.
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        return nil
      end
    end
    
    typesig { [] }
    # Destructively removes all occurrences of ".." segments from this path.
    def collapse_parent_references
      segment_count_ = @segments.attr_length
      stack = Array.typed(String).new(segment_count_) { nil }
      stack_pointer = 0
      i = 0
      while i < segment_count_
        segment_ = @segments[i]
        if ((segment_ == ".."))
          # $NON-NLS-1$
          if ((stack_pointer).equal?(0))
            # if the stack is empty we are going out of our scope
            # so we need to accumulate segments.  But only if the original
            # path is relative.  If it is absolute then we can't go any higher than
            # root so simply toss the .. references.
            if (!is_absolute)
              stack[((stack_pointer += 1) - 1)] = segment_
            end # stack push
          else
            # if the top is '..' then we are accumulating segments so don't pop
            if ((".." == stack[stack_pointer - 1]))
              # $NON-NLS-1$
              stack[((stack_pointer += 1) - 1)] = ".."
               # $NON-NLS-1$
            else
              stack_pointer -= 1
            end
            # stack pop
          end
          # collapse current references
        else
          if (!(segment_ == ".") || (segment_count_).equal?(1))
            # $NON-NLS-1$
            stack[((stack_pointer += 1) - 1)] = segment_
          end
        end # stack push
        i += 1
      end
      # if the number of segments hasn't changed, then no modification needed
      if ((stack_pointer).equal?(segment_count_))
        return
      end
      # build the new segment array backwards by popping the stack
      new_segments = Array.typed(String).new(stack_pointer) { nil }
      System.arraycopy(stack, 0, new_segments, 0, stack_pointer)
      @segments = new_segments
    end
    
    typesig { [String] }
    # Removes duplicate slashes from the given path, with the exception
    # of leading double slash which represents a UNC path.
    def collapse_slashes(path)
      length_ = path.length
      # if the path is only 0, 1 or 2 chars long then it could not possibly have illegal
      # duplicate slashes.
      if (length_ < 3)
        return path
      end
      # check for an occurrence of // in the path.  Start at index 1 to ensure we skip leading UNC //
      # If there are no // then there is nothing to collapse so just return.
      if ((path.index_of("//", 1)).equal?(-1))
        # $NON-NLS-1$
        return path
      end
      # We found an occurrence of // in the path so do the slow collapse.
      result = CharArray.new(path.length)
      count = 0
      has_previous = false
      characters = path.to_char_array
      index = 0
      while index < characters.attr_length
        c = characters[index]
        if ((c).equal?(SEPARATOR))
          if (has_previous)
            # skip double slashes, except for beginning of UNC.
            # note that a UNC path can't have a device.
            if ((@device).nil? && (index).equal?(1))
              result[count] = c
              count += 1
            end
          else
            has_previous = true
            result[count] = c
            count += 1
          end
        else
          has_previous = false
          result[count] = c
          count += 1
        end
        index += 1
      end
      return String.new(result, 0, count)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # Computes the hash code for this object.
    def compute_hash_code
      hash = (@device).nil? ? 17 : @device.hash_code
      segment_count_ = @segments.attr_length
      i = 0
      while i < segment_count_
        # this function tends to given a fairly even distribution
        hash = hash * 37 + @segments[i].hash_code
        i += 1
      end
      return hash
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # Returns the size of the string that will be created by toString or toOSString.
    def compute_length
      length_ = 0
      if (!(@device).nil?)
        length_ += @device.length
      end
      if (!((@separators & HAS_LEADING)).equal?(0))
        length_ += 1
      end
      if (!((@separators & IS_UNC)).equal?(0))
        length_ += 1
      end
      # add the segment lengths
      max = @segments.attr_length
      if (max > 0)
        i = 0
        while i < max
          length_ += @segments[i].length
          i += 1
        end
        # add the separator lengths
        length_ += max - 1
      end
      if (!((@separators & HAS_TRAILING)).equal?(0))
        length_ += 1
      end
      return length_
    end
    
    typesig { [String] }
    # (Intentionally not included in javadoc)
    # Returns the number of segments in the given path
    def compute_segment_count(path)
      len = path.length
      if ((len).equal?(0) || ((len).equal?(1) && (path.char_at(0)).equal?(SEPARATOR)))
        return 0
      end
      count = 1
      prev = -1
      i = 0
      while (!((i = path.index_of(SEPARATOR, prev + 1))).equal?(-1))
        if (!(i).equal?(prev + 1) && !(i).equal?(len))
          (count += 1)
        end
        prev = i
      end
      if ((path.char_at(len - 1)).equal?(SEPARATOR))
        (count -= 1)
      end
      return count
    end
    
    typesig { [String] }
    # Computes the segment array for the given canonicalized path.
    def compute_segments(path)
      # performance sensitive --- avoid creating garbage
      segment_count_ = compute_segment_count(path)
      if ((segment_count_).equal?(0))
        return NO_SEGMENTS
      end
      new_segments = Array.typed(String).new(segment_count_) { nil }
      len = path.length
      # check for initial slash
      first_position = ((path.char_at(0)).equal?(SEPARATOR)) ? 1 : 0
      # check for UNC
      if ((first_position).equal?(1) && len > 1 && ((path.char_at(1)).equal?(SEPARATOR)))
        first_position = 2
      end
      last_position = (!(path.char_at(len - 1)).equal?(SEPARATOR)) ? len - 1 : len - 2
      # for non-empty paths, the number of segments is
      # the number of slashes plus 1, ignoring any leading
      # and trailing slashes
      next_ = first_position
      i = 0
      while i < segment_count_
        start = next_
        end_ = path.index_of(SEPARATOR, next_)
        if ((end_).equal?(-1))
          new_segments[i] = path.substring(start, last_position + 1)
        else
          new_segments[i] = path.substring(start, end_)
        end
        next_ = end_ + 1
        i += 1
      end
      return new_segments
    end
    
    typesig { [String, StringBuffer] }
    # Returns the platform-neutral encoding of the given segment onto
    # the given string buffer. This escapes literal colon characters with double colons.
    def encode_segment(string, buf)
      len = string.length
      i = 0
      while i < len
        c = string.char_at(i)
        buf.append(c)
        if ((c).equal?(DEVICE_SEPARATOR))
          buf.append(DEVICE_SEPARATOR)
        end
        i += 1
      end
    end
    
    typesig { [Object] }
    # (Intentionally not included in javadoc)
    # Compares objects for equality.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(Path)))
        return false
      end
      target = obj
      # check leading separators and hash code
      if (!((@separators & HASH_MASK)).equal?((target.attr_separators & HASH_MASK)))
        return false
      end
      target_segments = target.attr_segments
      i = @segments.attr_length
      # check segment count
      if (!(i).equal?(target_segments.attr_length))
        return false
      end
      # check segments in reverse order - later segments more likely to differ
      while ((i -= 1) >= 0)
        if (!(@segments[i] == target_segments[i]))
          return false
        end
      end
      # check device last (least likely to differ)
      return (@device).equal?(target.attr_device) || (!(@device).nil? && (@device == target.attr_device))
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#getDevice
    def get_device
      return @device
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#getFileExtension
    def get_file_extension
      if (has_trailing_separator)
        return nil
      end
      last_segment_ = last_segment
      if ((last_segment_).nil?)
        return nil
      end
      index = last_segment_.last_index_of(Character.new(?..ord))
      if ((index).equal?(-1))
        return nil
      end
      return last_segment_.substring(index + 1)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # Computes the hash code for this object.
    def hash_code
      return @separators & HASH_MASK
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#hasTrailingSeparator2
    def has_trailing_separator
      return !((@separators & HAS_TRAILING)).equal?(0)
    end
    
    typesig { [String, String] }
    # Initialize the current path with the given string.
    def initialize_(device_string, path)
      Assert.is_not_null(path)
      @device = device_string
      path = RJava.cast_to_string(collapse_slashes(path))
      len = path.length
      # compute the separators array
      if (len < 2)
        if ((len).equal?(1) && (path.char_at(0)).equal?(SEPARATOR))
          @separators = HAS_LEADING
        else
          @separators = 0
        end
      else
        has_leading = (path.char_at(0)).equal?(SEPARATOR)
        is_unc_ = has_leading && (path.char_at(1)).equal?(SEPARATOR)
        # UNC path of length two has no trailing separator
        has_trailing = !(is_unc_ && (len).equal?(2)) && (path.char_at(len - 1)).equal?(SEPARATOR)
        @separators = has_leading ? HAS_LEADING : 0
        if (is_unc_)
          @separators |= IS_UNC
        end
        if (has_trailing)
          @separators |= HAS_TRAILING
        end
      end
      # compute segments and ensure canonical form
      @segments = compute_segments(path)
      if (!canonicalize)
        # compute hash now because canonicalize didn't need to do it
        @separators = (@separators & ALL_SEPARATORS) | (compute_hash_code << 3)
      end
      return self
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#isAbsolute
    def is_absolute
      # it's absolute if it has a leading separator
      return !((@separators & HAS_LEADING)).equal?(0)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#isEmpty
    def is_empty
      # true if no segments and no leading prefix
      return (@segments.attr_length).equal?(0) && (!((@separators & ALL_SEPARATORS)).equal?(HAS_LEADING))
    end
    
    typesig { [IPath] }
    # (Intentionally not included in javadoc)
    # @see IPath#isPrefixOf
    def is_prefix_of(another_path)
      if ((@device).nil?)
        if (!(another_path.get_device).nil?)
          return false
        end
      else
        if (!@device.equals_ignore_case(another_path.get_device))
          return false
        end
      end
      if (is_empty || (is_root && another_path.is_absolute))
        return true
      end
      len = @segments.attr_length
      if (len > another_path.segment_count)
        return false
      end
      i = 0
      while i < len
        if (!(@segments[i] == another_path.segment(i)))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#isRoot
    def is_root
      # must have no segments, a leading separator, and not be a UNC path.
      return (self).equal?(ROOT) || ((@segments.attr_length).equal?(0) && (((@separators & ALL_SEPARATORS)).equal?(HAS_LEADING)))
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#isUNC
    def is_unc
      if (!(@device).nil?)
        return false
      end
      return !((@separators & IS_UNC)).equal?(0)
    end
    
    typesig { [String] }
    # (Intentionally not included in javadoc)
    # @see IPath#isValidPath(String)
    def is_valid_path(path)
      test = Path.new(path)
      i = 0
      max = test.segment_count
      while i < max
        if (!is_valid_segment(test.segment(i)))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [String] }
    # (Intentionally not included in javadoc)
    # @see IPath#isValidSegment(String)
    def is_valid_segment(segment_)
      size = segment_.length
      if ((size).equal?(0))
        return false
      end
      i = 0
      while i < size
        c = segment_.char_at(i)
        if ((c).equal?(Character.new(?/.ord)))
          return false
        end
        if (WINDOWS && ((c).equal?(Character.new(?\\.ord)) || (c).equal?(Character.new(?:.ord))))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#lastSegment()
    def last_segment
      len = @segments.attr_length
      return (len).equal?(0) ? nil : @segments[len - 1]
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#makeAbsolute()
    def make_absolute
      if (is_absolute)
        return self
      end
      result = Path.new(@device, @segments, @separators | HAS_LEADING)
      # may need canonicalizing if it has leading ".." or "." segments
      if (result.segment_count > 0)
        first = result.segment(0)
        if ((first == "..") || (first == "."))
          # $NON-NLS-1$ //$NON-NLS-2$
          result.canonicalize
        end
      end
      return result
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#makeRelative()
    def make_relative
      if (!is_absolute)
        return self
      end
      return Path.new(@device, @segments, @separators & HAS_TRAILING)
    end
    
    typesig { [IPath] }
    # {@inheritDoc}
    # @since org.eclipse.equinox.common 3.5
    def make_relative_to(base)
      # can't make relative if devices are not equal
      if (!(@device).equal?(base.get_device) && ((@device).nil? || !@device.equals_ignore_case(base.get_device)))
        return self
      end
      common_length = matching_first_segments(base)
      difference_length = base.segment_count - common_length
      new_segment_length = difference_length + segment_count - common_length
      if ((new_segment_length).equal?(0))
        return Path::EMPTY
      end
      new_segments = Array.typed(String).new(new_segment_length) { nil }
      # add parent references for each segment different from the base
      Arrays.fill(new_segments, 0, difference_length, "..") # $NON-NLS-1$
      # append the segments of this path not in common with the base
      System.arraycopy(@segments, common_length, new_segments, difference_length, new_segment_length - difference_length)
      return Path.new(nil, new_segments, @separators & HAS_TRAILING)
    end
    
    typesig { [::Java::Boolean] }
    # (Intentionally not included in javadoc)
    # @see IPath#makeUNC(boolean)
    def make_unc(to_unc)
      # if we are already in the right form then just return
      if (!(to_unc ^ is_unc))
        return self
      end
      new_separators = @separators
      if (to_unc)
        new_separators |= HAS_LEADING | IS_UNC
      else
        # mask out the UNC bit
        new_separators &= HAS_LEADING | HAS_TRAILING
      end
      return Path.new(to_unc ? nil : @device, @segments, new_separators)
    end
    
    typesig { [IPath] }
    # (Intentionally not included in javadoc)
    # @see IPath#matchingFirstSegments(IPath)
    def matching_first_segments(another_path)
      Assert.is_not_null(another_path)
      another_path_len = another_path.segment_count
      max = Math.min(@segments.attr_length, another_path_len)
      count = 0
      i = 0
      while i < max
        if (!(@segments[i] == another_path.segment(i)))
          return count
        end
        count += 1
        i += 1
      end
      return count
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#removeFileExtension()
    def remove_file_extension
      extension = get_file_extension
      if ((extension).nil? || (extension == ""))
        # $NON-NLS-1$
        return self
      end
      last_segment_ = last_segment
      index = last_segment_.last_index_of(extension) - 1
      return remove_last_segments(1).append(last_segment_.substring(0, index))
    end
    
    typesig { [::Java::Int] }
    # (Intentionally not included in javadoc)
    # @see IPath#removeFirstSegments(int)
    def remove_first_segments(count)
      if ((count).equal?(0))
        return self
      end
      if (count >= @segments.attr_length)
        return Path.new(@device, NO_SEGMENTS, 0)
      end
      Assert.is_legal(count > 0)
      new_size = @segments.attr_length - count
      new_segments = Array.typed(String).new(new_size) { nil }
      System.arraycopy(@segments, count, new_segments, 0, new_size)
      # result is always a relative path
      return Path.new(@device, new_segments, @separators & HAS_TRAILING)
    end
    
    typesig { [::Java::Int] }
    # (Intentionally not included in javadoc)
    # @see IPath#removeLastSegments(int)
    def remove_last_segments(count)
      if ((count).equal?(0))
        return self
      end
      if (count >= @segments.attr_length)
        # result will have no trailing separator
        return Path.new(@device, NO_SEGMENTS, @separators & (HAS_LEADING | IS_UNC))
      end
      Assert.is_legal(count > 0)
      new_size = @segments.attr_length - count
      new_segments = Array.typed(String).new(new_size) { nil }
      System.arraycopy(@segments, 0, new_segments, 0, new_size)
      return Path.new(@device, new_segments, @separators)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#removeTrailingSeparator()
    def remove_trailing_separator
      if (!has_trailing_separator)
        return self
      end
      return Path.new(@device, @segments, @separators & (HAS_LEADING | IS_UNC))
    end
    
    typesig { [::Java::Int] }
    # (Intentionally not included in javadoc)
    # @see IPath#segment(int)
    def segment(index)
      if (index >= @segments.attr_length)
        return nil
      end
      return @segments[index]
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#segmentCount()
    def segment_count
      return @segments.attr_length
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#segments()
    def segments
      segment_copy = Array.typed(String).new(@segments.attr_length) { nil }
      System.arraycopy(@segments, 0, segment_copy, 0, @segments.attr_length)
      return segment_copy
    end
    
    typesig { [String] }
    # (Intentionally not included in javadoc)
    # @see IPath#setDevice(String)
    def set_device(value)
      if (!(value).nil?)
        Assert.is_true((value.index_of(IPath::DEVICE_SEPARATOR)).equal?((value.length - 1)), "Last character should be the device separator") # $NON-NLS-1$
      end
      # return the receiver if the device is the same
      if ((value).equal?(@device) || (!(value).nil? && (value == @device)))
        return self
      end
      return Path.new(value, @segments, @separators)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#toFile()
    def to_file
      return JavaFile.new(to_osstring)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#toOSString()
    def to_osstring
      # Note that this method is identical to toString except
      # it uses the OS file separator instead of the path separator
      result_size = compute_length
      if (result_size <= 0)
        return EMPTY_STRING
      end
      file_separator = JavaFile.attr_separator_char
      result = CharArray.new(result_size)
      offset = 0
      if (!(@device).nil?)
        size = @device.length
        @device.get_chars(0, size, result, offset)
        offset += size
      end
      if (!((@separators & HAS_LEADING)).equal?(0))
        result[((offset += 1) - 1)] = file_separator
      end
      if (!((@separators & IS_UNC)).equal?(0))
        result[((offset += 1) - 1)] = file_separator
      end
      len = @segments.attr_length - 1
      if (len >= 0)
        # append all but the last segment, with separators
        i = 0
        while i < len
          size = @segments[i].length
          @segments[i].get_chars(0, size, result, offset)
          offset += size
          result[((offset += 1) - 1)] = file_separator
          i += 1
        end
        # append the last segment
        size = @segments[len].length
        @segments[len].get_chars(0, size, result, offset)
        offset += size
      end
      if (!((@separators & HAS_TRAILING)).equal?(0))
        result[((offset += 1) - 1)] = file_separator
      end
      return String.new(result)
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#toPortableString()
    def to_portable_string
      result_size = compute_length
      if (result_size <= 0)
        return EMPTY_STRING
      end
      result = StringBuffer.new(result_size)
      if (!(@device).nil?)
        result.append(@device)
      end
      if (!((@separators & HAS_LEADING)).equal?(0))
        result.append(SEPARATOR)
      end
      if (!((@separators & IS_UNC)).equal?(0))
        result.append(SEPARATOR)
      end
      len = @segments.attr_length
      # append all segments with separators
      i = 0
      while i < len
        if (@segments[i].index_of(DEVICE_SEPARATOR) >= 0)
          encode_segment(@segments[i], result)
        else
          result.append(@segments[i])
        end
        if (i < len - 1 || !((@separators & HAS_TRAILING)).equal?(0))
          result.append(SEPARATOR)
        end
        i += 1
      end
      return result.to_s
    end
    
    typesig { [] }
    # (Intentionally not included in javadoc)
    # @see IPath#toString()
    def to_s
      result_size = compute_length
      if (result_size <= 0)
        return EMPTY_STRING
      end
      result = CharArray.new(result_size)
      offset = 0
      if (!(@device).nil?)
        size = @device.length
        @device.get_chars(0, size, result, offset)
        offset += size
      end
      if (!((@separators & HAS_LEADING)).equal?(0))
        result[((offset += 1) - 1)] = SEPARATOR
      end
      if (!((@separators & IS_UNC)).equal?(0))
        result[((offset += 1) - 1)] = SEPARATOR
      end
      len = @segments.attr_length - 1
      if (len >= 0)
        # append all but the last segment, with separators
        i = 0
        while i < len
          size = @segments[i].length
          @segments[i].get_chars(0, size, result, offset)
          offset += size
          result[((offset += 1) - 1)] = SEPARATOR
          i += 1
        end
        # append the last segment
        size = @segments[len].length
        @segments[len].get_chars(0, size, result, offset)
        offset += size
      end
      if (!((@separators & HAS_TRAILING)).equal?(0))
        result[((offset += 1) - 1)] = SEPARATOR
      end
      return String.new(result)
    end
    
    typesig { [::Java::Int] }
    # (Intentionally not included in javadoc)
    # @see IPath#uptoSegment(int)
    def upto_segment(count)
      if ((count).equal?(0))
        return Path.new(@device, NO_SEGMENTS, @separators & (HAS_LEADING | IS_UNC))
      end
      if (count >= @segments.attr_length)
        return self
      end
      Assert.is_true(count > 0, "Invalid parameter to Path.uptoSegment") # $NON-NLS-1$
      new_segments = Array.typed(String).new(count) { nil }
      System.arraycopy(@segments, 0, new_segments, 0, count)
      return Path.new(@device, new_segments, @separators)
    end
    
    private
    alias_method :initialize__path, :initialize
  end
  
end
