require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text
  module NonDeletingPositionUpdaterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # A position updater that never deletes a position. If the region containing
  # the position is deleted, the position is moved to the beginning/end (falling
  # together) of the change. If the region containing the position is replaced,
  # the position is placed at the same location inside the replacement text, but
  # always inside the replacement text.
  # 
  # @since 3.1
  class NonDeletingPositionUpdater 
    include_class_members NonDeletingPositionUpdaterImports
    include IPositionUpdater
    
    # The position category.
    attr_accessor :f_category
    alias_method :attr_f_category, :f_category
    undef_method :f_category
    alias_method :attr_f_category=, :f_category=
    undef_method :f_category=
    
    typesig { [String] }
    # Creates a new updater for the given <code>category</code>.
    # 
    # @param category the new category.
    def initialize(category)
      @f_category = nil
      @f_category = category
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IPositionUpdater#update(org.eclipse.jface.text.DocumentEvent)
    def update(event)
      event_offset = event.get_offset
      event_old_end_offset = event_offset + event.get_length
      event_new_length = (event.get_text).nil? ? 0 : event.get_text.length
      event_new_end_offset = event_offset + event_new_length
      delta_length = event_new_length - event.get_length
      begin
        positions = event.get_document.get_positions(@f_category)
        i = 0
        while !(i).equal?(positions.attr_length)
          position = positions[i]
          if (position.is_deleted)
            i += 1
            next
          end
          offset = position.get_offset
          length = position.get_length
          end_ = offset + length
          if (offset > event_old_end_offset)
            # position comes way after change - shift
            position.set_offset(offset + delta_length)
          else
            if (end_ < event_offset)
              # position comes way before change - leave alone
            else
              if (offset <= event_offset && end_ >= event_old_end_offset)
                # event completely internal to the position - adjust length
                position.set_length(length + delta_length)
              else
                if (offset < event_offset)
                  # event extends over end of position - include the
                  # replacement text into the position
                  position.set_length(event_new_end_offset - offset)
                else
                  if (end_ > event_old_end_offset)
                    # event extends from before position into it - adjust
                    # offset and length, including the replacement text into
                    # the position
                    position.set_offset(event_offset)
                    deleted = event_old_end_offset - offset
                    position.set_length(length - deleted + event_new_length)
                  else
                    # event comprises the position - keep it at the same
                    # position, but always inside the replacement text
                    new_offset = Math.min(offset, event_new_end_offset)
                    new_end_offset = Math.min(end_, event_new_end_offset)
                    position.set_offset(new_offset)
                    position.set_length(new_end_offset - new_offset)
                  end
                end
              end
            end
          end
          i += 1
        end
      rescue BadPositionCategoryException => e
        # ignore and return
      end
    end
    
    typesig { [] }
    # Returns the position category.
    # 
    # @return the position category
    def get_category
      return @f_category
    end
    
    private
    alias_method :initialize__non_deleting_position_updater, :initialize
  end
  
end
