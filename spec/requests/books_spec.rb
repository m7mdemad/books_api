require "rails_helper"


describe "Books API", type: :request do
    describe "GET /api/v1/books" do
        before do
            author = FactoryBot.create(:author, first_name: "First", last_name: "Last", age: "120")
            FactoryBot.create(:book, title: "Crime and Punishment", author_id: author.id)
            FactoryBot.create(:book, title: "Notes from Underground", author_id: author.id)
        end
        it "return all books" do
            get "/api/v1/books"
    
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                        "id" => 1,
                        "title" => "Crime and Punishment",
                        "author_name" => "First Last",
                        "author_age" => 120
                    },
                    {
                        "id" => 2,
                        "title" => "Notes from Underground",
                        "author_name" => "First Last",
                        "author_age" => 120
                    }
                ]
            )
        end

        it "return subset using limit" do
            get "/api/v1/books", params: { limit: 1 }

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        "id" => 1,
                        "title" => "Crime and Punishment",
                        "author_name" => "First Last",
                        "author_age" => 120
                    }
                ]
            )
        end

        it "return subset using limit and offset" do
            get "/api/v1/books", params: { limit: 1, offset: 1 }

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        "id" => 2,
                        "title" => "Notes from Underground",
                        "author_name" => "First Last",
                        "author_age" => 120
                    }
                ]
            )
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
            expect(response_body).to eq(
                {
                    "id" => 1,
                    "title" => "1919",
                    "author_name" => "Ahmed Morad",
                    "author_age" => 30
                }
            )
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