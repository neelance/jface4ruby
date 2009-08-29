require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Chris Gross (schtoo@schtoo.com) - initial API and implementation
# (bug 49497 [RCP] JFace dependency on org.eclipse.core.runtime enlarges standalone JFace applications)
module Org::Eclipse::Jface::Util
  module ISafeRunnableRunnerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Core::Runtime, :ISafeRunnable
    }
  end
  
  # Runs a safe runnables.
  # <p>
  # Clients may provide their own implementation to change
  # how safe runnables are run from within JFace.
  # </p>
  # 
  # @see SafeRunnable#getRunner()
  # @see SafeRunnable#setRunner(ISafeRunnableRunner)
  # @see SafeRunnable#run(ISafeRunnable)
  # @since 3.1
  module ISafeRunnableRunner
    include_class_members ISafeRunnableRunnerImports
    
    typesig { [ISafeRunnable] }
    # Runs the runnable.  All <code>ISafeRunnableRunners</code> must catch any exception
    # thrown by the <code>ISafeRunnable</code> and pass the exception to
    # <code>ISafeRunnable.handleException()</code>.
    # @param code the code executed as a save runnable
    # 
    # @see SafeRunnable#run(ISafeRunnable)
    def run(code)
      raise NotImplementedError
    end
  end
  
end
