require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Cagatay Calli <ccalli@gmail.com> - [find/replace] retain caps when replacing - https://bugs.eclipse.org/bugs/show_bug.cgi?id=28949
module Org::Eclipse::Jface::Text
  module FindReplaceDocumentAdapterContentProposalProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Org::Eclipse::Jface::Fieldassist, :IContentProposal
      include_const ::Org::Eclipse::Jface::Fieldassist, :IContentProposalProvider
    }
  end
  
  # Content assist proposal provider for the {@link FindReplaceDocumentAdapter}.
  # <p>
  # Clients can subclass to provide additional proposals in case they are supported
  # by their own find/replace mechanism.
  # </p>
  # <p>
  # <strong>Note:</strong> Clients must not make any assumptions about the returned
  # proposals. This can change from release to release to adapt to
  # changes made in {@link FindReplaceDocumentAdapter}.
  # </p>
  # 
  # @since 3.4
  class FindReplaceDocumentAdapterContentProposalProvider 
    include_class_members FindReplaceDocumentAdapterContentProposalProviderImports
    include IContentProposalProvider
    
    class_module.module_eval {
      # Proposal computer.
      const_set_lazy(:ProposalComputer) { Class.new do
        include_class_members FindReplaceDocumentAdapterContentProposalProvider
        
        class_module.module_eval {
          const_set_lazy(:Proposal) { Class.new do
            include_class_members ProposalComputer
            include class_self::IContentProposal
            
            attr_accessor :f_content
            alias_method :attr_f_content, :f_content
            undef_method :f_content
            alias_method :attr_f_content=, :f_content=
            undef_method :f_content=
            
            attr_accessor :f_label
            alias_method :attr_f_label, :f_label
            undef_method :f_label
            alias_method :attr_f_label=, :f_label=
            undef_method :f_label=
            
            attr_accessor :f_description
            alias_method :attr_f_description, :f_description
            undef_method :f_description
            alias_method :attr_f_description=, :f_description=
            undef_method :f_description=
            
            attr_accessor :f_cursor_position
            alias_method :attr_f_cursor_position, :f_cursor_position
            undef_method :f_cursor_position
            alias_method :attr_f_cursor_position=, :f_cursor_position=
            undef_method :f_cursor_position=
            
            typesig { [String, String, String, ::Java::Int] }
            def initialize(content, label, description, cursor_position)
              @f_content = nil
              @f_label = nil
              @f_description = nil
              @f_cursor_position = 0
              @f_content = content
              @f_label = label
              @f_description = description
              @f_cursor_position = cursor_position
            end
            
            typesig { [] }
            def get_content
              return @f_content
            end
            
            typesig { [] }
            def get_label
              return @f_label
            end
            
            typesig { [] }
            def get_description
              return @f_description
            end
            
            typesig { [] }
            def get_cursor_position
              return @f_cursor_position
            end
            
            private
            alias_method :initialize__proposal, :initialize
          end }
        }
        
        # The whole regular expression.
        attr_accessor :f_expression
        alias_method :attr_f_expression, :f_expression
        undef_method :f_expression
        alias_method :attr_f_expression=, :f_expression=
        undef_method :f_expression=
        
        # The document offset.
        attr_accessor :f_document_offset
        alias_method :attr_f_document_offset, :f_document_offset
        undef_method :f_document_offset
        alias_method :attr_f_document_offset=, :f_document_offset=
        undef_method :f_document_offset=
        
        # The high-priority proposals.
        attr_accessor :f_priority_proposals
        alias_method :attr_f_priority_proposals, :f_priority_proposals
        undef_method :f_priority_proposals
        alias_method :attr_f_priority_proposals=, :f_priority_proposals=
        undef_method :f_priority_proposals=
        
        # The low-priority proposals.
        attr_accessor :f_proposals
        alias_method :attr_f_proposals, :f_proposals
        undef_method :f_proposals
        alias_method :attr_f_proposals=, :f_proposals=
        undef_method :f_proposals=
        
        # <code>true</code> iff <code>fExpression</code> ends with an open escape.
        attr_accessor :f_is_escape
        alias_method :attr_f_is_escape, :f_is_escape
        undef_method :f_is_escape
        alias_method :attr_f_is_escape=, :f_is_escape=
        undef_method :f_is_escape=
        
        typesig { [String, ::Java::Int] }
        # Creates a new Proposal Computer.
        # @param contents the contents of the subject control
        # @param position the cursor position
        def initialize(contents, position)
          @f_expression = nil
          @f_document_offset = 0
          @f_priority_proposals = nil
          @f_proposals = nil
          @f_is_escape = false
          @f_expression = contents
          @f_document_offset = position
          @f_priority_proposals = self.class::ArrayList.new
          @f_proposals = self.class::ArrayList.new
          is_escape = false
          i = position - 1
          while i >= 0
            if ((@f_expression.char_at(i)).equal?(Character.new(?\\.ord)))
              is_escape = !is_escape
            else
              break
            end
            i -= 1
          end
          @f_is_escape = is_escape
        end
        
        typesig { [] }
        # Computes applicable proposals for the find field.
        # @return the proposals
        def compute_find_proposals
          # characters
          add_bs_proposal("\\\\", RegExMessages.get_string("displayString_bs_bs"), RegExMessages.get_string("additionalInfo_bs_bs")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bracket_proposal("\\0", 2, RegExMessages.get_string("displayString_bs_0"), RegExMessages.get_string("additionalInfo_bs_0")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bracket_proposal("\\x", 2, RegExMessages.get_string("displayString_bs_x"), RegExMessages.get_string("additionalInfo_bs_x")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bracket_proposal("\\u", 2, RegExMessages.get_string("displayString_bs_u"), RegExMessages.get_string("additionalInfo_bs_u")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\t", RegExMessages.get_string("displayString_bs_t"), RegExMessages.get_string("additionalInfo_bs_t")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\R", RegExMessages.get_string("displayString_bs_R"), RegExMessages.get_string("additionalInfo_bs_R")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\n", RegExMessages.get_string("displayString_bs_n"), RegExMessages.get_string("additionalInfo_bs_n")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\r", RegExMessages.get_string("displayString_bs_r"), RegExMessages.get_string("additionalInfo_bs_r")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\f", RegExMessages.get_string("displayString_bs_f"), RegExMessages.get_string("additionalInfo_bs_f")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\a", RegExMessages.get_string("displayString_bs_a"), RegExMessages.get_string("additionalInfo_bs_a")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\e", RegExMessages.get_string("displayString_bs_e"), RegExMessages.get_string("additionalInfo_bs_e")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bracket_proposal("\\c", 2, RegExMessages.get_string("displayString_bs_c"), RegExMessages.get_string("additionalInfo_bs_c")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          if (!@f_is_escape)
            add_bracket_proposal(".", 1, RegExMessages.get_string("displayString_dot"), RegExMessages.get_string("additionalInfo_dot"))
          end # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\d", RegExMessages.get_string("displayString_bs_d"), RegExMessages.get_string("additionalInfo_bs_d")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\D", RegExMessages.get_string("displayString_bs_D"), RegExMessages.get_string("additionalInfo_bs_D")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\s", RegExMessages.get_string("displayString_bs_s"), RegExMessages.get_string("additionalInfo_bs_s")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\S", RegExMessages.get_string("displayString_bs_S"), RegExMessages.get_string("additionalInfo_bs_S")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\w", RegExMessages.get_string("displayString_bs_w"), RegExMessages.get_string("additionalInfo_bs_w")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\W", RegExMessages.get_string("displayString_bs_W"), RegExMessages.get_string("additionalInfo_bs_W")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          # back reference
          add_bs_proposal("\\", RegExMessages.get_string("displayString_bs_i"), RegExMessages.get_string("additionalInfo_bs_i")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          # quoting
          add_bs_proposal("\\", RegExMessages.get_string("displayString_bs"), RegExMessages.get_string("additionalInfo_bs")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\Q", RegExMessages.get_string("displayString_bs_Q"), RegExMessages.get_string("additionalInfo_bs_Q")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\E", RegExMessages.get_string("displayString_bs_E"), RegExMessages.get_string("additionalInfo_bs_E")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          # character sets
          if (!@f_is_escape)
            add_bracket_proposal("[]", 1, RegExMessages.get_string("displayString_set"), RegExMessages.get_string("additionalInfo_set")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("[^]", 2, RegExMessages.get_string("displayString_setExcl"), RegExMessages.get_string("additionalInfo_setExcl")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("[-]", 1, RegExMessages.get_string("displayString_setRange"), RegExMessages.get_string("additionalInfo_setRange")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_proposal("&&", RegExMessages.get_string("displayString_setInter"), RegExMessages.get_string("additionalInfo_setInter")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          end
          if (!@f_is_escape && @f_document_offset > 0 && (@f_expression.char_at(@f_document_offset - 1)).equal?(Character.new(?\\.ord)))
            add_proposal("\\p{}", 3, RegExMessages.get_string("displayString_posix"), RegExMessages.get_string("additionalInfo_posix")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_proposal("\\P{}", 3, RegExMessages.get_string("displayString_posixNot"), RegExMessages.get_string("additionalInfo_posixNot")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          else
            add_bracket_proposal("\\p{}", 3, RegExMessages.get_string("displayString_posix"), RegExMessages.get_string("additionalInfo_posix")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("\\P{}", 3, RegExMessages.get_string("displayString_posixNot"), RegExMessages.get_string("additionalInfo_posixNot")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          end
          # boundary matchers
          if ((@f_document_offset).equal?(0))
            add_priority_proposal("^", RegExMessages.get_string("displayString_start"), RegExMessages.get_string("additionalInfo_start")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          else
            if ((@f_document_offset).equal?(1) && (@f_expression.char_at(0)).equal?(Character.new(?^.ord)))
              add_bracket_proposal("^", 1, RegExMessages.get_string("displayString_start"), RegExMessages.get_string("additionalInfo_start")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            end
          end
          if ((@f_document_offset).equal?(@f_expression.length))
            add_proposal("$", RegExMessages.get_string("displayString_end"), RegExMessages.get_string("additionalInfo_end")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          end
          add_bs_proposal("\\b", RegExMessages.get_string("displayString_bs_b"), RegExMessages.get_string("additionalInfo_bs_b")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\B", RegExMessages.get_string("displayString_bs_B"), RegExMessages.get_string("additionalInfo_bs_B")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\A", RegExMessages.get_string("displayString_bs_A"), RegExMessages.get_string("additionalInfo_bs_A")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\G", RegExMessages.get_string("displayString_bs_G"), RegExMessages.get_string("additionalInfo_bs_G")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\Z", RegExMessages.get_string("displayString_bs_Z"), RegExMessages.get_string("additionalInfo_bs_Z")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          add_bs_proposal("\\z", RegExMessages.get_string("displayString_bs_z"), RegExMessages.get_string("additionalInfo_bs_z")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          if (!@f_is_escape)
            # capturing groups
            add_bracket_proposal("()", 1, RegExMessages.get_string("displayString_group"), RegExMessages.get_string("additionalInfo_group")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            # flags
            add_bracket_proposal("(?)", 2, RegExMessages.get_string("displayString_flag"), RegExMessages.get_string("additionalInfo_flag")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("(?:)", 3, RegExMessages.get_string("displayString_flagExpr"), RegExMessages.get_string("additionalInfo_flagExpr")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            # non-capturing group
            add_bracket_proposal("(?:)", 3, RegExMessages.get_string("displayString_nonCap"), RegExMessages.get_string("additionalInfo_nonCap")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("(?>)", 3, RegExMessages.get_string("displayString_atomicCap"), RegExMessages.get_string("additionalInfo_atomicCap")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            # look around
            add_bracket_proposal("(?=)", 3, RegExMessages.get_string("displayString_posLookahead"), RegExMessages.get_string("additionalInfo_posLookahead")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("(?!)", 3, RegExMessages.get_string("displayString_negLookahead"), RegExMessages.get_string("additionalInfo_negLookahead")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("(?<=)", 4, RegExMessages.get_string("displayString_posLookbehind"), RegExMessages.get_string("additionalInfo_posLookbehind")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("(?<!)", 4, RegExMessages.get_string("displayString_negLookbehind"), RegExMessages.get_string("additionalInfo_negLookbehind")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            # greedy quantifiers
            add_bracket_proposal("?", 1, RegExMessages.get_string("displayString_quest"), RegExMessages.get_string("additionalInfo_quest")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("*", 1, RegExMessages.get_string("displayString_star"), RegExMessages.get_string("additionalInfo_star")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("+", 1, RegExMessages.get_string("displayString_plus"), RegExMessages.get_string("additionalInfo_plus")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{}", 1, RegExMessages.get_string("displayString_exact"), RegExMessages.get_string("additionalInfo_exact")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{,}", 1, RegExMessages.get_string("displayString_least"), RegExMessages.get_string("additionalInfo_least")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{,}", 1, RegExMessages.get_string("displayString_count"), RegExMessages.get_string("additionalInfo_count")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            # lazy quantifiers
            add_bracket_proposal("??", 1, RegExMessages.get_string("displayString_questLazy"), RegExMessages.get_string("additionalInfo_questLazy")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("*?", 1, RegExMessages.get_string("displayString_starLazy"), RegExMessages.get_string("additionalInfo_starLazy")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("+?", 1, RegExMessages.get_string("displayString_plusLazy"), RegExMessages.get_string("additionalInfo_plusLazy")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{}?", 1, RegExMessages.get_string("displayString_exactLazy"), RegExMessages.get_string("additionalInfo_exactLazy")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{,}?", 1, RegExMessages.get_string("displayString_leastLazy"), RegExMessages.get_string("additionalInfo_leastLazy")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{,}?", 1, RegExMessages.get_string("displayString_countLazy"), RegExMessages.get_string("additionalInfo_countLazy")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            # possessive quantifiers
            add_bracket_proposal("?+", 1, RegExMessages.get_string("displayString_questPoss"), RegExMessages.get_string("additionalInfo_questPoss")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("*+", 1, RegExMessages.get_string("displayString_starPoss"), RegExMessages.get_string("additionalInfo_starPoss")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("++", 1, RegExMessages.get_string("displayString_plusPoss"), RegExMessages.get_string("additionalInfo_plusPoss")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{}+", 1, RegExMessages.get_string("displayString_exactPoss"), RegExMessages.get_string("additionalInfo_exactPoss")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{,}+", 1, RegExMessages.get_string("displayString_leastPoss"), RegExMessages.get_string("additionalInfo_leastPoss")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("{,}+", 1, RegExMessages.get_string("displayString_countPoss"), RegExMessages.get_string("additionalInfo_countPoss")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            # alternative
            add_bracket_proposal("|", 1, RegExMessages.get_string("displayString_alt"), RegExMessages.get_string("additionalInfo_alt")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          end
          @f_priority_proposals.add_all(@f_proposals)
          return @f_priority_proposals.to_array(Array.typed(self.class::IContentProposal).new(@f_proposals.size) { nil })
        end
        
        typesig { [] }
        # Computes applicable proposals for the replace field.
        # @return the proposals
        def compute_replace_proposals
          if (@f_document_offset > 0 && (Character.new(?$.ord)).equal?(@f_expression.char_at(@f_document_offset - 1)))
            add_proposal("", RegExMessages.get_string("displayString_dollar"), RegExMessages.get_string("additionalInfo_dollar")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          else
            if (!@f_is_escape)
              add_proposal("$", RegExMessages.get_string("displayString_dollar"), RegExMessages.get_string("additionalInfo_dollar"))
            end # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\", RegExMessages.get_string("displayString_replace_cap"), RegExMessages.get_string("additionalInfo_replace_cap")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\", RegExMessages.get_string("displayString_replace_bs"), RegExMessages.get_string("additionalInfo_replace_bs")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\R", RegExMessages.get_string("displayString_replace_bs_R"), RegExMessages.get_string("additionalInfo_replace_bs_R")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("\\x", 2, RegExMessages.get_string("displayString_bs_x"), RegExMessages.get_string("additionalInfo_bs_x")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("\\u", 2, RegExMessages.get_string("displayString_bs_u"), RegExMessages.get_string("additionalInfo_bs_u")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\t", RegExMessages.get_string("displayString_bs_t"), RegExMessages.get_string("additionalInfo_bs_t")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\n", RegExMessages.get_string("displayString_replace_bs_n"), RegExMessages.get_string("additionalInfo_replace_bs_n")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\r", RegExMessages.get_string("displayString_replace_bs_r"), RegExMessages.get_string("additionalInfo_replace_bs_r")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\f", RegExMessages.get_string("displayString_bs_f"), RegExMessages.get_string("additionalInfo_bs_f")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\a", RegExMessages.get_string("displayString_bs_a"), RegExMessages.get_string("additionalInfo_bs_a")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\e", RegExMessages.get_string("displayString_bs_e"), RegExMessages.get_string("additionalInfo_bs_e")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bracket_proposal("\\c", 2, RegExMessages.get_string("displayString_bs_c"), RegExMessages.get_string("additionalInfo_bs_c")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            add_bs_proposal("\\C", RegExMessages.get_string("displayString_replace_bs_C"), RegExMessages.get_string("additionalInfo_replace_bs_C")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
          end
          @f_priority_proposals.add_all(@f_proposals)
          return @f_priority_proposals.to_array(Array.typed(self.class::IContentProposal).new(@f_priority_proposals.size) { nil })
        end
        
        typesig { [String, String, String] }
        # Adds a proposal.
        # 
        # @param proposal the string to be inserted
        # @param displayString the proposal's label
        # @param additionalInfo the additional information
        def add_proposal(proposal, display_string, additional_info)
          @f_proposals.add(self.class::Proposal.new(proposal, display_string, additional_info, proposal.length))
        end
        
        typesig { [String, ::Java::Int, String, String] }
        # Adds a proposal.
        # 
        # @param proposal the string to be inserted
        # @param cursorPosition the cursor position after insertion,
        # relative to the start of the proposal
        # @param displayString the proposal's label
        # @param additionalInfo the additional information
        def add_proposal(proposal, cursor_position, display_string, additional_info)
          @f_proposals.add(self.class::Proposal.new(proposal, display_string, additional_info, cursor_position))
        end
        
        typesig { [String, String, String] }
        # Adds a proposal to the priority proposals list.
        # 
        # @param proposal the string to be inserted
        # @param displayString the proposal's label
        # @param additionalInfo the additional information
        def add_priority_proposal(proposal, display_string, additional_info)
          @f_priority_proposals.add(self.class::Proposal.new(proposal, display_string, additional_info, proposal.length))
        end
        
        typesig { [String, ::Java::Int, String, String] }
        # Adds a proposal. Ensures that existing pre- and postfixes are not duplicated.
        # 
        # @param proposal the string to be inserted
        # @param cursorPosition the cursor position after insertion,
        # relative to the start of the proposal
        # @param displayString the proposal's label
        # @param additionalInfo the additional information
        def add_bracket_proposal(proposal, cursor_position, display_string, additional_info)
          prolog = @f_expression.substring(0, @f_document_offset)
          if (!@f_is_escape && prolog.ends_with("\\") && proposal.starts_with("\\"))
            # $NON-NLS-1$//$NON-NLS-2$
            @f_proposals.add(self.class::Proposal.new(proposal, display_string, additional_info, cursor_position))
            return
          end
          i = 1
          while i <= cursor_position
            prefix = proposal.substring(0, i)
            if (prolog.ends_with(prefix))
              postfix = proposal.substring(cursor_position)
              epilog = @f_expression.substring(@f_document_offset)
              if (epilog.starts_with(postfix))
                @f_priority_proposals.add(self.class::Proposal.new(proposal.substring(i, cursor_position), display_string, additional_info, cursor_position - i))
              else
                @f_priority_proposals.add(self.class::Proposal.new(proposal.substring(i), display_string, additional_info, cursor_position - i))
              end
              return
            end
            i += 1
          end
          @f_proposals.add(self.class::Proposal.new(proposal, display_string, additional_info, cursor_position))
        end
        
        typesig { [String, String, String] }
        # Adds a proposal that starts with a backslash.
        # Ensures that the backslash is not repeated if already typed.
        # 
        # @param proposal the string to be inserted
        # @param displayString the proposal's label
        # @param additionalInfo the additional information
        def add_bs_proposal(proposal, display_string, additional_info)
          prolog = @f_expression.substring(0, @f_document_offset)
          position = proposal.length
          # If the string already contains the backslash, do not include in the proposal
          if (prolog.ends_with("\\"))
            # $NON-NLS-1$
            position -= 1
            proposal = RJava.cast_to_string(proposal.substring(1))
          end
          if (@f_is_escape)
            @f_priority_proposals.add(self.class::Proposal.new(proposal, display_string, additional_info, position))
          else
            add_proposal(proposal, position, display_string, additional_info)
          end
        end
        
        private
        alias_method :initialize__proposal_computer, :initialize
      end }
    }
    
    # <code>true</code> iff the processor is for the find field.
    # <code>false</code> iff the processor is for the replace field.
    attr_accessor :f_is_find
    alias_method :attr_f_is_find, :f_is_find
    undef_method :f_is_find
    alias_method :attr_f_is_find=, :f_is_find=
    undef_method :f_is_find=
    
    typesig { [::Java::Boolean] }
    # Creates a new completion proposal provider.
    # 
    # @param isFind <code>true</code> if the provider is used for the 'find' field
    # <code>false</code> if the provider is used for the 'replace' field
    def initialize(is_find)
      @f_is_find = false
      @f_is_find = is_find
    end
    
    typesig { [String, ::Java::Int] }
    # @see org.eclipse.jface.fieldassist.IContentProposalProvider#getProposals(java.lang.String, int)
    def get_proposals(contents, position)
      if (@f_is_find)
        return ProposalComputer.new(contents, position).compute_find_proposals
      end
      return ProposalComputer.new(contents, position).compute_replace_proposals
    end
    
    private
    alias_method :initialize__find_replace_document_adapter_content_proposal_provider, :initialize
  end
  
end
