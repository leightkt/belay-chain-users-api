class MemberSerializer

    def initialize member, token
        @member = member
        @token = token
    end

    def to_serialized_json
        data = {
            user: {
                id: @member.id,
                first_name: @member.first_name,
                last_name: @member.last_name,
                email: @member.email,
                gym: @member.gym.name
            },
            token: @token
        }
        data.to_json()
    end



end