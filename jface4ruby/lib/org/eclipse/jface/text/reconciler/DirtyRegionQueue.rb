require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Reconciler
  module DirtyRegionQueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
    }
  end
  
  # Queue used by {@link org.eclipse.jface.text.reconciler.AbstractReconciler} to manage
  # dirty regions. When a dirty region is inserted into the queue, the queue tries
  # to fold it into the neighboring dirty region.
  # 
  # @see org.eclipse.jface.text.reconciler.AbstractReconciler
  # @see org.eclipse.jface.text.reconciler.DirtyRegion
  class DirtyRegionQueue 
    include_class_members DirtyRegionQueueImports
    
    # The list of dirty regions.
    attr_accessor :f_dirty_regions
    alias_method :attr_f_dirty_regions, :f_dirty_regions
    undef_method :f_dirty_regions
    alias_method :attr_f_dirty_regions=, :f_dirty_regions=
    undef_method :f_dirty_regions=
    
    typesig { [] }
    # Creates a new empty dirty region.
    def initialize
      @f_dirty_regions = ArrayList.new
    end
    
    typesig { [DirtyRegion] }
    # Adds a dirty region to the end of the dirty-region queue.
    # 
    # @param dr the dirty region to add
    def add_dirty_region(dr)
      # If the dirty region being added is directly after the last dirty
      # region on the queue then merge the two dirty regions together.
      last_dr = get_last_dirty_region
      was_merged = false
      if (!(last_dr).nil?)
        if ((last_dr.get_type).equal?(dr.get_type))
          if ((last_dr.get_type).equal?(DirtyRegion::INSERT))
            if ((last_dr.get_offset + last_dr.get_length).equal?(dr.get_offset))
              last_dr.merge_with(dr)
              was_merged = true
            end
          else
            if ((last_dr.get_type).equal?(DirtyRegion::REMOVE))
              if ((dr.get_offset + dr.get_length).equal?(last_dr.get_offset))
                last_dr.merge_with(dr)
                was_merged = true
              end
            end
          end
        end
      end
      if (!was_merged)
        # Don't merge- just add the new one onto the queue.
        @f_dirty_regions.add(dr)
      end
    end
    
    typesig { [] }
    # Returns the last dirty region that was added to the queue.
    # 
    # @return the last DirtyRegion on the queue
    def get_last_dirty_region
      size_ = @f_dirty_regions.size
      return ((size_).equal?(0) ? nil : @f_dirty_regions.get(size_ - 1))
    end
    
    typesig { [] }
    # Returns the number of regions in the queue.
    # 
    # @return the dirty-region queue-size
    def get_size
      return @f_dirty_regions.size
    end
    
    typesig { [] }
    # Throws away all entries in the queue.
    def purge_queue
      @f_dirty_regions.clear
    end
    
    typesig { [] }
    # Removes and returns the first dirty region in the queue
    # 
    # @return the next dirty region on the queue
    def remove_next_dirty_region
      if ((@f_dirty_regions.size).equal?(0))
        return nil
      end
      dr = @f_dirty_regions.get(0)
      @f_dirty_regions.remove(0)
      return dr
    end
    
    private
    alias_method :initialize__dirty_region_queue, :initialize
  end
  
end
