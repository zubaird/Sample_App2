require 'spec_helper'

describe "For Authentication Pages:" do
subject { page }

	describe "When visiting the signin page," do
		before { visit signin_path }
		it { should have_selector("h1", text: "Sign in")}
		it { should have_selector("title", text: "Sign in")}
	end

	describe "When completed the signin process," do
		before { visit signin_path }

		describe "and invalid information is entered," do
			before {click_button "Sign in"}
			it { should have_selector('title', text: 'Sign in')}
			it { should have_selector("div.alert.alert-error", text: 'Invalid')}

			describe "and a different page is visited," do
				before { click_link "Home" }
				it { should_not have_selector("div.alert.alert-error", text: 'Invalid') }
			end
		end

		describe "and valid information is entered," do

			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { should have_selector('title', text: user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do 
				before { click_link "Sign out" }
				it { should have_link("Sign in")}
			end
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it {should have_selector('title', text: "Sign in")}
					it {should have_selector('div.alert.alert-notice')}
				end

				describe "submitting to the update action" do
					# => This tests the update action instead of using  
					# => "visit" by calling the PUT action and going to 
					# => users/1 directly, then checking that it goes
					# => to the sign in path
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path )} 
				end
			end
		end



		describe "for the wrong signed-in user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com")}
			# => signin_user is a created method helper
			before { signin_user } 
			
			describe "visiting Users# edit page" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: 'Edit user')}
			end
		end
	end
end
