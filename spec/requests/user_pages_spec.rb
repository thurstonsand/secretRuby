require 'spec_helper'

describe "UserPages" do

  subject { page }

  shared_examples_for "all user pages" do
    it { should have_selector 'h1', :text => heading }
    it { should have_selector('title', :text => full_title(page_title)) }
  end

  describe "Index page" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "thurston", email: "thurston@example.com")
      FactoryGirl.create(:user, name: "jeff", email: "jeff@example.com")
      visit users_path
    end

    let(:heading) { 'All users' }
    let(:page_title) { 'All users' }
    it_should_behave_like "all user pages"

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end

  describe "Signup Page" do
    before { visit signup_path }
    let(:heading) { 'Sign up' }
    let(:page_title) { 'Sign up' }

    it_should_behave_like "all user pages"
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    let(:heading) { user.name }
    let(:page_title) { user.name }

    it_should_behave_like "all user pages"
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         :with => "Example User"
        fill_in "Email",        :with => "user@example.com"
        fill_in "Password",     :with => "foobar"
        fill_in "Confirmation", :with => "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }

    describe "page" do
      let(:heading) { "Update your profile" }
      let(:page_title) { "Edit user" }

      it_should_behave_like "all user pages"
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "New@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert_success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
