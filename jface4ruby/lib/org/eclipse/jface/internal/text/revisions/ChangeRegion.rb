require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module ChangeRegionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text::Revisions, :Revision
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
      include_const ::Org::Eclipse::Jface::Text::Source, :LineRange
    }
  end
  
  # A change region describes a contiguous range of lines that was changed in the same revision of a
  # document. Once it is adjusted to diff information, the originally contiguous range may be split
  # into several ranges or even be empty.
  # 
  # @since 3.2
  class ChangeRegion 
    include_class_members ChangeRegionImports
    
    attr_accessor :f_revision
    alias_method :attr_f_revision, :f_revision
    undef_method :f_revision
    alias_method :attr_f_revision=, :f_revision=
    undef_method :f_revision=
    
    attr_accessor :f_lines
    alias_method :attr_f_lines, :f_lines
    undef_method :f_lines
    alias_method :attr_f_lines=, :f_lines=
    undef_method :f_lines=
    
    attr_accessor :f_adjusted
    alias_method :attr_f_adjusted, :f_adjusted
    undef_method :f_adjusted
    alias_method :attr_f_adjusted=, :f_adjusted=
    undef_method :f_adjusted=
    
    typesig { [Revision, ILineRange] }
    # Creates a new change region for the given revision and line range.
    # 
    # @param revision the revision of the new region
    # @param lines the line range of the new region
    # @throws IndexOutOfBoundsException if the line range is not well-formed
    def initialize(revision, lines)
      @f_revision = nil
      @f_lines = nil
      @f_adjusted = LinkedList.new
      Assert.is_legal(!(revision).nil?)
      Assert.is_legal(!(lines).nil?)
      @f_lines = Range.copy(lines)
      @f_revision = revision
      clear_diff
    end
    
    typesig { [] }
    # Returns the revision that this region belongs to.
    # 
    # @return the revision that this region belongs to
    def get_revision
      return @f_revision
    end
    
    typesig { [] }
    # Returns the original (before applying diff information) line range of this change region.
    # 
    # @return the original (before applying diff information) line range of this change region
    def get_original_range
      return @f_lines
    end
    
    typesig { [] }
    # Returns the list of {@link ILineRange}s of this change region for which the revision
    # information is still valid.
    # 
    # @return the list of adjusted line ranges
    def get_adjusted_ranges
      return @f_adjusted
    end
    
    typesig { [] }
    # Returns the line coverage of the adjusted ranges, an empty range if the coverage is empty.
    # 
    # @return the line coverage of the adjusted ranges
    def get_adjusted_coverage
      if (@f_adjusted.is_empty)
        return LineRange.new(@f_lines.get_start_line, 0)
      end
      first = @f_adjusted.get(0)
      last = @f_adjusted.get(@f_adjusted.size - 1)
      return Range.create_absolute(first.start, last.end_)
    end
    
    typesig { [] }
    # Clears any adjusted ranges, restoring the original range.
    def clear_diff
      @f_adjusted.clear
      @f_adjusted.add(Range.copy(@f_lines))
    end
    
    typesig { [Hunk] }
    # Adjusts this change region to a diff hunk. This will change the adjusted ranges.
    # 
    # @param hunk the diff hunk to adjust to
    def adjust_to(hunk)
      it = @f_adjusted.list_iterator
      while it.has_next
        range = it.next_
        # do we need a split?
        unchanged = get_unchanged(hunk, range.start)
        if (unchanged > 0)
          if (unchanged >= range.length)
            next
          end
          range = range.split(Regexp.new(unchanged))
          it.add(range)
          it.previous
          it.next_ # needed so we can remove below
        end
        line = range.start
        Assert.is_true(hunk.attr_line <= line)
        # by how much do we shrink?
        overlap = get_overlap(hunk, line)
        if (overlap >= range.length)
          it.remove
          next
        end
        # by how much do we move?
        range.move_by(hunk.attr_delta + overlap)
        range.resize_by(-overlap)
      end
    end
    
    typesig { [Hunk, ::Java::Int] }
    def get_unchanged(hunk, line)
      return Math.max(0, hunk.attr_line - line)
    end
    
    typesig { [Hunk, ::Java::Int] }
    # Returns the number of lines after line that the hunk reports as changed.
    def get_overlap(hunk, line)
      delta_line = hunk.attr_line + hunk.attr_changed
      if (hunk.attr_delta >= 0)
        if (delta_line <= line)
          return 0
        end
        return delta_line - line
      end
      # hunk.delta < 0
      hunk_end = delta_line - hunk.attr_delta
      cut_count = hunk_end - line
      return Math.max(0, cut_count)
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      return "ChangeRegion [" + RJava.cast_to_string(@f_revision.to_s) + ", [" + RJava.cast_to_string(@f_lines.get_start_line) + "+" + RJava.cast_to_string(@f_lines.get_number_of_lines) + ")]" # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
    end
    
    private
    alias_method :initialize__change_region, :initialize
  end
  
end
