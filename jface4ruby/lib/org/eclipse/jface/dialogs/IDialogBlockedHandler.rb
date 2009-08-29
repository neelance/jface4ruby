require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module IDialogBlockedHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Jface::Wizard, :WizardDialog
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # The IDialogBlockedHandler is the handler used by
  # JFace to provide extra information when a
  # blocking has occured. There is one static instance
  # of this class used by WizardDialog and ModalContext.
  # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#clearBlocked()
  # @see  org.eclipse.core.runtime.IProgressMonitorWithBlocking#setBlocked(IStatus)
  # @see WizardDialog
  # @since 3.0
  module IDialogBlockedHandler
    include_class_members IDialogBlockedHandlerImports
    
    typesig { [] }
    # The blockage has been cleared. Clear the
    # extra information and resume.
    def clear_blocked
      raise NotImplementedError
    end
    
    typesig { [Shell, IProgressMonitor, IStatus, String] }
    # A blockage has occured. Show the blockage and
    # forward any actions to blockingMonitor.
    # <b>NOTE:</b> This will open any blocked notification immediately
    # even if there is a modal shell open.
    # 
    # @param parentShell The shell this is being sent from. If the parent
    # shell is <code>null</code> the behavior will be the same as
    # IDialogBlockedHandler#showBlocked(IProgressMonitor, IStatus, String)
    # 
    # @param blocking The monitor to forward to. This is most
    # important for calls to <code>cancel()</code>.
    # @param blockingStatus The status that describes the blockage
    # @param blockedName The name of the locked operation.
    # @see IDialogBlockedHandler#showBlocked(IProgressMonitor, IStatus, String)
    def show_blocked(parent_shell, blocking, blocking_status, blocked_name)
      raise NotImplementedError
    end
    
    typesig { [IProgressMonitor, IStatus, String] }
    # A blockage has occured. Show the blockage when there is
    # no longer any modal shells in the UI and forward any actions
    # to blockingMonitor.
    # 
    # <b>NOTE:</b> As no shell has been specified this method will
    # not open any blocked notification until all other modal shells
    # have been closed.
    # 
    # @param blocking The monitor to forward to. This is most
    # important for calls to <code>cancel()</code>.
    # @param blockingStatus The status that describes the blockage
    # @param blockedName The name of the locked operation.
    def show_blocked(blocking, blocking_status, blocked_name)
      raise NotImplementedError
    end
  end
  
end
