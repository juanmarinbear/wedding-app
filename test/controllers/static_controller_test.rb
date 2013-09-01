require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get aboutus" do
    get :aboutus
    assert_response :success
  end

  test "should get ceremony" do
    get :ceremony
    assert_response :success
  end

  test "should get reception" do
    get :reception
    assert_response :success
  end

  test "should get accommodations" do
    get :accommodations
    assert_response :success
  end

  test "should get presents" do
    get :presents
    assert_response :success
  end

end
