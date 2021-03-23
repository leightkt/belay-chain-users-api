class GymSerializer

    def initialize gym, token
        @gym = gym
        @token = token
        @certifications = []
    end

    def to_serialized_json
        get_certifications
        data = {
            user: {
                id: @gym.id,
                name: @gym.name,
                street_address: @gym.street_address,
                city: @gym.city,
                state: @gym.state,
                zip_code: @gym.zip_code,
                email: @gym.email,
                role: "gym"
            },
            token: @token,
            certifications: @certifications
        }
        data.to_json()
    end

    def get_certifications
        payload = { gym_id: @gym.id }
        rest_client = RestClient::Request.execute(
            method: :post, 
            url: 'http://localhost:3001/gym', 
            payload: { "gym_id": @gym.id }.to_json,
            headers: { :accept => :json, content_type: :json }
        )
        result = JSON.parse(rest_client)
        result.map do |certification|
            @member = Member.find_by(gym_member_id: certification["data"]["user_member_number"], gym_id: @gym.id)
            if @member 
                certification["first_name"] = @member.first_name
                certification["last_name"] = @member.last_name
                certification["email"] = @member.email
                @certifications << certification
            end
        end
    end


end