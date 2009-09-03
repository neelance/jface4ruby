require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module HunkComputerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineDiffInfo
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineDiffer
    }
  end
  
  # Computes the diff hunks from an {@link ILineDiffer}.
  # 
  # @since 3.3
  class HunkComputer 
    include_class_members HunkComputerImports
    
    class_module.module_eval {
      typesig { [ILineDiffer, ::Java::Int] }
      # Converts the line-based information of {@link ILineDiffer} into {@link Hunk}s, grouping
      # contiguous blocks of lines that are changed (added, deleted).
      # 
      # @param differ the line differ to query
      # @param lines the number of lines to query
      # @return the corresponding {@link Hunk} information
      def compute_hunks(differ, lines)
        hunks = ArrayList.new(lines)
        added = 0
        changed = 0
        info = nil
        line = 0
        while line < lines
          info = differ.get_line_info(line)
          if ((info).nil?)
            line += 1
            next
          end
          change_type = info.get_change_type
          case (change_type)
          when ILineDiffInfo::ADDED
            added += 1
            line += 1
            next
            changed += 1
            line += 1
            next
            added -= info.get_removed_lines_above
            if (!(added).equal?(0) || !(changed).equal?(0))
              hunks.add(Hunk.new(line - changed - Math.max(0, added), added, changed))
              added = 0
              changed = 0
            end
          when ILineDiffInfo::CHANGED
            changed += 1
            line += 1
            next
            added -= info.get_removed_lines_above
            if (!(added).equal?(0) || !(changed).equal?(0))
              hunks.add(Hunk.new(line - changed - Math.max(0, added), added, changed))
              added = 0
              changed = 0
            end
          when ILineDiffInfo::UNCHANGED
            added -= info.get_removed_lines_above
            if (!(added).equal?(0) || !(changed).equal?(0))
              hunks.add(Hunk.new(line - changed - Math.max(0, added), added, changed))
              added = 0
              changed = 0
            end
          end
          line += 1
        end
        # last hunk
        if (!(info).nil?)
          added -= info.get_removed_lines_below
          if (!(added).equal?(0) || !(changed).equal?(0))
            hunks.add(Hunk.new(lines - changed, added, changed))
            added = 0
            changed = 0
          end
        end
        return hunks.to_array(Array.typed(Hunk).new(hunks.size) { nil })
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__hunk_computer, :initialize
  end
  
end
