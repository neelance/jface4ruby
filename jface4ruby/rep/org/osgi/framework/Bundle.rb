class Org::Osgi::Framework::Bundle
  class_module.module_eval {
    def get_string(key)
      raise NotImplementedError
    end
  }
end
