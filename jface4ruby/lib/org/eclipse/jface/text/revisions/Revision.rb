require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Revisions
  module RevisionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Revisions
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Jface::Internal::Text::Revisions, :ChangeRegion
      include_const ::Org::Eclipse::Jface::Internal::Text::Revisions, :Hunk
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
    }
  end
  
  # Describes a revision of a document. A revision consists of one ore more {@link ILineRange}s.
  # <p>
  # Clients may subclass.
  # </p>
  # 
  # @since 3.2
  class Revision 
    include_class_members RevisionImports
    
    # The original list of change regions, element type: {@link ChangeRegion}.
    attr_accessor :f_change_regions
    alias_method :attr_f_change_regions, :f_change_regions
    undef_method :f_change_regions
    alias_method :attr_f_change_regions=, :f_change_regions=
    undef_method :f_change_regions=
    
    # The cached list of adjusted ranges, element type: {@link RevisionRange}. <code>null</code>
    # if the list must be re-computed. Unmodifiable.
    # 
    # @since 3.3
    attr_accessor :f_ranges
    alias_method :attr_f_ranges, :f_ranges
    undef_method :f_ranges
    alias_method :attr_f_ranges=, :f_ranges=
    undef_method :f_ranges=
    
    typesig { [] }
    # Creates a new revision.
    def initialize
      @f_change_regions = ArrayList.new
      @f_ranges = nil
    end
    
    typesig { [ILineRange] }
    # Adds a line range to this revision. The range must be non-empty and have a legal start line
    # (not -1).
    # 
    # @param range a line range that was changed with this revision
    # @throws IndexOutOfBoundsException if the line range is empty or has a negative start line
    def add_range(range)
      @f_change_regions.add(ChangeRegion.new(self, range))
    end
    
    typesig { [] }
    # Returns the contained {@link RevisionRange}s adapted to the current diff state. The returned
    # information is only valid at the moment it is returned, and may change as the annotated
    # document is modified.
    # 
    # @return an unmodifiable view of the contained ranges (element type: {@link RevisionRange})
    def get_regions
      if ((@f_ranges).nil?)
        ranges = ArrayList.new(@f_change_regions.size)
        it = @f_change_regions.iterator
        while it.has_next
          region = it.next_
          inner = region.get_adjusted_ranges.iterator
          while inner.has_next
            range = inner.next_
            ranges.add(RevisionRange.new(self, range))
          end
        end
        @f_ranges = Collections.unmodifiable_list(ranges)
      end
      return @f_ranges
    end
    
    typesig { [Array.typed(Hunk)] }
    # Adjusts the revision information to the given diff information. Any previous diff information
    # is discarded.
    # 
    # @param hunks the diff hunks to adjust the revision information to
    # @since 3.3
    def apply_diff(hunks)
      @f_ranges = nil # mark for recomputation
      regions = @f_change_regions.iterator
      while regions.has_next
        region = regions.next_
        region.clear_diff
        i = 0
        while i < hunks.attr_length
          hunk = hunks[i]
          region.adjust_to(hunk)
          i += 1
        end
      end
    end
    
    typesig { [] }
    # Returns the hover information that will be shown when the user hovers over the a change
    # region of this revision.
    # <p>
    # <strong>Note:</strong> The hover information control which is used to display the information
    # must be able process the given object. If the default information control creator is used
    # the supported format is simple text, full HTML or an HTML fragment.
    # </p>
    # 
    # @return the hover information for this revision or <code>null</code> for no hover
    # @see RevisionInformation#setHoverControlCreator(IInformationControlCreator)
    def get_hover_info
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the author color for this revision. This color can be used to visually distinguish
    # one revision from another, for example as background color.
    # <p>
    # Revisions from the same author must return the same color and revisions from different authors
    # must return distinct colors.</p>
    # 
    # @return the RGB color for this revision's author
    def get_color
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the unique (within the document) id of this revision. This may be the version string
    # or a different identifier.
    # 
    # @return the id of this revision
    def get_id
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the modification date of this revision.
    # 
    # @return the modification date of this revision
    def get_date
      raise NotImplementedError
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      return "Revision " + RJava.cast_to_string(get_id) # $NON-NLS-1$
    end
    
    typesig { [] }
    # Returns the display string for the author of this revision.
    # <p>
    # Subclasses should replace - the default implementation returns the empty string.
    # </p>
    # 
    # @return the author name
    # @since 3.3
    def get_author
      return "" # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__revision, :initialize
  end
  
end
