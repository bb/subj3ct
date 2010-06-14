# subj3ct - The DNS for the Semantic Web

This is a Ruby adapter for the subj3ct.com webservice.

Subj3ct is an infrastructure technology for Web 3.0 applications. These are
applications that are organised around subjects and semantics rather than
documents and links. Subj3ct provides the technology and services to enable
Web 3.0 applications to define and exchange subject definitions.

Or in other words: Subj3ct.com is for the Semantic Web what DNS is for the internet.

## Quick Links

 * [Subj3ct.com](http://www.subj3ct.com/)
 * [Wiki](http://wiki.github.com/bb/subj3ct)
 * [Bugs](http://github.com/bb/subj3ct/issues)
 * [Gem](http://rubygems.org/gems/subj3ct)

## Installing

Install the gem:

    gem install subj3ct

## Usage

First, you have to require the library in your Ruby project (or directly in IRB):

    require 'subj3ct'

Then you can query the subj3ct.com webservice with different queries:

Query a specific subject - to be specific: its subject identity record -  using it's identifier:

     Subj3ct.identifier("http://www.topicmapslab.de/publications/TMRA_2009_subj3ct_a_subject_identity_resolution_service")

Query all subjects associated with a given resource (i.e. with a given web address). The result is a list of subjects (without representation or equivalence statements):

     Subj3ct.resource("http://en.wikipedia.org/wiki/Topic_Maps")

To get the representation and equivalence statements for one of the results you can fetch the complete subject record:

    result = Subj3ct.resource("http://en.wikipedia.org/wiki/Topic_Maps")
    full_subject = result.subjects.first.fetch

If you don't know a web address or identifier URI for the thing you're interested in, try a full text search:

    Subj3ct.search("my query")

To query a specific number of items at a time, the query methods `identifier`, `resource`, `starts_with` and `search` accept a keyword parameter `:take` to specify the maximum number of items to query. The maximum allowed take is 50.
To display the results paginated, an offset, may be passed using the `:skip` keyword. The search results also feature methods like `fetch_next` to get the next page etc.. The following example fetches the first 5 pages, each page showing 3 results, then it fetches page 20:

    result = Subj3ct.search("benjamin bock", :take => 3)
    while result.next? && result.current_page < 5
       result = result.fetch_next
    end
    
    result.fetch_page(20)

## Subj3ct vs. Subject

The official name is "Subj3ct", however in this API, you can also use "Subject" which may be easier to remember or to type for normal, n0n-1337 people. It should work for the gem, for the require and for the main module.

## Plans

 * starts_with doesn't work at all. It looks like this is a server side problem.
 * Documentation. Currently the code is barely documented, this should be changed soon.
 * Write tests. Uh... of course we have tests... they're almost done...
 * Write support. Currently this lib is only reading subj3ct.com. It should be able to register feeds with the service and to create a feed from existing data.
 * Caching. A minimal caching solution should be built in.
 * Reduce dependencies. Currently this lib uses active_support only for `blank?`. Instead of open-uri a direct HTTP call could be done.
 * Threadsafe use of unencrypted and SSL usage in parallel. Due to the current architecture, you can't do SSL-encrypted and unencrypted queries in parallel in a threadsafe way. To work around that, the class methods should be moved to a query processor which should be instantiated and configured if this is needed.

## Contribute!

Subj3ct is a young and ambitious service. It's free, will stay free and needs your help. Contribute to this library! Create bindings for other languages! Publish your data as linked data to the web and register it with subj3ct.com.

## Note on Patches/Pull Requests
 
 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a future version unintentionally.
 * Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
 * Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Benjamin Bock, [Topic Maps Lab](http://www.topicmapslab.de/). See LICENSE for details.
