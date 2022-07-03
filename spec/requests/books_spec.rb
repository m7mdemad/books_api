require "rails_helper"


describe "Books API", type: :request do
    describe "GET /api/v1/books" do
        before do
            author = FactoryBot.create(:author, first_name: "First", last_name: "Last", age: "1")
            FactoryBot.create(:book, title: "Crime and Punishment", author_id: author.id)
            FactoryBot.create(:book, title: "Notes from Underground", author_id: author.id)
        end
        it "return all books" do
            get "/api/v1/books"
    
            expect(response).to have_http_status(:success)
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end

    describe "POST /api/v1/books" do
        it "create new valid book" do
            expect {
                post "/api/v1/books", params: { 
                    book: {title: "1919"},
                    author: {first_name: "Ahmed", last_name: "Morad", age: "30" }
                }
            }.to change { Book.count }.from(0).to(1)

            expect(response).to have_http_status(:created)
        end

        it "create new book with invalid field" do
            post "/api/v1/books", params: { 
                book: {title: "A"},
                author: {first_name: "Ahmed", last_name: "Morad", age: "30" } 
            }

            expect(response).to have_http_status(:unprocessable_entity)
        end
    end

    describe "DELETE /api/v1/books/:id" do
        it "delete a book" do
            author = FactoryBot.create(:author, first_name: "First", last_name: "Last", age: "1")
            book = FactoryBot.create(:book, title: "Crime and Punishment", author_id: author.id)
            
            expect {
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count}.from(1).to(0)

            expect(response).to have_http_status(:no_content)
        end

        it "delete missing/wrong book" do
            delete "/api/v1/books/1"

            expect(response).to have_http_status(:unprocessable_entity)
        end
    end
end