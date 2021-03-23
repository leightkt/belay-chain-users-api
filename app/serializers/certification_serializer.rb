class CertificationSerializer

    def initialize block
        @block = block
    end

    def to_serialized_json
        get_details
        @block.to_json()
    end

    def get_details
        @member = Member.find_by(gym_member_id: @block["data"]["user_member_number"], gym_id: @block["data"]["gym_id"])
        @block["first_name"] = @member.first_name
        @block["last_name"] = @member.last_name
        @block["email"] = @member.email
    end

end