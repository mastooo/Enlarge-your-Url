require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'url_enlarger'

class UrlEnlargerTest < Test::Unit::TestCase
  
  def test_input_nil
    assert_equal nil, UrlEnlarger.enlarge(nil)
  end
  
  def test_input_empty
    assert_equal nil, UrlEnlarger.enlarge('')
  end

  def test_input_empty_with_scheme
    assert_raises(SocketError) do 
      UrlEnlarger.enlarge('http://a.c.om')
    end
  end
  
  def test_bit_ly
    assert_equal 'http://37signals.com/svn/posts/2636-the-things-you-do-more-often-are-the-things?utm_medium=twitter&utm_source=twitterfeed', UrlEnlarger.enlarge('http://bit.ly/bKb1M9')
  end
  
  def test_jm_p
    assert_equal 'http://sr3d.github.com/GithubFinder/?utm_source=bml&user_id=sr3d&repo=GithubFinder', UrlEnlarger.enlarge('http://j.mp/bAgcXr')
  end
  
  def test_tcrn_ch
    assert_equal 'http://techcrunch.com/2010/11/19/hitwise-facebook-accounts-for-1-in-4-page-views-in-the-u-s/', UrlEnlarger.enlarge('http://tcrn.ch/chwzEr')
  end
  
  def test_tiny_url
    assert_equal 'http://rvanderroest.com/?p=273', UrlEnlarger.enlarge('http://tiny.ly/4x4W')
  end
  
  def test_goo_gl
    assert_equal 'http://webmasters.stackexchange.com/questions/5662/seo-for-image-based-website', UrlEnlarger.enlarge('http://goo.gl/9XG2f')
  end
  
end