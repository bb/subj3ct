# A Ruby API for the subj3ct.com webservice.
module Subj3ct
  DEFAULT_API_BASE = "http://api.subj3ct.com/subjects"
  DEFAULT_SECURE_API_BASE = DEFAULT_API_BASE.sub(/\Ahttp:/, "https:")
end
Subject = Subj3ct

begin
  require 'subj3ct/query'
  require 'subj3ct/register'
  require 'subj3ct/feed'
rescue LoadError
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
  retry
end