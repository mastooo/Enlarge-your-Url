require 'url_enlarger.rb'
require 'fakeweb'

FakeWeb.register_uri(:get, 'http://bit.ly/bKb1M9', :response => File.read("#{File.dirname(__FILE__)}/fixtures/bit_ly.txt"))
FakeWeb.register_uri(:get, %r{http://feedproxy.google.com}, :response => File.read("#{File.dirname(__FILE__)}/fixtures/feedproxy.txt"))
FakeWeb.register_uri(:get, 'http://j.mp/bAgcXr', :response => File.read("#{File.dirname(__FILE__)}/fixtures/jm_p.txt"))
FakeWeb.register_uri(:get, 'http://tcrn.ch/chwzEr', :response => File.read("#{File.dirname(__FILE__)}/fixtures/tcrn_ch.txt"))
FakeWeb.register_uri(:get,  %r{http://techcrunch.com}, :response => File.read("#{File.dirname(__FILE__)}/fixtures/techcrunch_get.txt"))
FakeWeb.register_uri(:head,  %r{http://techcrunch.com}, :response => File.read("#{File.dirname(__FILE__)}/fixtures/techcrunch_head.txt"))

describe UrlEnlarger do
  
  it "should raise an exception when passed nil" do
    lambda {UrlEnlarger.enlarge(nil)}.should raise_error(URI::InvalidURIError)
  end
  
  it "should raise an exception when passed an empty url" do
    lambda {UrlEnlarger.enlarge("")}.should raise_error(URI::InvalidURIError)
  end
  
  it "should raise an exception when passed an invalid url" do
    lambda {UrlEnlarger.enlarge("absc.c")}.should raise_error(URI::InvalidURIError)
  end
  
  it "should raise a socket error when passed a valid url that does not exist" do
    lambda {UrlEnlarger.enlarge("http://absczzz.com")}.should raise_error(SocketError, /.*getaddrinfo.*/)
  end
  
  it "should return the location when the response to the request is a redirect (bit.ly) with feedproxy" do
    UrlEnlarger.enlarge('http://bit.ly/bKb1M9').should == "http://37signals.com/svn/posts/2636-the-things-you-do-more-often-are-the-things?utm_source=twitterfeed"
  end
  
  it "should return the location when the response to the request is a redirect (j.mp)" do
    UrlEnlarger.enlarge('http://j.mp/bAgcXr').should == "http://sr3d.github.com/GithubFinder/?utm_source=bml&user_id=sr3d&repo=GithubFinder"
  end
  
  it "should return the location when the response to the request is a redirect (tcrn_ch)" do
    UrlEnlarger.enlarge('http://tcrn.ch/chwzEr').should == "http://techcrunch.com/2010/11/19/hitwise-facebook-accounts-for-1-in-4-page-views-in-the-u-s/"
  end
  
  it "should return the same url when the url is not a short one using Get method" do
    UrlEnlarger.enlarge('http://techcrunch.com/2010/11/19/hitwise-facebook-accounts-for-1-in-4-page-views-in-the-u-s/').should == "http://techcrunch.com/2010/11/19/hitwise-facebook-accounts-for-1-in-4-page-views-in-the-u-s/"
  end
  
  it "should return the same url when the url is not a short one using Head method" do
    UrlEnlarger.enlarge('http://techcrunch.com/2010/11/19/hitwise-facebook-accounts-for-1-in-4-page-views-in-the-u-s/', :head).should == "http://techcrunch.com/2010/11/19/hitwise-facebook-accounts-for-1-in-4-page-views-in-the-u-s/"
  end
end