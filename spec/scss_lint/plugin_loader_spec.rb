require 'spec_helper'

describe SCSSLint::PluginLoader do
  describe '.load' do
    include_context 'isolated environment'

    module FakeLinter
      class FakeLint < SCSSLint::Linter; end
    end

    before do
      root = File.join(ENV['HOME'], '.scss-lints')
      Dir.mkdir(root)
      File.open(File.join(root, 'test_lint.rb'), 'w') do |file|
        file.write(<<-'LINT')
          module FakeLinter
            class FakeLint < SCSSLint::Linter
              include SCSSLint::LinterRegistry

              def visit_prop(node)
                add_lint(node)
              end

              def description
                'I am a fake lint'
              end
            end
          end
        LINT
      end
    end

    it 'loads files specified by a matcher' do
      file_matcher = File.join(ENV['HOME'], '.scss-lints', '**/*.rb')
      SCSSLint::PluginLoader.load(file_matcher)

      SCSSLint::LinterRegistry.linters.should include(FakeLinter::FakeLint)
    end
  end
end
