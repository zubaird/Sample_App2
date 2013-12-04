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


  describe "edit" do
    let(:user) { FactoryGirl.create(:user)}
    before { visit edit_user_path(user) }

    describe "page" do 
      it { should have_selector('h1', text: "Update your profile")}
      it { should have_selector('title', text: "Edit user")}
      it { should have_link('change', href: 'http://gravatar.com/emails')}
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error')}
    end

    describe "with valid information" do
      let(:new_name) {"New name"}
      let(:new_email) { "new@example.com"}
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password 
        click_button "Save changes"
      end
        it { should have_selector("title", text: new_name ) }
        it { should have_selector("div.alert.alert-success", text: 'updated')}
        it { should have_link("Sign out", href: signout_path) }

      # => Verify that the user truly has a new name and info, Pull from database
      # => This reloads the USER variable from the test database using the user.reload
      # => "Specify" changes the rspec "subject" for that line 
      # => Will still pass without the below 2 lines

        specify { user.reload.name.should == new_name }
        specify { user.reload.email.should == new_email }

    end

  end















end
