require './categorizer'
require 'minitest/autorun'

class TestCategorizer < MiniTest::Unit::TestCase
  def test_single_upc_is_returned
    assert_equal 'single-upc', Categorizer.categorize('/search/?q=06250003')
    assert_equal 'single-upc', Categorizer.categorize('/search/?q= 07358210')
    assert_equal 'single-upc', Categorizer.categorize('/search/?q=07358210 ')
    assert_equal 'single-upc', Categorizer.categorize('/search/?q=+07358210')
    assert_equal 'single-upc', Categorizer.categorize('/search/?q=07358210+')
  end
  
  def test_unknown_is_returned_for_things_that_cannot_be_categorized
    assert_equal 'unknown', Categorizer.categorize('/DGJKHGKSDFJHSDFH')
  end
  
  def test_single_tcode_is_returned
    assert_equal 'single-tcode', Categorizer.categorize('/search/?q=t579057')
    assert_equal 'single-tcode', Categorizer.categorize('/search/?q=T747304J')
    assert_equal 'single-tcode', Categorizer.categorize('/search/?q=+t579057')
    assert_equal 'single-tcode', Categorizer.categorize('/search/?q= t579057')
    assert_equal 'single-tcode', Categorizer.categorize('/search/?q=+T747304J+')
  end
  
  def test_generic_search_is_returned
    assert_equal 'generic-search', Categorizer.categorize('/search/?q=bouquets')
    assert_equal 'generic-search', Categorizer.categorize('/search/?q=2+pack+hold+ups')
    assert_equal 'generic-search', Categorizer.categorize('/search/?q= bouquets')
  end
  
  def test_customer_search_is_returned
    assert_equal 'customer-search', Categorizer.categorize('/customer-search?search_type=phoneNumber')
  end
  
  def test_can_recognize_when_the_path_contains_categories
    assert Categorizer.contains_category?('/search/?q=flowers&category=97114')
    refute Categorizer.contains_category?('/search/?q=flowers')

  end
  
  def test_can_recognize_when_the_path_contains_page
    assert Categorizer.contains_page?('/search/?q=bouquets&page=2')
    refute Categorizer.contains_page?('/search/?q=flowers')
  end
  
  def test_can_recognize_when_the_path_contains_category_and_page
    assert Categorizer.contains_page?('/search/?q=wool mix trousers&page=2&category=98212')
    assert Categorizer.contains_category?('/search/?q=wool mix trousers&page=2&category=98212')
  end
end



   


