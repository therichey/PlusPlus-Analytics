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
  
  def test_unclassified_is_returned_for_things_that_cannot_be_categorized
    assert_equal 'unclassified', Categorizer.categorize('/DGJKHGKSDFJHSDFH')
  end

  def test_blank_search_is_returned_for_blank_searches
    assert_equal 'blank-search', Categorizer.categorize('/search/?q=')
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
    assert_equal 'customer-search', Categorizer.categorize('/customer-search?search_type=blarrgh')
  end
  
  def test_customer_search_phone_number
    assert_equal 'phone-number', Categorizer.categorize('/customer-search?search_type=phoneNumber')
  end
  
  def test_customer_search_email
    assert_equal 'email', Categorizer.categorize('/customer-search?search_type=email')
  end
  
  def test_customer_search_first_last_name
    assert_equal 'firstname-lastname', Categorizer.categorize('/customer-search?search_type=firstName_lastName')
  end
  
  def test_lastname_postcode
    assert_equal 'lastname-postcode', Categorizer.categorize('/customer-search?search_type=lastName_postcode')
  end  
  
  def test_can_recognize_order_number
    assert_equal 'ordernumber', Categorizer.categorize('/customer-search?search_type=orderNumber')
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
  
  def test_multi_code_search_is_returned
    assert_equal 'multi-code', Categorizer.categorize('/search/?q=05396696+05795635+20553708')
    assert_equal 'multi-code', Categorizer.categorize('/search/?q=T825634+T038568')
    assert_equal 'multi-code', Categorizer.categorize('/search/?q=T825634+05795635+20553708')
  end
  
  def test_generic_with_code_is_returned
    assert_equal 'generic-and-code', Categorizer.categorize('/search/?q=t862681+anti+bobble')
    assert_equal 'generic-and-code', Categorizer.categorize('/search/?q=T743631B+black+trousers+T743631B')
    assert_equal 'generic-and-code', Categorizer.categorize('/search/?q=05396696+black+trousers+T743631B')
    assert_equal 'generic-and-code', Categorizer.categorize('/search/?q=05396696+black+trousers+05396696+05795635+20553708')
  end
  
  def test_can_handle_pound_sign
    assert_equal 'generic-search', Categorizer.categorize('/search/?q=orchid+£15')
  end

end




   


