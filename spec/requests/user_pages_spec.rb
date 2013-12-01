require 'spec_helper'

  describe "For User Pages" do
    subject { page }

    	describe "when at the signup page" do
    		before { visit signup_path}

    		it { should have_selector("h1", text: "Sign up")}
    		it { should have_selector("title", text: full_title("Sign up")) }
    		
  end

	describe "when at the profile page" do
		let(:user) { FactoryGirl.create(:user) }


		before { visit user_path(user) }

		it { should have_selector("h1", text: user.name )}
		it { should have_selector("title", text: user.name ) }
		
	end

  # SIGN UP PAGE

  describe "when doing signup" do 
    before { visit signup_path }

    let(:submit) { "Create my account" }

        describe "and with invalid information" do
        it "should not create a user" do
            expect { click_button submit }.not_to change(User, :count)
        end

    describe "and after_submission" do
      before { click_button submit }
        it { should have_selector('title', text: 'Sign up')}
        it { should have_content('error')}
        it { should_not have_content("Password digest")}
      end
    end

    describe "and with valid information" do

          before do
            fill_in "Name", with: "Example User"
            fill_in "Email", with: "user@example.com"
            fill_in "Password", with: "fuckitall"
            fill_in "Confirmation", with: "fuckitall"
          end

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        describe "and after saving a user" do
          before { click_button submit }
          let(:user) { User.find_by_email("user@example.com") }
          it { should have_selector("title", text: user.name) }
          it { should have_selector("div.alert.alert-success", text: 'Welcome')}
          it { should have_selector("div.alert.alert-success", text: user.name )}
          it { should have_link('Sign out') }
        end

    end
  end
end
