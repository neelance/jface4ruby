require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Link
  module LinkedPositionAnnotationsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :AnnotationModel
    }
  end
  
  # Internal class.
  # 
  # @since 3.0
  class LinkedPositionAnnotations < LinkedPositionAnnotationsImports.const_get :AnnotationModel
    include_class_members LinkedPositionAnnotationsImports
    
    class_module.module_eval {
      # annotation types
      const_set_lazy(:TARGET_ANNOTATION_TYPE) { "org.eclipse.ui.internal.workbench.texteditor.link.target" }
      const_attr_reader  :TARGET_ANNOTATION_TYPE
      
      # $NON-NLS-1$
      const_set_lazy(:SLAVE_ANNOTATION_TYPE) { "org.eclipse.ui.internal.workbench.texteditor.link.slave" }
      const_attr_reader  :SLAVE_ANNOTATION_TYPE
      
      # $NON-NLS-1$
      const_set_lazy(:FOCUS_ANNOTATION_TYPE) { "org.eclipse.ui.internal.workbench.texteditor.link.master" }
      const_attr_reader  :FOCUS_ANNOTATION_TYPE
      
      # $NON-NLS-1$
      const_set_lazy(:EXIT_ANNOTATION_TYPE) { "org.eclipse.ui.internal.workbench.texteditor.link.exit" }
      const_attr_reader  :EXIT_ANNOTATION_TYPE
    }
    
    # $NON-NLS-1$
    # configuration
    attr_accessor :f_mark_targets
    alias_method :attr_f_mark_targets, :f_mark_targets
    undef_method :f_mark_targets
    alias_method :attr_f_mark_targets=, :f_mark_targets=
    undef_method :f_mark_targets=
    
    attr_accessor :f_mark_slaves
    alias_method :attr_f_mark_slaves, :f_mark_slaves
    undef_method :f_mark_slaves
    alias_method :attr_f_mark_slaves=, :f_mark_slaves=
    undef_method :f_mark_slaves=
    
    attr_accessor :f_mark_focus
    alias_method :attr_f_mark_focus, :f_mark_focus
    undef_method :f_mark_focus
    alias_method :attr_f_mark_focus=, :f_mark_focus=
    undef_method :f_mark_focus=
    
    attr_accessor :f_mark_exit_target
    alias_method :attr_f_mark_exit_target, :f_mark_exit_target
    undef_method :f_mark_exit_target
    alias_method :attr_f_mark_exit_target=, :f_mark_exit_target=
    undef_method :f_mark_exit_target=
    
    attr_accessor :f_focus_annotation
    alias_method :attr_f_focus_annotation, :f_focus_annotation
    undef_method :f_focus_annotation
    alias_method :attr_f_focus_annotation=, :f_focus_annotation=
    undef_method :f_focus_annotation=
    
    attr_accessor :f_exit_annotation
    alias_method :attr_f_exit_annotation, :f_exit_annotation
    undef_method :f_exit_annotation
    alias_method :attr_f_exit_annotation=, :f_exit_annotation=
    undef_method :f_exit_annotation=
    
    attr_accessor :f_group_annotations
    alias_method :attr_f_group_annotations, :f_group_annotations
    undef_method :f_group_annotations
    alias_method :attr_f_group_annotations=, :f_group_annotations=
    undef_method :f_group_annotations=
    
    attr_accessor :f_target_annotations
    alias_method :attr_f_target_annotations, :f_target_annotations
    undef_method :f_target_annotations
    alias_method :attr_f_target_annotations=, :f_target_annotations=
    undef_method :f_target_annotations=
    
    attr_accessor :f_targets
    alias_method :attr_f_targets, :f_targets
    undef_method :f_targets
    alias_method :attr_f_targets=, :f_targets=
    undef_method :f_targets=
    
    attr_accessor :f_exit_position
    alias_method :attr_f_exit_position, :f_exit_position
    undef_method :f_exit_position
    alias_method :attr_f_exit_position=, :f_exit_position=
    undef_method :f_exit_position=
    
    typesig { [Position] }
    # Sets the position that should be highlighted as the focus position, i.e.
    # as the position whose changes are propagated to all its linked positions
    # by the linked environment.
    # 
    # @param position the new focus position, or <code>null</code> if no focus is set.
    # @throws BadLocationException if <code>position</code> is invalid
    def set_focus_position(position)
      if (@f_mark_focus && !(get_position(@f_focus_annotation)).equal?(position))
        remove_annotation(@f_focus_annotation, false)
        if (!(position).nil?)
          @f_focus_annotation = Annotation.new(FOCUS_ANNOTATION_TYPE, false, "") # $NON-NLS-1$
          add_annotation(@f_focus_annotation, position, false)
        else
          @f_focus_annotation = nil
        end
      end
    end
    
    typesig { [Position] }
    # Sets the position that should be highlighted as the exit position, i.e.
    # as the position whose changes are propagated to all its linked positions
    # by the linked environment.
    # 
    # @param position the new exit position, or <code>null</code> if no focus is set.
    # @throws BadLocationException in case <code>position</code> is invalid
    def set_exit_position(position)
      if (@f_mark_exit_target && !(get_position(@f_exit_annotation)).equal?(position))
        remove_annotation(@f_exit_annotation, false)
        if (!(position).nil?)
          @f_exit_annotation = Annotation.new(EXIT_ANNOTATION_TYPE, false, "") # $NON-NLS-1$
          add_annotation(@f_exit_annotation, position, false)
        else
          @f_exit_annotation = nil
        end
      end
    end
    
    typesig { [JavaList] }
    # Sets the positions that should be highlighted as the slave positions, i.e.
    # as the positions that are linked to the focus position.
    # 
    # @param positions the new slave positions, or <code>null</code> if no slave positions are to be set
    # @throws BadLocationException in case any of the given positions is invalid
    def set_group_positions(positions)
      if (!@f_mark_slaves)
        return
      end
      # remove all positions which are already there
      # Algorithm: toRemove contains all mappings at first, but all that are in
      # positions get removed -> toRemove contains the difference set of previous - new
      # toAdd are the new positions, which don't exist in previous = new - previous
      to_remove = ArrayList.new(@f_group_annotations.values)
      to_add = HashMap.new
      if (!(positions).nil?)
        iter = positions.iterator
        while iter.has_next
          p = iter.next_
          if (@f_group_annotations.contains_key(p))
            to_remove.remove(@f_group_annotations.get(p))
          else
            a = Annotation.new(SLAVE_ANNOTATION_TYPE, false, "") # $NON-NLS-1$
            to_add.put(a, p)
            @f_group_annotations.put(p, a)
          end
        end
      end
      @f_group_annotations.values.remove_all(to_remove)
      replace_annotations(to_remove.to_array(Array.typed(Annotation).new(0) { nil }), to_add, false)
    end
    
    typesig { [JavaList] }
    # Sets the positions that should be highlighted as the target positions, i.e.
    # as the positions that can be jumped to in a linked set up.
    # 
    # @param positions the new target positions, or <code>null</code> if no target positions are to be set
    # @throws BadLocationException in case any of the given positions is invalid
    def set_target_positions(positions)
      if (!@f_mark_targets)
        return
      end
      # remove all positions which are already there
      # Algorithm: toRemove contains all mappings at first, but all that are in
      # positions get removed -> toRemove contains the difference set of previous - new
      # toAdd are the new positions, which don't exist in previous = new - previous
      to_remove = ArrayList.new(@f_target_annotations.values)
      to_add = HashMap.new
      if (!(positions).nil?)
        iter = positions.iterator
        while iter.has_next
          p = iter.next_
          if (@f_target_annotations.contains_key(p))
            to_remove.remove(@f_target_annotations.get(p))
          else
            a = Annotation.new(TARGET_ANNOTATION_TYPE, false, "") # $NON-NLS-1$
            to_add.put(a, p)
            @f_target_annotations.put(p, a)
          end
        end
      end
      @f_target_annotations.values.remove_all(to_remove)
      replace_annotations(to_remove.to_array(Array.typed(Annotation).new(0) { nil }), to_add, false)
    end
    
    typesig { [LinkedModeModel, LinkedPosition] }
    # Switches the focus position to <code>position</code> given the
    # <code>LinkedModeModel env</code>. The slave positions for <code>position</code> is extracted
    # from the environment and set accordingly, the target positions are updated as well.
    # 
    # @param env the linked mode model
    # @param position the linked position
    def switch_to_position(env, position)
      if ((self.attr_f_document).nil? || (!(position).nil? && (get_position(@f_focus_annotation)).equal?(position)) || ((position).nil? && (@f_focus_annotation).nil?))
        return
      end
      linked_group = nil
      if (!(position).nil?)
        linked_group = env.get_group_for_position(position)
      end
      targets = ArrayList.new
      targets.add_all(Arrays.as_list(@f_targets))
      group = nil
      if (!(linked_group).nil?)
        group = ArrayList.new(Arrays.as_list(linked_group.get_positions))
      else
        group = ArrayList.new
      end
      if ((position).nil? || !(self.attr_f_document == position.get_document))
        # position is not valid if not in this document
        position = nil
      end
      exit = @f_exit_position
      if ((exit).nil? || !(self.attr_f_document == exit.get_document))
        # position is not valid if not in this document
        exit = nil
      end
      if (!(exit).nil?)
        group.remove(exit)
        targets.remove(exit)
      end
      group.remove_all(targets)
      targets.remove(position)
      group.remove(position)
      prune(targets)
      prune(group)
      begin
        set_focus_position(position)
        set_exit_position(exit)
        set_group_positions(group)
        set_target_positions(targets)
      rescue BadLocationException => e
        # will never happen as we don't actually add/remove positions from the document
        # see the addPosition / removePosition methods
        Assert.is_true(false)
      end
      fire_model_changed
    end
    
    typesig { [JavaList] }
    # Prune <code>list</code> of all <code>LinkedPosition</code>s that
    # do not belong to this model's <code>IDocument</code>.
    # 
    # @param list the list of positions to prune
    def prune(list)
      iter = list.iterator
      while iter.has_next
        pos = iter.next_
        if (!(pos.get_document == self.attr_f_document))
          iter.remove
        end
      end
    end
    
    typesig { [Array.typed(Position)] }
    # Sets the target positions.
    # 
    # @param positions an array of positions
    def set_targets(positions)
      @f_targets = positions
    end
    
    typesig { [LinkedPosition] }
    # Sets the exit position.
    # 
    # @param position the new exit position, or <code>null</code> if no exit position should be set
    def set_exit_target(position)
      @f_exit_position = position
    end
    
    typesig { [IDocument, Position] }
    # @see org.eclipse.jface.text.source.AnnotationModel#addPosition(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.Position)
    def add_position(document, position)
      # don't to anything as our positions are managed by custom
      # position updaters
    end
    
    typesig { [IDocument, Position] }
    # @see org.eclipse.jface.text.source.AnnotationModel#removePosition(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.Position)
    def remove_position(document, pos)
      # don't to anything as our positions are managed by custom
      # position updaters
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.AnnotationModel#fireModelChanged()
    def fire_model_changed
      super
    end
    
    typesig { [::Java::Boolean] }
    # Sets the drawing state for the exit target. Default is <code>true</code>.
    # 
    # @param markExitTargets the new drawing state for exit targets
    def mark_exit_target(mark_exit_targets)
      @f_mark_exit_target = mark_exit_targets
    end
    
    typesig { [::Java::Boolean] }
    # Sets the drawing state for the focus position. Default is <code>true</code>.
    # 
    # @param markFocus the new drawing state for exit targets
    def mark_focus(mark_focus)
      @f_mark_focus = mark_focus
    end
    
    typesig { [::Java::Boolean] }
    # Sets the drawing state for slave positions. Default is <code>true</code>.
    # 
    # @param markSlaves the new drawing state for slaves
    def mark_slaves(mark_slaves)
      @f_mark_slaves = mark_slaves
    end
    
    typesig { [::Java::Boolean] }
    # Sets the drawing state for targets. Default is <code>true</code>.
    # 
    # @param markTargets the new drawing state for targets
    def mark_targets(mark_targets)
      @f_mark_targets = mark_targets
    end
    
    typesig { [] }
    def initialize
      @f_mark_targets = false
      @f_mark_slaves = false
      @f_mark_focus = false
      @f_mark_exit_target = false
      @f_focus_annotation = nil
      @f_exit_annotation = nil
      @f_group_annotations = nil
      @f_target_annotations = nil
      @f_targets = nil
      @f_exit_position = nil
      super()
      @f_mark_targets = true
      @f_mark_slaves = true
      @f_mark_focus = true
      @f_mark_exit_target = true
      @f_focus_annotation = nil
      @f_exit_annotation = nil
      @f_group_annotations = HashMap.new
      @f_target_annotations = HashMap.new
      @f_targets = Array.typed(Position).new(0) { nil }
      @f_exit_position = nil
    end
    
    private
    alias_method :initialize__linked_position_annotations, :initialize
  end
  
end
