require 'spec_helper'

describe "Authentication" do

  subject { page }

  shared_examples_for "all authentication pages" do
    it { should have_selector 'h1', :text => heading }
    it { should have_selector('title', :text => full_title(page_title)) }
  end

  describe "signin" do
    before { visit root_path }

    describe "with invalid information" do
      before { click_button "Sign in"}

      it { should have_selector('div.alert.alert-error', :text => 'Invalid') }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    :with => user.email
        fill_in "Password", :with => user.password
        click_button "Sign in"
      end

      let(:heading) { user.name }
      let(:page_title) { user.name }

      it_should_behave_like "all authentication pages"
      it { should have_link('Profile', :href => user_path(user)) }
      it { should have_link('Sign out', :href => signout_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
end