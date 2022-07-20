require 'rails_helper'

describe 'Authentication', type: :request do
    describe 'POST /authenticate' do
        let(:user) { FactoryBot.create(:user, username: 'user_name', password: 'blah blah') }
         it 'authenticates the client' do
            post '/api/v1/authenticate', params: { username: user.username, password: user.password }

            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
                'token' => 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w'
            })
         end

         it 'missing username' do
            post '/api/v1/authenticate', params: { password: '123456' }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                'error' => 'param is missing or the value is empty: username'
            })
         end

         it 'missing password' do
            post '/api/v1/authenticate', params: { username: 'user_name' }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                'error' => 'param is missing or the value is empty: password'
            })
         end

         it 'return error when using invalid password' do
            post '/api/v1/authenticate', params: { username: user.username, password: 'wrong_password' }

            expect(response).to have_http_status(:unauthorized)
         end
    end
end