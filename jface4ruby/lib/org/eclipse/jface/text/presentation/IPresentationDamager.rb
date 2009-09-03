require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Presentation
  module IPresentationDamagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Presentation
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
    }
  end
  
  # A presentation damager is a strategy used by a presentation reconciler to
  # determine the region of the document's presentation which must be rebuilt
  # because of a document change. A presentation damager is assumed to be
  # specific for a particular document content type. A presentation damager is
  # expected to return a damage region which is a valid input for a presentation
  # repairer. I.e. having access to the damage region only the repairer must be
  # able to derive all the information needed to successfully repair this region.
  # <p>
  # This interface must either be implemented by clients or clients use the
  # rule-based default implementation
  # {@link org.eclipse.jface.text.rules.DefaultDamagerRepairer}. Implementers
  # should be registered with a presentation reconciler in order get involved in
  # the reconciling process.</p>
  # 
  # @see IPresentationReconciler
  # @see IDocument
  # @see DocumentEvent
  # @see IPresentationRepairer
  module IPresentationDamager
    include_class_members IPresentationDamagerImports
    
    typesig { [IDocument] }
    # Tells the presentation damager on which document it will work.
    # 
    # @param document the damager's working document
    def set_document(document)
      raise NotImplementedError
    end
    
    typesig { [ITypedRegion, DocumentEvent, ::Java::Boolean] }
    # Returns the damage in the document's presentation caused by the given document change.
    # The damage is restricted to the specified partition for which the presentation damager is
    # responsible. The damage may also depend on whether the document change also caused changes
    # of the document's partitioning.
    # 
    # @param partition the partition inside which the damage must be determined
    # @param event the event describing the change whose damage must be determined
    # @param documentPartitioningChanged indicates whether the given change changed the document's partitioning
    # @return the computed damage
    def get_damage_region(partition, event, document_partitioning_changed)
      raise NotImplementedError
    end
  end
  
end
