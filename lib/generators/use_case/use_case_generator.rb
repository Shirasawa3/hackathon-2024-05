# frozen_string_literal: true

class UseCaseGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_use_case_file
    template 'use_case.rb.erb', File.join('app/use_cases', class_path, "#{file_name}_use_case.rb")
    template 'use_case_test.rb.erb', File.join('test/use_cases', class_path, "#{file_name}_use_case_test.rb")
  end
end
