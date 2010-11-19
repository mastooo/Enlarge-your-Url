require 'rubygems'
require 'net/https'

# This class is a little helper to get the real url behind a short one. Basically, it just
# follows the redirection a url shortener service send back when we request it with a short url.
# If the provided url is not a short one (ie it's a regular url), then it's returned unchanged.
# Warning: if the provided url is not from a shortener service but still do a redirection, then the returned
# url wll be the new location, not the provided one.
class UrlEnlarger

  # This class method expands the url passed as argument.
  def self.enlarge(url)
    if url.nil?
      return url
    end
    
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme =~ /https/i
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
    end

    # We just request the HEAD, which can save bandwidth it the url is not a short one
    request = Net::HTTP::Head.new(uri.request_uri)
    
    # We let the caller deal with failure
    response = http.request(request)

    # got ourself in the middle of a redirection
    if response.kind_of? Net::HTTPRedirection
      redirect_url = response['location']
      
      # redirect_url can be to relative pages
      if (redirect_url  =~ /\Ahttps?/i).nil?
        rindex = url.rindex '/'
        redirect_url = url[0, rindex+1] + redirect_url
      end
    else
      # No redirection -> the url is already a long one
      url
    end
  end
end