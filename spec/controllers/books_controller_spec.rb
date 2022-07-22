require "rails_helper"

RSpec.describe Api::V1::BooksController, type: :controller do
    describe 'GET index' do
        it "has a max limit of 100 books" do
            expect(Book).to receive(:limit).with(100).and_call_original
    
            get :index, params: { limit: 9999 }
        end
    end

    describe 'POST create' do
        context "missing authorization header" do
            it "return a 401" do
                post :create, params: {}
    
                expect(response).to have_http_status(:unauthorized)
            end
        end
        
        # Active Job testing. I was practicing how to cerate an active job.
        # let(:book_name) { 'Test title' }
        # let(:user) { FactoryBot.create(:user, password: 'password1') }
        # before do
        #     allow(AuthenticationTokenService).to receive(:decode).and_return(user.id)
        # end
        # it 'calls UpdteSKUJob with correct params' do
        #     expect(UpdateSkuJob).to receive(:perform_later).with(book_name)

        #     post :create, params: { 
        #         author: { first_name: 'first_name', last_name: 'last_name', age: 45 },
        #         book: { title: book_name }
        #      }

        # end
    end

    describe 'DELETE destroy' do
        context "missing authorization header" do
            it "return a 401" do
                delete :destroy, params: { id: 1}
    
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end