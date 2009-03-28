# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{zerg_xcode}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Costan"]
  s.date = %q{2009-03-28}
  s.default_executable = %q{bin/zerg-xcode}
  s.description = %q{Automated modifications for Xcode project files}
  s.email = %q{victor@zergling.net}
  s.executables = ["zerg-xcode"]
  s.extra_rdoc_files = ["bin/zerg-xcode", "CHANGELOG", "lib/zerg_xcode/file_format/archiver.rb", "lib/zerg_xcode/file_format/encoder.rb", "lib/zerg_xcode/file_format/lexer.rb", "lib/zerg_xcode/file_format/parser.rb", "lib/zerg_xcode/file_format/paths.rb", "lib/zerg_xcode/objects/pbx_build_file.rb", "lib/zerg_xcode/objects/pbx_build_phase.rb", "lib/zerg_xcode/objects/pbx_container_item_proxy.rb", "lib/zerg_xcode/objects/pbx_group.rb", "lib/zerg_xcode/objects/pbx_native_target.rb", "lib/zerg_xcode/objects/pbx_project.rb", "lib/zerg_xcode/objects/pbx_target_dependency.rb", "lib/zerg_xcode/objects/xc_configuration_list.rb", "lib/zerg_xcode/objects/xcode_object.rb", "lib/zerg_xcode/plugins/addlibrary.rb", "lib/zerg_xcode/plugins/core/core.rb", "lib/zerg_xcode/plugins/help.rb", "lib/zerg_xcode/plugins/import.rb", "lib/zerg_xcode/plugins/irb.rb", "lib/zerg_xcode/plugins/ls.rb", "lib/zerg_xcode/plugins/lstargets.rb", "lib/zerg_xcode/plugins/retarget.rb", "lib/zerg_xcode/shortcuts.rb", "lib/zerg_xcode.rb", "LICENSE", "README.textile"]
  s.files = ["bin/zerg-xcode", "CHANGELOG", "lib/zerg_xcode/file_format/archiver.rb", "lib/zerg_xcode/file_format/encoder.rb", "lib/zerg_xcode/file_format/lexer.rb", "lib/zerg_xcode/file_format/parser.rb", "lib/zerg_xcode/file_format/paths.rb", "lib/zerg_xcode/objects/pbx_build_file.rb", "lib/zerg_xcode/objects/pbx_build_phase.rb", "lib/zerg_xcode/objects/pbx_container_item_proxy.rb", "lib/zerg_xcode/objects/pbx_group.rb", "lib/zerg_xcode/objects/pbx_native_target.rb", "lib/zerg_xcode/objects/pbx_project.rb", "lib/zerg_xcode/objects/pbx_target_dependency.rb", "lib/zerg_xcode/objects/xc_configuration_list.rb", "lib/zerg_xcode/objects/xcode_object.rb", "lib/zerg_xcode/plugins/addlibrary.rb", "lib/zerg_xcode/plugins/core/core.rb", "lib/zerg_xcode/plugins/help.rb", "lib/zerg_xcode/plugins/import.rb", "lib/zerg_xcode/plugins/irb.rb", "lib/zerg_xcode/plugins/ls.rb", "lib/zerg_xcode/plugins/lstargets.rb", "lib/zerg_xcode/plugins/retarget.rb", "lib/zerg_xcode/shortcuts.rb", "lib/zerg_xcode.rb", "LICENSE", "Manifest", "Rakefile", "README.textile", "RUBYFORGE", "test/file_format/archiver_test.rb", "test/file_format/encoder_test.rb", "test/file_format/lexer_test.rb", "test/file_format/parser_test.rb", "test/file_format/path_test.rb", "test/objects/pbx_build_file_test.rb", "test/objects/pbx_build_phase_test.rb", "test/objects/pbx_container_item_proxy_test.rb", "test/objects/pbx_group_test.rb", "test/objects/pbx_native_target_test.rb", "test/objects/pbx_project_test.rb", "test/objects/pbx_target_dependency_test.rb", "test/objects/xc_configuration_list_test.rb", "test/objects/xcode_object_test.rb", "test/plugins/core/core_test.rb", "test/plugins/import_test.rb", "test/plugins/irb_test.rb", "test/plugins/ls_test.rb", "test/plugins/lstargets_test.rb", "test/plugins/retarget_test.rb", "test/plugins/test_helper.rb", "test/shortcuts_test.rb", "testdata/FlatTestApp/FlatTestApp.xcodeproj/project.pbxproj", "testdata/project.pbxproj", "testdata/project.pbxproj.compat", "testdata/TestApp/TestApp.xcodeproj/project.pbxproj", "testdata/ZergSupport.xcodeproj/project.pbxproj", "zerg_xcode.gemspec", "test/plugins/addlibrary_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://www.zergling.net/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Zerg_xcode", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{zerglings}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Automated modifications for Xcode project files}
  s.test_files = ["test/file_format/archiver_test.rb", "test/file_format/encoder_test.rb", "test/file_format/lexer_test.rb", "test/file_format/parser_test.rb", "test/file_format/path_test.rb", "test/objects/pbx_build_file_test.rb", "test/objects/pbx_build_phase_test.rb", "test/objects/pbx_container_item_proxy_test.rb", "test/objects/pbx_group_test.rb", "test/objects/pbx_native_target_test.rb", "test/objects/pbx_project_test.rb", "test/objects/pbx_target_dependency_test.rb", "test/objects/xc_configuration_list_test.rb", "test/objects/xcode_object_test.rb", "test/plugins/addlibrary_test.rb", "test/plugins/core/core_test.rb", "test/plugins/import_test.rb", "test/plugins/irb_test.rb", "test/plugins/ls_test.rb", "test/plugins/lstargets_test.rb", "test/plugins/retarget_test.rb", "test/plugins/test_helper.rb", "test/shortcuts_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
