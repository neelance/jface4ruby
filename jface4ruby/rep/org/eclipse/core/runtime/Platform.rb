class Org::Eclipse::Core::Runtime::Platform
  class ExtensionRegistryMock
    def get_configuration_elements_for(name)
      []
    end
  end

  class AdapterManagerMock
    def get_adapter(source_object, adapter_type)
      nil
    end
  end

  class_module.module_eval {
    def get_debug_option(name)
      nil
    end

    def get_extension_registry
      @extension_registry ||= ExtensionRegistryMock.new
    end

    def get_bundle(bundle_id)
      nil
    end

    def get_adapter_manager
      @adapter_manager ||= AdapterManagerMock.new
    end

    def run(runnable)
      runnable.run
    end
  }
end
