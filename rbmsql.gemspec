Gem::Specification.new do |s|
  s.name = %q{rbmsql}
  s.version = "0.0.0"
  s.date = %q{2015-08-21}
  s.authors = ["zp yuan"]
  s.summary = %q{statistcs for chrome bookmark}
  s.files = Dir.glob('lib/*').push('bin/rbmsql') 
  s.require_paths = ["lib"]
  s.executables = ["rbmsql"]
end
