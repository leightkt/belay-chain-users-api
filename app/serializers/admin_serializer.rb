class AdminSerializer

    def initialize admin, token
        @admin = admin
        @token = token
    end

    def to_serialized_json
        data = {
            user: {
                id: @admin.id,
                username: @admin.username,
                email: @admin.email,
                role: "admin"
            },
            token: @token,
            certifications: []
        }
        data.to_json()
    end



end