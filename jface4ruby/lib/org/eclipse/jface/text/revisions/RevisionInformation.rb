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
  module RevisionInformationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Revisions
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Text::Revisions, :Hunk
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :ITextHoverExtension
      include_const ::Org::Eclipse::Jface::Text::Information, :IInformationProviderExtension2
    }
  end
  
  # Encapsulates revision information for one line-based document.
  # <p>
  # Clients may instantiate.
  # </p>
  # 
  # @since 3.2
  # @see Revision
  class RevisionInformation 
    include_class_members RevisionInformationImports
    include ITextHoverExtension
    include IInformationProviderExtension2
    
    # The revisions, element type: {@link Revision}.
    attr_accessor :f_revisions
    alias_method :attr_f_revisions, :f_revisions
    undef_method :f_revisions
    alias_method :attr_f_revisions=, :f_revisions=
    undef_method :f_revisions=
    
    # A unmodifiable view of <code>fRevisions</code>.
    attr_accessor :f_rorevisions
    alias_method :attr_f_rorevisions, :f_rorevisions
    undef_method :f_rorevisions
    alias_method :attr_f_rorevisions=, :f_rorevisions=
    undef_method :f_rorevisions=
    
    # The flattened list of {@link RevisionRange}s, unmodifiable. <code>null</code> if the list
    # must be re-computed.
    # 
    # @since 3.3
    attr_accessor :f_ranges
    alias_method :attr_f_ranges, :f_ranges
    undef_method :f_ranges
    alias_method :attr_f_ranges=, :f_ranges=
    undef_method :f_ranges=
    
    # The hover control creator. Can be <code>null</code>.
    # 
    # @since 3.3
    attr_accessor :f_hover_control_creator
    alias_method :attr_f_hover_control_creator, :f_hover_control_creator
    undef_method :f_hover_control_creator
    alias_method :attr_f_hover_control_creator=, :f_hover_control_creator=
    undef_method :f_hover_control_creator=
    
    # The information presenter control creator. Can be <code>null</code>.
    # 
    # @since 3.3
    attr_accessor :f_information_presenter_control_creator
    alias_method :attr_f_information_presenter_control_creator, :f_information_presenter_control_creator
    undef_method :f_information_presenter_control_creator
    alias_method :attr_f_information_presenter_control_creator=, :f_information_presenter_control_creator=
    undef_method :f_information_presenter_control_creator=
    
    typesig { [] }
    # Creates a new revision information model.
    def initialize
      @f_revisions = ArrayList.new
      @f_rorevisions = Collections.unmodifiable_list(@f_revisions)
      @f_ranges = nil
      @f_hover_control_creator = nil
      @f_information_presenter_control_creator = nil
    end
    
    typesig { [Revision] }
    # Adds a revision.
    # 
    # @param revision a revision
    def add_revision(revision)
      Assert.is_legal(!(revision).nil?)
      @f_revisions.add(revision)
    end
    
    typesig { [] }
    # Returns the contained revisions.
    # 
    # @return an unmodifiable view of the contained revisions (element type: {@link Revision})
    def get_revisions
      return @f_rorevisions
    end
    
    typesig { [] }
    # Returns the line ranges of this revision information. The returned information is only valid
    # at the moment it is returned, and may change as the annotated document is modified. See
    # {@link IRevisionListener} for a way to be informed when the revision information changes. The
    # returned list is sorted by document offset.
    # 
    # @return an unmodifiable view of the line ranges (element type: {@link RevisionRange})
    # @see IRevisionListener
    # @since 3.3
    def get_ranges
      if ((@f_ranges).nil?)
        ranges = ArrayList.new(@f_revisions.size * 2) # wild size guess
        it = @f_revisions.iterator
        while it.has_next
          revision = it.next_
          ranges.add_all(revision.get_regions)
        end
        Collections.sort(ranges, # sort by start line
        Class.new(Comparator.class == Class ? Comparator : Object) do
          local_class_in RevisionInformation
          include_class_members RevisionInformation
          include Comparator if Comparator.class == Module
          
          typesig { [Object, Object] }
          define_method :compare do |o1, o2|
            r1 = o1
            r2 = o2
            return r1.get_start_line - r2.get_start_line
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @f_ranges = Collections.unmodifiable_list(ranges)
      end
      return @f_ranges
    end
    
    typesig { [Array.typed(Hunk)] }
    # Adjusts the revision information to the given diff information. Any previous diff information is discarded. <strong>Note</strong>: This is an internal framework method and must not be called by clients.
    # 
    # @param hunks the diff hunks to adjust the revision information to
    # @since 3.3
    # @noreference This method is not intended to be referenced by clients.
    def apply_diff(hunks)
      @f_ranges = nil # mark for recomputation
      revisions = get_revisions.iterator
      while revisions.has_next
        (revisions.next_).apply_diff(hunks)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextHoverExtension#getHoverControlCreator()
    # @since 3.3
    def get_hover_control_creator
      return @f_hover_control_creator
    end
    
    typesig { [] }
    # {@inheritDoc}
    # @return the information control creator or <code>null</code>
    # @since 3.3
    def get_information_presenter_control_creator
      return @f_information_presenter_control_creator
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the hover control creator.
    # <p>
    # <strong>Note:</strong> The created information control must be able to display the object
    # returned by the concrete implementation of {@link Revision#getHoverInfo()}.
    # </p>
    # 
    # @param creator the control creator
    # @since 3.3
    def set_hover_control_creator(creator)
      @f_hover_control_creator = creator
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the information presenter control creator.
    # 
    # @param creator the control creator
    # @since 3.3
    def set_information_presenter_control_creator(creator)
      @f_information_presenter_control_creator = creator
    end
    
    private
    alias_method :initialize__revision_information, :initialize
  end
  
end
