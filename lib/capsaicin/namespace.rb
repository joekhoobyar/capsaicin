module Capsaicin

  module Namespace
    
    # Redefine settings for the duration of an existing task.
    def task_settings(task, vars)
      orig_vars = vars.keys.select { |k| exists? k }.inject({}) { |h,k| h[k] = variables[k]; h }
      orig_body = tasks[task].body
      tasks[task].instance_variable_set(:@body, lambda do
        vars.each { |k,v| Proc===v ? set(k, &v) : set(k, v) }
        begin
          orig_body.call
        ensure
	        vars.keys.each do |k|
            if ! orig_vars.include? k
              variables.delete k
            else
              v = orig_vars[k]
              Proc===v ? set(k, &v) : set(k, v)
            end
          end
        end
      end)
    end

	  # Undefine tasks in a namespace.
	  def undef_tasks(name, list)
	    namespace name do
	      metaclass = class << self; self; end
	      list.each do |k|
	        k = k.to_sym  
	        metaclass.send(:undef_method, k)
	        tasks.delete k
	      end
	    end
	  end
	
	  # Override tasks in a namespace to a NOOP.
	  def noop_tasks(name, list)
	    namespace name do
	      metaclass = class << self; self; end
	      list.each do |k|
	        tasks[k.to_sym].instance_variable_set(:@body, lambda {})
	      end
	    end
	  end
	end
end
