class FaqsController < ApplicationController
  def index
    capture_user_hitting_route
    add_breadcrumb "FAQs", faqs_path
  end
end
