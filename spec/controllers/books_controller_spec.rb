require "rails_helper"

RSpec.describe Api::V1::BooksController, type: :controller do
    describe 'GET index' do
        it "has a max limit of 100 books" do
            expect(Book).to receive(:limit).with(100).and_call_original
    
            get :index, params: { limit: 9999 }
        end
    end

    # Active Job testing. I was practicing how to cerate an active job.
    # describe 'POST create' do
    #     let(:book_name) { 'Test title' }
    #     it 'calls UpdteSKUJob with correct params' do
    #         expect(UpdateSkuJob).to receive(:perform_later).with(book_name)

    #         post :create, params: { 
    #             author: { first_name: 'first_name', last_name: 'last_name', age: 45 },
    #             book: { title: book_name }
    #          }

    #     end
    # end
end