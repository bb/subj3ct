begin
  require 'subj3ct'
rescue LoadError
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
  retry
end