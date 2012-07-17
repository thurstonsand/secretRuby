require 'spec_helper'

describe LoginController do
  subject { page }

  shared_examples_for "all login pages" do
    it { should have_selector 'h1', :text => heading }
    it { should have_selector('title', :text => full_title(page_title)) }
  end

  describe "Home page" do
    before {visit root_path }
    let(:heading) { 'SeedSwap' }
    let(:page_title) { '' }

    it_should_behave_like "all login pages"
    it { should_not have_selector 'title', :text => '| Home' }
  end

end
