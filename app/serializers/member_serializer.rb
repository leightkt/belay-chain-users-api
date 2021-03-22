class MemberSerializer

    def initialize member, token
        @member = member
        @token = token
    end

    def to_serialized_json
        get_certifications
        data = {
            user: {
                id: @member.id,
                gym_member_id: @member.gym_member_id,
                first_name: @member.first_name,
                last_name: @member.last_name,
                email: @member.email,
                gym: @member.gym.name,
                role: "member"
            },
            token: @token,
            certifications: @certifications
        }
        data.to_json()
    end

    def get_certifications
        payload = { user_member_number: @member.gym_member_id, gym_id: @member.gym.id }
        rest_client = RestClient::Request.execute(
            method: :post, 
            url: 'http://localhost:3001/member', 
            payload: { "user_member_number": @member.gym_member_id, "gym_id": @member.gym.id }.to_json,
            headers: { :accept => :json, content_type: :json }
        )
        result = JSON.parse(rest_client)
        @certifications = result
    end



end