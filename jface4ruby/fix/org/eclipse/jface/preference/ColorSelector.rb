class Org::Eclipse::Jface::Preference::ColorSelector
  # Notification that a property has changed.
  def on_property_change(&block)
    add_listener Swt4Ruby::Listener.new(:property_change, &block)
  end
end
