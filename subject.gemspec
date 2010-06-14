# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{subject}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Benjamin Bock"]
  s.date = %q{2010-06-15}
  s.description = %q{==== subj3ct - The DNS for the Semantic Web

This is a Ruby adapter for the subj3ct.com webservice.

Subj3ct is an infrastructure technology for Web 3.0 applications. These are
applications that are organised around subjects and semantics rather than
documents and links. Subj3ct provides the technology and services to enable
Web 3.0 applications to define and exchange subject definitions.

Or in other words: Subj3ct.com is for the Semantic Web what DNS is for the internet.

==== Installing

Install the gem:

    gem install subj3ct

==== Usage

Query a specific subject - to be specific: its subject identity record -  using it's identifier:

 Subj3ct.identifier("http://www.topicmapslab.de/publications/TMRA_2009_subj3ct_a_subject_identity_resolution_service")

See the README or the github page for more examples.

==== Subj3ct vs. Subject

The official name is "Subj3ct", however in this API, you can also use "Subject" which may be easier to remember or to type for normal, n0n-1337 people. It should work for the gem, for the require and for the main module.

==== Contribute!

Subj3ct is a young and ambitious service. It's free, will stay free and needs your help. Contribute to this library! Create bindings for other languages! Publish your data as linked data to the web and register it with subj3ct.com.

==== Note on Patches/Pull Requests
 
 * Fork the project on http://github.bb/subj3ct
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a future version unintentionally.
 * Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
 * Send me a pull request. Bonus points for topic branches.

==== Copyright

Copyright (c) 2010 Benjamin Bock, Topic Maps Lab. See LICENSE for details.
}
  s.email = %q{bb--github.com@bock.be}
  s.extra_rdoc_files = [
    "LICENSE", "README.markdown"
  ]
  
  s.homepage = %q{http://github.com/bb/subj3ct}
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby bindings for Subj3ct.com, the DNS for the semantic web.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
  s.add_dependency(%q<subj3ct>, [">= 0.0.1"])
end

