require 'active_support/core_ext/object/blank'
require 'open-uri'
require 'json'
require 'cgi'

module Subj3ct
  # Query the subj3ct.com API
  module Query
    # identifier: Must be a URI value. Used to identify the subject to return. It is important that this value is URL encoded.
    # [optional] format: Allowed values are [default]'xml', 'json', 'atom', 'rss', 'xtm10', 'skos'. Used to indicate the representation format to be returned.
    # [optional] callback: Any string that will be used to wrap the json returned. Ignored if the format value is not 'json'
    # [optional, use array for multiple] provenance: Must be a URI value. All statements of equivalence are defined by some source. This source is known as the statements' provenance and is identified by a URI. Passing in one or more provenance parameters will limit the set of equivalent identifiers and web resources to only the ones defined by that provenance(s).
    def identifier(identifier, params={})
      SubjectIdentityRecord.new(request("", params.merge(:identifier => identifier)))
    end

    # uri: Must be a URI value. All subjects that have this resource associated with it will be returned.
    # [optional] skip: An integer value that indicates how many results to skip before the service starts returning results.
    # [optional] take: An integer value that indicates how many results to take and return. [Default = 10, Max Cut Off = 50]
    # [optional] format: Allowed values are [default]'xml', 'json'. Used to indicate the representation format to be returned.
    # [optional] callback: Any string that will be used to wrap the json returned. Ignored if the format value is not 'json'
    def resource(representationUri, params={})
      SearchResult.new(request("/webaddresses", params.merge(:uri => representationUri)))
    end

    # uriStartsWith: Must be a URI value. All subjects whose identifier starts with the URI provided are returned.
    # [optional] skip: An integer value that indicates how many results to skip before the service starts returning results.
    # [optional] take: An integer value that indicates how many results to take and return. [Default = 10, Max Cut Off = 50]
    # [optional] format: Allowed values are [default]'xml', 'json'. Used to indicate the representation format to be returned.
    # [optional] callback: Any string that will be used to wrap the json returned. Ignored if the format value is not 'json'
    def starts_with(uri, params={})
      SearchResult.new(request("/identifiers", params.merge(:uriStartsWith => uri)))
    end

    # query: String value. The query term is used to search the subjects to find matches based on name, description and identifier. For more information and syntax for advanced options please see the guide on portal search options.
    # [optional] skip: An integer value that indicates how many results to skip before the service starts returning results.
    # [optional] take: An integer value that indicates how many results to take and return. [Default = 10, Max Cut Off = 50]
    # [optional] format: Allowed values are [default]'xml', 'json', 'atom'. Used to indicate the representation format to be returned.
    # [optional] callback: Any string that will be used to wrap the json returned. Ignored if the format value is not 'json'
    def search(query, params={})
      SearchResult.new(request("/search", params.merge(:query => query)))
    end

    def api_base=(new_base)
      @custom_api_base = new_base
      @secure_custom_api_base = new_base.sub(/\Ahttp:/, "https:")
    end

    attr_accessor :secure
    alias :secure? :secure

    def api_base(secure=false)
      if secure
        @secure_custom_api_base || DEFAULT_SECURE_API_BASE
      else
        @custom_api_base || DEFAULT_API_BASE
      end
    end

    def request(method, params)
      result = JSON.parse(raw_request(method, params))
      result[:method] = method
      result[:take] = params[:take] || 50
      result
    end

    def raw_request(method, params)
      begin
        uri = request_uri(method, params)
        open(uri).read
      rescue OpenURI::HTTPError => e
        raise Subj3ctException.new("Subj3ct returned an HTTP Error on query #{uri}")
      end
    end

    def request_uri(method, params={})
      query_params = params
      query_params[:format] ||= "json"
      query_params[:identifier] = CGI.escape(query_params[:identifier]) if query_params.key?(:identifier)
      query_params[:uri] = CGI.escape(query_params[:uri]) if query_params.key?(:uri)
      query_params[:query] = CGI.escape(query_params[:query]) if query_params.key?(:query)
      query_string = params.reject{|key,value| key.blank? || value.blank?}.
        map{|k,v|
          if v.is_a? Array
            v.map{|vi| "#{k}=#{vi}" }.join("&")
          else
            "#{k}=#{v}"
          end
        }.join("&")
      return "#{api_base(secure?)}#{method}?#{query_string}"
    end
    
    class Result
      def self.abstract?
        self == Result
      end
    end
    
    class SubjectIdentityRecord < Result
      attr_reader :trust, :name, :provenance, :equivalences, :representations, :description, :identifier, :record_link

      # The initialization hash is the parsed JSON from a identity query to subj3ct.com
      def initialize(result)
        @trust       = result["Trust"]
        @record_link = result["RecordLink"]
        @name        = result["Name"]
        @description = result["Description"]
        @provenance  = result["Provenance"]
        @identifier  = result["Identifier"]
        @representation_uri = result["RepresentationUri"]

        @equivalences = (result["EquivalenceStatements"] || []).map do |eqiv|
          EquivalenceStatement.new(eqiv)
        end
        @representations = (result["RepresentationStatements"] || []).map do |rep|
          RepresentationStatement.new(rep)
        end
        @result = result
      end
    end

    class SearchResult < Result
      attr_reader :total, :skipped, :taken, :query, :subjects, :request_method
      # The initialization hash is the parsed JSON hash from a query to subj3ct.com
      def initialize(result)
        @total    = result["TotalNumberResults"] || 0
        @skipped  = result["Skipped"] || 0
        @taken    = result["Taken"] || 50
        @query    = result["Query"] if result["Query"]
        @request_method = result[:method]
        @request_take = result[:take]

        @subjects = (result["Subjects"] || []).map do |subject_hash|
          SubjectResult.new(subject_hash)
        end
      end
      
      def size
        @subjects.size
      end
      
      # Fetches the details for all subjects on the current page
      def fetch_all
        @subjects.map {|subject| subject.fetch}
      end
      
      # Fetches the next page (or the one starting at the given record number)
      def fetch_next(start_record=skipped+@request_take)
        SearchResult.new(Subj3ct.request(@request_method, :query => query, :skip => start_record, :take => @request_take))
      end
      
      # Fetches the next page of results (or any given page using the page number provided.)
      def fetch_page(page_num=current_page+1)
        fetch_next((page_num-1)*@request_take)
      end
      
      # returns the number of the current page (1-based)
      def current_page
        (skipped / @request_take) + 1
      end
      
      # returns the number of the last page (1-based)
      def last_page
        (total / @request_take) + (((total % @request_take) == 0) ? 0 : 1)
      end
      
      # Returns true if there are more pages to fetch
      def next?
        !last?
      end
      
      # Returns true if we're on the last page
      def last?
        current_page == last_page
      end
    end

    class SubjectResult
      attr_reader :trust, :record_link, :name, :description, :identifier
      def initialize(subject_hash)
        @trust       = subject_hash["Trust"]
        @record_link = subject_hash["RecordLink"]
        @name        = subject_hash["Name"]
        @description = subject_hash["Description"]
        @identifier  = subject_hash["Identifier"]
      end

      def fetch
        Subj3ct.identifier(@identifier)
      end
    end

    class RepresentationStatement
      attr_reader :trust, :provenance, :representation_uri
      def initialize(rep_hash)
        @trust = rep_hash["Trust"]
        @provenance = rep_hash["Provenance"]
        @representation_uri = rep_hash["RepresentationUri"]
      end

      def fetch
        Subject.resource(@representation_uri)
      end
    end

    class EquivalenceStatement
      attr_reader :trust, :provenance, :equivalent_identifier
      def initialize(equiv_hash)
        @trust = equiv_hash["Trust"]
        @provenance = equiv_hash["Provenance"]
        @equivalent_identifier = equiv_hash["EquivalentIdentifier"]
      end

      def fetch
        Subj3ct.identifier(@equivalent_identifier)
      end
    end
    class Subj3ctException < Exception;end
  end
  extend Query
end