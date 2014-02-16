module SCSSLint
  # Loader class for adding custom lints to the lint registry
  module PluginLoader
    class << self
      def load(lint_dir)
        # Use the same sorted loading behavior as the built-in linters
        Dir[File.expand_path(lint_dir)].sort.each do |file|
          require file
        end
      end
    end
  end
end
