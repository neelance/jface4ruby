/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
package org.eclipse.jface.text;


/**
 * The default implementation of the {@link org.eclipse.jface.text.IRegion} interface.
 */
public class Region implements IRegion {

	/** The region offset */
	private int fOffset;
	/** The region length */
	private int fLength;

	/**
	 * Create a new region.
	 *
	 * @param offset the offset of the region
	 * @param length the length of the region
	 */
	public Region(int offset, int length) {
		fOffset= offset;
		fLength= length;
	}

	/*
	 * @see org.eclipse.jface.text.IRegion#getLength()
	 */
	public int getLength() {
		return fLength;
	}

	/*
	 * @see org.eclipse.jface.text.IRegion#getOffset()
	 */
	public int getOffset() {
		return fOffset;
	}

	/*
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object o) {
	 	if (o instanceof IRegion) {
	 		IRegion r= (IRegion) o;
	 		return r.getOffset() == fOffset && r.getLength() == fLength;
	 	}
	 	return false;
	}

	/*
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode() {
	 	return (fOffset << 24) | (fLength << 16);
	}

	/*
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return "offset: " + fOffset + ", length: " + fLength; //$NON-NLS-1$ //$NON-NLS-2$;
	}
}
